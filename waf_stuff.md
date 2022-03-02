

get ips and test against a good response in burp replacing host with the ip, get a response

https://github.com/Top-Hat-Sec/thsosrtl/blob/master/CloudIP/cloudip.sh


https://censys.io/certificates?q= - search the ipv4 hosts for ips

Can also be bypassed by defeating WAF logic EG any fields containing string that would execute something getting blocked: Try to concatenate the fields together via html injection.
Specify hostname in host header

Add payload positions for the X-Forwarded-For header. 
On the Payloads tab, select payload set 1. Select the Numbers payload type. Enter the range 1 - 100 and set the step to 1. Set the max fraction digits to 0. This will be used to spoof your IP.  
