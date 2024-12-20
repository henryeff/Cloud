import boto3
import json
import base64

dynamodb=boto3.resource('dynamodb')
table=dynamodb.Table('realtimedata')

def lambda_handler(event,context):
    for record in event['Records']:
        payload = json.loads(base64.b64decode(record['kinesis']['data']))
        table.put_item(Item=payload)
        print(f"processed record: {payload}")
    return {
        'statusCode': 200,
        'body': 'Data processed successfully'
    }