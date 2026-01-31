class_name Character

extends Node

const HEALTH_DEFAULT : int = 100
const ENERGY_DEFAULT : int = 0
const ENERGY_MOD_DEFAULT : float = 1.0
const DAMAGE_MOD_DEFAULT : float = 1.0

@export var characterName : String
@export var characterType : String
@export var health : int = 100
@export var energy : int
@export var energyGain : int = 50
@export var battleActions : Array[BattleAction]

var energyMod : float = ENERGY_MOD_DEFAULT
var damageMod : float = DAMAGE_MOD_DEFAULT

func begin_turn():
	#Enable UI options
	#print("** " + characterName +"'s turn")
	recharge_energy()
	#Dialogic.VAR.currentCharacter = characterName

func end_turn():
	#Disable UI options
	pass
	
func take_damage(amount : int):
	health -= floor(amount*damageMod)
	damageMod = DAMAGE_MOD_DEFAULT
	return
	
func heal (amount : int):
	health += amount
	return

func recharge_energy():
	energy += floor(energyGain * energyMod)
	if energy > 100:
		energy = 100
	energyMod = ENERGY_MOD_DEFAULT
	return
