localStorage.setItem("serverIPAddr", "http://137.159.47.86:8181/");

//localStorage.setItem("serverIPAddr", "http://137.159.148.198:8000/");

$.ajax({ // get list of classes and their information from the server
	url: "http://137.159.47.86:8181/classes",
	type: "GET",
	dataType: "text",
}).done(function(result){
	localStorage.setItem("allclasses",result); // put list in localStorage
	var pagename = String(window.location.pathname);
	if (pagename.indexOf("browse") >= 0) { // once classes are loaded, show the department list if the app is on the browse page
		showDepartments();
	}
});

var json = JSON.parse(localStorage.getItem("allclasses"));

if (localStorage.getItem("picked") === null) {
	localStorage.setItem("picked","{}");
}

if (localStorage.getItem("pushSet") === null) {
	// default is that people want push notifications!
	localStorage.setItem("pushSet", "true");
}

function flipperChange(deptFlip,clasFlip,sectFlip,val) {
	console.log(deptFlip + " " + clasFlip + " " + sectFlip + " " + val);
	var pickedlist = JSON.parse(localStorage.getItem("picked"));
	if (val == "on") {
		// add this class to the followed list
		if ((typeof pickedlist[deptFlip]) === 'undefined') {
			pickedlist[deptFlip] = {};
			pickedlist[deptFlip][clasFlip] = {};
			pickedlist[deptFlip][clasFlip][sectFlip] = json[deptFlip][clasFlip][sectFlip];
		} 
		else if ((typeof pickedlist[deptFlip][clasFlip]) == 'undefined') {
			pickedlist[deptFlip][clasFlip] = {};
			pickedlist[deptFlip][clasFlip][sectFlip] = json[deptFlip][clasFlip][sectFlip];
		} else {
			pickedlist[deptFlip][clasFlip][sectFlip] = json[deptFlip][clasFlip][sectFlip];
		}
		localStorage.setItem("picked",JSON.stringify(pickedlist));

		// tell server the user is following a new class
		if (localStorage.getItem("pushSet") == "true") {
	        $.post(localStorage.getItem("serverIPAddr") + "follow",
	        {
	            section: pickedlist[deptFlip][clasFlip][sectFlip]["section"],			// object
	            token: localStorage.getItem("regID"),	// user token
	            user: localStorage.getItem("userName")
	        },
	        function(data,status){
	            //alert("Data: " + data + "\nStatus: " + status);
	        });
		}
	} else {
		// tell server the user unfollowed this class
        if (localStorage.getItem("pushSet") == "true") {
	        $.post(localStorage.getItem("serverIPAddr") + "unfollow",
	        {
	            section: pickedlist[deptFlip][clasFlip][sectFlip]["section"],			// object
	            token: localStorage.getItem("regID"),	// user token
	            user: localStorage.getItem("userName")
	        },
	        function(data,status){
	            //alert("Data: " + data + "\nStatus: " + status);
	        });
		}
		// delete this class from the followed list
		delete pickedlist[deptFlip][clasFlip][sectFlip];
		console.log(pickedlist[deptFlip][clasFlip]);
		if ($.isEmptyObject(pickedlist[deptFlip][clasFlip])) {
			delete pickedlist[deptFlip][clasFlip];
			if ($.isEmptyObject(pickedlist[deptFlip])) {
				delete pickedlist[deptFlip];
			}
		}
		localStorage.setItem("picked",JSON.stringify(pickedlist));
	}
}

//this function takes the events that are picked by the user and formats it to the correct format for fullCalendar in home.html
function cEvents() {
	var eventColor = "";
	var calEvents=[];
    var chosen = JSON.parse(localStorage.getItem("picked"));
	for(var department in chosen){
		for(var clas in chosen[department]){
			for(var section in chosen[department][clas]){
				if (chosen[department][clas][section]["meeting"] != 'TBA') {
					var meeting = chosen[department][clas][section]["meeting"].trim().split(/\s+/);
					var days = meeting[0].split(/(?=[A-Z])/);
					for(var day in days){
						var obj = {};
						var startTime = meeting[1].split(/(?=[A-Z])/);
						var newTime = startTime[0].split(":");
						if(startTime[1]=="P" && newTime[0]!="12"){
							startTime[0] = (Number(newTime[0])+12 + ":00:00");
						} 
						else {
							startTime[0] = startTime[0]+":00";
						}
						var endTime = meeting[3].split(/(?=[A-Z])/);
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
						if (json[department][clas][section]["status"] == "Open"){
							eventColor = "#b9cf96";
						}
						else{
							eventColor = "#f06d6d";
						}
						obj.title = chosen[department][clas][section]["section"];
						obj.start = days[day] + startTime[0];
						obj.color = eventColor;
						obj.end = days[day] + endTime[0];
						calEvents.push(obj);
					}
				}
			}
		}
	}
	return calEvents;
}