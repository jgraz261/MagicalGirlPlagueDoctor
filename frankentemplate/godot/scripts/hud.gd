extends Control

func _on_coin_collected(coins):
	print("coin")
	$Coins.text = str(coins)
