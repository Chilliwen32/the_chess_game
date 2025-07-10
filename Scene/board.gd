extends Sprite2D

const BOARD_SIZE = 8

#White Piece
const W_BISHOP = preload("res://Chess Asset/pixel chess_v1.2/16x32 pieces/W_Bishop.png")
const W_KING = preload("res://Chess Asset/pixel chess_v1.2/16x32 pieces/W_King.png")
const W_KNIGHT = preload("res://Chess Asset/pixel chess_v1.2/16x32 pieces/W_Knight.png")
const W_PAWN = preload("res://Chess Asset/pixel chess_v1.2/16x32 pieces/W_Pawn.png")
const W_QUEEN = preload("res://Chess Asset/pixel chess_v1.2/16x32 pieces/W_Queen.png")
const W_ROOK = preload("res://Chess Asset/pixel chess_v1.2/16x32 pieces/W_Rook.png")

#Black Piece
const B_BISHOP = preload("res://Chess Asset/pixel chess_v1.2/16x32 pieces/B_Bishop.png")
const B_KING = preload("res://Chess Asset/pixel chess_v1.2/16x32 pieces/B_King.png")
const B_KNIGHT = preload("res://Chess Asset/pixel chess_v1.2/16x32 pieces/B_Knight.png")
const B_PAWN = preload("res://Chess Asset/pixel chess_v1.2/16x32 pieces/B_Pawn.png")
const B_QUEEN = preload("res://Chess Asset/pixel chess_v1.2/16x32 pieces/B_Queen.png")
const B_ROOK = preload("res://Chess Asset/pixel chess_v1.2/16x32 pieces/B_Rook.png")

@onready var pieces: Node2D = $Pieces
@onready var dot: Node2D = $Dot
@onready var turn: Sprite2D = $Turn

#Variable
var board : Array
	
func _ready():
	pass
	
func _process(delta):
	pass
