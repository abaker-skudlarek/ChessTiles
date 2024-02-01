extends Node

func _ready():
	var a: Array = [1, 2, 3, 4]
	
	print("a: ", a)
	a.erase(3)
	print("a: ", a)
	
