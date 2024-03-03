extends Node

##
## Holds resources that need to be preloaded and accessed by other Scenes.
##

# ------------------------------------------------------------------------------------------------ #
# -- Variables -- #
# ------------------------------------------------------------------------------------------------ #

@onready var move_overlays: Dictionary = {
	"empty": preload("res://Scenes/Board/empty_move_overlay.tscn"),
	"enemy": preload("res://Scenes/Board/enemy_move_overlay.tscn")
}

@onready var square_backgrounds: Dictionary = {
	"light": preload("res://Sprites/Squares/square_brown_light.png"),
	"dark": preload("res://Sprites/Squares/square_brown_dark.png")
}

@onready var pieces: Dictionary = {
	"player_pawn": preload("res://Scenes/Pieces/Player/player_pawn.tscn"),
	"player_bishop": preload("res://Scenes/Pieces/Player/player_bishop.tscn"),
	"player_knight": preload("res://Scenes/Pieces/Player/player_knight.tscn"),
	"player_rook": preload("res://Scenes/Pieces/Player/player_rook.tscn"),
	"player_queen": preload("res://Scenes/Pieces/Player/player_queen.tscn"),
	"player_king": preload("res://Scenes/Pieces/Player/player_king.tscn"),
	"enemy_pawn": preload("res://Scenes/Pieces/Enemy/enemy_pawn.tscn"),
	"enemy_bishop": preload("res://Scenes/Pieces/Enemy/enemy_bishop.tscn"),
	"enemy_knight": preload("res://Scenes/Pieces/Enemy/enemy_knight.tscn"),
	"enemy_rook": preload("res://Scenes/Pieces/Enemy/enemy_rook.tscn"),
	"enemy_queen": preload("res://Scenes/Pieces/Enemy/enemy_queen.tscn"),
	"enemy_king": preload("res://Scenes/Pieces/Enemy/enemy_king.tscn")
}
