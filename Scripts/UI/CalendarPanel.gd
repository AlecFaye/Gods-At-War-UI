extends Panel


onready var CalendarContainer = $CalendarContainer
onready var MonthLabel = $Month

var dates = []

var month_dic = {
	1: "January",
	2: "February",
	3: "March",
	4: "April",
	5: "May",
	6: "June", 
	7: "July",
	8: "August",
	9: "September",
	10: "October",
	11: "November",
	12: "December"
	}

var days_dic = {
	"January": 31,
	"February": 28,
	"March": 31,
	"April": 30,
	"May": 31,
	"June": 30,
	"July": 31,
	"August": 31,
	"September": 30,
	"October": 31,
	"November": 30,
	"December": 31
	}


func _ready():
	_get_calendar_days()
	_clear_calendar()
	_set_up_calendar()


# Gets the calendar days
func _get_calendar_days():
	for week in CalendarContainer.get_children():
		for day in week.get_children():
			dates.append(day)


# Clears the calendar days
func _clear_calendar():
	for index in range(len(dates)):
		dates[index].text = ""


# Sets up the calendar
func _set_up_calendar():
	var date = OS.get_date()
	
	var year = date["year"]
	var month = date["month"]
	var day = date["day"]
	
	# Sets February's days based on the year
	if fmod(year, 4) == 0:
		days_dic[month_dic[month]] = 29
	else:
		days_dic[month_dic[month]] = 28
	
	MonthLabel.text = month_dic[month]
	
	var days_left = fmod(day, 7)
	var month_start = 7 - days_left
	
	var day_count = 1
	
	for index in range(month_start, days_dic[month_dic[month]] + month_start + 1):
		
		dates[index].text = str(day_count)
		day_count += 1
