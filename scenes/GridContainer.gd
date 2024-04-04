extends GridContainer

var player_1 = load("res://assets/white-heavy-check-mark.svg")
var player_2 = load("res://assets/x-letter.svg")

var player_1_turn := true

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is TextureButton:
			# Use Callable for Godot 4.2 signal connection, passing 'self' and the method name
			var callable = Callable(self, "_on_button_pressed")
			# Now connect the signal with the extra parameter (child) by including it in the bind array
			child.pressed.connect(callable.bind(child))

func _on_button_pressed(child: TextureButton) -> void:
	# Now 'child' is directly available here as the TextureButton that was pressed
	if player_1_turn:
		child.texture_normal = player_1
		child.texture_pressed = player_1
		child.texture_hover = player_1
		player_1_turn = false
	else:
		child.texture_normal = player_2
		child.texture_pressed = player_2
		child.texture_hover = player_2
		player_1_turn = true
		
