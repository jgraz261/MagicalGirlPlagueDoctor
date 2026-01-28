extends Node

@export var player_character : Array[Character]
@export var enemy : Array[Character]
var current_character : Character

var game_over : bool = false

func next_turn ():
	if game_over:
		return
	
	if current_character != null:
		current_character.end_turn()
		
	if current_character == null or current_character.characterType == "enemy" :
		current_character = player_character[0]
	elif current_character == player_character[0] :
		current_character = player_character[1]
	else :
		current_character = enemy[0]
	
	current_character.begin_turn()
	
	if current_character.characterType == "mGirl":
		print("** " + current_character["name"]+"'s turn")
		await get_tree().create_timer(0.5).timeout
		#enable player UI through Dialogic
		battle_action ( "PUNCH", $Infected )
		next_turn()
		
	else:
		#disable player UI
		print("** " + current_character["name"]+"'s turn")
		var wait_time = randf_range(0.5, 1.5)
		await get_tree().create_timer(wait_time).timeout
		# Add Combat Actions
		enemy_decide_action( $Infected )
		await get_tree().create_timer(0.5).timeout
		next_turn()

func battle_action ( action, target : Character ):
	print(current_character["name"] + " uses " + action + " on " + target["name"])
	
func enemy_decide_action( attacker : Character ):
	print(current_character["name"] + " attacks!!! ")

func _ready():
	next_turn()
