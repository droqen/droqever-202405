extends Node

func castspell(spellword):
	prints("said",spellword)
	match spellword:
		_:
			PlayerStatus.imm_cast('"'+spellword.to_upper()+'"')
#				"The word "+
#				spellword.to_upper()+
#				"... echoed, hollowly."
#			)

var dreamcatchers : Array = []

func register_dreamcatcher(dc):
	dreamcatchers.append(dc)
func unregister_dreamcatcher(dc):
	dreamcatchers.erase(dc)
