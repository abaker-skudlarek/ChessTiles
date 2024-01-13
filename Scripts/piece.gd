extends Sprite2D

var player_pieces_sprites: Dictionary = {
	"pawn": "res://Sprites/Player/w_pawn.png",
	"bishop": "res://Sprites/Player/w_bishop.png",
	"knight": "res://Sprites/Player/w_knight.png",
	"rook": "res://Sprites/Player/w_rook.png", 
	"queen": "res://Sprites/Player/w_queen.png",
	"king": "res://Sprites/Player/w_king.png"
}

var enemy_pieces_sprites: Dictionary = {
	"pawn": "res://Sprites/Enemy/b_pawn.png",
	"bishop": "res://sprites/Enemy/b_bishop.png",
	"knight": "res://sprites/Enemy/b_knight.png",
	"rook": "res://sprites/Enemy/b_rook.png", 
	"queen": "res://sprites/Enemy/b_queen.png",
	"king": "res://sprites/Enemy/b_king.png"
}

func _ready():
	print("Piece _ready()")
	_load_texture()
	
func _load_texture():
	print("Piece _load_texture()")
	texture = load(player_pieces_sprites["pawn"])
	print("loaded texture") 

func update_texture(piece_type:String):
	print("Piece update_texture(" + piece_type + ")")
	texture = load(player_pieces_sprites[piece_type])
