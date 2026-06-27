extends Control

var dict_words_0 = { "TIC":Color.RED, "ZAS":Color.BLUE, "TCH":Color.GHOST_WHITE, "DON":Color.SPRING_GREEN}
var dict_words_1 = { "NAR":Color.GREEN, "ANJ":Color.VIOLET, "ITA":Color.PINK, "JAM":Color.RED}
var array_portal_colors = [Color.PURPLE, Color.YELLOW, Color.TEAL]
var current_portal_color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("paint_orb", on_paint_orb)
	Global.connect("play_state", on_play_state)
	on_play_state(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func on_paint_orb(rgb: Color)-> void:
	$OrbColor.color = rgb


func on_play_state(state: int):
	current_portal_color = array_portal_colors[state]
	match (state):
		0:
			prepare_words(dict_words_0)
			# A mano lo de cual es la correcta. Muy perro esto. 
			# Lo siento, Fundamento de Programación I
			$HBoxContainer/MarginContainer/PanelWord/MarginContainer/Words.this_is_the_one_officer = true
			$HBoxContainer/MarginContainer2/PanelWord/MarginContainer/Words.this_is_the_one_officer = true
		1:
			prepare_words(dict_words_1)
			$HBoxContainer/MarginContainer/PanelWord/MarginContainer/Words.this_is_the_one_officer = true
			$HBoxContainer/MarginContainer5/PanelWord/MarginContainer/Words.this_is_the_one_officer = true
		# ... 
	Global.prepare_new_state_on_word.emit()


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
