class_name enemy extends CharacterBody2D

@export var interest_spot : Node2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum state{
	NONE,
	
	PASSIVE,
	PASSIVE_GOOMBA,
	ALERTED,
	CURIOUS
}

var current_state = state.NONE

var x_velocity : float = 0.5
var target_x : float = 0.0

func _ready():
	current_state = state.PASSIVE_GOOMBA
	target_x = randi_range(interest_spot.global_position.x - interest_spot.range, interest_spot.global_position.x + interest_spot.range)

func _physics_process(delta):
	match current_state:
		state.NONE:
			pass
		state.PASSIVE:
			enemy_passive(delta)
		state.PASSIVE_GOOMBA:
			enemy_passive_goomba(delta)
		state.ALERTED:
			pass
		state.CURIOUS:
			pass
	
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite.play("Falling")
	
	var direction = x_velocity
	if direction:
		sprite.flip_h = direction < 0
		velocity.x = direction * SPEED
		sprite.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("Idle")
	
	move_and_slide()

@onready var player : CharacterBody2D = %Player
func enemy_passive(delta):
	x_velocity = 0
	if self.position.x >= interest_spot.global_position.x - interest_spot.range and self.position.x <= interest_spot.global_position.x + interest_spot.range:
		if self.position.x <= target_x - 10:
			x_velocity = 0.5
		elif self.position.x >= target_x + 10:
			x_velocity = -0.5
	else:
		x_velocity = (interest_spot.global_position - self.position).normalized().x

@onready var ray_left : RayCast2D = $RayCasts/Ray_Left
@onready var ray_right : RayCast2D = $RayCasts/Ray_Right
func enemy_passive_goomba(delta):
	if ray_left is Node:
		if ray_left.get_collider() != null:
			x_velocity = 0.5
	if ray_right is Node:
		if ray_right.get_collider() != null:
			x_velocity = -0.5

func enemy_alerted():
	pass

func enemy_curious():
	pass

func _on_timer_timeout():
	match current_state:
		state.NONE:
			pass
		state.PASSIVE:
			target_x = randi_range(interest_spot.global_position.x - interest_spot.range, interest_spot.global_position.x + interest_spot.range)
