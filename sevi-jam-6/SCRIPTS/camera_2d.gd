extends Camera2D

@export var decay : float = -0.02
@export var max_offset : Vector2 = Vector2(100,75)
@export var max_roll: float = 0.1

var trauma : float = 0.0
var trauma_power : int = 2

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	add_trauma(0.1)
	get_node("../PortalBordes/AnimationPlayer").play("zoom")
	get_node("../Nebulosa/AnimationPlayer").play("zoom2")
	get_node("../fundido/AnimationPlayer").play("opacidad")
	await get_tree().create_timer(10).timeout
	trauma = 0
	get_tree().change_scene_to_file("res://SCENES/quote2.tscn")
	

func _process(delta: float) -> void:
	if trauma:
		trauma = min(trauma - decay * delta,0.4)
		shake()

func add_trauma(amount : float) ->void:
		trauma = min(trauma + amount,1.0)

func shake() -> void:
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1,1)
	offset.x = max_offset.x * amount * randf_range(-1,1)
	offset.y = max_offset.y * amount * randf_range(-1,1)
