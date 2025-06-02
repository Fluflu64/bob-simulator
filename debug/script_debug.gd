extends Node2D

@onready var label = $NinePatchRect/RichTextLabel

func _ready() -> void:
	BobGlobal.debug_menu = self


func add(msg):
	label.text = str(msg) + "\n" + label.text
