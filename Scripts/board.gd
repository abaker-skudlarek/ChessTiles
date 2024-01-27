extends Node

# -- Variables -- #

const LIGHT_SQUARE_PATH: CompressedTexture2D = preload("res://Sprites/Squares/square_brown_dark.png")
const DARK_SQUARE_PATH: CompressedTexture2D = preload("res://Sprites/Squares/square_brown_light.png")
const GRID_X_START_POSITION: int = 104
const GRID_Y_START_POSITION: int = 384
const GRID_OFFSET: int = 128
const GRID_WIDTH: int = 5
const GRID_HEIGHT: int = 5

var _board: Array # Two dimensional array that defines the board
var _pieces_on_board: Array = [] # Array containing the pieces that are currently on the board. This includes Player and Enemy pieces

@onready var player_pieces: Dictionary = {
	"pawn": preload("res://Scenes/Pieces/Player/player_pawn.tscn"),
	"bishop": preload("res://Scenes/Pieces/Player/player_bishop.tscn"),
	"knight": preload("res://Scenes/Pieces/Player/player_knight.tscn"),
	"rook": preload("res://Scenes/Pieces/Player/player_rook.tscn"),
	"queen": preload("res://Scenes/Pieces/Player/player_queen.tscn"),
	"king": preload("res://Scenes/Pieces/Player/player_king.tscn")
}
@onready var enemy_pieces: Dictionary = {
	"pawn": preload("res://Scenes/Pieces/Enemy/enemy_pawn.tscn"),
	"bishop": preload("res://Scenes/Pieces/Enemy/enemy_bishop.tscn"),
	"knight": preload("res://Scenes/Pieces/Enemy/enemy_knight.tscn"),
	"rook": preload("res://Scenes/Pieces/Enemy/enemy_rook.tscn"),
	"queen": preload("res://Scenes/Pieces/Enemy/enemy_queen.tscn"),
	"king": preload("res://Scenes/Pieces/Enemy/enemy_king.tscn")
}

# -- Private Functions -- #

# ------------------------------------------------------------------------------------------------ #

# NOTE: I'm using this function to connect to signals. The reasoning is that I found when using 
# 		_ready() for connecting, the ordering of the nodes in the scene tree mattered. If Board wasn't
#		in the top of the scene tree, GameManager would emit the signal before Board could connect 
#  		to it. I don't know if using _enter_tree to connect to signals is a good idea or not.  
# TODO: We can probably add this back to the _ready() function once we have a "start game" screen,
# 		because then GameManager will emit the signal whenever that is hit, instead of in it's _ready()
# 		function
func _enter_tree() -> void:
	SignalBus.connect("state_changed_start_game", _on_state_changed_start_game)
	SignalBus.connect("slide_move_left", _on_slide_move_left)
	SignalBus.connect("slide_move_right", _on_slide_move_right)
	SignalBus.connect("slide_move_up", _on_slide_move_up)
	SignalBus.connect("slide_move_down", _on_slide_move_down)

# ------------------------------------------------------------------------------------------------ #

