extends Panel

# Moves the sacrifice panel
func move(target):
	var sacrifice_cards_tween = $SacrificeCardsTween
	sacrifice_cards_tween.interpolate_property(self, "rect_position", rect_position, target, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	sacrifice_cards_tween.start()
