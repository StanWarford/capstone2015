/*
var changed = {};

for (var entry in db_old){
	var match = db_new.find(checkSection, db_old[entry]);
  	if (!match){
    	changed[db_old[entry]["section"]] = "cancelled";
  	}
   	else if (match["info"]["status"] != db_old[entry]["info"]["status"]){
        changed[match["section"]] = match["info"]["status"];
    }
}

function checkSection(element, index, array){
	return element["section"] == this["section"];
} 
*/

var deepDiffMapper = function() {
    return {
        VALUE_CREATED: 'created',
        VALUE_UPDATED: 'updated',
        VALUE_DELETED: 'deleted',
        VALUE_UNCHANGED: 'unchanged',
        // Obj1 == new, Obj2 == old
        map: function(obj1, obj2) {
            if (this.isFunction(obj1) || this.isFunction(obj2)) {
                throw 'Invalid argument. Function given, object expected.';
            }
            if (this.isValue(obj1) || this.isValue(obj2)) {
                return {type: this.compareValues(obj1, obj2), data: obj2 || obj1};
            }
            
            var diff = {};
            for (var key in obj1) {
                if (this.isFunction(obj1[key])) {
                    continue;
                }
                
                var value2 = undefined;
                if ('undefined' != typeof(obj2[key])) {
                    value2 = obj2[key];
                }
                
                diff[key] = this.map(obj1[key], value2);
            }
            for (var key in obj2) {
                if (this.isFunction(obj2[key]) || ('undefined' != typeof(diff[key]))) {
                    continue;
                }
                
                diff[key] = this.map(undefined, obj2[key]);
            }
            
            return diff;
            
        },
        compareValues: function(value1, value2) {
            if (value1 === value2) {
                return this.VALUE_UNCHANGED;
            }
            if ('undefined' == typeof(value1)) {
                return this.VALUE_CREATED;
            }
            if ('undefined' == typeof(value2)) {
                return this.VALUE_DELETED;
            }
            
            return this.VALUE_UPDATED;
        },
        isFunction: function(obj) {
            return {}.toString.apply(obj) === '[object Function]';
        },
        isArray: function(obj) {
            return {}.toString.apply(obj) === '[object Array]';
        },
        isObject: function(obj) {
            return {}.toString.apply(obj) === '[object Object]';
        },
        isValue: function(obj) {
            return !this.isObject(obj) && !this.isArray(obj);
        }
    }
}();


var result = deepDiffMapper.map({
    "1" : {
		"section" : "COSC105.01",
		"info" : {
			"room" : "RAC170",
			"status" : "open",
			"professor" : "Brad Cupp"	
		}
	},
    "2" : {
		"section" : "COSC105.02",
		"info" : {
			"room" : "RAC170",
			"status" : "open",
			"professor" : "Brad Cupp"	
		}
     }
    },
    {
    "1" : {
		"section" : "COSC105.01",
		"info" : {
			"room" : "RAC170",
			"status" : "closed",
			"professor" : "Brad Cupp"	
		}
                                },
   "3" : {
		"section" : "COSC105.03",
		"info" : {
			"room" : "RAC170",
			"status" : "open",
			"professor" : "Brad Cupp"	
		}
     }} );

var changed = {
	"created" : [],
	"deleted" : [],
	"updated" : []
};

for (var key in result){
	if (result[key]["type"] != null){
		if (result[key]["type"] == "created"){
			changed["created"].push(result[key]["data"]["section"]);
		} else {
			changed["deleted"].push(result[key]["data"]["section"]);
		}
    } else {
        if (result[key]["info"]["status"]["type"] == "updated"){
            changed["updated"].push(result[key]["section"]["data"]);
        }
    }
}

console.log(JSON.stringify(result));




