## Moves all pieces on the board in the direction that is defined in direction_to_move
## 	direction_to_move is a Vector2 which should contain a 1 or -1 in the direction that we want to move 
## 	For example: If we want to move all pieces right, direction_to_move = Vector2(1, 0)
## 				 If we want to move all pieces up, direction_to_move = Vector2(0, -1)
func _slide_move(direction_to_move: Vector2) -> void:
	
	# TODO: NEED TO IMPLEMENT MERGING PIECES WHEREVER THAT APPLIES	
	
	# TODO: THIS IS ONE OF THE UGLIEST PIECES OF CODE I'VE EVER WRITTEN
	# TODO: Please for the love of god do not keep this. You're better than that.
	if direction_to_move == Vector2.RIGHT:
		for i in range(_board.size() - 1, -1, -1):
			for j in _board[i].size():
				var current_grid_position = Vector2(i, j)
				
				if _is_square_occupied(current_grid_position):
					var new_grid_position = Vector2(current_grid_position.x + direction_to_move.x,
													current_grid_position.y + direction_to_move.y)
					
					if (new_grid_position.x < GRID_WIDTH and new_grid_position.x >= 0 and new_grid_position.y < GRID_HEIGHT and new_grid_position.y >= 0):
						var piece_moved = _move_piece(current_grid_position, new_grid_position)
	
	elif direction_to_move == Vector2.LEFT or direction_to_move == Vector2.UP:
		for i in _board.size():
			for j in _board[i].size():
				var current_grid_position = Vector2(i, j)
				
				if _is_square_occupied(current_grid_position):
					var new_grid_position = Vector2(current_grid_position.x + direction_to_move.x,
													current_grid_position.y + direction_to_move.y)
					
					if (new_grid_position.x < GRID_WIDTH and new_grid_position.x >= 0 and new_grid_position.y < GRID_HEIGHT and new_grid_position.y >= 0):
						var piece_moved = _move_piece(current_grid_position, new_grid_position)
	
	elif direction_to_move == Vector2.DOWN:
		for i in _board.size():
			for j in range(_board[i].size() - 1, -1, -1):
				var current_grid_position = Vector2(i, j)
				if _is_square_occupied(current_grid_position):
					var new_grid_position = Vector2(current_grid_position.x + direction_to_move.x,
													current_grid_position.y + direction_to_move.y)
					
					if (new_grid_position.x < GRID_WIDTH and new_grid_position.x >= 0 and new_grid_position.y < GRID_HEIGHT and new_grid_position.y >= 0):
						var piece_moved = _move_piece(current_grid_position, new_grid_position)

# ------------------------------------------------------------------------------------------------ #

## Generically moves a piece from the current_piece_grid_location to the new_piece_grid_location.
## Returns True if the piece was moved, False if the piece was not moved
func _move_piece(current_piece_grid_location: Vector2, new_piece_grid_location: Vector2) -> bool:
	if _is_square_occupied(new_piece_grid_location):
		print(new_piece_grid_location, " is occupied, cannot move piece to it!")
		return false
	else:
		var piece = _board[current_piece_grid_location.x][current_piece_grid_location.y]
		_board[current_piece_grid_location.x][current_piece_grid_location.y] = null
		_board[new_piece_grid_location.x][new_piece_grid_location.y] = piece
		piece.position = _grid_to_pixel(new_piece_grid_location)
		return true

# ------------------------------------------------------------------------------------------------ #

## Spawns pieces onto the board
# TODO: Need to implement spawning of enemy pieces
func _spawn_pieces(num_pieces_to_spawn: int):
	
	# Get the amount of empty spaces on the board defined by num_pieces_to_spawn. Each empty space is a Vector2()
	var empty_spaces: Array = _get_random_empty_board_spaces(num_pieces_to_spawn)
	
	# TODO: eventually, we need a more sophisticated way to determine what pieces to spawn. something like a 
	# 		class that will evaluate what state the board is in and spawn pieces based on that.
	# 		Can be based on how well the player is doing, how many other pieces there are already, etc
	
	for i in num_pieces_to_spawn:
		# Get a number between 0 and 100, this will be used to determine which piece to spawn
		var spawn_chance = randi() % 101 
		
		# Determine which piece to spawn based on the spawn_chance. 75% to spawn pawn, 25% to spawn bishop
		var piece_to_spawn = player_pieces["pawn"] if spawn_chance <= 75 else player_pieces["bishop"] 
		
		# Spawn the piece and adjust its position to the corresponding empty spaces
		var piece = piece_to_spawn.instantiate()
		var grid_position = _pixel_to_grid(Vector2(empty_spaces[i].x, empty_spaces[i].y))
		_board[grid_position.x][grid_position.y] = piece
		piece.position = Vector2(empty_spaces[i].x, empty_spaces[i].y)
		_pieces_on_board.append(piece)
		add_child(piece)
	
