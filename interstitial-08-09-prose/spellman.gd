extends Node

signal spoke(stuff)

func _ready():
	add_to_group("SPELLMEN")

func speak(stuff):
	emit_signal("spoke", stuff)

func castspell(spellword):
	speak(spellword.to_upper() + ('_' if len(spellword)<10 else '.'))
#	speak("You just cast spell '" + spellword.to_lower() + "'... It does nothing.")
