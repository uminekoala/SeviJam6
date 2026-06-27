extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/main.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/creditos.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()
