# 🖥️ Real-Time Data Processing with Kinesis, Lambda, and DynamoDB

This repository contains a real-time data processing application using **Amazon Kinesis**, **AWS Lambda**, and **Amazon DynamoDB**. The application simulates the ingestion of sensor data into Kinesis, processes it with Lambda, and stores the results in DynamoDB. This solution demonstrates how to build scalable, serverless applications for real-time data processing in the cloud.

---

## 🏗️ Architecture Overview

The architecture of this application consists of the following components:

- **Kinesis Data Stream**: Collects and ingests real-time sensor data.
- **AWS Lambda**: Processes incoming data from the Kinesis stream and writes it to DynamoDB.
- **DynamoDB**: Stores the processed data for further use or analytics.

---

## ✨ How it works?

1. **Data Producer**: A Python script that simulates the sending of sensor data to an Amazon Kinesis stream at regular intervals. (this can be run locally or using ec2 instance)
2. **Kinesis Stream**: The stream is used to receive and buffer incoming sensor data.
3. **Lambda Function**: The Lambda function is triggered by new records in the Kinesis stream. It processes the incoming data and stores it in an Amazon DynamoDB table.
4. **DynamoDB**: A DynamoDB table is used to persist the processed data for querying and analytics.

---

## Prerequisites

Before you begin, ensure you have the following:

- **AWS CLI** installed and configured on your local machine.
- **Python 3.x** installed.

---

## 🛠️ How to Deploy?

Follow the step-by-step guide to deploy this application.  
The detailed instructions are available in the link below and the code is stored under [code](./code) subdirectory

1. [Create dynamodb table](./console/dynamodb.md)
1. [Create Kinesis Data Stream](./console/kinesis.md)
1. [Create lambda function](./console/lambda.md)
1. [Create IAM policy](./console/IAM.md)
1. [How To test](./console/HOW_TO_USE.MD)
