extends Node2D

@export var entity :Node
@onready var energy_bar := $Energy
@onready var health_bar := $Health

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	#Dialogic.VAR.variable_changed.connect(_on_variable_changed)
	$Label.text = entity.name
	health_bar.value = 100
	energy_bar.value = 0
	
func update_ui():
	if entity.name != "Infected":
		health_bar.value = float(Dialogic.VAR.playerHealth) / (entity.HEALTH_DEFAULT * 2) * 100
		energy_bar.value = float(entity.energy) / 100 * 100
	else:
		health_bar.value = float(Dialogic.VAR.enemyHealth) / (entity.HEALTH_DEFAULT * 2) * 100
			
func _on_dialogic_signal(argument:String):
	if argument == "battle_start":
		#update_ui()
		visible = true
		print("battle start")
	if argument == "checkCharacter":
		update_ui()
	if argument == "endTurn":
		update_ui()
	if argument == "updateUI":
		update_ui()
	if argument == "hide_health":
		visible = false
		#next_turn();
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
		
#func _on_variable_changed(info:Dictionary):
		#print(info)
		#if entity.name == "Infected":
			#pass
		#
		#if info["variable"] == "mGirlIndex":
			#if Dialogic.VAR.currentCharacter == entity.name:
				#visible = true
			#else:
				#visible = false
				
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
