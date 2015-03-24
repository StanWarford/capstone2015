var json = "";
$.ajax({
	url: "http://dbserver-capstone2015.rhcloud.com/get/classes",
	type: "GET",
	dataType: "text",
}).done(function(result){
	json = JSON.parse(result);
});

var picked = "";