# Buoy iOS Documentation
## Pepperdine Senior Capstone (COSC 490), Spring 2015
 **Dr. Warford**
 
**Bryan Carter**

**Adam Ingleheart**

**Jeremiah Montoya**

# Overview
Buoy is a simple way to view classes offered at Pepperdine, keeping you up to date on the status of the courses you’re interested in. It is the ideal solution for schedule planning, letting you see how your week will look on the calendar, before you’ve even registered.

This implementation of Buoy is written in Swift, using Xcode. To test this project on a Mac, download the latest version of Xcode from the App Store.

# Style Guide
- Blue, orange, gray, black, and white are the only colors used in the app.
- Use white text on blue backgrounds.
- Use black text on white or light gray backgrounds.
- The Buoy icon with white text should be used on blue backgrounds.
- The Buoy icon with blue text should be used on white backgrounds.
- The Buoy icon without text should be used for the app icon.

# Dependencies
**Alamofire** - an external open source library that allows for asynchronous HTTP requests.

**CustomCollectionViewLayout** -  an extension of UICollectionViewLayout that allows for horizontal and vertical scrolling of a Collection View. We used this for our Calendar View.

**SwiftyJSON** - an external open source library that allows for less syntax, when it comes to dealing with JSON data. 

**Parse (Unimplemented)** -  a push notifications system that might be used in the future, but due to time constraints was not implemented.

# Push Notifications
- Push notifications are still unfinished with the iOS app, but we intend to use the open source Smile-SA push server library, which the Android team is currently leveraging.

# To-do
- Follow proper code reuse by having only one TableViewCell for ClassListViewController, SearchListViewController, and SectionListViewController.
- Sync Class Table View Cells with Core Data, keeping the Follow/Unfollow buttons accurate. Do not allow a user to follow a class more than once.
- On the Class List main page, make the “+ Add New Class” button a part of the table view, so that upon scrolling, it moves along with the class list content.
- Handle empty searches by telling the user that there are no classes that match.
- Allow the user to scale the Calendar, possibly by zooming in and out.
