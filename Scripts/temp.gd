extends Node

var _background_music: Array = ["1", "2", "3", "4"]
var _played_music: Array = []

func _ready() -> void:
	print("ready get_music")
	print(_get_music())

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if event.pressed:		
			print(_get_music())


func _get_music() -> String:
	print("_background_music at start of _get_music: ", _background_music)
	print("_played_music at start of _get_music: ", _played_music)

	var return_music: String

	if _background_music.size() == 1:
		return_music = _background_music[0]
		_background_music.remove_at(0)
		_background_music.append_array(_played_music)
		_played_music.clear()	
		_played_music.append(return_music)

		print("_background_music at return of _get_music: ", _background_music)
		print("_played_music at return of _get_music: ", _played_music)

		return return_music

	return_music = _background_music.pick_random()
	_played_music.append(return_music)
	_background_music.erase(return_music)

	print("_background_music at return of _get_music: ", _background_music)
	print("_played_music at return of _get_music: ", _played_music)

	return return_music
				