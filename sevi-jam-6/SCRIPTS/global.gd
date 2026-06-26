extends Node

# funcion global para todas las señales y variables a usar. 
# maquina de estado too

var current_state = 0
var dict_of_letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L']
var rgb_array = []
var rgb_total = Color()
var array_id = []
var is_gameplay = true #debug
signal word_solved(rgb_value, id)
signal word_unsolved(rgb_value,id)
signal paint_orb(rgb_value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("word_solved", on_word_solved)
	connect("word_unsolved", on_word_unsolved)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_word_solved(color: Color, id: int) -> void:
	if (array_id.has(id)):
		pass
	else:
		array_id.append(id)
		rgb_array.append(color)
		paint_orb.emit(calculateColor())
		print(array_id.size())
		if (array_id.size() == 2):
			next_state()

func on_word_unsolved(color: Color, id: int) -> void:
	if (array_id.has(id)):
		array_id.erase(id)
		rgb_array.erase(color)
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
	print("next state")
