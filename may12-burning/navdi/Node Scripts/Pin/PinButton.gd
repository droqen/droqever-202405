class_name PinButton
extends Reference

var held : bool = false
var pressed : bool = false
var released : bool = false

func pin(b : bool):
	if b != held:
		if b:
			held = true
			pressed = true
		else:
			held = false
			released = true

func end_frame():
	pressed = false
	released = false

func clr():
	held = false
	pressed = false
	released = false
