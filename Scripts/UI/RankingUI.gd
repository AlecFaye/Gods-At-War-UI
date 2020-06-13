extends Control


onready var PersonalRankingPanel = $InformationPanel/PersonalRanking
onready var KingdomRankingPanel = $InformationPanel/KingdomRanking


# Shows the Ranking UI
func _on_Ranking_pressed():
	show()


# Hides the Ranking UI
func _on_CloseRanking_pressed():
	hide()


# Shows the Personal Ranking UI
func _on_Personal_pressed():
	PersonalRankingPanel.show()
	KingdomRankingPanel.hide()


# Shows the Kingdom Ranking UI
func _on_Kingdom_pressed():
	PersonalRankingPanel.hide()
	KingdomRankingPanel.show()
