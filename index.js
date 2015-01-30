//1
var http = require('http');
var express = require("express");
var path = require("path");
var MongoClient = require('mongodb').MongoClient;
var Server = require('mongodb').Server;
var CollectionDriver = require('./collectionDriver').CollectionDriver;

var bodyParser = require('body-parser');
 
var app = express();
app.set("port", process.env.PORT || 3000);
//app.set('views', path.join(__dirname, 'views'));
//app.set('view engine', 'jade');
var mongoHost = 'localHost'; 
var mongoPort = 27017; 
var collectionDriver;

app.use(bodyParser.json());
 
var mongoClient = new MongoClient(new Server(mongoHost, mongoPort)); //B

mongoClient.open(function(err, mongoClient) { 
  if (!mongoClient) {
      console.error("Error! Exiting... Must start MongoDB first");
      process.exit(1); 
  }
  var db = mongoClient.db("mydb");  
  collectionDriver = new CollectionDriver(db); 
});

app.use(express.static(path.join(__dirname, "public")));

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
	console.log("DATA: " + data);
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
 
http.createServer(app).listen(app.get("port"), function(){
	console.log("express server listening on port " + app.get("port"));
})
