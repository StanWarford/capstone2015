//1
var http = require('http');
var express = require("express");
var path = require("path");
var MongoClient = require('mongodb').MongoClient;
var Server = require('mongodb').Server;
// Functions for interacting with MongoDB
var CollectionDriver = require('./collectionDriver').CollectionDriver;

var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var cookieSession = require('cookie-session');
var multer = require("multer");

var app = express();

app.set("port",  8080);
app.set("ipAddress", process.env.OPENSHIFT_NODEJS_IP || "127.0.0.1");

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
    console.log(file.originalname + " complete");
  },
  dest: "./files"
}));

var mongoHost = process.env.OPENSHIFT_MONGODB_DB_HOST; 
var mongoPort = process.env.OPENSHIFT_MONGODB_DB_PORT; 
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

//receive file from Warford with class data
app.post('/file', function(req, res){
  res.send(200, "File uploaded");
});

 /*
 // Access specific element or list of elements
app.get('/get/:collection/:entity', function(req, res) { //I
   var params = req.params;
   var entity = params.entity;
   var collection = params.collection;
   if (entity) {
       collectionDriver.get(collection, entity, function(error, objs) { //J
          if (error) { res.send(400, error); }
          else { res.send(200, "Success"); } //K
       });
   } else {
      res.send(400, {error: 'bad url', url: req.url});
   }
});
*/
 
http.createServer(app).listen(app.get("port"), app.get("ipAddress"), function(){
	console.log("express server listening on port " + app.get("port"));
  console.log("IP: " + app.get("ipAddress"));
})
