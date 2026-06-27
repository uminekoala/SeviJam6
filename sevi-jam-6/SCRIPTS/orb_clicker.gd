extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", on_mouse_entered)
	connect("mouse_exited", on_mouse_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_mouse_entered() -> void:
	Global.can_touch_orb = true


func on_mouse_exited() -> void:
	Global.can_touch_orb = false


func _input(event) -> void:
	if (Global.can_touch_orb):
		if event is InputEventMouseButton and event.pressed:
			Global.is_gameplay = true
			Global.mouse_feedback.emit()
		elif event is InputEventMouseButton and event.is_released:
			Global.is_gameplay = false
			Global.stop_mouse_feedback.emit()
