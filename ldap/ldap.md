#### LDAP Authentication bypass
some LDAP servers authorise NULL Bind: if null values are sent, the LDAP server will proceed to bind the connection, and the PHP code will think that the credentials are correct.  
To get the bind with 2 null values, you will need to completely remove this parameter from the query.  
If you keep something like username=&password= in the URL, these values will not work, since they won't be null; instead, they will be empty.  
_**This is an important check to perform on all login forms that you will test in the future, even if the backend is not LDAP-based.**_
