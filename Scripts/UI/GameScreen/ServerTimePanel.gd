extends Panel


var _timer = null


func _ready():
	
	_timer = Timer.new()
	add_child(_timer)
	
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0)
	_timer.set_one_shot(false)  # Make sure it loops
	_timer.start()


# Calls the update every second
func _on_Timer_timeout():
	_update_server_time()


# Updates the server timer
func _update_server_time():
	var timeDict = OS.get_time(true);
	var hour = timeDict.hour;
	var minute = timeDict.minute;
	var seconds = timeDict.second;
	var server_time_label = get_node("ServerTime")
	
	server_time_label.text = str(hour) + " : " + str(minute) + " : " + str(seconds)


func move(target):
	var ServerTimeTween = $ServerTimeTween
	ServerTimeTween.interpolate_property(self, "rect_position", rect_position, target, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	ServerTimeTween.start()
