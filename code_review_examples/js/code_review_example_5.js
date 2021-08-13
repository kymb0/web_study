const express = require('express')
const app = express()
const port = 3000
 
 
app.get('/fetch', (req, res) => {
  /* [...] */
  console.log("Access to fetch: "+req.query.path);
  /* [...] */
});
 
app.listen(port, () => console.log(`Listening on port ${port}!`))
