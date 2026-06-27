class_name DialogueLucrecio
extends Control

@onready var text_to_use = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") && Global.can_pass_dialogue:
		pass



func _enter_tree() -> void:
	pass


func update_text(text: String) -> void:
	$dialogue.update_message(text)
