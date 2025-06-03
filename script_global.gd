extends Node

@onready var french_trad = FileAccess.open("res://localisation/francais.trad", FileAccess.READ)
@onready var english_trad = FileAccess.open("res://localisation/anglais.trad", FileAccess.READ)
var loaded_french_trad = []
var loaded_english_trad = []
var lan_str_to_int = {\
"fr_FR"=0,
"en_EN"=1}
var langue = [loaded_french_trad,loaded_english_trad]
var langindex = 1
var story = 0
var game_root = null
var choice = 0

var controler = null

var debug_menu = null

var annex = []
var number_of_annex = 3

func generate_trad_liste():
	for i in range(1000) :
		loaded_french_trad.append(french_trad.get_line())
		loaded_english_trad.append(english_trad.get_line())

func generate_annex():
	for i in range(number_of_annex+1):
		annex.append(false)

func _ready() -> void:
	generate_annex()
	
	if lan_str_to_int[OS.get_locale()] == OK :
		langindex = lan_str_to_int[OS.get_locale()]
	else :
		langindex = 1
	generate_trad_liste()

func to_array(string):
	var liste = [""]
	var index = 0
	for i in range(len("["),len(string)-1) :
		if string[i] == "," :
			liste.append("")
			index += 1
		else :
			liste[index] += string[i]
	return liste

func print(msg):
	if debug_menu != null :
		debug_menu.add(msg)

func _input(event: InputEvent) -> void:
	controler = check_controler(event)
	if event.is_action("speed"):
		var input_scale = event.get_action_strength("speed")
		input_scale *= 4
		input_scale += 1
		Engine.time_scale = input_scale
	



func check_controler(event):
	if(event is InputEventKey):
		return "Keyboard"
	elif(event is InputEventJoypadButton):
		return "GamePad"
	elif(event is InputEventScreenTouch):
		self.print("Touch")
		return "Touch"
	else:
		return "Other"
