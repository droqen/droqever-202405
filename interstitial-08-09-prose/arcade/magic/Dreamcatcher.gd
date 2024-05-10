extends Node2D
class_name Dreamcatcher

# class for interacting with spellwords.

func _enter_tree():
	Spellman.register_dreamcatcher(self)

func _exit_tree():
	Spellman.unregister_dreamcatcher(self)

func modify_spell(spell):
	pass
