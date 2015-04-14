$.ajax({
	url: "http://137.159.47.86:8181/classes",
	type: "GET",
	dataType: "text",
}).done(function(result){
	// var ajson = JSON.parse(result);
	localStorage.setItem("allclasses",result);
	var pagename = String(window.location.pathname);
	if (pagename.indexOf("browse") >= 0) {
		showDepartments();
	}
});

var json = JSON.parse(localStorage.getItem("allclasses"));

if (localStorage.getItem("picked") === null) {
	localStorage.setItem("picked","{}");
}




function flipperChange(deptFlip,clasFlip,sectFlip,val) {
	console.log(deptFlip + " " + clasFlip + " " + sectFlip + " " + val);
	// for (var all in picked) {
	// 	delete picked[all];
	// }
	var pickedlist = JSON.parse(localStorage.getItem("picked"));
	if (val == "on") {
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
        $.post("http://137.159.150.222:8000/follow",
        {
            section: pickedlist[deptFlip][clasFlip][sectFlip]["section"],			// object
            token: localStorage.getItem("regID"),	// user token
            user: localStorage.getItem("userName")
        },
        function(data,status){
            alert("Data: " + data + "\nStatus: " + status);
        });

	} else {

		// tell server the user unfollowed this class
		//alert(JSON.stringify(pickedlist[deptFlip]));

        $.post("http://137.159.150.222:8000/unfollow",
        {
            section: pickedlist[deptFlip][clasFlip][sectFlip]["section"],			// object
            token: localStorage.getItem("regID"),	// user token
            user: localStorage.getItem("userName")
        },
        function(data,status){
            alert("Data: " + data + "\nStatus: " + status);
        });


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
	console.log("Picked: "+JSON.stringify(pickedlist));
}


// var picked = JSON.stringify(jsonAlertList);

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
						// var times = meeting[1].split("-");
						// var times = meeting[1];
						// console.log("times: " + times);
						// var startTime = times[0].split(/(?=[A-Z])/);
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

// alert(localStorage.getItem("firstLogin"));

// if (localStorage.getItem("firstLogin") == "false") {
// 	alert("In if");
// 	localStorage.setItem("firstLogin", "true");
// 	alert(localStorage.getItem("firstLogin"));
// }
