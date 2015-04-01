var jsonAlertList = {
    "COSC": {
        "COSC105": {
            "01": {
                "subject": "COSC",
                "section": "COSC105.01",
                "room": "RAC170",
                "status": "open",
                "professor": "Brad Cupp",
                "meeting": "MoTh 2:00PM-2:50PM"
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
var calEvents = "";

function getEvents(){
	    var json = JSON.parse(picked);
		for(var department in json){
			for(var clas in json[department]){
				for(var section in json[department][clas]){
					var meeting = json[department][clas][section]["meeting"].trim().split(/\s+/);
					var days = meeting[0].split(/(?=[A-Z])/);
					for(var day in days){
						var times = meeting[1].split("-");
						var startTime = times[0].split(/(?=[A-Z])/);
						if(startTime[1]=="P"){
							var newTime = startTime[0].split(":");
							startTime[0] = (Number(newTime[0])+12 + ":00:00");
						} 
						else {
							startTime[0] = startTime[0]+":00";
						}
						var endTime = times[1].split(/(?=[A-Z])/);
						if(endTime[1]=="P"){
							var newtime = endTime[0].split(":");
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
						calEvents+=("{title:'" + json[department][clas][section]["section"] +"',");
						calEvents+=("start:'" + days[day] + startTime[0]+"',");
						calEvents+=("end:'" + days[day] + endTime[0]+"'},");
					}
				}
			}
		}
		return calEvents;
    }