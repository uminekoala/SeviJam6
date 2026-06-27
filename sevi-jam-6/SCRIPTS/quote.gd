extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel/AnimationPlayer.play("scroll_quote")
	$ColorRect/AnimationPlayer.play("reveal")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
