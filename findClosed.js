var json1 = {
	//Class
	{
		"ID" : "Big number",
		"section" : "COSC105.01",
		"info" : {
			"room" : "RAC170",
			"status" : "open",
			"professor" : "Brad Cupp"	
		},
		"users" : {
			"1" : "Token1",
			"2" : "Token2"
		}
	}
	// Repeat 
}

var json2 = {
	//Class
	{
		"ID" : "Big number",
		"section" : "COSC105.01",
		"info" : {
			"room" : "RAC170",
			"status" : "closed",
			"professor" : "Brad Cupp"	
		},
		"users" : {
			"1" : "Token1",
			"2" : "Token2"
		}
	}
	// Repeat 
}

var changed = {};

function compare(db_old, db_new){
	for (var section in db_old){
		if (db_new[section]["info"]["status"] == null){

		}
		else if (db_old[section]["info"]["status"] != db_new[section]["info"][status]){
			changed[section] = db_new["info"]["status"];
		}
	}
}