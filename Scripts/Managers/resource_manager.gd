extends Node

##
## Holds resources that need to be preloaded and accessed by other Scenes.
##

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

@onready var move_square_overlay := preload("res://Sprites/Squares/move_square_overlay.png")

@onready var square_backgrounds: Dictionary = {
	"light": preload("res://Sprites/Squares/square_brown_light.png"),
	"dark": preload("res://Sprites/Squares/square_brown_dark.png")
}

@onready var player_pieces: Dictionary = {
	"pawn": preload("res://Scenes/Pieces/Player/player_pawn.tscn"),
	"bishop": preload("res://Scenes/Pieces/Player/player_bishop.tscn"),
	"knight": preload("res://Scenes/Pieces/Player/player_knight.tscn"),
	"rook": preload("res://Scenes/Pieces/Player/player_rook.tscn"),
	"queen": preload("res://Scenes/Pieces/Player/player_queen.tscn"),
	"king": preload("res://Scenes/Pieces/Player/player_king.tscn")
}
@onready var enemy_pieces: Dictionary = {
	"pawn": preload("res://Scenes/Pieces/Enemy/enemy_pawn.tscn"),
	"bishop": preload("res://Scenes/Pieces/Enemy/enemy_bishop.tscn"),
	"knight": preload("res://Scenes/Pieces/Enemy/enemy_knight.tscn"),
	"rook": preload("res://Scenes/Pieces/Enemy/enemy_rook.tscn"),
	"queen": preload("res://Scenes/Pieces/Enemy/enemy_queen.tscn"),
	"king": preload("res://Scenes/Pieces/Enemy/enemy_king.tscn")
}
