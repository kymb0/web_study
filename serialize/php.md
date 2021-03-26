

Objects are serialized as:  
`O:<i>:"<s>":<i>:{<properties>}`  
where the first `<i>` is an integer representing the string length of `<s>`, and `<s>` is the fully qualified class name (class name prepended with full namespace). The second `<i>` is an integer representing the number of object properties. `<properties>` are zero or more serialized name value pairs:  

Booleans are serialized as:  
`b:<i>;`  
where `<i>` is an integer with a value of either 0 (false) or 1 (true).  

Integers are serialized as:  
`i:<i>;`  
where `<i>` is the integer value.  

Floats are serialized as (with d meaning double):  
`d:<f>;`  
where `<f>` is the float value.  

Strings are serialized as:  
`s:<i>:"<s>";`  
where `<i>` is an integer representing the string length of `<s>`, and `<s>` is the string value.  

Special types:  
null is simply serialized as:  
`N;`  

Arrays are serialized as:  
`a:<i>:{<elements>}`  
where `<i>` is an integer representing the number of elements in the array, and `<elements>` zero or more serialized key value pairs:  
`<key><value>`  
where `<key>` represents a serialized scalar type, and `<value>` any value that is serializable.  
  
`<name><value>`  
where `<name>` is a serialized string representing the property name, and `<value>` any value that is serializable.  
There's a catch with `<name>` though:  
`<name>` is represented as  
`s:<i>:"<s>";`  
where `<i>` is an integer representing the string length of `<s>`. But the values of `<s>` differs per visibility of properties:  

