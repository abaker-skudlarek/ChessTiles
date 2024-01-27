extends Node

func _ready():
	var a = [[1,2,3], [4,5,6], [7,8,9]]
	print(a)
	
	for i in a.size():
		a[i].reverse()
	a.reverse()
	print(a)
	
	
	
