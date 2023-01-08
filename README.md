# mechat

A Flutter project integrated with firebase authentication and firestore.

## SignIn Page

Existing user can sign-in to the app and firebase authentication is used for this
Also contains Sign-up and Reset Password buttons

## SignUp Page

New users can create their account using email address.

## ResetPage

If any users forget their password, firebase is used to send a reset password link to their email

## Home Page and Chats

After sign-in/sign-up, the user can enter the homescreen which includes a search bar. User can search for other users by entering their exact email id. Once a chat is initiated with the user, firestore creates a collection with an id, concatenating both the usernames. The collection will contain documents of chats of the users.

