class_name SquareBase 
extends Area2D

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

var sprite_texture: CompressedTexture2D
var overlay_shown: bool = false
var occupying_piece: Node = null

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _init() -> void:
	$SquareSprite.texture = sprite_texture
	$MoveOverlaySprite.visible = overlay_shown
	
