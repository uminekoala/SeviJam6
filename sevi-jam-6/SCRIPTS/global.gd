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

#var array_dialogue_states = [["Esto es inaudito... completamente inconcebible.","Tengo que salir de aquí. No, [shake]debo[/shake] salir de aquí.","Primero tengo que concentrarme en el [color=violet]orbe[/color]. Será mi guía.","He de [color=violet]presionarlo[/color] con todas mis fuerzas.","Si pierdo la concentración, no podré lanzar hechizos...","Será mejor que no suelte el orbe, en la medida de lo posible.","Y luego, hay que buscar las palabras adecuadas.","Con la mano izquierda tengo que conjurar la palabra al completo.","Si combino la [color=violet]esencia[/color] de dos palabras, de forma que se parezca a la del portal...","Llegaré a casa.","¿Y para qué?"], ["No te creo, lo hsa hecho, esto es el dialogo del state 2", "Hola"],["Llegamos al tercero"],["four baby"],["ACEPTA TU DESTINO"],["oleeeeeee"]]
var array_dialogue_states = [["Esto es inaudito... completamente inconcebible.","Tengo que salir de aquí. No, [shake]debo[/shake] salir de aquí.","Primero tengo que concentrarme en el [color=violet]orbe[/color]. Será mi guía.","He de [color=violet]presionarlo[/color] con todas mis fuerzas.","Si pierdo la concentración, no podré lanzar hechizos...","Será mejor que no suelte el orbe, en la medida de lo posible.","Y luego, hay que buscar las palabras adecuadas.","Con la mano izquierda tengo que conjurar la palabra [color=violet]al completo[/color].","Si combino la [color=violet]esencia[/color] de dos palabras, de forma que se parezca a la del portal...","Llegaré a casa.","¿Y para qué?","¿Qué sentido tiene regresar?"], ["No es justo.","¿Por qué tengo que marcharme?","No he hecho nada para merecer esto.","Y aún así no hay perdón para los que anhelan.","¿Tan grave es el pecado es amar?","¿Tanto duele el amor?"], ["Si tan solo pudiera volver a escuchar su voz.","Caminar a su vera, sentir su abrazo una vez más.","Si tan solo pudiera decirle adiós.","Así podría olvidar.","¿...olvidar?"], ["Vine a buscarte y me voy sin ti.","Y tu recuerdo son todo cicatrices.","Duele y siento que nunca va a dejar de doler. ¿Cómo quieren que siga sin ti?","¿Sin tu luz para guiarme?"], ["Ya veo el camino de vuelta. Un poco más...","Supongo que te haría feliz verme hacer todo esto. La magia siempre te ha encantado.","La misma que me ha traído hasta aquí para buscarte, ahora me hace regresar.","La muerte no admite discusiones, ¿eh? Es realmente inexorable.","Pero también tierna."], ["Ya puedo cruzar.","...",". . .","Te echo de menos. Aunque eso ya lo sabes.","Y te amo. Eso también.",". . . . .","Adiós."]]
var array_dialogue_fail = ["Cerca, estuve cerca.", "Orbe, amigo mío, no me abandones tú también. Guíame.", "Debo salir de aquí, no hay margen de error ahora.", "No es justo, esto no es justo", "... ¿Podré hacerlo?", "Concéntrate.", "Debería concentrarme más en la esencia de las palabras. Su color."]
var array_dialogue_fail_tutorial = ["Debería concentrarme más en la esencia de las palabras. Su color.", "Cerca, estuve cerca.", "Orbe, amigo mío, no me abandones tú también. Guíame.", "He de concentrarme en la esencia del portal y encontrar una solución."]

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
signal failed_dialogue()
signal next_state_feedback()
signal mouse_feedback()
signal stop_mouse_feedback()
signal hum_increase(tone)
signal fail_sound_feedback()

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
	#fallo
	if !god_true_veredict:
		can_unpaint_orb = true
		failed_dialogue.emit()
		revert_all_words.emit(array_id)
		fail_sound_feedback.emit()
		array_id = []
		rgb_array = []
		dict_id_correct = {}
	#acierto	
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
	
