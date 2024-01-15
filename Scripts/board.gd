extends Node

# -- Variables -- #

const LIGHT_SQUARE_PATH: CompressedTexture2D = preload("res://Sprites/Squares/square_brown_dark.png")
const DARK_SQUARE_PATH: CompressedTexture2D = preload("res://Sprites/Squares/square_brown_light.png")
const GRID_X_START_POSITION: int = 104
const GRID_Y_START_POSITION: int = 384
const GRID_OFFSET: int = 128
const GRID_WIDTH: int = 5
const GRID_HEIGHT: int = 5

var _board: Array  # Two dimensional array that defines the board

# -- Private Functions -- #

# NOTE: I'm using this function to connect to signals. The reasoning is that I found when using 
# 		_ready() for connecting, the ordering of the nodes in the scene tree mattered. If Board wasn't
#		in the top of the scene tree, GameManager would emit the signal before Board could connect 
#  		to it. I don't know if using _enter_tree to connect to signals is a good idea or not.  		
func _enter_tree():
	$"../GameManager".state_changed_start_game.connect(_on_state_changed_start_game)
		
# ------------------------------------------------------------------------------------------------ #

## When the corresponding signal is emitted, perform functions that need to occur at the start of the game
func _on_state_changed_start_game() -> void:
	_board = _create_empty_2d_array()
	_generate_board_background()
	# TODO: spawn the first two pieces onto the board

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
	
# -- Public Functions -- #
