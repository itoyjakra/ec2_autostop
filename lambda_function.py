import boto3
import json
import os

def lambda_handler(event, context):
    # Use instance ID from environment variable (works for both metric and composite alarms)
    instance_id = os.environ['INSTANCE_ID']
    print(f"{event=}")
    print(f"{instance_id=}")
    
    # Create an EC2 client
    ec2 = boto3.client('ec2')
    
    try:
        # Stop the EC2 instance
        response = ec2.stop_instances(
            InstanceIds=[instance_id]
        )
        print('Stopping instance: ', instance_id)
        print('Response: ', response)
    except Exception as e:
        print('Error stopping instance: ', e)
        raise e

    return {
        'statusCode':  200,
        'body': json.dumps('EC2 instance stopped successfully')
    }
