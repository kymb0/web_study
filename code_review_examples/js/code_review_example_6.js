const https = require('https');
const express = require('express')
const ejs = require('ejs') // import the 'ejs' template library
const app = express()
const port = 3000
app.set( "view engine", "ejs" ); //set the app so that the ejs template gets applied to the view
 
 

app.get( "/", ( req, res ) => { // whenever a request is sent to the index of webapp, as below a template is applied before being sent back
  
    var template = `<h1>${req.query.name}</h1>` //create template dynamically
    return res.send( ejs.render(template)) // ejs.render is used to create the template and interprete to get final html code to send back
} );
app.listen(port, () => console.log(`Listening on port ${port}!`))
//the issue is on line 12 where the template is generated dynamically as we can inject what is interpreted by the template.
//an example of how this could be exploited is as follows:
//<%=global.process.mainModule.require('child_process').execSync('ls').toString()%>
//
