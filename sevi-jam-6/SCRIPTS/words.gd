extends RichTextLabel

var is_solved = false
@export var rgb_value = Color.BLUE
@export var id = 0
var array_letters = []
var array_pressed_letters = []
var dict_animated_letters = {}
var is_animated = false
@onready var original_text = text


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpellController.connect("letter_pressed", on_letter_pressed)
	SpellController.connect("letter_released", on_letter_released)
	for c in text:
		array_letters.append(c)
	array_letters = unique_array(array_letters)
	array_letters.sort()
	for a in array_letters:
		dict_animated_letters[a] = false

	add_theme_color_override("default_color",rgb_value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func unique_array(arr: Array) -> Array:
	var dict := {}
	for a in arr:
		dict[a] = 1
	return dict.keys()


func on_letter_pressed(letter: String) -> void:
	if array_pressed_letters.has(letter):
		pass
	if original_text.contains(letter):
		animate_such_letter(letter)
		array_pressed_letters.append(letter)
		array_pressed_letters = unique_array(array_pressed_letters)
		array_pressed_letters.sort()
		if array_letters.size() <= array_pressed_letters.size():
			var solved = true
			for i in range(array_letters.size()):
				if array_pressed_letters[i] != array_letters[i]:
					solved = false
					break
			is_solved = solved
			#print("array letters")
			#print(array_letters)
			#print("array pressed letters")
			#print(array_pressed_letters)
			#print("valor")
			#print(is_solved)
			if (is_solved):
				Global.word_solved.emit(rgb_value, id)


func on_letter_released(letter: String) -> void:
	if array_pressed_letters.has(letter):
		if is_solved:
			Global.word_unsolved.emit(rgb_value, id)
			is_solved = false
		array_pressed_letters = unique_array(array_pressed_letters)
		array_pressed_letters.sort()
		array_pressed_letters.erase(letter)
		text = original_text
		dict_animated_letters[letter] = false


func animate_such_letter(letter: String) -> void:
	for i in text.length():
		if letter == text[i]:
			if !dict_animated_letters[letter]:
				var substring1 = text.substr(0, i)
				var substring2 = text.substr(i,text.length())
				var animated = "[wave amp=100.0 freq=15.0 connected=1]"
				text = substring1 + animated + substring2[0] + "[/wave]" + substring2.substr(1,-1)
				dict_animated_letters[letter] = true
