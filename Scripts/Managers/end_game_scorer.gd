extends Node

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

var _total_score: int = 0

var _piece_values: Dictionary = {
	"player_pawn": 1,
	"player_bishop": 3,
	"player_knight": 3,
	"player_rook": 5,
	"player_queen": 9,
	"player_king": 20,
	"enemy_pawn": -1,
	"enemy_bishop": -3,
	"enemy_knight": -3,
	"enemy_rook": -5,
	"enemy_queen": -9,
	"enemy_king": -20
}

# ------------------------------------------------------------------------------------------------ #
# -- Private Functions -- #
# ------------------------------------------------------------------------------------------------ #

func _ready() -> void:
	SignalBus.connect("state_changed_scoring", _on_state_changed_scoring)
	
# ------------------------------------------------------------------------------------------------ #

func _score_game(signal_arguments: Dictionary) -> void:
	print("scoring game")

	var _final_board: Array = signal_arguments.final_board

	print("_final_board in score_game:")
	print(_final_board)
	
	for i in _final_board.size():
		for j: int in _final_board[i].size():
			var piece: Node = _final_board[j][i]
			print("-------------------")
			print("piece_name: ", piece.piece_name)
			print("piece_score: ", _piece_values[piece.piece_name])
			_total_score += _piece_values[piece.piece_name]
			print("_total_score: ", _total_score)

			_tween_scoring_piece(piece)

	print("_total score: ", _total_score)

	SignalBus.emit_signal("end_game_score_calculated", _total_score)

	GameManager.change_state(GameManager.GameState.GAME_OVER)

# ------------------------------------------------------------------------------------------------ #

func _tween_scoring_piece(piece: Node) -> void:
	# TODO: This is probably not the way to do this, but it works. Basically, just setting the Z index super
	# 		high for the piece that we are going to tween, so that it's guaranteed to be in front of the
	# 		other pieces. Again, probably a much better way to do this, but it works.
	var original_z_index: int = piece.z_index
	piece.z_index = 100

	var tween := create_tween()
	tween.tween_property(piece, "position:y", -100, .15).set_trans(Tween.TRANS_CUBIC).as_relative()
	tween.tween_property(piece, "position:y", 100, .15).set_trans(Tween.TRANS_CUBIC).as_relative()
	await tween.finished

	# TODO: Again, probably not the best way to do this. But we want to set the z_index back to it's
	# 		original value
	piece.z_index = original_z_index

# ------------------------------------------------------------------------------------------------ #

func _on_state_changed_scoring(signal_arguments: Dictionary) -> void:
	_score_game(signal_arguments)

# ------------------------------------------------------------------------------------------------ #
