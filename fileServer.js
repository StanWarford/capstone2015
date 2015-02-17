var multer = require("multer");

//1
var http = require('http');
var express = require("express");
var path = require("path");
var MongoClient = require('mongodb').MongoClient;
var Server = require('mongodb').Server;
var CollectionDriver = require('./collectionDriver').CollectionDriver;
var bodyParser = require("body-parser");
var multer = require("multer");
var app = express();
app.set("port",  8080);
app.use(express.bodyParser());
app.use(multer({
	dest: "./files"
}));
app.set("ipAddress", "137.159.47.170")

//receive file with class data
app.post('/file', function(req, res){
	console.log("connection");
  res.send(200, "File uploaded");
});

app.get("/test", function(req, res){
	res.send(200, "success");
	console.log("connection");
})
 
http.createServer(app).listen(app.get("port"), app.get("ipAddress"), function(){
	console.log("express server listening on port " + app.get("port"));
  	console.log("IP: " + app.get("ipAddress"));
})
