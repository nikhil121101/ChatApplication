#Application discription

a messaging app where :

- one can login with there email and password Or if not an existing user then can
  sign-up with there email(valid) , password(at leat 8 character including a Capital letter character , 
  a number and a special character) , and a unique username(min lenghth 4) 

- two user can search each other by there username
  and send messages to one another 

- a fully fledged message log page to see the all chats



technology used -> 

 - Flutter 1.17.3 ,  Dart 2.8.4

 - firebase authentication to authenticate and add users and reset password facility too

 - firebase database to store deatils of ech user registerd , ongoing chats between two node (chatRoom ID) and messages in that chat

 - email validator to validate if the enterde email exist or not

 - shared prefernces to store the data of currrent user(logged in but not logged out) so that one dont
   need to re - login until user sign outs
