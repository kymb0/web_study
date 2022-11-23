Cross origin resource sharing is particular header that can be put on endpoints which determines if javascript is allowed send and read data to an endpoint.  cors can actually introduce vulnerabilities as without them the server Always follow the same origin policy.  

Case study: on a site where you can search for medical status, testers hosted a malicious site which used javascript that when someone visited it, a GET request would be sent from the victims browser to the search page, when the data came back, the cors header should have checked the header to make sure the origins match up. Instead, due to a manual CORS config, the data was then send again from the victims browser to the attacker.  

TL;DR “We are checking if we are allowed to do this against you”. 
