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

var annex = []
var number_of_annex = 3

func generate_trad_liste():
	for i in range(1000) :
		loaded_french_trad.append(french_trad.get_line())
		loaded_english_trad.append(english_trad.get_line())

func _ready() -> void:
	for i in range(number_of_annex+1):
		annex.append(false)
	
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
