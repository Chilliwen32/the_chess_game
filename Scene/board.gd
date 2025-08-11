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

# board values:
# -6 = black king, -5 queen, -4 rook, -3 bishop, -2 knight, -1 pawn
# 0 = empty
# 1 = white pawn, 2 knight, 3 bishop, 4 rook, 5 queen, 6 king

var board: Array = []
var white: bool = true
var state: bool = false
var moves: Array = []
var selected_piece := Vector2(-1, -1)

func _ready():
	board = [
		[4, 2, 3, 5, 6, 3, 2, 4],
		[1, 1, 1, 1, 1, 1, 1, 1],
		[0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0],
		[-1,-1,-1,-1,-1,-1,-1,-1],
		[-4,-2,-3,-6,-5,-3,-2,-4]
	]
	display_board()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse = get_global_mouse_position()
		# bounds check (same as your original idea)
		if mouse.x < 8 or mouse.x > 134 or mouse.y > 8 or mouse.y < -134:
			return

		var var1 = int((mouse.x - 8) / CELL_WIDTH)                  # column (j)
		var var2 = int((-mouse.y - 16) / CELL_WIDTH)                # row (i)
		print_debug("click tile: ", var1, ",", var2, " mouse:", mouse)

		if not state and ((white and board[var2][var1] > 0) or (not white and board[var2][var1] < 0)):
			# set selection first, then compute moves
			selected_piece = Vector2(var2, var1)
			moves = get_moves(var2, var1)
			if moves.size() == 0:
				# no legal moves -> cancel
				state = false
				return
			show_dots()
			state = true
		elif state:
			set_move(var2, var1)

func print_debug(msg, a = "", b = ""):
	# small helper so we can easily turn debug on/off
	print(str(msg) + str(a) + str(b))

func display_board():
	for child in pieces.get_children():
		child.queue_free()

	for i in range(BOARD_SIZE):
		for j in range(BOARD_SIZE):
			var holder = TEXTURE_HOLDER.instantiate()
			pieces.add_child(holder)
			holder.global_position = Vector2(j * CELL_WIDTH + (CELL_WIDTH / 2) + 8,
											 -i * CELL_WIDTH - (CELL_WIDTH / 2) - 16)
			holder.z_index = 100 - i

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

func show_dots():
	delete_dots()
	for mv in moves:
		var holder = Sprite2D.new()
		holder.texture = PIECE_MOVE
		holder.z_index = 1000  # ensure dots rendered above pieces
		dots.add_child(holder)
		holder.global_position = Vector2(mv.y * CELL_WIDTH + (CELL_WIDTH / 2) + 8,
										 -mv.x * CELL_WIDTH - (CELL_WIDTH / 2) - 16)
	print_debug("dots added:", dots.get_child_count())

func delete_dots():
	for child in dots.get_children():
		child.queue_free()

func set_move(var2, var1):
	# var2 = target row, var1 = target column
	for mv in moves:
		if mv.x == var2 and mv.y == var1:
			board[var2][var1] = board[selected_piece.x][selected_piece.y]
			board[selected_piece.x][selected_piece.y] = 0
			white = not white
			display_board()
			delete_dots()
			state = false
			moves.clear()
			selected_piece = Vector2(-1, -1)
			return
	# if we get here, clicked a non-move tile -> cancel selection
	delete_dots()
	state = false
	moves.clear()
	selected_piece = Vector2(-1, -1)

func get_moves(r, c):
	var res: Array = []
	var p = board[r][c]
	if p == 1: # white pawn (moves up the board -> decreasing row index)
		var forward = r - 1
		if forward >= 0:
			if board[forward][c] == 0:
				res.append(Vector2(forward, c))
				# double step from starting row (row==1 for white)
				if r == 1 and board[r - 2][c] == 0:
					res.append(Vector2(r - 2, c))
			# captures
			for dc in [-1, 1]:
				var nc = c + dc
				if nc >= 0 and nc < BOARD_SIZE and board[forward][nc] < 0:
					res.append(Vector2(forward, nc))
	elif p == -1: # black pawn (moves down -> increasing row index)
		var forward_b = r + 1
		if forward_b < BOARD_SIZE:
			if board[forward_b][c] == 0:
				res.append(Vector2(forward_b, c))
				if r == 6 and board[r + 2][c] == 0:
					res.append(Vector2(r + 2, c))
			for dc in [-1, 1]:
				var nc = c + dc
				if nc >= 0 and nc < BOARD_SIZE and board[forward_b][nc] > 0:
					res.append(Vector2(forward_b, nc))
	# For now: other pieces not implemented -> return empty (you can expand similarly)
	return res
