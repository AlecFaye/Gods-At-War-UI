extends HBoxContainer


func move(target):
	var SecondRowTween = get_node("SecondRowTween")
	SecondRowTween.interpolate_property(self, "rect_position", rect_position, target, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	SecondRowTween.start()
