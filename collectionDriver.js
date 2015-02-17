var ObjectID = require("mongodb").ObjectID
// Flag for spinlock while database is updating
var flag = false;

CollectionDriver = function(db){
	this.db = db;
}

CollectionDriver.prototype.getCollection = function(collectionName, callback) {
  this.db.collection(collectionName, function(error, the_collection) {
    if( error ) callback(error);
    else callback(null, the_collection);
  });
};

CollectionDriver.prototype.findAll = function(collectionName, callback) {
    this.getCollection(collectionName, function(error, collection) { //A
      if( error ) callback(error);
      else {
        collection.find().toArray(function(error, results) { //B
          if( error ) callback(error);
          else callback(null, results);
        });
      }
    });
};

CollectionDriver.prototype.get = function(collectionName, id, callback) { //A
    while (flag){
        // Spinlock while database is updating
    }
    this.getCollection(collectionName, function(error, collection) {
        if (error) callback(error);
        else {
            var checkForHexRegExp = new RegExp("^[0-9a-fA-F]{24}$"); //B
            if (!checkForHexRegExp.test(id)) callback({error: "invalid id"});
            else collection.findOne({'_id':ObjectID(id)}, function(error,doc) { //C
                if (error) callback(error);
                else callback(null, doc);
            });
        }
    });
};

// Clear all entries in collection
CollectionDriver.prototype.delete = function(collectionName, callback) {
    this.getCollection(collectionName, function(error, collection) { //A
        if (error) callback(error);
        else {
            collection.remove({}, function(error,doc) { //B
                if (error) callback(error);
                else callback(null, doc);
            });
        }
    });
};

CollectionDriver.prototype.update = function(collectionName, JSONData, callback){
	this.getCollection(collectionName, function(error, collection){
		if (error) callback(error);
		else {
            // Set flag while updating
			flag = true;
            // Clear database
			collection.remove({}, function(error, results){
				if (error) callback(error);
			});
            // Iterate through new data, insert each object in database
            for (var section in JSONData){
                collection.insert(JSONData[section], function(error, results){
                if (error) callback(error);
                else callback(null, results);
            });    
            }
			// Allow database to be read
			flag = false;
		}
	});
};




exports.CollectionDriver = CollectionDriver;