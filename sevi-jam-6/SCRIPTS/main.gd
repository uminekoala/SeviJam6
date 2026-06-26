extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("paint_orb", on_paint_orb)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_paint_orb(rgb: Color)-> void:
	$OrbColor.color = rgb
