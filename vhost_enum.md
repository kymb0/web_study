try subdomains and/or dirs/files with either a small wordlist or cewl one:  
`cewl http://<site>/ > cewl.txt`  
(or ffuf `ffuf -c -w /usr/share/dnsrecon/subdomains-top1mil-5000.txt -u http://prod.website.com -H "Host: FUZZ.website.com" -fw 5338 -s`)  
`ffuf -c -w /usr/share/dnsrecon/subdomains-top1mil-20000.txt -u http://amzcorp.local -H "Host:FUZZ.amzcorp.local " -fs 86 -s`

Use intruder as below with cewl list as payload (easier to manage responses and tested params AND it removes need for trying wildcards linked to the IP)  

```
GET /§§.php HTTP/1.1  
Host: §ss§.tenet.htb  
<REST OF REQ>  
ffuf -c -w /usr/share/dnsrecon/subdomains-top1mil-5000.txt -u http://artcorp.htb -H "Host: FUZZ.artcorp.htb" -fc 301
If still struggling try running doscovered endpoints through burpPRO discover content/active scan etc. This helped me find the .bak file on tenet (although I should have figured that out from the clue in comments)
```
then if you want you can do a quick sweep with gobuster

```
#!/bin/bash

# Subdomains
subdomains="cloud jobs inventory workflow"

# Wordlist
wordlist="/path/to/your/wordlist"

# Loop over each subdomain and run gobuster
for subdomain in $subdomains
do
  echo "Running gobuster on $subdomain.example.com..."
  gobuster dir -u http://$subdomain.example.com -w $wordlist
done

```
