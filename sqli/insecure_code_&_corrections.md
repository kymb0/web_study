        #### sql server connection string
        string conString = ConfigurationManager.ConnectionStrings["eCommerceConnString"].ConnectionString;
        SqlConnection conn = new SqlConnection(conString);
        ~~string sqlquerystring = "select password from users where username = '" + username + "'";~~
        SqlCommand cmd = new SqlCommand(sqlquerystring, conn);
       
        #### sql server connection string
        string conString = ConfigurationManager.ConnectionStrings["eCommerceConnString"].ConnectionString;
        SqlConnection conn = new SqlConnection(conString);
        **string sqlquerystring = "select password from users where username = @name";**
        SqlCommand cmd = new SqlCommand(sqlquerystring, conn);
        **cmd.Parameters.AddWithValue("@name", username);**
