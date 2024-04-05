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

var _board: Array 				     # Two dimensional array that defines the board and holds references to piece locations
var _pieces_on_board: Array = []     # Array containing a list of all the pieces that are currently on the board. This includes Player and Enemy pieces
var _shown_move_overlays: Array = [] # Array containing a list of all the move overlays that are currently on the board.
var _last_clicked_piece: Node 		 # The last piece that was clicked, needed to know which piece to chess move
									 # TODO: There might be a better way to do this, but not going to worry about it yet

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
	SignalBus.connect("player_piece_clicked", _on_player_piece_clicked)
	SignalBus.connect("empty_move_overlay_clicked", _on_empty_move_overlay_clicked)
	SignalBus.connect("enemy_move_overlay_clicked", _on_enemy_move_overlay_clicked)

# ------------------------------------------------------------------------------------------------ #

## Processes a slide move. Attempts to move all pieces on the board in the direction that is defined 
## 	in direction_to_move. If the piece can't move, it doesn't. 
## 	direction_to_move is a Vector2 which should contain a 1 or -1 in the direction that we want to move 
## 	For example: If we want to move all pieces right, direction_to_move = Vector2(1, 0)
## 				 If we want to move all pieces up, direction_to_move = Vector2(0, -1)
func _process_slide_move(direction_to_move: Vector2) -> void:

	# Only move if we are waiting for user input
	if GameManager.get_current_game_state() == GameManager.GameState.WAITING_USER_INPUT:

		GameManager.change_state(GameManager.GameState.SLIDE_MOVE)

		var slide_moves_performed: int = 0
		
		# Reset the move overlays when performing a slide move
		_remove_move_overlays()
		
		# TODO: REWRITE THIS TO BE MORE READABLE. Don't worry too much about efficiency, it's a small board
		# Based on the direction to move, for each square, check if it's occupied. If it is, perform a slide 
		# move for the piece in that square.
		if direction_to_move == Vector2.RIGHT:
			for i in range(_board.size() - 1, -1, -1):
				for j: int in _board[i].size():
					var current_grid_location := Vector2(i, j)
					# Check that the location we are looking at is occupied by a piece
					if (
						_is_location_occupied(current_grid_location) == GameManager.BoardLocationStates.OCCUPIED_PLAYER or
						_is_location_occupied(current_grid_location) == GameManager.BoardLocationStates.OCCUPIED_ENEMY
					):
						var new_grid_location := Vector2(current_grid_location.x + direction_to_move.x,
														current_grid_location.y + direction_to_move.y)
						# Check that the new location we want to move to is in bounds
						if (new_grid_location.x < GRID_WIDTH and new_grid_location.x >= 0 and new_grid_location.y < GRID_HEIGHT and new_grid_location.y >= 0):
							slide_moves_performed += _slide_move_piece(current_grid_location, new_grid_location)

		elif direction_to_move == Vector2.LEFT or direction_to_move == Vector2.UP:
			for i: int in _board.size():
				for j: int in _board[i].size():
					var current_grid_location := Vector2(i, j)
					# Check that the location we are looking at is occupied by a piece
					if (
						_is_location_occupied(current_grid_location) == GameManager.BoardLocationStates.OCCUPIED_PLAYER or
						_is_location_occupied(current_grid_location) == GameManager.BoardLocationStates.OCCUPIED_ENEMY
					):
						var new_grid_location := Vector2(current_grid_location.x + direction_to_move.x,
														current_grid_location.y + direction_to_move.y)
						# Check that the new location we want to move to is in bounds
						if (new_grid_location.x < GRID_WIDTH and new_grid_location.x >= 0 and new_grid_location.y < GRID_HEIGHT and new_grid_location.y >= 0):
							slide_moves_performed += _slide_move_piece(current_grid_location, new_grid_location)
		elif direction_to_move == Vector2.DOWN:
			for i in _board.size():
				for j in range(_board[i].size() - 1, -1, -1):
					var current_grid_location := Vector2(i, j)
					# Check that the location we are looking at is occupied by a piece
					if (
						_is_location_occupied(current_grid_location) == GameManager.BoardLocationStates.OCCUPIED_PLAYER or
						_is_location_occupied(current_grid_location) == GameManager.BoardLocationStates.OCCUPIED_ENEMY
					):
						var new_grid_location := Vector2(current_grid_location.x + direction_to_move.x,
														current_grid_location.y + direction_to_move.y)
						# Check that the new location we want to move to is in bounds
						if (new_grid_location.x < GRID_WIDTH and new_grid_location.x >= 0 and new_grid_location.y < GRID_HEIGHT and new_grid_location.y >= 0):
							slide_moves_performed += _slide_move_piece(current_grid_location, new_grid_location)

		if slide_moves_performed > 0:
			SignalBus.emit_signal("slide_move_finished")

		if _is_game_over():
			var signal_arguments: Dictionary = { final_board = _board.duplicate() }
			GameManager.change_state(GameManager.GameState.SCORING, signal_arguments)
		else:
			GameManager.change_state(GameManager.GameState.WAITING_USER_INPUT)

