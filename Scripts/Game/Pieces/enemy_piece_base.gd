extends Area2D

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

@export var value: int
@export var piece_name: String
@export var next_piece_name: String = ""
@export var piece_family: String = GameManager.ENEMY_FAMILY

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _input_event(_viewport: Viewport, event:InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		SignalBus.emit_signal("enemy_piece_clicked", position, piece_name)	

# ------------------------------------------------------------------------------------------------ #
# -- Public Functions -- #
# ------------------------------------------------------------------------------------------------ #

func score_piece() -> void:
	# TODO: need to wait for the animation to finish, before we return
	$Sprite2D/AnimationPlayer.play("score_piece")
	await $Sprite2D/AnimationPlayer.animation_finished

# ------------------------------------------------------------------------------------------------ #
