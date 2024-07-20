extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var just_jumped = false
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

# Rays used for light detection
@onready var ray_one : RayCast2D = $RayCasts/RayOne
@onready var ray_two : RayCast2D = $RayCasts/RayTwo
@onready var ray_three : RayCast2D = $RayCasts/RayThree

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var light_points : Array = []
func _ready():
	light_points = get_light_points()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite.play("Falling")

	# Handle jump.
	# The player can now do a short or a long jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_released("ui_accept") and velocity.y < 0 and not is_on_floor():
		velocity.y *= 0.5

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		sprite.flip_h = direction < 0
		velocity.x = direction * SPEED
		sprite.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("Idle")
	
	move_and_slide()
	
	if is_light_detected():
		# Do Something
		pass

# Helper Functions
func get_light_points() -> Array:
	for node in get_parent().get_children():
		if node.is_in_group("light_layer"):
			light_points = node.get_children()
			light_points.pop_front()
			return light_points
	return []

func is_light_detected() -> bool:
	var distance = 0.0
	for node in light_points:
		distance = self.position.distance_to(node.position)
		if distance < node.texture.get_width() * node.texture_scale / 2:
			ray_one.target_position = node.position - ray_one.global_position
			ray_two.target_position = node.position - ray_two.global_position
			ray_three.target_position = node.position - ray_three.global_position
			ray_one.force_raycast_update()
			ray_two.force_raycast_update()
			ray_three.force_raycast_update()
			var collider = ray_one.get_collider()
			var collider_two = ray_one.get_collider()
			var collider_three = ray_one.get_collider()
			if collider is Node:
				if collider.is_in_group("light_obstacle"):
					return false
			if collider_two is Node:
				if collider_two.is_in_group("light_obstacle"):
					return false
			if collider_three is Node:
				if collider_three.is_in_group("light_obstacle"):
					return false
			return true
	ray_one.target_position = Vector2(0, 50)
	ray_two.target_position = Vector2(0, 50)
	ray_three.target_position = Vector2(0, 50)
	return false
