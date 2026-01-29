class_name Character

extends Node

@export var characterName : String
@export var characterType : String
@export var health : int = 100
@export var energy : int
@export var damageBaseMod : float = 1.0
@export var energyGain : int = 50
@export var energyBaseMod : float = 1.0
var energyMod : float = 1.0
var damageMod : float = 1.0

@export var battleActions : Array[BattleAction]

func begin_turn():
	#Enable UI options
	print("** " + characterName +"'s turn")

func end_turn():
	#Disable UI options
	pass
	
func take_damage(amount : int):
	health -= floor(amount*damageMod)
	damageMod = damageBaseMod
	return
	
func heal (amount : int):
	health += amount
	return

func recharge_energy():
	energy += floor(energyGain * energyMod)
	energyMod = energyBaseMod
	return
