extends Node

onready var Parent = get_parent()

var gravity_direction = Vector2.DOWN.y
var gravity_acceleration = 10.0
var terminal_velocity = 550.0

const climbing_terminal_velocity = 60.0

var friction = 0.06
const air_friction = 0.01

var acceleration = 20.0
var max_acceleration = 220.0
const walk_max_accel = 220.0
const skate_max_accel = 350.0

const max_jump_acceleration = 250.0
const min_jump_acceleration = 150.0
const convert_acceleration = 125.0

const wall_jump_acceleration = Vector2(220.0, 275.0)

func _gravity() -> float:
	
	var grounded = false
	var vel_y = 0.0
	var new_vel_y = 0.0
	var term_vel = terminal_velocity
	
	if "grounded" in Parent:
		grounded = Parent.grounded
	
	if "velocity" in Parent:
		vel_y = Parent.velocity.y
	
	if Parent.body.state == Parent.body.states.climbing:
		term_vel = climbing_terminal_velocity
	
	if grounded:
		new_vel_y = gravity_acceleration * 3 * gravity_direction
	elif vel_y + ( gravity_acceleration * gravity_direction ) < term_vel * gravity_direction:
		new_vel_y = vel_y + ( gravity_acceleration * gravity_direction )
	else:
		new_vel_y = term_vel * gravity_direction
	
	return new_vel_y


func _friction(var f = friction) -> float:
	
	var fric = f
	var vel_x = 0.0
	var new_vel_x = 0.0
	 
	var cutoff = max_acceleration * 0.08
	
	if "velocity" in Parent:
		vel_x = Parent.velocity.x
	
	fric = 1.0 - fric
	
	if abs( vel_x * fric ) > cutoff:
		new_vel_x = vel_x * fric
	
	return new_vel_x


func _move(var direction):
	
	if Parent.wall_jump_timer.time_left > 0:
		return _friction(air_friction)
	
	if round(direction.x) == 0:
		if Parent.grounded:
			Parent.body.state_transition(Parent.body.states.idle)
		else:
			Parent.body.state_transition(Parent.body.states.falling)
		
		return _friction()
	
	
	var accel = acceleration * direction.x
	var vel_x = Parent.velocity.x
	
	
	direction.x = stepify(direction.x, 0.1)
	var new_vel_x = vel_x + accel
	var max_vel_x = max_acceleration * abs( direction.x )
	
	
	if Parent.is_pushing_wall():
		if Parent.grounded:
			Parent.body.state_transition(Parent.body.states.banging_head)
		else:
			Parent.body.state_transition(Parent.body.states.climbing)
		
		return acceleration * direction.normalized().x
	else:
		if Parent.grounded:
			Parent.body.state_transition(Parent.body.states.walking_grounded)
	
	
	if abs( new_vel_x ) > max_vel_x:
		new_vel_x = max_vel_x * direction.normalized().x
	
	return new_vel_x


func jump(var fixed_acceleration = 0.0) -> float:
	
	var vel_y = Parent.velocity.y
	var amptitude = 1.0
	
	if fixed_acceleration != 0.0:
		if fixed_acceleration == convert_acceleration:
			Parent.body.state_transition(Parent.body.states.converting)
		
		return fixed_acceleration * -gravity_direction
	
	amptitude = abs(Parent.velocity.x) / max_acceleration
	
	var acceleration = max(min_jump_acceleration, max_jump_acceleration * amptitude)
	print("Jump acceleration: " + str(acceleration))
	
	Parent.body.state_transition(Parent.body.states.jumping)
	return acceleration * -gravity_direction


func wall_jump(var direction) -> Vector2:
	
	Parent.body.state_transition(Parent.body.states.jumping)
	return Vector2(wall_jump_acceleration.x * -direction.x, wall_jump_acceleration.y * -gravity_direction)
