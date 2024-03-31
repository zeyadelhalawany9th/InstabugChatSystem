# Code Specs

#### To run the project -> docker-compose up -> <http://localhost:3000/>

#### Check http://localhost:3000/routes for all the available routes

## Tools Used

#### The chats_count and messages_count fields are updated every 15 minutes using Rufus Scheduler

#### Indices are added to the app_token, chat_number and message_number fields along with the foreign keys for the chats and the messages tables (chats -> application_id, messages -> chat_id and application_id) to optimize the tables

#### MySQL Database

#### RabbitMQ and Sneakers -> To handle the queuing of inserting to the database when creating new chats and messages

#### Elasticsearch -> Searching through the bodies of the messages (Partial match)

#### Redis -> To keep track of the auto incrementing fields of chat_number and message_number and therefore handing the race condition

## Endpoints

#### POST <http://localhost:3000/applications> -> Create a new application with "app_name" as a parameter -> new token is generated

#### GET <http://localhost:3000/applications> -> Retrieve all existing applications

#### GET <http://localhost:3000/applications/app_token> -> Retrieve a specific application with its token 

#### POST <http://localhost:3000/applications/app_token/chats> -> Create a new chat for a specific application

#### GET <http://localhost:3000/applications/app_token/chats> -> Retrieve all chats for a specific application

#### GET <http://localhost:3000/applications/app_token/chats/chat_number> -> Retrieve a specific chat from a specific application with its number

#### POST <http://localhost:3000/applications/app_token/chats/chat_number/messages> -> Create a new message for a specific chat from a specific application with "body" as a parameter

#### GET <http://localhost:3000/applications/app_token/chats/chat_number/messages> -> Retrieve all messages from a specific chat from a specific application

#### GET <http://localhost:3000/applications/app_token/chats/chat_number/messages/message_number> -> Retrieve a specific message from a specific chat from a specific application with its number

#### POST <http://localhost:3000/applications/app_token/chats/chat_number/messages/search> -> Search for a specific message from a specific chat from a specific application with "text" as a parameter (partial match)

#### Update and Delete requests can be done using the same endpoints


