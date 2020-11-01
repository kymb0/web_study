__mass assignment__ in rails is the act of constructing an object (eg registering an account) with a parameters hash.  
It is reffered to as mass iassgnment because it can assign more than one value via a single operator.

As a contrived example, let's say we create a new user, intercept the request and add `&user[admin]` the user will now be created as an admin.


as a more technical example:
In this exercise, you can register an account. However, you won't be part of an organisation. The goal is to join the organisation Organisation #1

To do so you will need to set your organisation using mass-assignment.

By convention (can be changed programmatically) when a developer uses ActiveRecord (Ruby-on-Rails' most common data mapper), and a class Organisation has multiple User, the relation is managed using a field organisation_id inside the User class:

The following code is used in Ruby:

class User < ActiveRecord::Base
  belongs_to :organisation
end

class Organisation < ActiveRecord::Base
  has_many :users
end

You can guess the fact that organisation is used by visiting the organisation page and looking at the URL. You will see that the class is probably named Organisation. And therefore the key in the users table is likely to be organisation_id.
Ruby-on-Rails enforces "convention" over "configuration" which really helps to guess class names and attributes' name...

Using this information, you should be able to set your current organisation to get access to the "key".
