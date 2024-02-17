extends Node

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

const GRID_X_START_LOCATION: int = 104
const GRID_Y_START_LOCATION: int = 384
const GRID_OFFSET: int = 128
const GRID_WIDTH: int = 5
const GRID_HEIGHT: int = 5
const NONE: String = "NONE"

var _board: Array # Two dimensional array that defines the board and holds references to piece locations
var _pieces_on_board: Array = [] # Array containing a list of all the pieces that are currently on the board. This includes Player and Enemy pieces
var _shown_move_overlays: Array = [] # Array containing a list of all the move overlays that are currently on the board.

# ------------------------------------------------------------------------------------------------ #
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
	SignalBus.connect("slide_move_finished", _on_slide_move_finished)
	SignalBus.connect("piece_clicked", _on_piece_clicked)

# ------------------------------------------------------------------------------------------------ #

## Processes a slide move. Attempts to move all pieces on the board in the direction that is defined 
## 	in direction_to_move. If the piece can't move, it doesn't. 
## 	direction_to_move is a Vector2 which should contain a 1 or -1 in the direction that we want to move 
## 	For example: If we want to move all pieces right, direction_to_move = Vector2(1, 0)
## 				 If we want to move all pieces up, direction_to_move = Vector2(0, -1)
func _process_slide_move(direction_to_move: Vector2) -> void:
	var slide_moves_performed: int = 0
	
	GameManager.change_state(GameManager.GameState.SLIDE_MOVE)
	
	# Reset the move overlays when performing a slide move
	_remove_move_overlays()
	
	# TODO: REWRITE THIS TO BE MORE READABLE. Don't worry too much about efficiency, it's a small board
	if direction_to_move == Vector2.RIGHT:
		for i in range(_board.size() - 1, -1, -1):
			for j: int in _board[i].size():
				var current_grid_location := Vector2(i, j)
				if _is_square_occupied(current_grid_location):
					var new_grid_location := Vector2(current_grid_location.x + direction_to_move.x,
													 current_grid_location.y + direction_to_move.y)
					if (new_grid_location.x < GRID_WIDTH and new_grid_location.x >= 0 and new_grid_location.y < GRID_HEIGHT and new_grid_location.y >= 0):
						slide_moves_performed += _slide_move_piece(current_grid_location, new_grid_location)
	elif direction_to_move == Vector2.LEFT or direction_to_move == Vector2.UP:
		for i: int in _board.size():
			for j: int in _board[i].size():
				var current_grid_location := Vector2(i, j)
				if _is_square_occupied(current_grid_location):
					var new_grid_location := Vector2(current_grid_location.x + direction_to_move.x,
													 current_grid_location.y + direction_to_move.y)
					if (new_grid_location.x < GRID_WIDTH and new_grid_location.x >= 0 and new_grid_location.y < GRID_HEIGHT and new_grid_location.y >= 0):
						slide_moves_performed += _slide_move_piece(current_grid_location, new_grid_location)
						
	elif direction_to_move == Vector2.DOWN:
		for i in _board.size():
			for j in range(_board[i].size() - 1, -1, -1):
				var current_grid_location := Vector2(i, j)
				if _is_square_occupied(current_grid_location):
					var new_grid_location := Vector2(current_grid_location.x + direction_to_move.x,
													 current_grid_location.y + direction_to_move.y)
					
					if (new_grid_location.x < GRID_WIDTH and new_grid_location.x >= 0 and new_grid_location.y < GRID_HEIGHT and new_grid_location.y >= 0):
						slide_moves_performed += _slide_move_piece(current_grid_location, new_grid_location)

	# If we performed at least 1 slide move, emit the signal
	if slide_moves_performed > 0:
		SignalBus.emit_signal("slide_move_finished")

	GameManager.change_state(GameManager.GameState.WAITING_USER_INPUT)

# ------------------------------------------------------------------------------------------------ #

