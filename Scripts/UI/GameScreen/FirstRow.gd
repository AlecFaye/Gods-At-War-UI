extends HBoxContainer


func move(target):
	var FirstRowTween = get_node("FirstRowTween")
	FirstRowTween.interpolate_property(self, "rect_position", rect_position, target, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	FirstRowTween.start()
