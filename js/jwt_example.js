payload='{"username": "ninja","email": "ninja@notebook.com","admin_cap": false}'

token= jwt.encode(payload,private_key,algorithm='RS256',headers=
'{"typ": "JWT","alg": "RS256","kid": "http://localhost:7070/privKey.key"}')
print(token)
