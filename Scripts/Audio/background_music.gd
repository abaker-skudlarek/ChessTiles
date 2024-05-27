extends AudioStreamPlayer

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

var _background_music: Array = [
	preload("res://Audio/Music/bossa-lounge-159715.mp3"),
	preload("res://Audio/Music/great-latin-elevator-music-176570.mp3"),
	preload("res://Audio/Music/jazz-bossa-nova-163669.mp3"),
	preload("res://Audio/Music/morning-sunshine-bossa-nova-170204.mp3"),
	preload("res://Audio/Music/own-conversation-elevator-191517.mp3"),
	preload("res://Audio/Music/restaurant-music-110483.mp3"),
	preload("res://Audio/Music/waiting-music-116216.mp3"),
]

var _played_music: Array = []

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _ready() -> void:
	connect("finished", _on_finished)
	_change_music()

# ------------------------------------------------------------------------------------------------ #

## Gets new music choice and plays it
func _change_music() -> void:
	stream = _get_music()
	play()

# ------------------------------------------------------------------------------------------------ #

## Returns a random music file from _background_music, and then moves it to _music_played. Once the
## last piece of music is chosen from _background_music, everything in _music_played is added back
## to _background_music. This is so that we never get a repeat song one after another.
func _get_music() -> Resource:
	var return_music: Resource

	if _background_music.size() == 1:
		return_music = _background_music[0]
		_background_music.remove_at(0)
		_background_music.append_array(_played_music)
		_played_music.clear()	
		_played_music.append(return_music)
		return return_music

	return_music = _background_music.pick_random()
	_played_music.append(return_music)
	_background_music.erase(return_music)
	return return_music

# ------------------------------------------------------------------------------------------------ #

func _on_finished() -> void:
	_change_music()

# ------------------------------------------------------------------------------------------------ #
