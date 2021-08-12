	app.get('/api/v1/users/filter', (req, res) => { // create a rule that when the client sends a get to this url, we apply below logic
  var where = [] // create a variable named as an empty array .an empty array 'where'
  var query ="SELECT * FROM users WHERE "; // create query which is a string
  var data = [] // create an empty array 'data'
  for (var param in req.query) { // create for loop on all parameters within req.query
    where.push(param+"=?") // push all parameters sent in get request into 'where' array with "=?" appended (So where would look like [number=?,string=?]'?' is a placeholder in SQL)
    data.push(req.query[param]); // push all parameter values into data (so now data looks like [1, 'hello world'])
  }
  query+=where.join(" AND "); //concatenate query with the where array, so now it looks like "SELECT * FROM users WHERE number=?, string=?"
  db.query(query, data, (err,rows) => { //now we send our query to the database
    if(err) return res.send(JSON.stringify({}));
    return res.send(JSON.stringify(rows));
  });  
});

// why is the above vulnerable? 
