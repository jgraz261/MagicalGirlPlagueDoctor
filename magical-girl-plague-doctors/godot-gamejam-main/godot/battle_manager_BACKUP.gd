extends Node
#
#@export var player_characters : Array[Character]
#@export var enemies : Array[Character]
#var current_character : Character
#var actionChoice : int = 0
#
#var game_over : bool = false
#var player_win : bool = false
#
#func next_turn ():
	#set_Dialogic_variables()
## Check for battle end conditions
	#if player_win:
		#print("Players Win!")
		##Signal *Battle Win* to Dialogic
		#return
	#elif game_over:
		#print("You got infected! Game Over!")
		## Signal *Game Over* to Dialogic
		#return
#
	## Clear any accidentally left open turn
	#if current_character != null:
		#current_character.end_turn()
	#
	## Set current character
	#if current_character == null or current_character.characterType == "enemy" :
		#current_character = player_characters[0]
	#elif current_character == player_characters[0] :
		#current_character = player_characters[1]
	#else :
		#current_character = enemies[0]
	#
	## Regain energy and display battle action options
	#current_character.begin_turn()
	##Dialogic.VAR.currentCharacter = current_character.characterName
	#
	#if current_character.characterType == "mGirl":
		#
		##await Dialogic.VAR.DialogicVariableEvent
		#print(actionChoice)
		##enable player UI through Dialogic
		##Get player input
		#battle_action ( current_character.battleActions[actionChoice], $Infected )
		#
	#else:
		##disable player UI
		## Wait a sec for realistic computery thinking time
		#var wait_time = randf_range(1.0, 2.0)
		#await get_tree().create_timer(wait_time).timeout
		## Randomly choose Combat Actions for Enemy Characters
		#battle_action ( 
			#current_character.battleActions [
				#randi_range(0,current_character.battleActions.size()-1)],
		 		#player_characters[randi_range(0,1)
				#]
			#)
		##Check for more enemies
		##If all enemies have acted, end turn
	#await get_tree().create_timer(0.5).timeout
	#check_status(enemies, player_characters)
	##next_turn()
#
#func check_status(opponents : Array[Character], players: Array[Character]):
	#
	#var opponentTotalHealth = 0
	#var playersTotalHealth = 0
	#
	#for opponent in opponents:
		##print(opponent.characterName + " (health): " + str(opponent.health))
		#opponentTotalHealth += opponent.health
	#if opponentTotalHealth <= 0:
		#player_win = true
		#return
	#
	#for player in players:
		##print(player.characterName + " (health): " + str(player.health))
		#playersTotalHealth += player.health
	#if playersTotalHealth <= 0:
		#game_over = true
		#return
	#set_Dialogic_variables()
#
#func battle_action(action : BattleAction, target : Character):
	#current_character.energy -= action.energyCost
	#print(current_character.characterName + " uses " + action.displayName + " on " + target.characterName)
	#
	#if action.damage > 0:
		#target.take_damage(action.damage)
	#if action.healAmount > 0:
		#target.heal(action.healAmount)
	#target.damageMod = action.dmgMod
	#target.energyMod = action.energyMod
	#set_Dialogic_variables()
#
#func set_Dialogic_variables():
	## Set Player Health
	#Dialogic.VAR.playerHealth = player_characters[0].health + player_characters[1].health
	#Dialogic.VAR.enemyHealth = enemies[0].health
	#
	## Set Player Energy
	#Dialogic.VAR.aylinEnergy = player_characters[0].energy
	#Dialogic.VAR.miaEnergy = player_characters[1].energy
	#
	##print("Health: " + str(Dialogic.VAR.playerHealth))
	##print("Enemy Health: " + str(Dialogic.VAR.enemyHealth))
	##print("Aylin Energy: " + str(Dialogic.VAR.aylinEnergy))
	##print("Mia Energy: " + str(Dialogic.VAR.miaEnergy))
	#
##func _on_dialogic_signal(argument : String):
	##if argument == "nextTurn":
		##next_turn();
	##if argument == "Action":
		##actionChoice = Dialogic.takeAction
#
##func _ready():
	##Dialogic.signal_event.connect(_on_dialogic_signal)
	##next_turn()
