extends Node

# funcion global para todas las señales y variables a usar. 
# maquina de estado too

var current_state = 0
var dict_of_letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L']
var rgb_array = []
var rgb_total = Color()
var array_id = []
var dict_id_correct = {}
var is_gameplay = true #debug
var orb_array_colors = [Color(Color.hex(0x00001a),1), Color(Color.hex(0x000000),1), Color(Color.hex(0x000000),1)]
var can_unpaint_orb = false 
var can_pass_dialogue = false
var can_touch_orb = false

var array_dialogue_states = [["Soy el dialogo del primer state. Está guapo eh?","Pero un momento, pero si es Zaakori!","QUÉ ES LO QUE TENGO QUE HACER?"], ["No te creo, lo hsa hecho, esto es el dialogo del state 2"]]
var array_dialogue_fail = ["AY LMAO", "UPS.", "AAAAAAAAA", "COMO"]
var array_dialogue_tutorial = []

var current_line_dialogue = 0

signal word_solved(rgb_value, id, is_correct)
signal word_unsolved(rgb_value,id)
signal paint_orb(rgb_value)
signal unpaint_orb(rgb_value)
signal revert_all_words(array_id)
signal play_word_correct_animation(array_id)
signal play_state(state)
signal prepare_new_state_on_word()
signal state_dialogue(state)
signal next_state_feedback()
signal mouse_feedback()
signal stop_mouse_feedback()
signal hum_increase(tone)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("word_solved", on_word_solved)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_word_solved(color: Color, id: int, is_correct: bool) -> void:
	if (array_id.has(id)):
		pass
	else:
		array_id.append(id)
		rgb_array.append(color)
		dict_id_correct[id] = is_correct
		paint_orb.emit(calculateColor())
		print(array_id.size())
		if (array_id.size() == 2):
			next_state()

func on_word_unsolved(color: Color, id: int) -> void:
	if (array_id.has(id)):
		array_id.erase(id)
		rgb_array.erase(color)
		dict_id_correct.erase(id)
		paint_orb.emit(calculateColor())

func calculateColor() -> Color:
	if rgb_array.size() == 2:
		# Se han rellenado las dos palabras.
		rgb_total = rgb_array[0] + rgb_array[1]
		return rgb_total
	elif rgb_array.size() == 1:
		return rgb_array[0]
	else:
		return Color.BLACK

func next_state() -> void:
	var god_true_veredict = true
	for id in dict_id_correct:
		if !dict_id_correct[id]:
			god_true_veredict = false
	
	if !god_true_veredict:
		can_unpaint_orb = true
		
		revert_all_words.emit(array_id)
		array_id = []
		rgb_array = []
		dict_id_correct = {}	
	else:
		play_word_correct_animation.emit(array_id)
		array_id = []
		rgb_array = []
		dict_id_correct = {}	
		print("next state!")
		current_state += 1
		state_dialogue.emit(current_state)
		next_state_feedback.emit()
		#play_state.emit(current_state)
	
