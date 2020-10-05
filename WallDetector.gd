extends RayCast2D


func colliding():
	force_raycast_update()
	return is_colliding()
