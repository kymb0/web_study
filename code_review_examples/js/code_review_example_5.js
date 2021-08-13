const express = require('express')
const app = express()
const port = 3000
 
 
app.get('/fetch', (req, res) => {
  /* [...] */
  console.log("Access to fetch: "+req.query.path);
  /* [...] */
});
 
app.listen(port, () => console.log(`Listening on port ${port}!`))
// similair to exercise 4, the answer is on line 8 however this time bug type is log injection, as we can play with the ?query= parameter with no filtering in place
