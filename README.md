## Capstone2015: Project Documentation, PhoneGap Version
### Pepperdine Computer Science Senior Capstone Project, 2015
**Dr. Stan Warford** 

**Chloe Cheung**

**Samantha Olson**

**Eva Varotsis**


### Introduction:
Buoy is a cross-platform class-scheduling mobile application. It is a simple way to view classes offered at Pepperdine, keeping you up to date on the status of the courses you're interested in. It is the ideal solution for schedule planning, letting you see how your week will look on the calendar before you've even registered.

This implementation of Buoy uses PhoneGap, which takes a web application made with HTML, CSS, and Javascript and can build the app into other platforms. This project only contains the build for Android, but other platforms can be built if the corresponding SDK is provided. Please see http://phonegap.com/ for more information on how to install and use PhoneGap applications.

### Design:

FullCalendar was used to create the calendar portion of the app. Moment.min and jQuery are needed to use FullCalendar. Documentation for how to use this plug-in can be found at http://fullcalendar.io/docs/.

### Tracking Classes:


### Push Notifications:
js/index.js contains the handlers for registering a device with Google Cloud Messaging/Apple Push Notification Service (GCM/APN) (only GCM will be discussed since only the Android platform was being built) as well as what to do when the device receives a notification.

The device will only be registered with GCM once (localStorage tracks whether or not the device has been registered). This should occur when the user first launches the app and views first.html. He/she should input their NTID and press “submit.” This will both register the device (with app.initialize(app.registerUser)) and send an AJAX request to the project server to record the username and registration ID in the database.

app.initialize() must be called on every .html page where you would want push notifications to be handled. Without calling app.initialize(), the handlers for push notifications will not be set up and push notifications cannot be received correctly. app.initialize(app.registerUser) must be called when you want the user to go through the subscribing/registering process.

The app also makes AJAX calls to the server when the user follows and unfollows a class. These can be found in js/global.js in the function, “flipperChange.” The server must be notified so that it can keep track of which users are following which classes so that the appropriate notifications can be sent.

All AJAX calls to the server that regard push notifications are disabled when the user sets “Push Notification Alerts” to off (which can be set in both first.html and options.html). The localStorage item “pushSet” is “true” when the user allows notification alerts and “false” when they don’t. In js/global.js, it is initialzied to “true”. Several other localStorage items are set throughout the app, to track usernames, etc. and are essentially self-explanatory in the code.

The following is a pretty thorough tutorial on how to set up push notifications with a PhoneGap application, specifically Android. All of the steps have been completed, as push notifications are currently being handled succesfully, but here is the link in case it needs to be referred to again:
http://devgirl.org/2013/07/17/tutorial-implement-push-notifications-in-your-phonegap-application/

The following is the necessary information from the Google Developers Console that aid in setting up with GCM:

Project ID: moonlit-state-859
Project Number (Sender ID to use in app): 1047272876473
API Key (For server to use): AIzaSyCxsa6qGhehj4E2U2pnS4ax8zrZDFIPTg4

Furthermore, the server had to be set up to communicate with GCM. An open source cross-platform push notification library was utilized to help with this, which can be found here:
https://github.com/Smile-SA/node-pushserver
More information on how this works with the server can be found in the documentation for the project server.

### AJAX Calls:
To make it easier to switch which server you are communicating with, there is a localStorage item called “serverIPAddr” which stores the server address. Using that item, you can just append desired URL params such as “/subscribe”, “/follow”, “/unfollow”, etc.
This made it easier during testing between different servers. This localStorage item may or may not be used depending on your preference.

Running in Browser vs. Running Natively on Device:
Very few changes need to be made to the application if you are going to run it in a browser (running the app through the PhoneGap Developer App is analogous to running it in a browser) or natively on a device.

If you do run into problems where the platform differences causes errors, you can often check which platform you are on in the code itself with checking “device.platform” and then do different things according to which platform gets detected.

The biggest annoyance with running on a browser was that www/cordova.js would not cooperate. In cordova.js, two specific alerts come up (annoyingly) only when in a browser, which can be found on lines

353: return prompt(argsJson, 'gap:'+JSON.stringify([bridgeSecret, service, action, callbackId]));

and

941: bridgeSecret = +prompt('', 'gap_init:' + nativeToJsBridgeMode);

I simply commented out these lines so that they don’t come up at all, which probably isn’t the best solution, but worked for the scope that we were dealing with at the time. So far, commenting out these lines did not bring forth any problems. But then again, I did not write cordova.js and therefore am not the best judge of the importance of these lines.

Another quick fix was simply commenting out the JavaScript lines that include cordova.js every time we ran the app in a browser. However, you would need to uncomment these lines when installing on a device. The previous fix was more sustainable than this fix.
