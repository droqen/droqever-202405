extends ExamZone



func get_display_text() -> String:
	if wiz and wiz.movst.id == wiz.MEDITATE:
		return '. . . You did it. Now type "DUOTO" to set me free, fool.'
	else:
		return intro_monologue
