extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var array = []
	for i in 5:
		array.append([])
		for j in 5:
			array[i].append(null) 
	
	print("standard array")
	print(array)
	print("")
	
	array[0][0] = "val"
	array[0][3] = "val"
	array[2][4] = "val"
	array[2][1] = "val"
	array[3][1] = "val"
	array[4][2] = "val"
	array[1][1] = "val"
	array[2][2] = "val"
	array[3][3] = "val"
	array[4][4] = "val"
	
	print("val array")
	print(array)
	print("")
	
	var temp_array = array.duplicate(true)
	for i in array.size():
		print("i: ", str(i))
		for j in array[i].size():
			print("j: " + str(j))
			if array[i][j] != null:
				temp_array[i].remove_at(j)	
	
	
	
	print("removed temp_array")
	print(temp_array)
	print("")

	
	
	
	
