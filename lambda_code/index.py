# lambda_code/index.py

import os
import boto3
import socket

def handler(event, context):
    rds_proxy_endpoint = os.environ['RDS_PROXY_ENDPOINT']
    ssm_parameter_name = os.environ['SSM_PARAMETER_NAME']

    # Resolve the RDS Proxy endpoint to IP addresses
    ip_addresses = socket.gethostbyname_ex(rds_proxy_endpoint)[2]

    # Store IP addresses in SSM Parameter Store
    ssm = boto3.client('ssm')
    ssm.put_parameter(
        Name=ssm_parameter_name,
        Value=','.join(ip_addresses),
        Type='String',
        Overwrite=True
    )

    return {
        'statusCode': 200,
        'body': 'IP addresses stored in SSM'
    }