# ------------------------------------------------------------------------------------------------ #

## Moves a piece using a slide move from the current_piece_grid_location to the new_piece_grid_location.
## Returns 1 if the slide move was performed, 0 if not. Not using bools because the calling code wants
## to know how many slide moves are performed
func _slide_move_piece(current_piece_grid_location: Vector2, new_piece_grid_location: Vector2) -> int:
	var piece_at_current_location: Node = _board[current_piece_grid_location.x][current_piece_grid_location.y]
	var piece_at_new_location: Node = _board[new_piece_grid_location.x][new_piece_grid_location.y]

	# If there is no piece at the current location, we shouldn't have called this function. Print an error and return
	if piece_at_current_location == null:
		printerr("!!! Attempted to slide move from a square with no piece on it !!!")
		return 0

	# If there is no piece at the new location, we can simply move the piece at the current location to the new location
	if piece_at_new_location == null:
		_move_piece_from_location_a_to_empty_location_b(current_piece_grid_location, new_piece_grid_location)
		return 1

	# If the piece at the current location is a player piece and the piece at the new location is a player piece, we
	# need to check if we can merge them, or if they can't move
	if (
		piece_at_current_location.piece_family == GameManager.PLAYER_FAMILY and
		piece_at_new_location.piece_family == GameManager.PLAYER_FAMILY
	):
		# If the pieces have the same name, we can attempt to merge them
		if piece_at_current_location.piece_name == piece_at_new_location.piece_name:

			# We need to do a quick check to make sure that the pieces have a next piece name
			# If they don't, then we can't merge because there is no piece to upgrade to. This is usually
			# the case when we have two kings
			if piece_at_current_location.next_piece_name == "":
				return 0

			# If we've gotten here, we know the pieces are the same and they have a next piece, so we can merge them
			_move_and_merge_piece_from_location_a_to_location_b(current_piece_grid_location, new_piece_grid_location)
			return 1
		
		# If the pieces don't have the same name, we can't merge them, so don't move and simply return 0
		else:
			return 0

	# If we've gotten here, then the piece we are trying to slide move is not allowed to slide move, either because 
	# it's two enemy pieces (enemy piece merging is not allowed), or because they are two opposing pieces (piece 
	# capturing during a slide move is not allowed)
	return 0
		
# ------------------------------------------------------------------------------------------------ #

## Move the last clicked piece, according to its chess movementm, from its location to a new empty location
func _chess_move_piece_to_empty_square(desired_pixel_location: Vector2) -> void:

	# If a chess move isn't allowed, return and do nothing
	if !GameManager.is_chess_move_allowed():
		return

	var last_clicked_piece_grid_location: Vector2 = _pixel_to_grid(_last_clicked_piece.position)
	var desired_grid_location: Vector2 = _pixel_to_grid(desired_pixel_location)

	_move_piece_from_location_a_to_empty_location_b(last_clicked_piece_grid_location, desired_grid_location)
	
	SignalBus.emit_signal("chess_move_finished")
	
