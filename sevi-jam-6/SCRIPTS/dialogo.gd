class_name Dialogue
extends Control
 
@onready var voice_player := get_node("AudioStreamPlayer") as AudioStreamPlayer
@onready var content := get_node("texto") as RichTextLabel
@onready var type_timer := get_node("TypeTyper") as Timer

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout

# Start typing the provided message
func update_message(message: String) -> void:
	$AudioStreamPlayer.stop()
	content.text = message
	content.visible_characters = 0
	type_timer.start()
	while content.visible_characters < content.text.length():
		content.visible_characters += 1
		voice_player.pitch_scale = randf_range(0.95, 1.08) #para darle más jugo
		$AudioStreamPlayer.play()
		await get_tree().create_timer(0.1).timeout
	$AudioStreamPlayer.stop()

func _enter_tree() -> void:
	pass
