extends RichTextLabel

var is_solved = false
@export var rgb_value = Color.BLUE
@export var id = 0
@export var this_is_the_one_officer = false
var array_letters = []
var array_pressed_letters = []
var dict_animated_letters = {}
var is_animated = false
@onready var original_text = text
@onready var timer := Timer.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("revert_all_words", on_revert_all_words)
	Global.connect("play_word_correct_animation", on_play_word_correct_animation)
	Global.connect("prepare_new_state_on_word", on_prepare_new_state_on_word)

	timer.wait_time = 8.0
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)

	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Global.is_gameplay):
		add_theme_color_override("default_color",rgb_value)
	elif (!is_solved):
		add_theme_color_override("default_color",Color.WHITE)

func start() -> void:
	is_solved = false
	original_text = text
	array_letters = []
	dict_animated_letters = {}
	array_pressed_letters = []

	for c in original_text:
		array_letters.append(c)
	array_letters = unique_array(array_letters)
	array_letters.sort()

	for a in array_letters:
		dict_animated_letters[a] = false

func on_prepare_new_state_on_word() -> void:
	start()
	_on_timer_timeout()


func unique_array(arr: Array) -> Array:
	var dict := {}
	for a in arr:
		dict[a] = 1
	return dict.keys()

func _unhandled_key_input(event):
	if Global.is_gameplay:
		if event is InputEventKey and event.is_pressed():
			on_letter_pressed(event.as_text_key_label())
		elif event is InputEventKey and event.is_released():
			on_letter_released(event.as_text_key_label())

func _on_timer_timeout() -> void:
	# funciona tambien como un reset
	is_solved = false
	text = original_text
	array_pressed_letters = []
	for i in dict_animated_letters:
		dict_animated_letters[i] = false
	#Global.on_word_unsolved(rgb_value, id)


func on_letter_pressed(letter: String) -> void:
	if array_pressed_letters.has(letter):
		pass
	if original_text.contains(letter):
		if (Global.can_unpaint_orb):
			Global.unpaint_orb.emit(Global.orb_array_colors)
			Global.can_unpaint_orb = false
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
			if (is_solved):
				text = "[shake rate=20.0 level=20 connected=1]"+original_text+"[/shake]"
				Global.word_solved.emit(rgb_value, id, this_is_the_one_officer)
				#text = "[pulse freq=1.0 color=#ffffff40 ease=-2.0]"+original_text+"[/pulse]"
				#text = "[rainbow freq=0.5 sat=0.8 val=0.8 speed=0.7]"+original_text+"[/rainbow]"
				timer.start()
				
				
		#print("array letters")
		#print(array_letters)
		#print("array pressed letters")
		#print(array_pressed_letters)
		#print("valor")
		#print(is_solved)


func on_letter_released(letter: String) -> void:
	if !timer.is_stopped():
			pass
	elif array_pressed_letters.has(letter):
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


func on_revert_all_words(array_id: Array) -> void:
	_on_timer_timeout()
	print(array_id)
	print(id)
	for i in array_id:
		if i == id:
			print("entramos aqui")
			$AnimationPlayer.play("shift")
			Global.on_word_unsolved(rgb_value, id)
		
	
func on_play_word_correct_animation(array_id: Array) -> void:
	_on_timer_timeout()
	for i in array_id:
		if i == id:
			$AnimationPlayer.play("correct")
			Global.on_word_unsolved(rgb_value, id)
