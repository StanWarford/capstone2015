deepDiffMapper = function() {
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
                //return {type: this.compareValues(obj1, obj2), data: obj2 || obj1};
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


exports.getChanged = function(classesOld, classesNew){
    var result = deepDiffMapper.map(classesOld, classesNew);
    var changed = {
    "cancelled" : [],
    "added" : [],
    "opened" : [],
    "closed" : []
};
for (var subject in result) {
    if (result[subject]["type"] != null) {
        if (result[subject]["type"] == "deleted"){
            // Add all sections in all classes in subject to cancelled
            for (var className in result[subject]["data"]){
                for (var section in result[subject]["data"][className]){
                    changed["cancelled"].push(className + "." + section);
                }
            }
        }
    } else {
        for (var className in result[subject]) {
            if (result[subject][className]["type"] != null) {
                if (result[subject][className]["type"] == "deleted") {
                    // Add all sections in class to cancelled
                    for (var section in result[subject][className]["data"]){
                        changed["cancelled"].push(className + "." + section);
                    }
                }
            } else {
                for (var section in result[subject][className]) {
                    if (result[subject][className][section]["type"] != null) {
                        if (result[subject][className][section]["type"] == "deleted") {
                            // Add section to cancelled
                            changed["cancelled"].push(className + "." + section);
                      }
                    } else {
                        if (result[subject][className][section]["status"]["type"] != "unchanged") {
                            if (result[subject][className][section]["status"]["data"] == "Open") {
                                changed["opened"].push(className + "." + section);
                            } else {
                                changed["closed"].push(className + "." + section);
                            }
                        }
                    }
                }
            }
        }
    }
}
return changed;
}





