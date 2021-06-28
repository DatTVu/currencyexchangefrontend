# Illustration:
<img src=https://github.com/DatTVu/currencyexchangefrontend/blob/main/doc/CES.png width="720" height="1080">
# Requirement Analysis:

Assumption: this is a feature developed for a game or a sets of games.

1. The prototype must function correctly under common circumstances.
2. The set up of it should be easy enough so it can be shared among the team.
3. The application must run on multiplatform included: MacOS, Windows and Web. <br/>
   And the application must be online.
4. The prototype should be reusable if stake holders decide the feature <br/>
   should be developed for production.
5. Managing AWS resources should be easy and cost effective.

# Choice of API:

After some research, I found there are two popular currency exchange API <br/>
used: fixer-api and exchangeratesapi. Their pricing and support plan are <br/>
identical. They offer the same functions. Both have very good documentation. <br/>
However, fixer-api has longer service status. And their uptime is ~99.9%. <br/>
Hence I chose fixer-api.

# Design:

I believed the keys for making prototype in gaming industry are agility and cost.<br/>
Thus for this prototype, I chose a serverless architecture. Most components are manage <br/>
by AWS, scale effortlessly and cheap. The backend architecture consists of DynamoDB.<br/>
APIs running on AWS Lambda and an API Gateway and the application talks <br/>
The application doesn't need to know about each Lambda endpoints. It only <br/>
need to know about API Gateway endpoint which makes extend our set of APIs really<br/>
easy. Frontend is built with Flutter which can release android, iOS and Web at ease <br/>
Backend is deployed using CDK.

# API Designs:

There are three main APIs in this application:

1. CronTab: everyday, this API fetch the latest exchange rate and save it to <br/>
   DynamoDB. Currently fixer-api free tier offer daily update. If I purchase premium <br/>
   plan, the update can be set to every minute.
2. GetLatestExchangeRate: this API will ideally check if the latest exchange rate is <br/>
   cached at DAX Cache Layer. If not, it will query DynamoDB, cache the response then <br/>
   return the result to the customer. This API doesn't need to call fixer-api. <br/>
   The update and fetch fixer-api is handled by CronTab instead. Moreover, this <br/>
   API is likely be used by many games, thus it is better have only 1 updater/writer <br/>
   which is CronTab and many readers.
3. GetHistoricalExchangeRat: this API will also check the cache. If it is not there <br/>
   query the DB. If the item is not in the DB, fetch fixer-api and store the result <br/>
   in DynamoDB and cache the result for next users <br/>.

# API Endpoinst:
1. FrontEnd Repo:
https://github.com/DatTVu/currencyexchangefrontend

2. BackEnd Repo:
branch for this application: currencyexchangeservice
https://github.com/DatTVu/aws-cdk-examples/tree/master/typescript/api-cors-lambda-crud-dynamodb

3. Demo APK:
\currencyexchangefrontend\build\app\outputs\apk\release

4. Get the latest exchange rate:
   https://jq660phus7.execute-api.ap-southeast-1.amazonaws.com/prod/items/lastest

5. Get historical exchange rate:
   https://jq660phus7.execute-api.ap-southeast-1.amazonaws.com/prod/exchange/{date}

# Test cases for exchange historical rate:

1. Out of range: date bigger than today. Expect response: error
2. Out of range: date smaller than what fixer-api can support. Expect response: error
3. Wrong date format: Expect response: error. Should be handled by clientside
4. Get a historical rate multiple times. Expect reponse: should be the same everytime

# Test cases for both latest and historical rate API:

1. Slow internet: Expect response: should time out after 30 secs.
2. No internet: Expect response: error, no internet.
3. CORS: Expecte response: only allowed host can make CORS requests to the system
4. Same base currency and convert currency. Expect reponse: 1 to 1 rate.
5. Check the rate then flip the currency. Expect response: the rate should
   be the same even after flipping the side.
6. One currency to another: should display the correct result
7. Wrong currency format: should return an error to users.

# DISCLAIMERS FOR BUILD AND DEPLOY:

Currently the credentails and keys in code are dummy. To deploy, follow the steps <br/>
below to acquire the credentials and keys required.

# Back End Deploy(Deploy before Frontend):

Prequisite: git, aws-cliv2, nodejs installed.

1. git clone <repo>
2. Sign up for fixer.io to get API key and put the API key in
   get-history-rate.ts and get-latest.ts
3. Install AWS-CLI V2
4. Create an IAM user on AWS and grant them administrator access.
5. Run: aws configure
6. Follow the isntructions to fill in access key and secret for
   IAM user.
7. cd <repo_folder>
8. npm install -g aws-cdk
9. npm install
10. cd src
11. npm install
12. cd ..
13. npm run build
14. cdk deploy

After finish with the prototype: use cdk destroy to release AWS resources.

# Front End Build:

1. Install Flutter and Dart.
2. Run: flutter doc
3. Check if there is any missing dependencies and install them accordingly.
4. Get base_url from result of backend deployment. Base_url is the endpoint <br/>
   of API Gateway.Put base_url in api_provider.dart.
5. Run: flutter pub get
6. Install Android Studio.
7. Create an Android Virtual Device.
6. In VSCode, CTRL + SHIFT + P. Flutter: Select Device. Select the Android Virtual Device.
6. In VSCode, Hit Run and Debug.
7. To run on real device: flutter build apk to build Android. The build should be in <br/>
\currencyexchangefrontend\build\app\outputs\apk\release
8. To install the apk, copy it to your device. Locate the apk using file explorer or 
   ES Explorer. Click install and install anyway. You may have to enable developer mode
   before able to install the apk.

# Remaining Issues:

1. [BUG][high][FrontEnd}[BackEnd] Need to press twice before the result for historical rate <br/>
   appear. Cause: if the value doesn't exist yet, the backend fetch it <br/>
   and store it to dynamoDB. So the first request is only for fetching data from <br/>
   fixer-api into our DB but hasn't return.
2. [BUG][high][FrontEnd] The flag initial value doesn't match the currency. For example <br/>
   if I chose US as my country, I want to see my flag. However, the libary <br/>
   match it to the first country uses USD. Hence the flag doesn't match.
3. [Enhancement][low][FrontEnd] Refactor the code into MVC model. Currently most things are in
   main.
4. [BUG][high][FrontEnd] Web doesn't work yet. Since CORS hasn't been enable. So web browser <br/>
   can't make request to the backend.
5. [BUG][high][FrontEnd][BackEnd] Refactor and keep credentials/access key in .env file or use
   AWS KMS to manage it for us. Currently the credentails and keys in code are dummy. They are not
   real. 

# Future Plan and Suggestion:

1. Add Cognito to the architecture. Cognito is an authentication service managed by AWS <br/>
Cognito allows only authenticated users to make requests to the backend. Since <br/>
this application uses a paid API(fixer-api), it should only serve our customers.
2. Add CloudWatch trigger to the Lambda Functions to trigger alarm to alarm about the<br/>
health of Lambda.
