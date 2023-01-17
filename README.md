# quizzapp

A Flutter project created by me as part of an excersize given by the Mobile Computing lecture.

<img src ="https://github.com/dersiwi/quizzapp/blob/master/images/question_wrong.png" alt="app prev" style="height:200px;"/>

## Basic idea

The app is basically an endless quiz. The first screen mainly has two function

- Choosing a category of questions
- Connecting an eSense device

### Quiz
After clicking on one of the categories, the App will fetch questions from https://the-trivia-api.com/ and display them to the user.  
The user has 4 possible answers. If he chooses the correct one, his score goes up and the next answer is generated.  
If he chooses the wrong answer, the correct answer is shown and the next question is loaded.  

### eSense
#### Connection
The user is able to connect an eSense device via BLE. For this, he has to enter the device name, as presented in the home-screen of the app. He then has to initiate the connection, also via a button on the home-screen.  

#### Usage
After a device has been successfully connected, a user can go on with the app as normal; choose a category and answer question.  
The app tries to recognize whether a question is too hard by the users head movements; 

- if th user shakes his head, the next question is loaded

this can also be used proactively by the user; the user is able to skip questions he doesn't like by looking to the right quickly.


