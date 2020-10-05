extends Control

onready var direction = get_node("Split/PanelContainer/VBoxContainer/InputDirection")
onready var iconvert = get_node("Split/PanelContainer/VBoxContainer/InputConvert")
onready var jump = get_node("Split/PanelContainer/VBoxContainer/InputJump")
onready var vel = get_node("Split/State/VBoxContainer/Velocity")
onready var state = get_node("Split/State/VBoxContainer/State")
onready var facing_direction = get_node("Split/State/VBoxContainer/Direction")


func update_direction(var direction):
	self.direction.text = "Directional: " + str(direction)


func update_convert(var unhandled):
	self.iconvert.text = "Convert Queued: " + str(unhandled)


func update_jump(var unhandled):
	self.jump.text = "Jump Queued: " + str(unhandled)


func update_velocity(var value):
	self.vel.text = "Velocity: " + str(value)


func update_state(var state):
	self.state.text = "State: " + str(state)


func update_facing_direction(var direction):
	self.facing_direction.text = "Facing Direction: " + str(direction)
