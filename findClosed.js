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