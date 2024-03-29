extends TextureProgressBar

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

func _ready() -> void:
    SignalBus.connect("piece_taken", _on_piece_taken)
    SignalBus.connect("pieces_merged", _on_pieces_merged)

# ------------------------------------------------------------------------------------------------ #

func _update_charge(charge_addition: int) -> void:
    print("charge_addition: ", charge_addition)
    var new_charge: int = _charge + charge_addition
    print("new_charge: ", new_charge)
    # If we're gaining enough charge to go over 100%, emit a signal that we gained a chess move
    if new_charge >= 100:
        new_charge = new_charge - 100
        print("new_charge after subtraction: ", new_charge)
        print("emitting chess move gained signal")
        SignalBus.emit_signal("chess_move_gained")


    print("_charge before update: ", _charge) 
    _charge = new_charge
    print("_charge updated: ", _charge) 
    value = _charge

# ------------------------------------------------------------------------------------------------ #

func _on_piece_taken(taken_piece_name: String) -> void:
    print("piece taken: ", taken_piece_name)
    _update_charge(_charge_rates[taken_piece_name])

# ------------------------------------------------------------------------------------------------ #

func _on_pieces_merged() -> void:
    print("pieces merged")
    _update_charge(_charge_rates["merge"])

# ------------------------------------------------------------------------------------------------ #
