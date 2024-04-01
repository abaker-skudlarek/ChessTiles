extends PanelContainer

# Defines the amount of charge the listed entry gives to the charge bar. This number is in
# percentages, so 30 = 30% added to charge
var _charge_rates: Dictionary = {
	"enemy_pawn": 20,
	"enemy_bishop": 35,
	"enemy_knight": 35,
	"enemy_rook": 50,
	"enemy_queen": 75,
	"enemy_king": 100,
	"merge": 10
}

var _charge: int = 0  # The amount of charge the player currently has

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _enter_tree() -> void:
	SignalBus.connect("chess_moves_remaining_updated", _on_chess_moves_remaining_updated)
	SignalBus.connect("piece_taken", _on_piece_taken)
	SignalBus.connect("pieces_merged", _on_pieces_merged)

# ------------------------------------------------------------------------------------------------ #

func _update_charge(charge_addition: int) -> void:
	var overfill: bool = false
	var new_charge: int = _charge + charge_addition
	# If we're gaining enough charge to go over 100%, emit a signal that we gained a chess move
	if new_charge >= 100:
		new_charge = new_charge - 100
		overfill = true
		SignalBus.emit_signal("chess_move_gained", 1)

	_charge = new_charge

	_animate_fill_charge_bar(overfill)

# ------------------------------------------------------------------------------------------------ #

func _animate_fill_charge_bar(overfill: bool) -> void: 
	# TODO: this needs some work, not as smooth as I'd like it to be

	var charge_bar: Node = $VBoxContainer/ChargeBar

	if overfill:
		# TODO: I'm not sure if there is a better way to do this than with two tweens. Only using
		# 		one with the await did not work
		var tween: Tween = create_tween()
		tween.tween_property(charge_bar, "value", 100, 0.5).set_trans(Tween.TRANS_SINE)
		await tween.finished

		charge_bar.value = 0

		var tween2: Tween = create_tween()
		tween2.tween_property(charge_bar, "value", _charge, 0.5).set_trans(Tween.TRANS_SINE)
	else:	
		var tween: Tween = create_tween()
		tween.tween_property(charge_bar, "value", _charge, 0.5).set_trans(Tween.TRANS_SINE)


# ------------------------------------------------------------------------------------------------ #

func _on_chess_moves_remaining_updated(num_moves: int) -> void:
	$VBoxContainer/ChessMovesRemainingLabel.text = str(num_moves) 

# ------------------------------------------------------------------------------------------------ #

func _on_piece_taken(taken_piece_name: String) -> void:
	_update_charge(_charge_rates[taken_piece_name])

# ------------------------------------------------------------------------------------------------ #

func _on_pieces_merged() -> void:
	_update_charge(_charge_rates["merge"])

# ------------------------------------------------------------------------------------------------ #
