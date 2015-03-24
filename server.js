//1
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


var app = express();

app.set("port", process.env.OPENSHIFT_NODEJS_PORT || 8181);
app.set("ipAddress", process.env.OPENSHIFT_NODEJS_IP || "137.159.47.86");
app.use(cors());
app.use(cookieParser());
app.use(bodyParser.urlencoded({extended : true}));
app.use(bodyParser.json());
app.use(cookieSession({secret: 'app_1'}));
// Used to deal with multipart/form-data requests
app.use(multer({
  onFileUploadStart: function(file){
    console.log(file.originalname + " starting");
  },
  onFileUploadComplete: function(file){
    fileUpload.handleFile(collectionDriver);
  },
  dest : "xmlFile",
  rename: function (fieldname, filename) {
    return "classes"
  }
}));

var mongoHost = process.env.OPENSHIFT_MONGODB_DB_HOST || "137.159.47.86"; 
var mongoPort = process.env.OPENSHIFT_MONGODB_DB_PORT || 27017; 
var collectionDriver;
 
var mongoClient = new MongoClient(new Server(mongoHost, mongoPort)); //B

mongoClient.open(function(err, mongoClient) { 
  if (!mongoClient) {
      console.error("Error! Exiting... Must start MongoDB first");
      process.exit(1); 
  }
  var db = mongoClient.db("dbserver");  
  // Authentication for OpenShift MongoDB instance
  db.authenticate("admin", "CXaaGK5JvdR_", function(err, result){
      if (err){
        console.error(err);
      }
      if (result){
        // Initialize collectionDriver with authenticated database
        collectionDriver = new CollectionDriver(db); 
      }
  });
});

// Returns array of all entries in specified collection
app.get('/get/:collection', function(req, res) { 
   var params = req.params; 
   collectionDriver.findAll(req.params.collection, function(error, objs) { //C
    	  if (error) { res.send(400, error); } 
	      else { 
	          res.set('Content-Type','application/json'); 
                  res.send(200, objs); 
         }
   	});
});

app.post('/upload', function(req, res){
    res.send(200, "file received");
});

// Rewrites collection with new data from request body
app.post('/update/:collection', function(req, res){
	var params = req.params;
	var collection = params.collection;
	var data = req.body;
	console.log("DATA: " + JSON.stringify(data));
	collectionDriver.update(collection, data, function(error, objs){
		res.send(200, "Success");
	});
});

http.createServer(app).listen(app.get("port"), app.get("ipAddress"), function(){
    console.log("express server listening on port " + app.get("port"));
    console.log("IP: " + app.get("ipAddress"));
})