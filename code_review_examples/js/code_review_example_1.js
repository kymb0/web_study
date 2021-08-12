const jwt = require('jsonwebtoken'); //here we see this code requires the 'jsonwebtokenlibrary'
 
const secret = process.env.NODE_ENV === 'production' ? //here we see that the const 'secret' is set to one of two values, if NODE_ENV var within the process is set to 'production', then const secret is set to the JWT_SECRET environment var within process, otherwise it is set to the string 'secret'
                        process.env.JWT_SECRET : 'secret';
 
const authService = () => {
...
};
  
// the security issue with this code lies on line 3, where we can see that a strong secret is only used if the environment is production, so if it were to be say, dev, test, staging etc - only the string 'secret' would be used for const secret
// Why is this a risk? Well, if in production then the jwt is secure as it is pulled out of the process - however if in any other environment, an attacker could sign their own auth tokens and impersonate any user as the secret would simply be ''secret'
