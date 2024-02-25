extends Node

## This script is used to determine which piece(s) need to spawn.
## The board script will call a function here, then this piece_spawn_manager script will pass back
## a reference to the piece(s) that need to spawn based on information it has. This script is not 
## actually spawning any pieces, it's simply used to keep the logic to decide which piece to spawn
## out of the board script.

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ 

const NUM_STARTING_PIECES: int = 2  # This is the amount of pieces on the board when the game starts

# Defines the chances for each player piece to spawn. The number is the percentage chance.
var _player_piece_spawn_rates: Dictionary = {
	"player_pawn": 75,
	"player_bishop": 20,
	"player_knight": 5,
	"player_rook": 0,
	"player_queen": 0,
	"player_king": 0
}

# Defines the chances for each enemy piece to spawn. The number is the percentage chance.
# TODO: Currently, only enemy pawns can spawn, no other pieces. Not sure if we'll change that some
# 		day or not. If we did, we'd probably want to figure out some way to punish the player for 
# 		allowing higher value enemy pieces to stay on the board
var _enemy_piece_spawn_rates: Dictionary = {
	"enemy_pawn": 100,
	"enemy_bishop": 0,
	"enemy_knight": 0,
	"enemy_rook": 0,
	"enemy_queen": 0,
	"enemy_king": 0
}

var _base_enemy_piece_spawn_chance: int = 25  # 25% chance to spawn an enemy piece, at base. Some effects may change this number to make it more likely

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

## Determines a new piece from the player or enemy family, based on it's probability.
## Returns the string name of the new piece
func _determine_new_piece(piece_family: String) -> String: 
	var new_piece: String = ""
	
	# Determine which dictionary to use, based on if we want to get a new player piece or enemy piece
	var piece_family_dictionary: Dictionary = _player_piece_spawn_rates if piece_family == GameManager.PLAYER_FAMILY else _enemy_piece_spawn_rates
	var possible_pieces: Array = piece_family_dictionary.keys()
	
	# Get a random number between 1 and 100
	var random_roll: int = randi() % 100 + 1
	
	# For each piece in the list of possible pieces
	for piece: String in possible_pieces:
		# If the random number we got is less than the pieces spawn rate, assign it to the new piece
		# we will be returning and break out of the loop
		if random_roll <= piece_family_dictionary[piece]:
			new_piece = piece
			break
		# If the random number we got is more than the pieces spawn rate, subtract the spawn rate 
		# from that random number, and go check the next piece in array
		else:
			random_roll -= piece_family_dictionary[piece]
			
	return new_piece

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #

## Gets the pieces that should spawn at the start of the game
func get_starting_pieces() -> Array:
	var pieces_to_spawn: Array = []  # Array of each piece as a Resource
	
	for i in NUM_STARTING_PIECES:
		var piece_name: String = _determine_new_piece(GameManager.PLAYER_FAMILY)
		pieces_to_spawn.append(get_piece_by_name(piece_name))
			
	return pieces_to_spawn

# ------------------------------------------------------------------------------------------------ #

## Returns a number of new pieces to spawn based on num_pieces_to_spawn
func get_new_pieces(num_pieces_to_spawn: int) -> Array:
	var pieces_to_spawn: Array = []  # Arrya of each piece as a Resource
	
	# For each piece that we want to spawn, randomly decide if the piece should be an enemy or 
	# player piece. Get the piece, then append it to the array of pieces to spawn.
	for i in num_pieces_to_spawn:
		var piece_color_spawn_chance: int = randi() % 100 + 1
		if piece_color_spawn_chance <= _base_enemy_piece_spawn_chance:
			var piece_name: String = _determine_new_piece(GameManager.ENEMY_FAMILY)
			pieces_to_spawn.append(get_piece_by_name(piece_name))
		else:
			var piece_name: String = _determine_new_piece(GameManager.PLAYER_FAMILY)
			pieces_to_spawn.append(get_piece_by_name(piece_name))
	
	return pieces_to_spawn
	
# ------------------------------------------------------------------------------------------------ #

## Simply returns the piece that matches the name passed in
func get_piece_by_name(piece_name: String) -> Resource:
	return ResourceManager.pieces[piece_name]
