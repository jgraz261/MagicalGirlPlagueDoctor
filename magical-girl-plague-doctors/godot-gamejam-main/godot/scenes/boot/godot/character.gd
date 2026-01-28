class_name Character

extends Node

@export var characterName : String
@export var characterType : String
@export var health : int
@export var energy : int

func begin_turn():
	pass

func end_turn():
	pass
	
func take_damage(amount : int):
	pass
	
func heal (amount : int):
	pass
