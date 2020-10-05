extends Node


var direction = Vector2.ZERO setget set_direction , get_direction
var facing_direction = Vector2.RIGHT

var jump_queued = false
var skate_transition_queued = false

signal direction_change(dir)
signal jump(unhandled)
signal convert_state(unhandled)


func _ready():
	connect("direction_change", self, "_on_direction_change")
	connect("jump", self, "_on_jump")
	connect("convert_state", self, "_on_convert_state")


func _input(event):
	var prev_dir = direction.x
	
	direction.x = Input.get_action_strength("right") + -Input.get_action_strength("left")
	direction.y = -Input.get_action_strength("up") + Input.get_action_strength("down")
	
	if direction.x != prev_dir:
		emit_signal("direction_change", direction)
	
	if facing_direction != direction and direction != Vector2.ZERO:
		facing_direction = direction
	
	if Input.is_action_just_pressed("jump"):
		jump_queued = true
		emit_signal("jump", jump_queued)
	
	if Input.is_action_just_pressed("convert_state"):
		skate_transition_queued = !skate_transition_queued
		emit_signal("convert_state", skate_transition_queued)


func _on_convert_state(unhandled):
	Debug_Screen.update_convert(unhandled)


func _on_jump(unhandled):
	Debug_Screen.update_jump(unhandled)


func _on_direction_change(dir):
	Debug_Screen.update_direction(dir)


func set_direction(val):
	direction = val


func get_direction():
	return direction
