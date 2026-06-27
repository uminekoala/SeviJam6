extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("paint_orb", on_paint_orb)
	Global.connect("play_state", on_play_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_paint_orb(rgb: Color)-> void:
	$OrbColor.color = rgb

func on_play_state(state: int):
	pass


func state_controller()-> void:
	pass