## Moves a piece using a slide move from the current_piece_grid_location to the new_piece_grid_location.
## Returns 1 if the slide move was performed, 0 if not. Not using bools because the calling code wants
## to know how many slide moves are performed
func _slide_move_piece(current_piece_grid_location: Vector2, new_piece_grid_location: Vector2) -> int:
	# If the new grid location to move to is occupied, either merge the pieces or don't perform the movement
	if _is_square_occupied(new_piece_grid_location):
		
		var piece_at_current_grid_location: Node = _board[current_piece_grid_location.x][current_piece_grid_location.y]
		var piece_at_new_grid_location: Node = _board[new_piece_grid_location.x][new_piece_grid_location.y]
		
		# If the piece at the current grid location and the new grid location are the same, merge them
		if piece_at_current_grid_location.piece_name == piece_at_new_grid_location.piece_name:
			print("piece_at_current_grid_location.next_piece_name: ", piece_at_current_grid_location.next_piece_name)
			print("piece_at_new_grid_location.next_piece_name: ", piece_at_new_grid_location.next_piece_name)
			
			# If the pieces that we are merging don't have a next piece name, don't merge, because
			# there aren't any pieces after this one. This usually means that we have two kings merging
			if piece_at_new_grid_location.next_piece_name == "":
				return 0
			
			GameManager.change_state(GameManager.GameState.MERGING)
			
			# TODO: This doesn't work because the objects are freed before the tween starts so it doesn't start
			# 		May be able to connect to the tween finished signal and free the objects then?
			# 		I'd like to have some kind of animation when pieces are merging
			#var move_tween := create_tween()
			#move_tween.tween_property(piece_at_current_grid_location, "location", _grid_to_pixel(new_piece_grid_location), .3).set_trans(Tween.TRANS_EXPO)
			
			# Remove both pieces from _board and _pieces_on_board
			_board[new_piece_grid_location.x][new_piece_grid_location.y] = null	
			_board[current_piece_grid_location.x][current_piece_grid_location.y] = null
			_pieces_on_board.erase(piece_at_current_grid_location)  
			_pieces_on_board.erase(piece_at_new_grid_location)     

			_spawn_piece_at_grid_location(new_piece_grid_location, "player", piece_at_new_grid_location.next_piece_name)
			
			# Delete the pieces that are merging
			piece_at_current_grid_location.queue_free()
			piece_at_new_grid_location.queue_free()
			
			GameManager.change_state(GameManager.GameState.WAITING_USER_INPUT)
			
			return 1
		
		# If the new grid location is occupied but the pieces don't match, do nothing and return. No movement should happen
		else:
			return 0
		
	# If the new grid location to move to is not occupied, move the piece to the new locaation 
	# without worrying about merging.
	else:
		var piece: Node = _board[current_piece_grid_location.x][current_piece_grid_location.y]
		_board[current_piece_grid_location.x][current_piece_grid_location.y] = null
		_board[new_piece_grid_location.x][new_piece_grid_location.y] = piece
		
		# TODO: This makes the sprite move to the final location in the set amount of time
		# TODO: A few problems/improvements with this:
		# 		  1. The player can input a new direction DURING the tween, so the pieces change their 
		# 			 direction before the tween ends
		# 		  2. The player can input a diagonal direction, causing the pieces to move diagonally, 
		# 			 which we do not want
		# 		  3. When merging, the tween doesn't seem to fully finish. We need some better animation when merging happens
		# 		  4. Find the best transition settings. Using set_trans, we can change how the sprite moves to it's final destination
		var move_tween := create_tween()
		#move_tween.connect("finished", _on_move_tween_finished) # TODO: This didn't seem to work like I wanted
		move_tween.tween_property(piece, "position", _grid_to_pixel(new_piece_grid_location), .3).set_trans(Tween.TRANS_EXPO)
		
		return 1
		
# ------------------------------------------------------------------------------------------------ #

