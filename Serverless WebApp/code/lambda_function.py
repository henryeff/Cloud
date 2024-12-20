import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ENTER-YOUR-DYNAMODB-TABLE-HERE') # enter your dynamo table here

def lambda_handler(event,context):
    print(event)
    method = event['requestContext']['http']['method']

    if method == 'POST':
        body = json.loads(event['body']) 
        id = body.get('id')
        name = body.get('name')
        email = body.get('email')
        if not (id and name and email):
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Missing required fields: id/name/email'})
            }
        table.put_item(Item={'id': id, 'name': name, 'email': email})
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'record has beend added successfully!'})
        }
    elif method == 'GET':
        id=event['queryStringParameters'].get('id')
        if not id:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Missing requried field: id'})
            }
        response = table.get_item(Key={'id': id})
        item = response.get('Item')

        if not item:
            return {
                'statusCode': 404,
                'body': json.dumps({'error':'Record not found'})
            }
        
        return {
            'statusCode': 200,
            'body': json.dumps(item)
        }
    elif method == 'DELETE':
        id=event['queryStringParameters'].get('id')
        if not id:
            return {
                'statusCode': 400,
                'body': json.dumps({'error':'missing required field: ID'})
            }
        checkItem = table.get_item(Key={'id':id})
        item = checkItem.get('Item')
        if not item:
            return {
                'statusCode': 404,
                'body': json.dumps({'Error':'Record not found! invalid ID'})
            }
        response = table.delete_item(Key={'id': id})
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Recrod has been successfully deleted'})
        }
    else:
        return {
            'statusCode': 405,
            'body': json.dumps({'error':'Method not allowed'})
        }