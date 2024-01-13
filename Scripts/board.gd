extends Node

# -- Constants -- #
const BOARD_WIDTH:  int = 5  # Number of Squares that make up the width of the board
const BOARD_HEIGHT: int = 5  # Number of Squares that make up the height of the board

# -- Exported Variables -- #
@export var light_square_scene: PackedScene
@export var dark_square_scene: PackedScene
@export var piece_scene: PackedScene

# -- Variables -- #
# TODO: Should this be a 2d array?
var _squares: Array = []  # Array of squares that make up the board

var screen_size: Vector2

# -- Private Functions -- #

## Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = DisplayServer.window_get_size()

	create_board()
	
	spawn_piece()

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Calculates the offsets that are used when placing the board squares in the world
## Returns: 
## 	Array: [X axis offset, Y axis offset]
func _calculate_offsets() -> Array:
	var temp_square: Sprite2D = light_square_scene.instantiate()
	var square_texture_size: Vector2 = Vector2(temp_square.texture.get_width() * temp_square.scale.x,
											   temp_square.texture.get_height() * temp_square.scale.y)
	
	var x_axis_offset = (screen_size.x - (square_texture_size.x * BOARD_WIDTH)) / 2
	var y_axis_offset = (screen_size.y - (square_texture_size.y * BOARD_HEIGHT)) / 2
	
	return [x_axis_offset, y_axis_offset]

# -- Public Functions -- #

## Creates the board out of light and dark square scenes
func create_board():
	
	# Calculate the offsets that will be used to determine where to start placing squares on X and Y axis
	var offsets: Array = _calculate_offsets()
	var width_offset = offsets[0]
	var height_offset = offsets[1]
	
	# Get the texture size of the square
	var temp_square: Sprite2D = light_square_scene.instantiate()
	var square_texture_size: Vector2 = temp_square.get_texture_size()
				
	# Instantiate and spawn the squares
	for i in range(0, BOARD_HEIGHT):
		
		# Reset the offsets after spawning an entire line of squares
		height_offset += square_texture_size.y / 2 if i == 0 else square_texture_size.y
		width_offset = offsets[0]
		
		for j in range(0, BOARD_WIDTH):
			
			# Alternate square color
			var spawned_square: Sprite2D
			if (i + j) % 2 == 0:
				spawned_square = light_square_scene.instantiate()
			else:
				spawned_square = dark_square_scene.instantiate()
				
			# Add the spawned square to our array of spawned squares
			_squares.append(spawned_square)
			
			# Update the width offset before changing the position of the square
			width_offset += square_texture_size.x / 2 if j == 0 else square_texture_size.x
			
			# Update the position of the square using the updated width and height offsets
			spawned_square.position = Vector2(width_offset, height_offset)
			
			# Finally, add the square to the scene
			add_child(spawned_square) 

# TODO: Probably shouldn't do this in the Board script. Maybe in a game manager script?
func spawn_piece():
	print("Instantiate")
	var spawned_piece = piece_scene.instantiate()
	print("Instantiated")
	
	spawned_piece.position = Vector2(360, 540)
	
	print("Add child")	
	add_child(spawned_piece)
	spawned_piece.update_texture("knight")
	print("added child")	
	
	
	
