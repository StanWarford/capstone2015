function add_header () {
	console.log("loaded");
	var header_contents = read_contents ("header.txt" );
	console.log("header" + header_contents);
	$("#header").html(header_contents);
	alert("done");
}