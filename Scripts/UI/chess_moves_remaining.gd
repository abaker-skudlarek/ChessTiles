extends VBoxContainer

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _enter_tree() -> void:
	SignalBus.connect("chess_moves_remaining_updated", _on_chess_moves_remaining_updated)

# ------------------------------------------------------------------------------------------------ #

func _on_chess_moves_remaining_updated(num_moves: int) -> void:
	$NumRemaining.text = str(num_moves) 

# ------------------------------------------------------------------------------------------------ #
