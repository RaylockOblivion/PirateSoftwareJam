extends Node

var light_points : Array = []
var ray_casts: Array = []
func _ready():
	for node in get_tree().get_root().get_child(0).get_children():
		if node.is_in_group("light_layer"):
			light_points = node.get_children()
			light_points.pop_front()
			break
	
	ray_casts = $"../RayCasts".get_children()

signal light_detected
var light_intensity : float = 0
func _process(delta):
	if is_light_detected():
		light_detected.emit(light_intensity)

func is_light_detected() -> bool:
	var distance = 0.0
	for light in light_points:
		distance = get_parent().position.distance_to(light.position)
		if distance < light.texture.get_width() * light.texture_scale / 2:
			for ray in ray_casts:
				ray.target_position = light.position - ray.global_position
				ray.force_raycast_update()
				var collider = ray.get_collider()
				if collider is Node:
					if collider.is_in_group("light_obstacle"):
						return false
			light_intensity = (1 / distance) * light.energy * light.texture_scale * 10.0 
			return true
	for ray in ray_casts:
		ray.target_position = Vector2(0, 50)
	return false
