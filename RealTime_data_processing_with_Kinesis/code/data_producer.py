import boto3
import json
import time
from random import randint

kinesis_client = boto3.client('kinesis', region_name='ap-southeast-1')
stream_name='RealTimeDataStream'

while True:
    data = {
        "sensor_id": randint(1,100),
        "temp": randint(1,100),
        "timestamp": int(time.time())
    }
    response = kinesis_client.put_record(
        StreamName=stream_name,
        Data=json.dumps(data),
        PartitionKey=str(data["sensor_id"])
    )
    print(f"send data: {data}")
    print(f"response: {response}")
    time.sleep(1)