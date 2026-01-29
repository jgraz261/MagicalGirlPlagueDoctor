extends Node

@export var player_characters : Array[Character]
@export var enemies : Array[Character]
var current_character : Character

var game_over : bool = false
var player_win : bool = false

func next_turn ():
# Check for battle end conditions
	print(player_win)
	print(game_over)
	
	if player_win:
		#Signal *Battle Win* to Dialogic
		return
	elif game_over:
		# Signal *Game Over* to Dilogic
		return

	# Clear any accidentally left open turn
	if current_character != null:
		current_character.end_turn()
	
	# Set current character
	if current_character == null or current_character.characterType == "enemy" :
		current_character = player_characters[0]
	elif current_character == player_characters[0] :
		current_character = player_characters[1]
	else :
		current_character = enemies[0]
	
	# Regain energy and display battle action options
	current_character.begin_turn()
	print("** " + current_character["name"]+"'s turn")
	
	if current_character.characterType == "mGirl":
		#enable player UI through Dialogic
		#Get player input
		battle_action ( current_character.battleActions[0], $Infected )
		
	else:
		#disable player UI
		# Wait a sec for realistic computery thinking time
		var wait_time = randf_range(1.0, 2.0)
		await get_tree().create_timer(wait_time).timeout
		
		# Randomly choose Combat Actions for Enemy Characters
		battle_action ( 
			current_character.battleActions [
				randi_range(0,current_character.battleActions.size()-1)],
		 		player_characters[randi_range(0,1)
				]
			)
		#Check for more enemies
		#If all enemies have acted, end turn
	
	await get_tree().create_timer(0.5).timeout
	check_status(player_characters, enemies)
	next_turn()

#func battle_action ( action, target : Character ):
	#print(current_character["name"] + " uses " + action + " on " + target["name"])
	
func enemy_decide_action( attacker : Character ):
	print(attacker["name"] + " attacks!!! ")

func check_status(opponents : Array[Character], players: Array[Character]):
	
	var opponentTotalHealth = 0
	
	for opponent in opponents:
		#print(opponent.characterName)
		#print(opponent.health)
		opponentTotalHealth += opponent.health
	if opponentTotalHealth <= 0:
		player_win = true
		return
	
	for player in players:
		#print(player.characterName)
		#print(player.health)
		if player.health <= 0:
			game_over = true
	return

func battle_action(action : BattleAction, target : Character):
	current_character.energy -= action.energyCost
	
	print(current_character.characterName + " uses " + action.displayName + " on " + target.characterName)
	
	if action.damage > 0:
		target.take_damage(action.damage)
	if action.healAmount > 0:
		target.heal(action.healAmount)
	target.damageMod = action.dmgMod
	target.energyMod = action.energyMod

func _ready():
	next_turn()
