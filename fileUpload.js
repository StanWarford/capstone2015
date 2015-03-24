var xml2js = require('xml2js');
var CollectionDriver = require('./collectionDriver').CollectionDriver;
var fs = require("fs");

exports.handleFile = function(collectionDriver){
  var jsonString;
  var jsonBlob = {};
  var parser = new xml2js.Parser();
  var numberOfClasses;
  var classes;

  fs.readFile("xmlFile/classes.xml", "utf-8", function(err,raw_xml){ //read XML file
    if(err) throw err;

    
    parser.parseString(raw_xml, function(err, result){
      
      classes = result['webRowSet']['data'][0]['currentRow'];
      numberOfClasses = result['webRowSet']['data'][0]['currentRow'].length;

      for(var j = 0; j < numberOfClasses; j++){ //Get unique department --> "COSC"
      var child = classes[j]['columnValue'];
      
      var department = child[4]; //COSC

      if(!(jsonBlob.hasOwnProperty(department))){
        jsonBlob[department] = {};
      }

    }


    for(var j = 0; j < numberOfClasses; j++){ //Get unique courses --> "COSC 101"
      var child = classes[j]['columnValue'];

      var department = child[4]; //COSC
      var course = child[4] + child[6]; //COSC 101

      if(!(jsonBlob[department].hasOwnProperty(course))){
        jsonBlob[[department]][[course]] = {};
        }

      }


    for(var j = 0; j < numberOfClasses; j++){ //Get unique section --> "01"
      var child = classes[j]['columnValue'];

      var department = child[4]; //COSC
      var course = child[4] + child[6]; //COSC 101
      var section = child[7]; //01


        jsonBlob[[department]][[course]][[section]] = {
          "subject" : child[7],
          "section" : child[5] + child[6] + "." + child[7],
          "professor" : child[15],
          "status" : child[8],
          "room" : child[14],
          "meeting" : child[13],
          "name" : child[25]
        };

      }

    });

   jsonString = JSON.stringify(jsonBlob, null, 3); //Indented 3 spaces
   collectionDriver.update("classes", jsonBlob, function(error, objs){
    if (error) { } 
        else { 
           
         }
   })
  });
}
