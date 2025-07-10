extends Sprite2D

const BOARD_SIZE = 8

const BLACK_PIECES = preload("res://Chess Asset/pixel chess_v1.2/16x16 pieces/BlackPieces.png")

const WHITE_PIECES = preload("res://Chess Asset/pixel chess_v1.2/16x16 pieces/WhitePieces.png")

@onready var pieces: Node2D = $Pieces
@onready var dot: Node2D = $Dot
@onready var turn: Sprite2D = $Turn

#Variable
var board : Array
	
func _ready():
	pass
	
func _process(delta):
	pass
