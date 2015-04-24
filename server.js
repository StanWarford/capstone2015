//1
var pmx = require("pmx");
var probe = pmx.probe();
var http = require('http');
var express = require("express");
var path = require("path");
var MongoClient = require('mongodb').MongoClient;
var Server = require('mongodb').Server;
// Functions for interacting with MongoDB
var CollectionDriver = require('./collectionDriver').CollectionDriver;
//enable cross origin requests
var cors = require("cors");
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var cookieSession = require('cookie-session');
var multer = require("multer");
var fileUpload = require("./fileUpload.js")
var fs = require('fs');

var push = require('./pushserver/PushController');
var config = require('./pushserver/Config'); // Change path to config.js

var configPath = "/Users/adaminglehart/Developer/class_server/pushserver/config.json";    // gets whatever path we end up putting config.json
var overrideValues = {};
config.initialize(configPath, overrideValues);

var notify = require("./pushserver/notify.js");

var app = express();

var mongoHost = "127.0.0.1"; 
var mongoPort = 27017; 
var collectionDriver;


app.set("port", 8181);
app.set("ipAddress", "137.159.47.86");
app.use(cors());
app.use(cookieParser());
app.use(bodyParser.urlencoded({extended : true}));
app.use(bodyParser.json());
app.use(cookieSession({secret: 'app_1'}));
// Used to deal with multipart/form-data requests
app.use(multer({
  onFileUploadStart: function(file){

  },
  onFileUploadComplete: function(file){
    console.log("file done");
    fileUpload.handleFile(collectionDriver);
  },
  dest : "xmlFile",
  rename: function (fieldname, filename) {
    //var d = new Date();
    //return "classes" + d.getHours()%12 + "." + d.getMinutes() + "." + d.getSeconds();
    return "classes";
  }
}));


var mongoClient = new MongoClient(new Server(mongoHost, mongoPort)); //B

mongoClient.open(function(err, mongoClient) { 
  if (!mongoClient) {
      console.error("Error! Exiting... Must start MongoDB first");
      process.exit(1); 
  }
  var db = mongoClient.db("dbserver");  
  collectionDriver = new CollectionDriver(db); 
  });

// Returns array of all entries in specified collection
app.get('/:collection', function(req, res) { 
   var params = req.params; 
   collectionDriver.findAll(req.params.collection, function(error, objs) { //C
    	  if (error) { res.send(400, error); } 
	      else { 
	          res.set('Content-Type','application/json'); 
                  res.status(200).send(objs);
         }
   	});
});

app.post('/upload', function(req, res){
    res.status(200).send("file received");
});

// Rewrites collection with new data from request body
app.post('/update/:collection', function(req, res){
	var params = req.params;
	var collection = params.collection;
	var data = req.body;
	console.log("DATA: " + JSON.stringify(data));
	collectionDriver.update(collection, data, function(error, objs){
		res.status(200).send("success");
	});
});

app.use('/subscribe', function(req,res,next){
        var deviceInfo = req.body;
        push.subscribe(deviceInfo);
        res.status(200).send("subscribed");
});

app.post('/follow', function(req, res, next){
    var deviceInfo = req.body;
    var user = deviceInfo["user"];
    var section = deviceInfo["section"];
    collectionDriver.follow(section, user, function(){});
     res.status(200).send(section + " followed");
});

app.post("/unfollow", function (req, res, next){
   var deviceInfo = req.body;
    var user = deviceInfo["user"];
    var section = deviceInfo["section"];
    collectionDriver.unfollow(section, user, function(){});
     res.status(200).send(section + " unfollowed");
});

// For test only
app.post("/notify", function(req, res, next){

  var notifs = [
            {
                android: {
                    collapseKey: "optional",
                    data: {
                        message: "You've beem notified"
                    }
                },
                ios: {
                  "badge": 0,
                  "alert": "You have been notified"
                }
            }
        ];
        var notificationsValid = notify.sendNotifications(notifs);
        res.status(200).send("notification sent");
});

http.createServer(app).listen(app.get("port"), app.get("ipAddress"), function(){
    console.log("express server listening on port " + app.get("port"));
    console.log("IP: " + app.get("ipAddress"));
})









