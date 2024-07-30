extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -650.0
var just_jumped = false
var health:int = 100
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar = $Debugger/ProgressBar

@onready var label = $Debugger/Label
@onready var color_rect = $Debugger/ColorRect
@onready var coyote_time_timer = $CoyoteTimeTimer
@onready var jump_buffer_timer = $JumpBufferTimer

var was_in_air:bool = false
var was_on_floor:bool = false
var jump_buffer:bool = false
var jumping:bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fake_grav = 1

func _ready():
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

func reduce_health(val:int):
	if(health-val<0):
		health = 0
		health_bar.value=0
		return
	health-=val
	health_bar.value=health

func _on_jump_buffer_timer_timeout():
	jump_buffer = false

func _on_coyote_time_timer_timeout():
	print("timer started?")
	was_in_air = false

func _on_light_detection_manager_light_detected(light_intensity):
	pass
