extends Control


var scene_path_to_load = "res://Scenes/UI.tscn"


# Starts the fade transition
func _on_LoginButton_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()


# When the fade is finished, the game screen is loaded
func _on_FadeIn_fade_finished():
	get_tree().change_scene(scene_path_to_load)
