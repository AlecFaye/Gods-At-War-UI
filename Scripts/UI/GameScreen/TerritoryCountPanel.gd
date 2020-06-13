extends Panel


func move(target):
	var TerritoryTween = $TerritoryTween
	TerritoryTween.interpolate_property(self, "rect_position", rect_position, target, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	TerritoryTween.start()