## Spawns pieces onto the board
# TODO: 1. Need to implement spawning of enemy pieces
# TODO: 2. In Threes, the pieces are only spawned at the edges of the board. We might want to do that as well
# TODO: 3. We want to make sure pieces spawn at places that weren't just occupied or are going to be occupied by a move
func _spawn_pieces_at_random_locations(num_pieces_to_spawn: int) -> void:
	# Get the amount of empty spaces on the board defined by num_pieces_to_spawn. Each empty space is a Vector2()
	var empty_spaces: Array = _get_random_empty_board_spaces(num_pieces_to_spawn)
	
	# TODO: eventually, we need a more sophisticated way to determine what pieces to spawn. something like a 
	# 		class that will evaluate what state the board is in and spawn pieces based on that.
	# 		Can be based on how well the player is doing, how many other pieces there are already, etc
	
	for i in num_pieces_to_spawn:
		# Get a number between 0 and 100, this will be used to determine which piece to spawn
		var spawn_chance: int = randi() % 101 
		
		# Spawn the piece based on the random chance and set it's location to the empty_space we're on
		var grid_location: Vector2 = _pixel_to_grid(Vector2(empty_spaces[i].x, empty_spaces[i].y))
		if spawn_chance <= 75:
			_spawn_piece_at_grid_location(grid_location, "player", "pawn")
		else:
			_spawn_piece_at_grid_location(grid_location, "player", "bishop")
	
# ------------------------------------------------------------------------------------------------ #

## Spawn a piece at the grid location specified. 
## piece_family is "enemy" or "player"
## piece_name is "pawn", "bishop", "knight", "rook", "queen", "king"
func _spawn_piece_at_grid_location(grid_location: Vector2, piece_family: String, piece_name: String) -> void:
	
	# Determine our piece to spawn based on the options passed in
	var piece_to_spawn: Resource = ResourceManager.player_pieces[piece_name] if piece_family == "player" else ResourceManager.enemy_pieces[piece_name]
		
	# Instantiate and spawn our piece at the given location
	var piece: Variant = piece_to_spawn.instantiate()
	_board[grid_location.x][grid_location.y] = piece
	piece.position = _grid_to_pixel(grid_location)
	_pieces_on_board.append(piece)
	add_child(piece)
	
# ------------------------------------------------------------------------------------------------ #

## Spawn move overlays on the grid locations passed in
func _spawn_move_overlays(desired_overlay_locations: Array) -> void:
	for i in desired_overlay_locations.size():
		print("overlay_location: ", desired_overlay_locations[i])
		
		# TODO: also, probably need to add these overlays to a list so we can delete them when the player clicks on another piece or clicks on a space to move to
		
		var overlay_sprite := Sprite2D.new()
		overlay_sprite.texture = ResourceManager.move_square_overlay
		overlay_sprite.position = _grid_to_pixel(desired_overlay_locations[i])
		_shown_move_overlays.append(overlay_sprite)
		add_child(overlay_sprite)

# ------------------------------------------------------------------------------------------------ #

## Removes all shown move overlays from the board and resets the array that keeps track of them
func _remove_move_overlays() -> void:
	print("_shown_move_overlays: ", _shown_move_overlays)
	
	for i in _shown_move_overlays.size():
		print("freeing")
		_shown_move_overlays[i].queue_free()
	
	print("resetting")
	_shown_move_overlays = []
	print("_shown_move_overlays: ", _shown_move_overlays)

# ------------------------------------------------------------------------------------------------ #

## Generate the board background by creating a grid of alternating sprites
func _generate_board_background() -> void:
	for i in GRID_WIDTH:
		for j in GRID_HEIGHT:	
			var sprite := Sprite2D.new()
			sprite.texture = ResourceManager.square_backgrounds["dark"] if (i + j) % 2 == 0 else ResourceManager.square_backgrounds["light"]
			sprite.position = _grid_to_pixel(Vector2(i, j))
			add_child(sprite)

# ------------------------------------------------------------------------------------------------ #

