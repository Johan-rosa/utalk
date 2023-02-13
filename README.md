# Utalk

This is a chat application developed using shiny. The idea of the project was to
create a non-typical shiny application, something not related to data analysis and
dashboards. [Deployed version](https://demo.prod.appsilon.ai/utalk/)

## Technical highlight

1. Custom CSS to create an user interface that doesn't look like a shiny app
2. Google's Firebase for authentication and real-time database storage
3. Shiny modules
4. Sending information to R server via JS code
5. jQuery

## Inspiration

Whatsapp web application

## Features
1. Login and authentication
2. Persistent storage of conversations
3. Notification of new messages
4. Switch between chats

## Planed features

- Creating groups
- Search contacts
- Using emojis

## How to run the app locally

1. Create a firebase project, example described in [this post](https://firebase.john-coene.com/guide/get-started/) by John Coene
2. Clone this repository and restore dependencies
3. Create the following environment variables: `FIREBASE_API_KEY`, `FIREBASE_PROJECT_ID`, `FIREBASE_AUTH_DOMAIN`, `FIREBASE_STORAGE_BUCKET`, `FIREBASE_APP_ID`, `FIREBASE_DATABASE_URL`, `db_url`, `fb_key`. More details [here](https://firebase.john-coene.com/guide/config/)
4. Run the app