# ------------------------------------------------------------------------------------------------ #

## Move the last clicked piece, according to its chess movement, from its location to a new location 
## that is occupied by an enemy piece
func _chess_move_piece_to_enemy_square(desired_pixel_location: Vector2) -> void:

	# If a chess move isn't allowed, return and do nothing
	if !GameManager.is_chess_move_allowed():
		return

	var last_clicked_piece_grid_location: Vector2 = _pixel_to_grid(_last_clicked_piece.position)
	var desired_grid_location: Vector2 = _pixel_to_grid(desired_pixel_location)
	var piece_at_desired_grid_location: String = _get_piece_name_at_grid_location(desired_grid_location) 
	
	_move_and_take_piece_from_location_a_to_location_b(last_clicked_piece_grid_location, desired_grid_location)

	SignalBus.emit_signal("chess_move_finished")
	SignalBus.emit_signal("piece_taken", piece_at_desired_grid_location)
	
# ------------------------------------------------------------------------------------------------ #

## Spawns pieces onto the board
# TODO: 1. In Threes, the pieces are only spawned at the edges of the board. We might want to do that as well
# TODO: 2. We want to make sure pieces spawn at places that weren't just occupied or are going to be occupied by a move
func _spawn_pieces_at_random_locations(pieces_to_spawn: Array) -> void:

	# Get the amount of empty spaces on the board defined by num_pieces_to_spawn. Each empty space is a Vector2()
	var empty_spaces: Array = _get_random_empty_board_spaces(pieces_to_spawn.size())

	# For each empty space that's available, spawn a piece at that location
	# NOTE: The reason we are iterating over empty_spaces instead of pieces_to_spawn is because we don't want to try to
	# 		spawn more pieces than we have empty spaces for
	for i in empty_spaces.size():
		var grid_location: Vector2 = _pixel_to_grid(Vector2(empty_spaces[i].x, empty_spaces[i].y))
		_spawn_piece_at_grid_location(grid_location, pieces_to_spawn[i])
	
# ------------------------------------------------------------------------------------------------ #

## Spawn a piece at the grid location specified. 
func _spawn_piece_at_grid_location(grid_location: Vector2, piece_to_spawn: Resource) -> void:

	# Instantiate and spawn our piece at the given location
	var piece: Variant = piece_to_spawn.instantiate()
	_board[grid_location.x][grid_location.y] = piece
	piece.position = _grid_to_pixel(grid_location)
	_pieces_on_board.append(piece)
	add_child(piece)
	
# ------------------------------------------------------------------------------------------------ #

## Spawn move overlays on the grid locations passed in
func _spawn_move_overlays(desired_overlay_locations: Dictionary) -> void:

	# Spawn all of the overlays for the empty spaces
	for i: int in desired_overlay_locations["empty_spaces"].size():
		var overlay: Variant = ResourceManager.move_overlays["empty"].instantiate()
		overlay.position = _grid_to_pixel(desired_overlay_locations["empty_spaces"][i])
		_shown_move_overlays.append(overlay)
		add_child(overlay)
	
	# Spawn all of the overlays for the enemy spaces
	for i: int in desired_overlay_locations["enemy_spaces"].size():
		var overlay: Variant = ResourceManager.move_overlays["enemy"].instantiate()
		overlay.position = _grid_to_pixel(desired_overlay_locations["enemy_spaces"][i])
		_shown_move_overlays.append(overlay)
		add_child(overlay)
	
# ------------------------------------------------------------------------------------------------ #

## Removes all shown move overlays from the board and resets the array that keeps track of them
func _remove_move_overlays() -> void:
	for i in _shown_move_overlays.size():
		_shown_move_overlays[i].queue_free()
	_shown_move_overlays = []

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

