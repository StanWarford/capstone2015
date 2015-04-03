// var json = "";
// $.ajax({
// 	url: "http://dbserver-capstone2015.rhcloud.com/get/classes",
// 	type: "GET",
// 	dataType: "text",
// }).done(function(result){
// 	json = JSON.parse(result);
// });

var jsonAlertList = {
    "COSC": {
        "COSC105": {
            "01": {
                "subject": "COSC",
                "section": "COSC105.01",
                "room": "RAC170",
                "status": "open",
                "professor": "Brad Cupp",
                "meeting": "MoTh 2:00PM-5:50PM"
            },
            "02": {
                "subject": "COSC",
                "section": "COSC105.02",
                "room": "RAC170",
                "status": "closed",
                "professor": "Brad Cupp",
                "meeting": "MoTh 3:00PM-3:50PM"
            }
        },
        "COSC330": {
            "01": {
                "subject": "COSC",
                "section": "COSC330.01",
                "room": "RAC170",
                "status": "open",
                "professor": "Stan Warford",
                "meeting": "MoTh 2:00PM-2:50PM"
            }
        }
    },
    "MATH": {
        "MATH151": {
            "01": {
                "subject": "MATH",
                "section": "MATH151.01",
                "room": "RAC170",
                "status": "open",
                "professor": "Brad Cupp",
                "meeting": "MoTh 2:00PM-2:50PM"
            },
            "02": {
                "subject": "MATH",
                "section": "MATH151.02",
                "room": "RAC170",
                "status": "closed",
                "professor": "Brad Cupp",
                "meeting": "MoTh 3:00PM-3:50PM"
            }
        }
    }
};


var picked = JSON.stringify(jsonAlertList);

function cEvents() {
	var eventColor = "";
	var calEvents=[];
	console.log(calEvents);
    var json = JSON.parse(picked);
	for(var department in json){
		for(var clas in json[department]){
			for(var section in json[department][clas]){
				var meeting = json[department][clas][section]["meeting"].trim().split(/\s+/);
				var days = meeting[0].split(/(?=[A-Z])/);
				for(var day in days){
					var obj = {};
					var times = meeting[1].split("-");
					var startTime = times[0].split(/(?=[A-Z])/);
					var newTime = startTime[0].split(":");
					if(startTime[1]=="P" && newTime[0]!="12"){
						startTime[0] = (Number(newTime[0])+12 + ":00:00");
					} 
					else {
						startTime[0] = startTime[0]+":00";
					}
					var endTime = times[1].split(/(?=[A-Z])/);
					var newtime = endTime[0].split(":");
					if(endTime[1]=="P" && newtime[0]!="12"){
						endTime[0] = (Number(newtime[0])+12 + ":" + newtime[1] +":00");
					} 
					else {
						endTime[0] = endTime[0]+":00";
					}

					switch (days[day]) {
					    case "Mo":
					        days[day] = "2015-08-31T";
					        break;
					    case "Tu":
					        days[day] = "2015-09-01T";
					        break;
					    case "We":
					        days[day] = "2015-09-02T";
					        break;
					    case "Th":
					        days[day] = "2015-09-03T";
					        break;
					    case "Fr":
					        days[day] = "2015-09-04T";
					        break;
					}
					if (json[department][clas][section]["status"]=="open"){
						eventColor = "#a6e69a";
					}
					else{
						eventColor = "#f06d6d";
					}
					obj.title = json[department][clas][section]["section"];
					obj.start = days[day] + startTime[0];
					obj.color = eventColor;
					obj.end = days[day] + endTime[0];
					calEvents.push(obj);
				}
			}
		}
	}
	return calEvents;
}


