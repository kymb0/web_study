## Blind OS command injection vulnerabilities
Many instances of OS command injection are blind vulnerabilities. This means that the application does not return the output from the command within its HTTP response. Blind vulnerabilities can still be exploited, but different techniques are required.  

Consider a web site that lets users submit feedback about the site. The user enters their email address and feedback message. The server-side application then generates an email to a site administrator containing the feedback. To do this, it calls out to the mail program with the submitted details. For example:  

`mail -s "This site is great" -aFrom:peter@normal-user.net feedback@vulnerable-website.com`  

The output from the mail command (if any) is not returned in the application's responses, and so using the echo payload would not be effective. In this situation, you can use a variety of other techniques to detect and exploit a vulnerability.  

## Exploiting blind OS command injection by redirecting output
You can redirect the output from the injected command into a file within the web root that you can then retrieve using your browser. For example, if the application serves static resources from the filesystem location /var/www/static, then you can submit the following input:  

`& whoami > /var/www/images/whoami.txt &` !remember to choose a writeable dir  

sleep:
`||ping+-c+10+127.0.0.1||`
out of band:
`||nslookup+x.burpcollaborator.net||`
