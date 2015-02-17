//1
var http = require('http');
var express = require("express");
var path = require("path");
var MongoClient = require('mongodb').MongoClient;
var Server = require('mongodb').Server;
var CollectionDriver = require('./collectionDriver').CollectionDriver;
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var cookieSession = require('cookie-session');
var multer = require("multer");

var app = express();

app.use(cookieParser());
app.use(bodyParser.urlencoded({extended : true}));
app.use(bodyParser.json());
app.use(cookieSession({secret: 'app_1'}));
app.use(multer({
  onFileUploadStart: function(file){
    console.log(file.originalname + " starting");
  },
  onFileUploadComplete: function(file){
    console.log(file.originalname + " complete");
  },
  dest: "./files"
}));


app.set("port",  8080);
app.set("ipAddress", "137.159.47.86")

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
