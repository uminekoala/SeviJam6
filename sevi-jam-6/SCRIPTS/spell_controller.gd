extends Node

signal letter_pressed(letter)
signal letter_released(letter)

var is_gameplay = true #debug

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event):
	if is_gameplay:
		if event is InputEventKey and event.is_pressed():
			letter_pressed.emit(event.as_text_key_label())
		elif event is InputEventKey and event.is_released():
			letter_released.emit(event.as_text_key_label())
