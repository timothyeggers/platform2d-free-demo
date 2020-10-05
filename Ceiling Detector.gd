extends RayCast2D


func get_ceiling_position():
	
	force_raycast_update()
	
	return get_collision_point()
