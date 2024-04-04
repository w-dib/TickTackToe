extends GridContainer

@onready var winning_label: Label = %WinningLabel

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
	var children = get_children()
	for child in children:
		if child is TextureButton:
			var callable = Callable(self, "_on_button_pressed")
			child.pressed.connect(callable.bind(child))

func _on_button_pressed(child: TextureButton) -> void:
	var cell_index = int(str(child.name)) - 1
	var row = cell_index/3
	var column = cell_index % 3
	if board_state[row][column] == null:
		if player_1_turn:
			child.texture_normal = player_1
			child.texture_pressed = player_1
			child.texture_hover = player_1
			board_state[row][column] = 1
			if check_win(1):  
				winning_label.text = "Player 2 wins!"
				winning_label.show()
			player_1_turn = false

		else:
			child.texture_normal = player_2
			child.texture_pressed = player_2
			child.texture_hover = player_2
			board_state[row][column] = 2
			if check_win(2):  
				winning_label.text = "Player 2 wins!"
				winning_label.show()
			player_1_turn = true
			
		check_win(board_state[row][column])
	
		child.disabled = true
	
func check_win(player_number) -> bool:
	# Check rows
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

