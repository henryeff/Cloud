## **Create new lambda function**

![alt text](image.png)

---

## **Paste the lambda_function.py code into the code source**

- change table name in the code to your dynamo table name
- deploy the code
  ![alt text](./images/image-1.png)

---

## **Add trigger**

Source: kinesis data stream  
Kinesis Stream: your data stream name create in kinesis  
Batch size: 100  
Starting position: Latest

- ![alt text](./images/image-3.png)
- ![alt text](./images/image-5.png)
