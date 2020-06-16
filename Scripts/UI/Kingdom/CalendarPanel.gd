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
	var weekday = date["weekday"]
	
	# Sets February's days based on the year
	if fmod(year, 4) == 0:
		days_dic[month_dic[month]] = 29
	else:
		days_dic[month_dic[month]] = 28
	
	MonthLabel.text = month_dic[month]
	
	# Calculate the first day of the month
	var days_left = fmod(day, 7)
	var month_start = weekday - days_left + 1
	
	# Tracks the first day and the last day of the month
	var day_count = 1
	var first_day = month_start
	var last_day = days_dic[month_dic[month]] + 1
	
	# Sets up the calendar
	for index in range(len(dates)):
		if index >= first_day and index <= last_day:
			dates[index].text = str(day_count)
			dates[index].disabled = false
			dates[index].flat = false
			
			day_count += 1
		else:
			dates[index].disabled = true
			dates[index].flat = true
