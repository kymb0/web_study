const express = require('express')
const app = express()
const port = 3000
 
 
app.get('/dangerous', (req, res) => {
  /* [...] */
  console.log("Access to dangerous function: "+req.ip);
  /* [...] */
});
 
app.listen(port, () => console.log(`Example app listening on port ${port}!`))