## Returns num_spaces amount of random empty spaces on the board
func _get_random_empty_board_spaces(num_spaces: int) -> Array:	
	# Find all of the empty spaces on the board
	var empty_spaces := []  # Every element in this array will be a Vector2 pertaining to the pixel location of the space
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
	var array := []
	for i in GRID_WIDTH:
		array.append([])
		for j in GRID_HEIGHT:
			array[i].append(null) 
	return array

# ------------------------------------------------------------------------------------------------ #

## Converts a grid location to a pixel location
func _grid_to_pixel(grid_location: Vector2) -> Vector2:
	var pixel_x := int(GRID_X_START_LOCATION + (GRID_OFFSET * grid_location.x))
	var pixel_y := int(GRID_Y_START_LOCATION + (GRID_OFFSET * grid_location.y))
	return Vector2(pixel_x, pixel_y)

# ------------------------------------------------------------------------------------------------ #

## Converts a pixel location to a grid location
func _pixel_to_grid(pixel_location: Vector2) -> Vector2:
	var grid_x: int = round((pixel_location.x - GRID_X_START_LOCATION) / GRID_OFFSET)
	var grid_y: int = round((pixel_location.y - GRID_Y_START_LOCATION) / GRID_OFFSET)
	return Vector2(grid_x, grid_y)
	
# ------------------------------------------------------------------------------------------------ #

## Checks if the square at the passed in grid space has a piece assigned to it
func _is_square_occupied(grid_location: Vector2) -> bool:
	return _board[grid_location.x][grid_location.y] != null

# ------------------------------------------------------------------------------------------------ #

## Perform functions that need to occur at the start of the game
func _on_state_changed_start_game() -> void:
	_board = _create_empty_2d_array()
	_generate_board_background()
	_spawn_pieces_at_random_locations(2)
	
	# TODO: We are allowing the board scene to change the state of the game, using the GameManager Singleton.
	# 		I honestly don't know if this is good or not. This way, any script can change the state using GameManager,
	# 		and that scares me. But, maybe it's not a bad thing. I'm not going to focus too hard on
	# 		over-engineering a perfect solution until it matters.
	# 		So, whether it's good or not, I will be allowing this for now. Maybe some day it will change when
	# 		I understand more about Godot.
	GameManager.change_state(GameManager.GameState.WAITING_USER_INPUT)

# ------------------------------------------------------------------------------------------------ #

func _on_slide_move_left() -> void:
	_process_slide_move(Vector2.LEFT)

# ------------------------------------------------------------------------------------------------ #

func _on_slide_move_right() -> void:
	_process_slide_move(Vector2.RIGHT)

# ------------------------------------------------------------------------------------------------ #

func _on_slide_move_up() -> void:
	_process_slide_move(Vector2.UP)

# ------------------------------------------------------------------------------------------------ #

func _on_slide_move_down() -> void:
	_process_slide_move(Vector2.DOWN)

# ------------------------------------------------------------------------------------------------ #

func _on_slide_move_finished() -> void:
	_spawn_pieces_at_random_locations(1)

# ------------------------------------------------------------------------------------------------ #

func _on_piece_clicked(piece_pixel_location: Vector2, piece_name: String) -> void:
	_remove_move_overlays()
	
	print("piece clicked! location: ", piece_pixel_location, " name: ", piece_name)
	
	var piece_grid_location: Vector2 = _pixel_to_grid(piece_pixel_location)
	var piece_at_grid_location: Node = _board[piece_grid_location.x][piece_grid_location.y]
	if piece_at_grid_location.has_method("calculate_possible_moves"):
		var possible_moves: Array = piece_at_grid_location.calculate_possible_moves(_board, piece_grid_location, GRID_WIDTH, GRID_HEIGHT)
		print("possible_moves: ", possible_moves)
		_spawn_move_overlays(possible_moves)
	else:
		printerr(piece_at_grid_location.piece_name, " does not have method 'calculate_possible_moves'!")

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #




