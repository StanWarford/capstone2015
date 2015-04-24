# Capstone 2015 Back-end Documentation

## Endpoints

A colon in a URL represents a parameter that can be specified by the client

* GET /:collection
	- Returns a JSON object containing all class information using the specified MongoDB collection.

* POST /upload
       - Body: An XML file    
       - Handles the upload of an XML file containing all class information. 

* POST /update/:collection
      - Body: A JSON object containing the new class information.
      - Updates the specified collection in the database with the provided JSON data.

* POST /subscribe
     - Body: A JSON object containing required user information according to the node-pushserver documentation (https://www.npmjs.com/package/node-pushserver) 
     - Adds a user to the pushassociations collection, which contains a unique entry for each user of the app.

* POST /follow
	- Body: A JSON object containing the user's unique ID and the name of the class section they wish to follow 
	- Adds a user to an array of users following a specified section. This information is stored in the subscriptions collection of the database. 

* POST /unfollow
	- Body: A JSON object containing the user's unique ID and the name of the class section they wish to unfollow
	-  Removes a user from an array of users following a specified section. This information is stored in the subscriptions collection of the database. 	

## Cross-Platform Push Notification Library
* All of the methods used to subscribe users and send push notifications to users come from the Smile-SA node-pushserver project, which can be found here: https://github.com/Smile-SA/node-pushserver
* The only changes one would generally make to this code would be to config.json, which contains the the mongoDB URL, and project information for iOS and Android projects so the server can send push notifications. Other than that, the methods from this project were used as-is.
