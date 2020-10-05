extends KinematicBody2D

onready var input = get_node("Controller")
onready var physics = get_node("Physics")
onready var body = get_node("State")

onready var wall_detector = get_node("WallDetector")

onready var convert_timer = get_node("ConvertTimer")
onready var wall_jump_timer = get_node("WallJumpTimer")

var velocity = Vector2.ZERO
var grounded = false setget , is_grounded


func _ready():
	body.set_facing_direction(input.facing_direction)
	body.state_transition(body.states.idle)


func _physics_process(delta):
	var new_velocity = Vector2.ZERO
	
	body.set_facing_direction(input.facing_direction)
	
	# Perform move, friction, gravity. Assign to velocity.
	new_velocity.x = physics._move(input.direction)
	new_velocity.y = physics._gravity()
	velocity = new_velocity
	
	# Perform queued special actions.
	new_velocity = _handle_actions()
	velocity = new_velocity
	
	# Move and slide with velocity.
	move_and_slide(velocity, Vector2.UP)
	grounded = is_on_floor()
	
	
	Debug_Screen.update_velocity(velocity)


func _handle_actions() -> Vector2:
	var new_velocity = velocity
	
	if input.skate_transition_queued:
		
		input.skate_transition_queued = false
		input.emit_signal("convert_state", false)
		
		if can_convert() == true:
			new_velocity.y = physics.jump(physics.convert_acceleration)
		
	elif input.jump_queued:
		
		input.jump_queued = false
		input.emit_signal("jump", false)
		
		if can_jump():
			new_velocity.y = physics.jump()
		elif can_wall_jump():
			new_velocity = physics.wall_jump(input.direction)
	
	return new_velocity

func is_grounded():
	
	return grounded


func can_jump() -> bool:
	
	if body.state == body.states.climbing:
		#Parent.climb_mode = false
		print("Cant jump.")
		return false
	
	if is_grounded():
		print("Can jump, is grounded.")
		return true
	
	return false


func can_wall_jump() -> bool:
	
	if convert_timer.time_left > 0:
		return false
	
	if body.state != body.states.climbing:
		return false
	
	if is_pushing_wall() == false:
		return false
	
	wall_jump_timer.start()
	
	return true


func can_convert() -> bool:
	
	if body.state == body.states.converting:
		return false
	
	if convert_timer.time_left > 0:
		return false
	
	convert_timer.start()
	
	return true


func is_pushing_wall() -> bool:
	
	if wall_detector.colliding() and input.direction.x != 0:
		return true
	
	return false
