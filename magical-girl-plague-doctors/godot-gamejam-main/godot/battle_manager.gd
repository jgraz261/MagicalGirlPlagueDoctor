extends Node

@export var player_characters : Array[Character]
@export var enemies : Array[Character]
var current_character : Character
var actionChoice : int = 0

var game_over : bool = false
var player_win : bool = false
var turnOrderToken
var playerTurn : bool = true

func next_turn ():
	#Update variables
	set_Dialogic_variables()
	# Check for battle end conditions
	if player_win:
		print("Players Win!")
		#Signal *Battle Win* to Dialogic
		Dialogic.VAR.playerWin = player_win
		return
	elif game_over:
		print("You got infected! Game Over!")
		# Signal *Game Over* to Dialogic
		Dialogic.VAR.gameOver = game_over
		return
	
	if turnOrderToken == null:
		turnOrderToken = 0
	
	if !playerTurn:
		if turnOrderToken < enemies.size():
			current_character = enemies[turnOrderToken]
			Dialogic.VAR.currentCharacter = current_character.characterName
			turnOrderToken += 1
		else:
			playerTurn = true
			turnOrderToken = 0
			current_character = player_characters[turnOrderToken]
			turnOrderToken += 1
			Dialogic.VAR.currentCharacter = current_character.characterName
	elif playerTurn:
		if turnOrderToken < player_characters.size():
			current_character = player_characters[turnOrderToken]
			Dialogic.VAR.currentCharacter = current_character.characterName
			turnOrderToken += 1
		else:
			playerTurn = false
			turnOrderToken = 0
			current_character = enemies[turnOrderToken]
			turnOrderToken += 1
			Dialogic.VAR.currentCharacter = current_character.characterName
			
	# Regain energy and display battle action options
	current_character.begin_turn()
	#Update variables
	set_Dialogic_variables()

func m_girl_act(characterIndex : int, action : int, target : Character):
	battle_action(
		player_characters[characterIndex].battleActions[action],
		target
		)

func enemy_act(enemyIndex : int):
	# Randomly choose Combat Actions for Enemy Characters
	battle_action(
		enemies[enemyIndex].battleActions[
			randi_range(0,current_character.battleActions.size()-1)],
			player_characters[randi_range(0,1)]
		)

func check_status(opponents : Array[Character], players: Array[Character]):
	
	var opponentTotalHealth = 0
	var playersTotalHealth = 0
	
	for opponent in opponents:
		#print(opponent.characterName + " (health): " + str(opponent.health))
		opponentTotalHealth += opponent.health
	if opponentTotalHealth <= 0:
		player_win = true
		#return
	
	for player in players:
		playersTotalHealth += player.health
	if playersTotalHealth <= 0:
		game_over = true
		
	set_Dialogic_variables()

func battle_action(action : BattleAction, target : Character):
	var textNotice : String = ""
	#print(
			#current_character.characterName + " uses " +
	 		#action.displayName + " on " + target.characterName)
	current_character.energy -= action.energyCost
	
	
	if action.damage > 0:
		target.take_damage(action.damage)
		textNotice = target.characterName + " takes " + str(action.damage) + " damage! "
	if action.healAmount > 0:
		target.heal(action.healAmount)
		textNotice = target.characterName + " gains " + str(action.healAmount) + " health! "
	target.defenceMod = action.defMod
	target.damageMod = action.dmgMod
	target.energyMod = action.energyMod
	if action.defMod != 1.0:
		textNotice = textNotice + target.characterName + "'s defence went up! "
	if action.dmgMod > 1.0:
		textNotice = textNotice + target.characterName + "'s power went up! "
	if action.dmgMod < 1.0:
		textNotice = textNotice + target.characterName + "'s power went down! "
	if action.energyMod > 1.0:
		textNotice = textNotice + target.characterName + "'s energy recovery went up! "
	
	Dialogic.VAR.battleComment = (
			current_character.characterName + " uses " +
	 		action.displayName + " on " + target.characterName + ". " + textNotice)
	
	set_Dialogic_variables()

func set_Dialogic_variables():
	# Set Player Health
	Dialogic.VAR.playerHealth = player_characters[0].health + player_characters[1].health
	Dialogic.VAR.enemyHealth = enemies[0].health
	
	# Set Player Energy
	Dialogic.VAR.aylinEnergy = player_characters[0].energy
	Dialogic.VAR.miaEnergy = player_characters[1].energy
	
	# Set win/loss conditions
	Dialogic.VAR.playerWin = player_win
	Dialogic.VAR.gameOver = game_over
	
func _on_dialogic_signal(argument : String):
	if argument == "nextTurn":
		next_turn();
	if argument == "mGirl action":
		var target_index = Dialogic.VAR.targetIndex
		var target_player = Dialogic.VAR.targetPlayer
		var target_char
		if target_player:
			target_char = player_characters[target_index]
		if !target_player:
			target_char = enemies[target_index]
		m_girl_act ( Dialogic.VAR.mGirlIndex, Dialogic.VAR.takeAction, target_char)
	if argument == "enemy action":
		enemy_act(Dialogic.VAR.enemyIndex)
		#actionChoice = Dialogic.Actions.takeAction
	if argument == "endTurn":
		check_status(enemies, player_characters)
	if argument == "checkCharacter":
		Dialogic.VAR.currentCharacter = current_character.characterName
		#print(Dialogic.VAR.currentCharacter)

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	#next_turn()
