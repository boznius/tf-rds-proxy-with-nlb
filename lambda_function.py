import os
import socket
import boto3

def handler(event, context):
    rds_proxy_endpoint = os.environ['RDS_PROXY_ENDPOINT']
    ssm_parameter_name = os.environ['SSM_PARAMETER_NAME']

    # Resolve the RDS Proxy endpoint to IP addresses
    ip_addresses = socket.gethostbyname_ex(rds_proxy_endpoint)[2]

    # Join IP addresses into a comma-separated string
    ip_addresses_str = ','.join(ip_addresses)

    # Store the IP addresses in SSM Parameter Store
    ssm = boto3.client('ssm')
    ssm.put_parameter(
        Name=ssm_parameter_name,
        Value=ip_addresses_str,
        Type='String',
        Overwrite=True
    )

    return {
        'statusCode': 200,
        'body': f"IP addresses {ip_addresses_str} stored in SSM parameter {ssm_parameter_name}"
    }
