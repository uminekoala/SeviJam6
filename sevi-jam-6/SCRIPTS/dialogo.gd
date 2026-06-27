class_name Dialogue
extends Control
 
@onready var voice_player := get_node("AudioStreamPlayer") as AudioStreamPlayer
@onready var content := get_node("texto") as RichTextLabel
@onready var type_timer := get_node("TypeTyper") as Timer

var irse = false

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout

# Start typing the provided message
func update_message(message: String) -> void:
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.play()
	content.text = message
	content.visible_characters = 0
	type_timer.start()
	while content.visible_characters < content.text.length():
		if irse:
			content.visible_characters = -1
			break
		else:
			content.visible_characters += 1
			voice_player.pitch_scale = randf_range(0.95, 1.08) #para darle más jugo
			await get_tree().create_timer(0.03).timeout
	$AudioStreamPlayer.stop()
	irse = false

func _enter_tree() -> void:
	pass