## Simple helper function that retrieves the piece name at the board's grid location that is passed 
## in. If there is no piece at the location, returns the string "NO PIECE AT GRID LOCATION"
func _get_piece_name_at_grid_location(grid_location: Vector2) -> String:
	var grid_location_contents: Node = _board[grid_location.x][grid_location.y]

	# If the contents are null, there is no piece at the location
	if grid_location_contents == null:
		return "NO PIECE AT GRID LOCATION"

	# If we have gotten here, we know there is a piece at the location, so return its name
	return grid_location_contents.piece_name

# ------------------------------------------------------------------------------------------------ # 

## Simple helper function that retrieves the piece's family at the board's grid location that is passed 
## in. If there is no piece at the location, returns the string "NO PIECE AT GRID LOCATION"
func _get_piece_family_at_grid_location(grid_location: Vector2) -> String:
	var grid_location_contents: Node = _board[grid_location.x][grid_location.y]

	# If the contents are null, there is no piece at the location
	if grid_location_contents == null:
		return "NO PIECE AT GRID LOCATION"

	# If we have gotten here, we know there is a piece at the location, so return its family
	return grid_location_contents.piece_family

# ------------------------------------------------------------------------------------------------ # 

# TODO: Use this function in all other places where we have to check if two pieces can merge
## Simple helper function that checks if the two pieces at each grid location can merge with each other.
func _can_merge(piece_a_grid_location: Vector2, piece_b_grid_location: Vector2) -> bool:

	# Only player pieces can merge, so if either piece isn't a player piece, we can't merge
	if (
		_get_piece_family_at_grid_location(piece_a_grid_location) != GameManager.PLAYER_FAMILY or 
		_get_piece_family_at_grid_location(piece_b_grid_location) != GameManager.PLAYER_FAMILY
	):
		return false

	# We know the pieces are both player pieces, so check that their names are equal. If they are, they can merge
	if (_get_piece_name_at_grid_location(piece_a_grid_location) == _get_piece_name_at_grid_location(piece_b_grid_location)):
		return true
	
	# If we have gotten here, return false. The pieces are not player pieces or they don't have the same name
	return false

# ------------------------------------------------------------------------------------------------ # 

## Helper function that moves a piece from location_a to location_b, assuming that location_b is empty
func _move_piece_from_location_a_to_empty_location_b(grid_location_a: Vector2, grid_location_b: Vector2) -> void:
	var piece_to_move: Node = _board[grid_location_a.x][grid_location_a.y]

	_board[grid_location_a.x][grid_location_a.y] = null
	_board[grid_location_b.x][grid_location_b.y] = piece_to_move

	# Tween the piece to the new location
	var move_tween := create_tween()
	move_tween.tween_property(piece_to_move, "position", _grid_to_pixel(grid_location_b), .3).set_trans(Tween.TRANS_CUBIC)

# ------------------------------------------------------------------------------------------------ #

## Helper function that moves a piece from location_a to location_b and merges the piece that's 
## moving from location_a with the piece that's in location_b
## This function assumes that we have already checked that the two pieces are valid to merge into
## each other. That needs to be done somewhere before this function is called in the calling code.
func _move_and_merge_piece_from_location_a_to_location_b(grid_location_a: Vector2, grid_location_b: Vector2) -> void:
	var piece_at_grid_location_a: Node = _board[grid_location_a.x][grid_location_a.y]
	var piece_at_grid_location_b: Node = _board[grid_location_b.x][grid_location_b.y]

	# Remove both pieces from _board and _pieces_on_board
	_board[grid_location_a.x][grid_location_a.y] = null
	_board[grid_location_b.x][grid_location_b.y] = null
	_pieces_on_board.erase(piece_at_grid_location_a)
	_pieces_on_board.erase(piece_at_grid_location_b)

	# Get the next piece that we want to spawn and spawn it at grid_location_b
	# NOTE: At this point, we're assuming that we are safe to merge. Meaning, the calling code of
	# 		this function has already checked that the pieces we are trying to merge are the same
	var upgraded_piece_to_spawn: Resource = PieceSpawnManager.get_piece_by_name(piece_at_grid_location_a.next_piece_name)
	_spawn_piece_at_grid_location(grid_location_b, upgraded_piece_to_spawn)

	# Delete the pieces that are merging
	piece_at_grid_location_a.queue_free()
	piece_at_grid_location_b.queue_free()

	SignalBus.emit_signal("pieces_merged")

