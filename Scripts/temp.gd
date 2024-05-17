extends Node

@onready var objects: Array = [$Icon, $Icon2, $Icon3, $Icon4]
@onready var positions: Array = [Vector2(10, 10), Vector2(20, 20), Vector2(30, 30), Vector2(40, 40)]

var tweener: ObjectTweener

func _ready() -> void:
	tweener = ObjectTweener.new()
	add_child(tweener)

func _input(event: InputEvent) -> void:

	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			objects.shuffle()
			positions.shuffle()
			var objects_to_tween: Array = objects.slice(0, objects.size() - 2)	
			var positions_to_tween: Array = positions.slice(0, positions.size() - 2)
			print(objects_to_tween)
			print(positions_to_tween)

			for i in objects_to_tween.size():
				tweener.add(objects_to_tween[i], positions_to_tween[i])
	
	if event is InputEventMouseButton:
		if event.pressed:		
			tweener.execute()
