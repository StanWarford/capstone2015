//1
var http = require('http');
var express = require("express");
var path = require("path");
var MongoClient = require('mongodb').MongoClient;
var Server = require('mongodb').Server;
var CollectionDriver = require('./collectionDriver').CollectionDriver;
var bodyParser = require("body-parser");
var app = express();
app.set("port",  8080);
app.set("ipAddress", process.env.OPENSHIFT_NODEJS_IP || "127.0.0.1");
app.use(express.bodyParser());
//app.set("ipAddress", "137.159.47.170")
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
  db.authenticate("admin", "CXaaGK5JvdR_", function(err, result){
      if (err){
        console.error(err);
      }
      if (result){
        collectionDriver = new CollectionDriver(db); 
      }
  });
});

//app.use(express.static(path.join(__dirname, "public")));

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


app.post('/update/:collection', function(req, res){
	var params = req.params;
	var collection = params.collection;
	var data = req.body;
	console.log("DATA: " + JSON.stringify(data));
	collectionDriver.update(collection, data, function(error, objs){
		res.send(200, "Success");
	});

})

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
