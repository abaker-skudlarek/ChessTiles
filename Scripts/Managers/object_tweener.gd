class_name ObjectTweener
extends Node

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #


## An Array of dictionaries, each element holds information about the thing that needs to be tweened. 
## Each dictionary will be formatted the following way:
## 	{
## 		"object": <object-reference>,
## 		"position": <Vector2>
## 	}
## 	"object" is the reference to the object that needs to be tweened
## 	"position" is the position that the object needs to be tweened to
var _to_tween: Array = [] 
var _tween_time: float = .25

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #

## Creates a dictionary out of the passed in object and position and appends it to the list of 
## things to be tweened simultaneously.
func add(object: Node, position: Vector2) -> void:
	_to_tween.append({ 
		"object": object,
		"position": position,
	})

# ------------------------------------------------------------------------------------------------ #

## Tweens all of the objects in "_to_tween" to the positions that they want to be tweened to. 
## Each tween is executed in sequence according to the order they were added. 
## It happens very quickly, so it's essentially simultaneous. 
func execute() -> void:
	if _to_tween != []:
		var tween: Tween = create_tween().set_parallel()
		for tween_info: Dictionary in _to_tween:
			tween.tween_property(tween_info["object"], 
								"position", 
								tween_info["position"], 
								_tween_time).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		_to_tween = []

