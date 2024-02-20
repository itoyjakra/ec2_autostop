import boto3
import json

def lambda_handler(event, context):
    # Extract the instance ID from the CloudWatch alarm message
    # instance_id = os.environ['INSTANCE_ID']
    print(f"{event=}")
    event_dimensions = event['alarmData']['configuration']['metrics'][0]['metricStat']['metric']['dimensions']
    instance_id = event_dimensions["InstanceId"]
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
