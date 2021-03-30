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

## A number of characters function as command separators, allowing commands to be chained together. The following command separators work on both Windows and Unix-based systems:  

`&`  
`&&`  
`|`  
`||`  

### The following command separators work only on Unix-based systems:  

`;`  
Newline (`0x0a` or `\n`)  

### On Unix-based systems, you can also use backticks or the dollar character to perform inline execution of an injected command within the original command:

` injected command `  
`$( injected command )`  
Note that the different shell metacharacters have subtly different behaviors that might affect whether they work in certain situations, and whether they allow in-band retrieval of command output or are useful only for blind exploitation.  

Sometimes, the input that you control appears within quotation marks in the original command. In this situation, you need to terminate the quoted context (using " or ') before using suitable shell metacharacters to inject a new command.  