# ------------------------------------------------------------------------------------------------ #

## Generate the board background by creating a grid of alternating sprites
func _generate_board_background() -> void:
	for i in GRID_WIDTH:
		for j in GRID_HEIGHT:	
			var sprite = Sprite2D.new()
			sprite.texture = DARK_SQUARE_PATH if (i + j) % 2 == 0 else LIGHT_SQUARE_PATH
			sprite.position = _grid_to_pixel(Vector2(i, j))
			add_child(sprite)

# ------------------------------------------------------------------------------------------------ #

## Returns num_spaces amount of random empty spaces on the board
func _get_random_empty_board_spaces(num_spaces: int) -> Array:	
	# Find all of the empty spaces on the board
	var empty_spaces := []  # Every element in this array will be a Vector2 pertaining to the pixel position of the space
	for i in GRID_WIDTH:
		for j in GRID_HEIGHT:
			if _board[i][j] == null:
				empty_spaces.append(_grid_to_pixel(Vector2(i, j)))
	
	# Randomize the empty spaces
	empty_spaces.shuffle()
	
	# Return a slice of the array from the first element to the amount of spaces we want
	return empty_spaces.slice(0, num_spaces)

# ------------------------------------------------------------------------------------------------ #	

## Creates and returns a 2d array where all values equal null
func _create_empty_2d_array() -> Array:
	var array = []
	for i in GRID_WIDTH:
		array.append([])
		for j in GRID_HEIGHT:
			array[i].append(null) 
	return array

# ------------------------------------------------------------------------------------------------ #

## Converts a grid position to a pixel position
func _grid_to_pixel(grid_coordinates: Vector2) -> Vector2:
	var pixel_x = GRID_X_START_POSITION + (GRID_OFFSET * grid_coordinates.x)
	var pixel_y = GRID_Y_START_POSITION + (GRID_OFFSET * grid_coordinates.y)
	return Vector2(pixel_x, pixel_y)

# ------------------------------------------------------------------------------------------------ #

## Converts a pixel position to a grid position
func _pixel_to_grid(pixel_coordinates: Vector2) -> Vector2:
	var grid_x = round((pixel_coordinates.x - GRID_X_START_POSITION) / GRID_OFFSET)
	var grid_y = round((pixel_coordinates.y - GRID_Y_START_POSITION) / GRID_OFFSET)
	return Vector2(grid_x, grid_y)
	
# ------------------------------------------------------------------------------------------------ #

## Checks if the square at the passed in grid space has a piece assigned to it
func _is_square_occupied(grid_coordinates: Vector2) -> bool:
	return _board[grid_coordinates.x][grid_coordinates.y] != null

# ------------------------------------------------------------------------------------------------ #

## Perform functions that need to occur at the start of the game
func _on_state_changed_start_game() -> void:
	_board = _create_empty_2d_array()
	_generate_board_background()
	# TODO: figure out a way to decide what piece(s) we want to spawn. spawn_pieces should probably 
	# 		handle that, for now. We should only pass in the amount of pieces we want to spawn, and 
	# 		then spawn_pieces will figure out which ones, where, and handle the actual spawning
	_spawn_pieces(2)

# ------------------------------------------------------------------------------------------------ #

func _on_slide_move_left() -> void:
	print("slide move left heard in board.gd")
	_slide_move(Vector2.LEFT)

# ------------------------------------------------------------------------------------------------ #

func _on_slide_move_right() -> void:
	print("slide move right heard in board.gd")
	_slide_move(Vector2.RIGHT)

# ------------------------------------------------------------------------------------------------ #

func _on_slide_move_up() -> void:
	print("slide move up heard in board.gd")
	_slide_move(Vector2.UP)

# ------------------------------------------------------------------------------------------------ #

func _on_slide_move_down() -> void:
	print("slide move down heard in board.gd")
	_slide_move(Vector2.DOWN)

# ------------------------------------------------------------------------------------------------ #

# -- Public Functions -- #





