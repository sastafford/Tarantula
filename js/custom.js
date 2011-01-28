$(document).ready(function(){
	var refreshId = setInterval(function() {
		$("div#count").load("count.xqy");
		}, 3000);
    });



