# 🖥️ AWS Serverless Web Application

This project is a **simple serverless web application** hosted on AWS. It demonstrates the use of AWS services to build a **scalable** and **cost-effective** application for adding, searching, and deleting items.

---

## 🌟 Overview

This web application leverages the following AWS services:

- **Amazon S3**: Hosts the static website files (**HTML**, **CSS**, **JavaScript**).
- **AWS API Gateway**: Serves as the API layer to route requests to Lambda functions.
- **AWS Lambda**: Executes backend logic for adding, searching, and deleting items.
- **Amazon DynamoDB**: Acts as the NoSQL database to store and retrieve application data.

---

## ✨ Features

1. **Add Item**  
   Add new items to the database via the web interface.

2. **Search Item**  
   Retrieve stored items by providing specific criteria.

3. **Delete Item**  
   Remove items from the database.

---

## 🏗️ Architecture

### **Frontend**

- Hosted on **Amazon S3** as a static website.
- Interacts with the backend via **REST APIs**.

### **Backend**

- **API Gateway**: Routes HTTP requests to specific Lambda functions.
- **Lambda Functions**: Handle business logic and interact with **DynamoDB** to store or retrieve data.

---

## 🛠️ How to Deploy?

Follow the step-by-step guide to deploy this application.  
The detailed instructions are available in the link below and the code is stored under [code](./code) subdirectory

1. [Create dynamodb table](./console/dynamoDB.md)
2. [Create lambda function](./console/lambda.md)
3. [Create api gateway](./console/apigateway.md)
4. [Create s3 bucket](./console/S3.md)
5. [Create IAM policy for lambda function](./console/IAM.md)
