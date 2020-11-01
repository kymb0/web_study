_mass assignment_ in rails is the act of constructing an object (eg registering an account) with a parameters hash.  
It is reffered to as mass iassgnment because it can assign more than one value via a single operator.

As a contrived example, let's say we create a new user, intercept the request and add `&user[admin]` the user will now be created as an admin.


as a more technical example:
We set our organisation as we create a user.
You can guess the fact that organisation is used by visiting the organisation page and looking at the URL. You will see that the class is probably named Organisation. And therefore the key in the users table is likely to be organisation_id.
Ruby-on-Rails enforces "convention" over "configuration" which really helps to guess class names and attributes' name...

Using this information, we set your current organisation to get access to the "key".

The resulting attack string is &user%5Borganisation_id%5D=1
