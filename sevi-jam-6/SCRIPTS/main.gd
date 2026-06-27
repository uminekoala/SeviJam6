extends Control

var dict_words_0 = { "TIC":Color.RED, "ZAS":Color.BLUE, "TCH":Color.GHOST_WHITE, "DON":Color.SPRING_GREEN}
var dict_words_1 = { "NAR":Color.GREEN, "ANJ":Color.VIOLET, "ITA":Color.PINK, "JAM":Color.RED}
var array_portal_colors_0 = [Color(0.1,0.1,0.6,1),Color(0.45,0.1,0.8,1), Color.PURPLE]
var array_portal_colors_1 = [Color(0.4,0.4,1,1),Color(0.9,0.9,0,1), Color.YELLOW]
var current_portal_colors
var array_used_keys = []
var current_tone = 0 as int

@onready var lucrecio_scene := get_node("DialogueLucrecio") as DialogueLucrecio
#array de arrays de modo que el array 1 son los dialogos del primer state que se reproducen en orden.




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("paint_orb", on_paint_orb)
	Global.connect("play_state", on_play_state)
	Global.connect("unpaint_orb", on_unpaint_orb)
	Global.connect("state_dialogue",on_state_dialogue)
	Global.connect("mouse_feedback",on_mouse_feedback)
	Global.connect("stop_mouse_feedback",on_stop_mouse_feedback)
	Global.connect("word_solved", on_word_solved_sound_feedback)
	Global.connect("next_state_feedback", on_next_state_feedback)
	
	init_gameplay()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _unhandled_key_input(event):
	if Global.is_gameplay && Global.can_touch_orb:
		if event is InputEventKey and event.is_pressed():
			if (array_used_keys.has(event.as_text_key_label())):
				pass
			else:
				array_used_keys.append(event.as_text_key_label())
				if (current_tone >= 0 && current_tone < 3):
					current_tone += 1
				check_to_hum_increase(current_tone)
		elif event is InputEventKey and event.is_released():
			if (array_used_keys.has(event.as_text_key_label())):
				array_used_keys.erase(event.as_text_key_label())
				if (current_tone > 0):
					current_tone -= 1
				check_to_hum_increase(current_tone)
	else:
		current_tone = 0
		array_used_keys = []


func init_gameplay():
	on_state_dialogue(0)
	#on_play_state(0)


func check_to_hum_increase(tone: int) -> void:
	print(tone)
	if ($HumSound.playing):
		$HumSound.stop()
	if ($HumSound2.playing):
		$HumSound2.stop()
	if ($HumSound3.playing):
		$HumSound3.stop()
	match (tone):
		0:
			pass
		1:
			$HumSound.play()
		2:
			$HumSound2.play()
		3:
			$HumSound3.play()

			
func on_unpaint_orb(array_colors: Array) -> void:
	$Orb/shader/ColorRect.material.set_shader_parameter('colorC', array_colors[2])
	$Orb/shader/ColorRect.material.set_shader_parameter('colorA',array_colors[0])
	$Orb/shader/ColorRect.material.set_shader_parameter('colorB',array_colors[1])

func on_paint_orb(rgb: Color)-> void:
	$Orb/shader/ColorRect.material.set_shader_parameter('colorC',rgb)
	

func on_paint_portal(array_colors: Array) -> void:
	$ShaderPortal/ColorRect.material.set_shader_parameter('colorA',array_colors[0])
	$ShaderPortal/ColorRect.material.set_shader_parameter('colorB',array_colors[1])
	$ShaderPortal/ColorRect.material.set_shader_parameter('colorC',array_colors[2])


func on_play_state(state: int):
	array_used_keys = []
	current_tone = 0
	match (state):
		0:
			current_portal_colors = array_portal_colors_0
			prepare_words(dict_words_0)
			# A mano lo de cual es la correcta. Muy perro esto. 
			# Lo siento, Fundamento de Programación I
			$HBoxContainer/MarginContainer/PanelWord/MarginContainer/Words.this_is_the_one_officer = true
			$HBoxContainer/MarginContainer2/PanelWord/MarginContainer/Words.this_is_the_one_officer = true
		1:
			current_portal_colors = array_portal_colors_1
			prepare_words(dict_words_1)
			$HBoxContainer/MarginContainer/PanelWord/MarginContainer/Words.this_is_the_one_officer = true
			$HBoxContainer/MarginContainer2/PanelWord/MarginContainer/Words.this_is_the_one_officer = false
			$HBoxContainer/MarginContainer5/PanelWord/MarginContainer/Words.this_is_the_one_officer = true
		# ... 
	Global.prepare_new_state_on_word.emit()
	on_paint_portal(current_portal_colors)


func on_state_dialogue(state: int) -> void:
	Global.can_pass_dialogue = true
	Global.can_touch_orb = false
	instantiate_lucrecio_dialogue(state)

func on_failed_dialogue() -> void:
	Global.can_pass_dialogue = true
	Global.can_touch_orb = false
	instantiate_failed_dialogue()


func instantiate_failed_dialogue() -> void:
	pass

func instantiate_lucrecio_dialogue(state: int) -> void:
	lucrecio_scene.visible = true
	lucrecio_scene.update_text(Global.array_dialogue_states[state][0])
	

func on_mouse_feedback() -> void:
	$MouseSound.stop()
	$MouseSound.play()

func on_stop_mouse_feedback() -> void:
	if ($HumSound.playing):
		$HumSound.stop()
	if ($HumSound2.playing):
		$HumSound2.stop()
	if ($HumSound3.playing):
		$HumSound3.stop()

func on_word_solved_sound_feedback(rgb: Color, id: int, is_correct: bool) -> void:
	pass
	#$HumSound2.stop()
	#$HumSound.stop()
	#$HumSound3.play()
	
func on_next_state_feedback() -> void:
	if ($HumSound.playing):
		$HumSound.stop()
	if ($HumSound2.playing):
		$HumSound2.stop()
	if ($HumSound3.playing):
		$HumSound3.stop()
	$YaySound.stop()
	$YaySound.play()

func prepare_words(dict_words: Dictionary) -> void:
	var i = 0
	for word in dict_words:
		match (i):
			0:
				$HBoxContainer/MarginContainer/PanelWord/MarginContainer/Words.text = word
				$HBoxContainer/MarginContainer/PanelWord/MarginContainer/Words.rgb_value = dict_words[word]
			1:
				$HBoxContainer/MarginContainer2/PanelWord/MarginContainer/Words.text = word
				$HBoxContainer/MarginContainer2/PanelWord/MarginContainer/Words.rgb_value = dict_words[word]
			2:
				$HBoxContainer/MarginContainer4/PanelWord/MarginContainer/Words.text = word
				$HBoxContainer/MarginContainer4/PanelWord/MarginContainer/Words.rgb_value = dict_words[word]
			3:
				$HBoxContainer/MarginContainer5/PanelWord/MarginContainer/Words.text = word
				$HBoxContainer/MarginContainer5/PanelWord/MarginContainer/Words.rgb_value = dict_words[word]
		i += 1
