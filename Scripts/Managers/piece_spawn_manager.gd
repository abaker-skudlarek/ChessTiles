extends Node

## This script is used to determine which piece(s) need to spawn.
## The board script will call a function here, then this piece_spawn_manager script will pass back
## a reference to the piece(s) that need to spawn based on information it has. This script is not 
## actually spawning any pieces, it's simply used to keep the logic to decide which piece to spawn
## out of the board script.

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

const NUM_STARTING_PIECES: int = 2  # This is the amount of pieces on the board when the game starts

# TODO: Might want to have some sort of dictionary for the base spawn rate of pieces?

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("piece spawn manager ready")

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #

## Calculates which pieces should spawn at the start of the game
func get_starting_pieces() -> Array:
	var pieces_to_spawn: Array = []
	
	for i in NUM_STARTING_PIECES:
		var spawn_chance: int = randi() % 100
		if spawn_chance <= 75:
			var piece: Resource = ResourceManager.pieces["player_pawn"]
			pieces_to_spawn.append(piece)
		else:
			var piece: Resource = ResourceManager.pieces["player_bishop"]
			pieces_to_spawn.append(piece)
	
	return pieces_to_spawn

# ------------------------------------------------------------------------------------------------ #

## Returns a number of new pieces to spawn based on num_pieces_to_spawn
func get_new_pieces(num_pieces_to_spawn: int) -> Array:
	var pieces_to_spawn: Array = []
	
	# TODO: We will want to be able to spawn other pieces, not just pawns and bishops.
	
	# TODO: Also, we will want to include enemy pieces
	
	for i in num_pieces_to_spawn:
		var spawn_chance: int = randi() % 100
		if spawn_chance <= 75:
			var piece: Resource = ResourceManager.pieces["player_pawn"]
			pieces_to_spawn.append(piece)
		else:
			var piece: Resource = ResourceManager.pieces["player_bishop"]
			pieces_to_spawn.append(piece)
	
	return pieces_to_spawn
	
# ------------------------------------------------------------------------------------------------ #

## Simply returns the piece that matches the name passed in
func get_piece_by_name(piece_name: String) -> Resource:
	return ResourceManager.pieces[piece_name]
