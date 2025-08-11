extends Sprite2D

const BOARD_SIZE = 8
const CELL_WIDTH = 16

const TEXTURE_HOLDER = preload("res://Scene/texture_holder.tscn")

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

const BLACK_TURN_DOT = preload("res://Chess Asset/pixel chess_v1.2/32x32 pieces/Black-Turn-Dot.png")
const WHITE_TURN_DOT = preload("res://Chess Asset/pixel chess_v1.2/32x32 pieces/White-Turn-Dot.png")

const PIECE_MOVE = preload("res://Chess Asset/pixel chess_v1.2/32x32 pieces/Piece_Move.png")

@onready var pieces: Node2D = $Pieces
@onready var dots: Node2D = $Dot
@onready var turn: Sprite2D = $Turn

#Variable
# -6 = black king
# -5 = black queen
# -4 = black rook
# -3 = black bishop
# -2 = black knight
# -1 = black pawn
# 0 = empty
# 6 = white king
# 5 = white queen
# 4 = white rook
# 3 = white bishop
# 2 = white knight
# 1 = white pawn

var board : Array
var white : bool = true
var state : bool = false
var moves = []
var selected_piece : Vector2

func _ready():
	board.append([4, 2, 3, 5, 6, 3, 2, 4])
	board.append([0, 0, 0, 0, 0, 0, 0, 0])
	board.append([0, 0, 0, 0, 0, 0, 0, 0])
	board.append([0, 0, 0, 0, 0, 0, 0, 0])
	board.append([0, 0, 0, 0, 0, 0, 0, 0])
	board.append([0, 0, 0, 0, 0, 0, 0, 0])
	board.append([-1, -1, -1, -1, -1, -1, -1, -1])
	board.append([-4, -2, -3, -6, -5, -3, -2, -4])
	
	display_board()
	
func _input(event):
	if event is InputEventMouseButton && event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_mouse_out(): return
			var var1 = (snapped(get_global_mouse_position().x+8, 0) / 16) - 1
			var var2 = (abs(snapped(get_global_mouse_position().y-8, 0)) / 16) - 1
			if !state && (white && board[var2][var1] > 0 || white && board[var2][var1] < 0):
				selected_piece = Vector2(var2,var1)
				show_options()
				state = true
			elif state: 
				set_move(var2, var1)
			

func is_mouse_out():
	if get_global_mouse_position().x < 8 || get_global_mouse_position().x > 135 || get_global_mouse_position().y > 8 || get_global_mouse_position().y < -134:
		return true
	return false

func display_board():
	for child in pieces.get_children():
		child.queue_free()

	for i in BOARD_SIZE: #
		for j in BOARD_SIZE: #
			var holder = TEXTURE_HOLDER.instantiate()
			pieces.add_child(holder)
			holder.global_position = Vector2(j * CELL_WIDTH + (CELL_WIDTH / 2)+8, -i * CELL_WIDTH - (CELL_WIDTH / 2)-16)
			holder.z_index = 100 - i # higher z_index draws above
			
			match board[i][j]:
				-6: holder.texture = B_KING
				-5: holder.texture = B_QUEEN
				-4: holder.texture = B_ROOK
				-3: holder.texture = B_BISHOP
				-2: holder.texture = B_KNIGHT
				-1: holder.texture = B_PAWN
				0: holder.texture = null
				6: holder.texture = W_KING
				5: holder.texture = W_QUEEN
				4: holder.texture = W_ROOK
				3: holder.texture = W_BISHOP
				2: holder.texture = W_KNIGHT
				1: holder.texture = W_PAWN

func show_options():
	moves = get_moves()
	if moves == []:
		state = false
		return
	show_dots()

func set_move(var2, var1):
	for i in moves:
		if i.x == var2 && i.y == var1:
			board[var2][var1] = board[board[selected_piece.x][selected_piece.y]]
			board[selected_piece.x][selected_piece.y] = 0
			white = !white
			display_board()
			break
	delete_dots()
	state = false

func delete_dots():
	for child in dots.get_children():
		child.queue_free()

func show_dots():
	for i in moves:
		var holder = TEXTURE_HOLDER.instantiate()
		dots.add_child(holder)
		holder.texture = PIECE_MOVE
		holder.global_position = Vector2(i.y * CELL_WIDTH + (CELL_WIDTH / 2) + 8, -i.x * CELL_WIDTH - (CELL_WIDTH / 2) - 16)

func get_moves():
	var _moves = []
	match abs(board[selected_piece.x][selected_piece.y]):
		1: print("pawn")
		2: print("knight")
		3: print("bishop")
		4: _moves = get_rook_moves()
		5: print("queen")
		6: print("king")	
	return _moves

func is_valid_position(pos : Vector2):
	if pos.x >= 0 && pos.x < BOARD_SIZE && pos.y >= 0 && pos.y < BOARD_SIZE:
		return true
	return false

func is_empty(pos : Vector2):
	if board[pos.x][pos.y] == 0:
		return state
	return false
 
func is_enemy(pos : Vector2):
	if white && board[pos.x][pos.y] < 0 || !white && board[pos.x][pos.y] > 0:
		return true
	return false

func get_rook_moves():
	var _moves = []
	var directions = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
	
	for i in directions:
		var pos = selected_piece
		pos += i
		while is_valid_position(pos):
			if is_empty(pos):
				_moves.append(pos)
			elif is_enemy(pos):
				_moves.append(pos)
				break
			else:
				break
			pos += i
			
	return _moves

func get_bishop_moves():
	pass
func get_knight_moves():
	pass
func get_king_moves():
	pass
func get_queen_moves():
	pass
func get_pawn_moves():
	pass
