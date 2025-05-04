extends Node

@onready var french_trad = FileAccess.open("res://localisation/francais.trad", FileAccess.READ)
@onready var english_trad = FileAccess.open("res://localisation/anglais.trad", FileAccess.READ)
var loaded_french_trad = []
var loaded_english_trad = []
var langue = [loaded_french_trad,loaded_english_trad]
var langindex = 1

func generate_trad_liste():
	for i in range(1000) :
		loaded_french_trad.append(french_trad.get_line())
		loaded_english_trad.append(english_trad.get_line())

func _ready() -> void:
	generate_trad_liste()
