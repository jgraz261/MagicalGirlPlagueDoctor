extends Node2D

@export var entity :Node
@onready var energy_bar := $Energy
@onready var health_bar := $Health

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.VAR.variable_changed.connect(_on_variable_changed)
	if "Aylin" == entity.name:
		visible = true
	else:
		visible = false
	
func _on_dialogic_signal(argument:String):
	if argument == "battle_start":
		visible = true
		print("battle start")
	if argument == "mGirl action":
		if Dialogic.VAR.currentCharacter == entity.name:
			visible = true
		else:
			visible = false
	
	#if argument == "nextTurn":
		#next_turn();
	#if argument == "mGirl action":
		#m_girl_act ( Dialogic.VAR.mGirlIndex, Dialogic.VAR.takeAction )
	#if argument == "enemy action":
		#enemy_act(Dialogic.VAR.enemyIndex)
		##actionChoice = Dialogic.Actions.takeAction
	#if argument == "endTurn":
		#check_status(enemies, player_characters)
	#if argument == "checkCharacter":
		#Dialogic.VAR.currentCharacter = current_character.characterName
		#print(Dialogic.VAR.currentCharacter)
		
func _on_timeline_ended():
		visible = false
		
func _on_variable_changed(info:Dictionary):
		print(info)
		if entity.name == "Infected":
			pass
		
		if info["variable"] == "mGirlIndex":
			if Dialogic.VAR.currentCharacter == entity.name:
				visible = true
			else:
				visible = false
				
		#turn off visibility depending on character present
		
	#Dialogic.VAR.playerHealth = player_characters[0].health + player_characters[1].health
	#Dialogic.VAR.enemyHealth = enemies[0].health
	#Dialogic.VAR.currentCharacter
	
	## Set Player Energy
	#Dialogic.VAR.aylinEnergy = player_characters[0].energy
	#Dialogic.VAR.miaEnergy = player_characters[1].energy
	#
	## Set win/loss conditions
	#Dialogic.VAR.playerWin = player_win
	#Dialogic.VAR.gameOver = game_over
