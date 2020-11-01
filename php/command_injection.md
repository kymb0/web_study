## When injecting php, warning == find & error == not fine
## As you work through which characters complete the injection string, when you hit a character in the php error that was not in your string - try commenting the end of the string
### Abuse eval() being used, inject a concatenated command:  
`".phpinfo();"`
### usort()
