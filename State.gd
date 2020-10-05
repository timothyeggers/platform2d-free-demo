extends Node

onready var parent = get_parent()

enum states {
	idle,
	walking_grounded,
	wall_interact,
	climbing,
	jumping,
	falling,
	converting,
	ceiling_interact,
	banging_head,
}

var skate_mode := false setget set_skate_mode

var state = states.idle

var facing_direction = Vector2.RIGHT



func state_transition(var new_state, var old_state = state) -> bool:
	# returns true on successful transition, returns false otherwise.
	# Do state transition?
	#  do comparisons of old and new state to determine animation frame.
	# 	example, if you were grounded and you jumpecx, play the full jump animation
	#     but if youre sliding and you jumped then skip to falling jump frame.
	
	
	state = new_state
	Debug_Screen.update_state(new_state)
	
	return true


func set_skate_mode(val):
	
	# do something animation thing before continuing normal state
	
	skate_mode = val


func get_state():
	
	return state


func set_facing_direction(var direction := Vector2.RIGHT):
	if direction.x != facing_direction.x:
		facing_direction.x = direction.x
		
		if facing_direction == Vector2.RIGHT:
			parent.set_global_transform(Transform2D(Vector2(1,0),Vector2(0,1),Vector2(parent.position.x,parent.position.y)))
		else:
			parent.set_global_transform(Transform2D(Vector2(-1,0),Vector2(0,1),Vector2(parent.position.x,parent.position.y)))
	
	Debug_Screen.update_facing_direction(facing_direction)
