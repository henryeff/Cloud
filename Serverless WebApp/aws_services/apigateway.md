**Create new HTTP API gateway**

- create new HTTP API
  ![alt text](./images/api1.png)
  ![alt text](./images/api2.png)
  ![alt text](./images/api3.png)

- create routes for the API
  ![alt text](./images/api4.png)
  ![alt text](./images/api5.png)
  ![alt text](./images/api6.png)

- Integrate both api routes with lambda function
  ![alt text](./images/api7.png)
  ![alt text](./images/api8.png)
  ![alt text](./images/api9.png)

- Enable the CORS - Access-Control-Allow-Origin: **you can use \* to allow all or you can add your s3 bucket url to only allow your s3 bucket** - Access-Control-Allow-Headers: **content-type** - Access-Control-Allow-Methods: **GET, POST, DELETE**
  ![alt text](./images/api10.png)
  ![alt text](image.png)
