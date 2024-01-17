extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var array = []
	for i in 5:
		array.append([])
		for j in 5:
			array[i].append(null) 
	
	print("array")
	print(array)
	print("")
	
	array[0][0] = "val"
	array[1][1] = "val"
	array[2][2] = "val"
	array[3][3] = "val"
	array[4][4] = "val"
	
	print("array")
	print(array)
	print("")
	
	array[0].remove_at(0)
	array[1].remove_at(1)
	array[2].remove_at(2)
	array[3].remove_at(3)
	array[4].remove_at(4)
	
	print("array")
	print(array)
	print("")
	
	
	
