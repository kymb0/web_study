Basic Auth:
## Old (vulnerable)
string conString = ConfigurationManager.ConnectionStrings["eCommerceConnString"].ConnectionString;

SqlConnection conn = new SqlConnection(conString);

~~string sqlquerystring = "select password from users where username = '" + username + "'";~~

SqlCommand cmd = new SqlCommand(sqlquerystring, conn);

## New (secure)
string conString = ConfigurationManager.ConnectionStrings["eCommerceConnString"].ConnectionString;

SqlConnection conn = new SqlConnection(conString);

**string sqlquerystring = "select password from users where username = @name";**

SqlCommand cmd = new SqlCommand(sqlquerystring, conn);

**cmd.Parameters.AddWithValue("@name", username);**

```It is secure because parameterized query has been used which will clearly separate the control plane and data plane of the SQL statement. The parameterized query will never the treat the user supplied input as executable SQL command or statement.```
