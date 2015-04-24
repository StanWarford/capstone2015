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
        var js = {};
        collection.find().each(function(error, item) { //B
          if( error ) callback(error);
          else{
            if (item == null){
                //cursor is empty
                callback(null, js);
            } else {
                // add item to json with section name as key
                var subject = item["subject"];
                delete item.subject
                delete item._id;
                js[subject] = item;
            }
          }
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
            for (var subject in JSONData){
                JSONData[subject]["subject"] = subject;
                collection.insert(JSONData[subject], function(error, results){
                if (error) callback(error);
                else callback(null, results);
            });    
            }
			// Allow database to be read
			flag = false;
		}
	});
};

CollectionDriver.prototype.follow = function(sectionName, user, callback){
    this.getCollection("subscriptions", function(error, collection){
    var subscribersList;
        collection.findOne({section : sectionName}, function(error, item){
            if (error) {return error;}
            
            if (item == null){
                collection.insert({section : sectionName, subscribers : []}, function(error, doc){
                    subscribersList = doc[0]["subscribers"];
                    if (subscribersList.indexOf(user) == -1){
                        subscribersList.push(user);
                        collection.update({section : sectionName}, {$set : {subscribers : subscribersList}}, function(){});
                    }   
                });
            } else {
                subscribersList = item["subscribers"];
                if (subscribersList.indexOf(user) == -1){
                    subscribersList.push(user);
                    collection.update({section : sectionName}, {$set : {subscribers : subscribersList}}, function(){});
                }
            }   
            
        })
    });
}

CollectionDriver.prototype.unfollow = function(sectionName, user, callback){
    this.getCollection("subscriptions", function(error, collection){
        collection.findOne({section : sectionName}, function(error, item){
            if (error) {return error;}
            var subscribersList = item["subscribers"];
            var index = subscribersList.indexOf(user);
            if (index != -1){
                subscribersList.splice(index, 1);
                collection.update({section : sectionName}, {$set : {subscribers : subscribersList}}, function(){});
            }
        })
    })
}




exports.CollectionDriver = CollectionDriver;