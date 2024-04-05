extends GridContainer

@onready var winning_label: Label = %WinningLabel

var reset_button
var player_1 = load("res://assets/white-heavy-check-mark.svg")
var player_2 = load("res://assets/x-letter.svg")
var player_1_turn := true
var cell_filled := false
var board_state := [ 
[null, null, null],
[null, null, null],
[null, null, null],
]

func _ready() -> void:
	reset_button = get_tree().get_first_node_in_group("reset")
	var children = get_children()
	for child in children:
		if child is TextureButton:
			var callable = Callable(self, "_on_button_pressed")
			child.pressed.connect(callable.bind(child))

func _on_button_pressed(child: TextureButton) -> void:
	var cell_index = int(str(child.name)) - 1
	var row = cell_index / 3
	var column = cell_index % 3
	if board_state[row][column] == null:
		board_state[row][column] = 1 if player_1_turn else 2
		var current_texture = player_1 if player_1_turn else player_2
		child.texture_normal = current_texture
		child.texture_pressed = current_texture
		child.texture_hover = current_texture
		
		if check_win(board_state[row][column]):
			game_over()
			var player = "Player 1" if player_1_turn else "Player 2"
			winning_label.text = player + " wins!"
			winning_label.show()
		elif is_draw():  # Check for draw only if no win
			game_over()
			winning_label.text = "It's a draw!"
			winning_label.show()
		
		player_1_turn = not player_1_turn  # Switch turns
		child.disabled = true  # Disable the button to prevent further clicks

#fix draw
func is_draw() -> bool:
	for row in board_state:
		for cell in row:
			if cell == null:
				return false
	game_over()
	winning_label.text = "Draw!"
	winning_label.show()
	return true

func check_win(player_number) -> bool:
		for i in range(3):
			if board_state[i][0] == player_number and board_state[i][1] == player_number and board_state[i][2] == player_number:
				return true
		# Check columns
		for i in range(3):
			if board_state[0][i] == player_number and board_state[1][i] == player_number and board_state[2][i] == player_number:
				return true
		# Check diagonals
		if board_state[0][0] == player_number and board_state[1][1] == player_number and board_state[2][2] == player_number:
			return true
		if board_state[0][2] == player_number and board_state[1][1] == player_number and board_state[2][0] == player_number:
			return true
		return false

func game_over() -> void:
	#hide()
	reset_button.show()

func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()
