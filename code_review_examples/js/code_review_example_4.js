const express = require('express')
const app = express()
const port = 3000
 
 
app.get('/dangerous', (req, res) => {
  /* [...] */
  console.log("Access to dangerous function: "+req.ip);
  /* [...] */
});
 
app.listen(port, () => console.log(`Example app listening on port ${port}!`))
// the bug type for this exercise was "insufficient logging" on line 8, this is because there is no proper logging mechanism for requester IP's. The reg.ip can also be controlled through the x-forwarded-for header