# ------------------------------------------------------------------------------------------------ #

## Helper function that moves a piece from location_a to location_b and takes the piece in location_b.
func _move_and_take_piece_from_location_a_to_location_b(grid_location_a: Vector2, grid_location_b: Vector2) -> void:

	# Delete the piece at location_b
	var piece_at_grid_location_b: Node = _board[grid_location_b.x][grid_location_b.y]
	_pieces_on_board.erase(piece_at_grid_location_b)
	piece_at_grid_location_b.queue_free()

	# We've now created an empty space to move to, so we can use our function to move to an empty space
	_move_piece_from_location_a_to_empty_location_b(grid_location_a, grid_location_b)

# ------------------------------------------------------------------------------------------------ #

## Helper to check if a board square location is occupied, and if so, by who
func _is_location_occupied(grid_location: Vector2) -> GameManager.BoardLocationStates:
	var board_location_contents: Node = _board[grid_location.x][grid_location.y]
	var state: GameManager.BoardLocationStates = GameManager.BoardLocationStates.ERROR  # Error state should not be returned, it should be set to one of the other ones. If not, bug.
	
	if board_location_contents == null:
		state = GameManager.BoardLocationStates.NOT_OCCUPIED
	elif board_location_contents.piece_family == GameManager.PLAYER_FAMILY:
		state = GameManager.BoardLocationStates.OCCUPIED_PLAYER
	elif board_location_contents.piece_family == GameManager.ENEMY_FAMILY:
		state = GameManager.BoardLocationStates.OCCUPIED_ENEMY
		
	return state

# ------------------------------------------------------------------------------------------------ #

## Simply sets the last clicked piece to the piece located at the pixel location passed in
## This is needed so that we know which piece to move when performing a chess move
func _set_last_clicked_piece(piece_pixel_location: Vector2) -> void:
	var piece_grid_location: Vector2 = _pixel_to_grid(piece_pixel_location)
	_last_clicked_piece = _board[piece_grid_location.x][piece_grid_location.y]

# ------------------------------------------------------------------------------------------------ #

## Runner function that checks if the game is over. 
## Returns true if it is, meaning there are no valid slide moves NOR chess moves.
## Returns false if it isn't, meaning there is at least one valid slide more OR chess move
func _is_game_over() -> bool:

	# If there is at least one empty space, the game cannot be over yet
	if _get_random_empty_board_spaces(1) != []:
		return false

	# If there are valid horizontal slide moves, return false, the game isn't over yet
	if _check_valid_horizontal_slide_moves() == true:
		return false

	# If there are valid vertical slide moves, return false, the game isn't over yet
	if _check_valid_vertical_slide_moves() == true:
		return false

	# If there are any valid chess moves, return false, the game isn't over yet
	if _check_valid_chess_moves() == true:
		return false	

	# If we have gotten here, the game is over
	return true

# ------------------------------------------------------------------------------------------------ #

## Checks if there are any valid slide moves in the horizontal direction. Returns true if so, false otherwise
func _check_valid_horizontal_slide_moves() -> bool:
	for i in GRID_WIDTH - 1:
		for j in GRID_HEIGHT:
			# If the pieces at the two locations can merge, return true
			if _can_merge(Vector2(i, j), Vector2(i + 1, j)):
				return true

	# If we have gotten here, we know there are no valid moves, so return false
	return false

# ------------------------------------------------------------------------------------------------ #

