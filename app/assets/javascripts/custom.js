$(function () {  
  $(document).on('click', '#companies th a, #companies .pagination a', function () {  
    $.getScript(this.href);  
    return false;  
  });  

  $('#companies_search input').keyup(function () {  
  $.get($('#companies_search').attr('action'),  
    $('#companies_search').serialize(), null, 'script');  
  return false;  
  });  

  $(document).on('click', '#users th a, #users .pagination a', function () {  
    $.getScript(this.href);  
    return false;  
  });  

  $('#users_search input').keyup(function () {  
  $.get($('#users_search').attr('action'),  
    $('#users_search').serialize(), null, 'script');  
  return false;  
  });
})  

function to_signup()
{
	window.location = '/signup';
}

function to_signin()
{
	window.location = '/signin';
}

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

function add_employee()
{
	document.getElementById("add_employee_label").style.display = "block";
	document.getElementById("add_employee_form").style.display = "block";

	var form = $("#add_employee_form");
    startAnimation();
    function startAnimation(){
      form.animate({height:300},"slow");
    }

    setTimeout(func, 500);

    function func() {
		document.getElementById("add_employee_label").scrollIntoView();
	}
}

function show_hidden()
{
	modifyStyleRule('.hidden_field', "display: block !important;");
	modifyStyleRule('.shown_field', "display: none !important;");
}

function hide_hidden()
{
	window.location.reload();
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

/* from web */

/* Replace the cssText for rule matching selectorText with value
** Changes all matching rules in all style sheets
*/
function modifyStyleRule(selectorText, value) {
  var sheets = document.styleSheets;
  var sheet, rules, rule;
  var i, j, k, l;

  for (i=0, iLen=sheets.length; i<iLen; i++) {
    sheet = sheets[i];

    // W3C model
    if (sheet.cssRules) {
      rules = sheet.cssRules;

      for (j=0, jLen=rules.length; j<jLen; j++) {
        rule = rules[j];

        if (rule.selectorText == selectorText) {
          removeRule(sheet, rule);
          addRule(sheet, selectorText, value);
        }
      }

    // IE model
    } else if (sheet.rules) {
      rules = sheet.rules;

      for (k=0, kLen=rules.length; k<kLen; k++) {
        rule = rules[k];

        // An alternative is to just modify rule.style.cssText,
        // but this way keeps it consistent with W3C model
        if (rule.selectorText == selectorText) {
          removeRule(sheet, rule);
          addRule(sheet, selectorText, value);

          // Alternative
          // rule.style.cssText = value;
        }
      }
    }
  }
}

/* Remove rule from supplied sheet
*/
function removeRule(sheet, rule) {

  // W3C model
  if (typeof sheet.deleteRule == 'function') {
    sheet.deleteRule(rule);

  // IE model
  } else if (sheet.removeRule) {
    sheet.removeRule(rule);
  }
}

/* Add rule from supplied sheet
** Rule is added as last rule in sheet
*/
function addRule(sheet, selectorText, value) {

  // W3C model
  if (typeof sheet.insertRule == 'function') {
    sheet.insertRule(selectorText + ' {' + value + '}', sheet.cssRules.length);

  // IE model
  } else if (sheet.addRule) {
    sheet.addRule(selectorText, value, sheet.rules.length);
  }
}