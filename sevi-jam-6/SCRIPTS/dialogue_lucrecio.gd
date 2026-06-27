class_name DialogueLucrecio
extends Control

@onready var text_to_use = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") && Global.can_pass_dialogue:
		if ($dialogue/texto.visible_ratio != 1):
			$dialogue.irse = true
		else:
			Global.current_line_dialogue += 1
			if (Global.current_line_dialogue >= Global.array_dialogue_states[Global.current_state].size()):
				Global.play_state.emit(Global.current_state)
				visible = false
				Global.can_pass_dialogue = false
				Global.can_touch_orb = true
				$dialogue/AudioStreamPlayer.stop()
			else:
				update_text(Global.array_dialogue_states[Global.current_state][Global.current_line_dialogue])



func _enter_tree() -> void:
	pass


func update_text(text: String) -> void:
	$dialogue.update_message(text)
