// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
function check_in()
{
	document.getElementById("checkin_button").style.display = "none";
	document.getElementById("checkout_button").style.display = "block";

	start();
}

function check_out()
{
	document.getElementById("checkin_button").style.display = "block";
	document.getElementById("checkout_button").style.display = "none";

	stop();
}


/* complementary function */

var interval;

function startCount(){
	var second = parseInt(document.getElementById("timer-second").innerHTML, 10);

	var minute = parseInt(document.getElementById("timer-minute").innerHTML, 10);
	var hour = parseInt(document.getElementById("timer-hour").innerHTML, 10);
	if (second < 59){
		second++;
	} else{
		second = 0;
		if (minute < 59) {
			minute++;
		}else{
			minute = 0;
			if (hour < 59) {
				hour++;
			}
		}
	}

	document.getElementById("timer-second").innerHTML = padding(second.toString());
	document.getElementById("timer-minute").innerHTML = padding(minute.toString());
	document.getElementById("timer-hour").innerHTML = padding(hour.toString());
}

function start(){
	document.getElementById("timer-second").innerHTML = "00";
	document.getElementById("timer-minute").innerHTML = "00";
	document.getElementById("timer-hour").innerHTML = "00";
	interval = setInterval(function() {startCount();}, 1000);
}

function stop(){
	clearInterval(interval);
}

function padding(number){
	while(number.length < 2){
			number = '0' + number;
	}

	return number;
}

function popUp(){
	document.getElementById("popup_window").style.opacity = "1";
	document.getElementById("popup_window").style.zIndex = 5;
}

function close_popup(){
	document.getElementById("popup_window").style.opacity = "0";
	document.getElementById("popup_window").style.zIndex = -5;
}

function checkDate(){
	var date_from = document.getElementById("datefrom").value;
	var date_to = document.getElementById("dateto").value;
	var dmy_from;
	var dmy_to;
	var f;
	var t;

			//element[0] = date, element[1] = month, elemen[2] = year
			dmy_from = date_from.split("/");
			dmy_to = date_to.split("/");

			f = new Date();
			f.setFullYear(dmy_from[2], parseInt(dmy_from[1])-1, dmy_from[0]);

			t = new Date();
			t.setFullYear(dmy_to[2], parseInt(dmy_to[1])-1, dmy_to[0]);

	if (f > t){
		alert("Wrong input! End Date must be the same date or after the Start Date!");
		return false;
	}
	return true;
}
