extends Node

onready var textwin = $"../m/h/text_win"

func _ready():
	add_to_group("SPELLMEN")

func castspell(spellword):
	textwin.printmessage("You just cast spell '" + spellword.to_lower() + "'... It does nothing.")
