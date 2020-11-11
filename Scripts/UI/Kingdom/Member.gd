extends "res://Scripts/Player.gd"


onready var _player_name = $InfoContainer/Name
onready var _player_icon = $InfoContainer/Icon/Sprite

onready var _total_contribution = $InfoContainer/Contribution/TotalContribution/Count
onready var _weekly_contribution = $InfoContainer/Contribution/WeeklyContribution/Count

onready var _player_honor = $InfoContainer/HonorCount
onready var _player_influence = $InfoContainer/InfluenceCount

onready var _player_homeland = $InfoContainer/Homeland
onready var _player_position = $InfoContainer/Position


# Sets up the member info
func set_up_member_info(_name, _icon, _total_con, _weekly_con, _honor, _influence, _homeland, _position):
	_player_name.text = _name
	_player_icon = _icon
	
	_total_contribution.text = str(_total_con)
	_weekly_contribution.text = str(_weekly_con)
	
	_player_honor.text = str(_honor)
	_player_influence.text = str(_influence)
	
	_player_homeland.text = _homeland
	_player_position.text = _position
