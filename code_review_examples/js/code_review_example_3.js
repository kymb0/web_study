const express = require('express')
const path = require('path')
const app = express()
 
 

app.get('/download', (req, res) => { // create a rule that when a get request is sent to this endpoint, run the below code
    const filename = req.query.filename.replace(/\/\.\./g,"") // here we extact from the filename param send in request, and apply a regex to replace "../" with a blank string
    return res.sendFile(path.resolve(__dirname+'/'+filename)) // he we return res.sendFile which is how we send a file in a response using express - in other words this is a small program to allow clients to download files
});
 
// why is this vulnerable? Amongst missing other filters for path traversal - this filter is not applied recursively, so can be subverted simply by sending "....//....//....//etc/passwd"
