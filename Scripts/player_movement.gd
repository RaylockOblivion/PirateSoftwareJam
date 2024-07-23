extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -650.0
var just_jumped = false
var health:int = 100
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar = $ProgressBar

# Rays used for light detection
@onready var ray_one : RayCast2D = $RayCasts/RayOne
@onready var ray_two : RayCast2D = $RayCasts/RayTwo
@onready var ray_three : RayCast2D = $RayCasts/RayThree
@onready var label = $Label
@onready var color_rect = $ColorRect
@onready var coyote_time_timer = $CoyoteTimeTimer
@onready var jump_buffer_timer = $JumpBufferTimer

var was_in_air:bool = false
var was_on_floor:bool = false
var jump_buffer:bool = false
var jumping:bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fake_grav = 1
var light_points : Array = []

func _ready():
	light_points = get_light_points()
	health_bar.value=health
	#Engine.time_scale=0.25

func _physics_process(delta):
	apply_gravity(delta)
	label.set_text(str(velocity))
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor()||was_on_floor:
			jump()
			print("test?")
		else:
			jump_buffer=true
			jump_buffer_timer.start()
	elif Input.is_action_just_released("ui_accept") and not is_on_floor():
		jump_release()
	
	move()
	
	move_and_slide()
	#print(is_on_floor(),was_in_air)
	if(is_on_floor()&&was_in_air):
		printerr("happened")
	
	if(is_on_floor()&&was_in_air):
		was_in_air=false
		if jump_buffer:
			jump()
		was_on_floor=true
		print("why am i on the floor?")
		jumping=false
	
	if(!is_on_floor()&&!jumping):
		coyote_time_timer.start()

	if is_light_detected():
		# Do Something
		pass

func apply_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y = clamp(velocity.y + (gravity * fake_grav) * delta,JUMP_VELOCITY,gravity)
		#sprite.play("Falling")

func move():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		sprite.flip_h = direction < 0
		velocity.x = direction * SPEED
		#sprite.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("PlaceHolder_idle")
	
func jump():
	if jumping: return
	jumping=true
	velocity.y = JUMP_VELOCITY
	color_rect.color=Color(0,1,0,1)
	fake_grav = 1
	was_in_air=true

func jump_release():
	velocity.y *= 0.25
	color_rect.color=Color(1,0,0,1)
	fake_grav = 1.5

func get_light_points() -> Array:
	for node in get_parent().get_children():
		if node.is_in_group("light_layer"):
			light_points = node.get_children()
			light_points.pop_front()
			return light_points
	return []

func reduce_health(val:int):
	if(health-val<0):
		health = 0
		health_bar.value=0
		return
	health-=val
	health_bar.value=health

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

func _on_jump_buffer_timer_timeout():
	jump_buffer = false

func _on_coyote_time_timer_timeout():
	print("timer started?")
	was_in_air = false
