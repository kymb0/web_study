import json
import boto3

def create_policy(Policy_Name):
	iam = boto3.client('iam')
	
	new_policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}

	response = iam.create_policy(
	PolicyName=Policy_Name,
	PolicyDocument=json.dumps(new_policy)
)
	return response

def attach_role(Policy_Name):	
	iam = boto3.client('iam')
	response = iam.attach_role_policy(
	RoleName='blog_app_lambda_data',
	PolicyArn=('arn:aws:iam::xxxxxxxx:policy/'+Policy_Name)
	)
	

def lambda_handler(event, context):
	Policy_Name="dev-lambda-2"
	create_policy(Policy_Name)
	attach_role(Policy_Name)

	exit()