## Checks if there are any valid slide moves in the vertical direction. Returns true if so, false otherwise
func _check_valid_vertical_slide_moves() -> bool:
	for i in GRID_WIDTH:
		for j in GRID_HEIGHT - 1:
			# If the pieces at the two locations can merge, return true
			if _can_merge(Vector2(i, j), Vector2(i, j + 1)):
				return true

	# If we have gotten here, we know there are no valid moves, so return false
	return false

# ------------------------------------------------------------------------------------------------ #

## Checks if there are any chess moves on the board. Returns true if so, false otherwise 
func _check_valid_chess_moves() -> bool:

	# If a chess move isn't allowed, there are no valid chess moves
	if !GameManager.is_chess_move_allowed():
		return false

	# Iterate through each space and check if there are valid chess moves for any pieces
	for i in GRID_WIDTH:
		for j in GRID_HEIGHT:
			# If the location is occupied by a player piece, have it calculate it's possible moves. 
			if _is_location_occupied(Vector2(i, j)) == GameManager.BoardLocationStates.OCCUPIED_PLAYER:
				var piece_at_grid_location: Node = _board[i][j]
				var possible_moves: Dictionary = piece_at_grid_location.calculate_possible_moves(_board, Vector2(i, j), GRID_WIDTH, GRID_HEIGHT)
				# If either of the possible moves arrays that are returned isn't empty, there is at least one possible
				# chess move, so return true
				if (
					possible_moves["empty_spaces"] != [] or
					possible_moves["enemy_spaces"] != []
				):
					return true

	# If we have gotten here, we know there are no valid chess moves, so return false
	return false

# ------------------------------------------------------------------------------------------------ #
# -- Signal Functions -- #
# ------------------------------------------------------------------------------------------------ #

## Perform functions that need to occur at the start of the game
func _on_state_changed_start_game() -> void:
	_board = _create_empty_2d_array()
	_generate_board_background()
	
	# Get and spawn our starting pieces
	var starting_pieces_to_spawn: Array = PieceSpawnManager.get_starting_pieces()
	_spawn_pieces_at_random_locations(starting_pieces_to_spawn)

	# TODO: Not sure if this is how we should be doing this. But we need to let things know when the
	# 		game has finished being set up. Really, it's that the board is being set up. Maybe this
	# 		is something that should be done better, but not too worried about it right now.
	SignalBus.emit_signal("game_initialized")

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
	# TODO: this is a very basic way to spawn between 1 and 3 pieces each slide move,
	# 		we probably want to make this a little more dynamic at some point
	var num_pieces_to_spawn: int = randi() % 3 + 1
	var piece_to_spawn: Array = PieceSpawnManager.get_new_pieces(num_pieces_to_spawn)
	_spawn_pieces_at_random_locations(piece_to_spawn)

# ------------------------------------------------------------------------------------------------ #

func _on_player_piece_clicked(piece_pixel_location: Vector2, piece_name: String) -> void:
	_set_last_clicked_piece(piece_pixel_location)	
	_remove_move_overlays()
	
	# Spawn the move overlays based on the location of the piece we clicked
	var piece_grid_location: Vector2 = _pixel_to_grid(piece_pixel_location)
	var piece_at_grid_location: Node = _board[piece_grid_location.x][piece_grid_location.y]
	if piece_at_grid_location.has_method("calculate_possible_moves"):
		var possible_moves: Dictionary = piece_at_grid_location.calculate_possible_moves(_board, piece_grid_location, GRID_WIDTH, GRID_HEIGHT)
		_spawn_move_overlays(possible_moves)
	else:
		printerr(piece_at_grid_location.piece_name, " does not have method 'calculate_possible_moves'!")

# ------------------------------------------------------------------------------------------------ #

func _on_empty_move_overlay_clicked(overlay_pixel_location: Vector2) -> void:
	_remove_move_overlays()
	_chess_move_piece_to_empty_square(overlay_pixel_location)

# ------------------------------------------------------------------------------------------------ #

func _on_enemy_move_overlay_clicked(overlay_pixel_location: Vector2) -> void:
	_remove_move_overlays()
	_chess_move_piece_to_enemy_square(overlay_pixel_location)

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #


