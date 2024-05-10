extends Node2D
class_name Spell

var spellstring : String # always all uppercase.
var caster : Node2D
var startpos : Vector2
var validspell : bool = true
var failedspell : bool = false

func _init(_string : String, _caster : Node2D):
	self.spellstring = _string
	self.caster = _caster
	self.startpos = caster.position
