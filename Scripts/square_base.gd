extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Calculates and returns a Vector2 containing the X and Y texture size of the square. Accounts 
## for scale
## Returns:
##  texture_size (Vector2): X value is the size in pixels of the width of the texture
##							Y value is the size in pixels of the height of the texture
func get_texture_size() -> Vector2:
	var texture_size: Vector2 = Vector2(texture.get_width() * scale.x,
										texture.get_height() * scale.y)
											
	return texture_size
