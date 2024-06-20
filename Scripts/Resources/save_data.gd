extends Resource
class_name SaveData

const DEFAULT_HIGH_SCORE: int = -999
const DEFAULT_MUSIC_VOLUME: float = 0.50

@export var high_score: int
@export var music_volume: float 

func _init(p_high_score: int = DEFAULT_HIGH_SCORE, p_music_volume: float = DEFAULT_MUSIC_VOLUME) -> void:
    high_score = p_high_score
    music_volume = p_music_volume
