Kringle
=======

Secret Santa app for everyone.  Users may sign up to participate in a secret santa exchange.  Each user must login with facebook and may then add additional information (ie.. the sort of gifts they like) to that which I grab from facebook (picture/name/email/birthday).  On the date of the trade, each user draws a name of someone else participating in the exchange.  

To make sure that each user is giving to and receiving from exactly 1 user, I create an array of each user and then order it by the hashed objectIds.  That provides a pseudo random order.  Each user then 'draws the name' of the user to their left in the array.  The user in the 1st spot in the array draws the last user's name.

Uses:

* Parse.com framework
* Socialize framework
* Facebook authentication
* Facebook/Twitter integration for sharing to both
* multiple threads via Grand Central Dispatch
* UINavigationController
* UIModalView
* UIScrollView
* NSPredicate
* blocks
* delegate methods
* lots of great stock images

