class_name LittleGuy
extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var little_hat: Sprite2D = $Sprite2D/LittleHat

const SPEED = 10
const PANIC_SPEED = SPEED * 2

enum State { IDLE, ROAMING, PANIC }
var current_state = State.IDLE
var idle_timer: float = 0.0
var panic_timer: float = 0.0
var panic_retarget_timer: float = 0.0
var roam_target: Vector2
var last_velocity = Vector2.RIGHT

func _ready():
	navigation_agent.avoidance_enabled = false
	start_panic(randf_range(1.0, 3.0))

func _physics_process(delta):
	position = get_global_mouse_position()
	#match current_state:
		#State.IDLE:
			#idle_timer -= delta
			#if idle_timer <= 0:
				#start_roaming()
		#
		#State.ROAMING:
			#if navigation_agent.is_navigation_finished():
				#start_idle()
			#else:
				#move_toward_target(delta, SPEED)
		#
		#State.PANIC:
			#panic_timer -= delta
			#panic_retarget_timer -= delta
			#
			## Check if panic is over
			#if panic_timer <= 0:
				#start_idle()
			#else:
				## Rapidly change targets while panicking
				#if panic_retarget_timer <= 0 or navigation_agent.is_navigation_finished():
					#set_panic_target()
					#panic_retarget_timer = randf_range(0.3, 0.8)
				#
				#move_toward_target(delta, PANIC_SPEED)
	#
	#_animate()

func start_roaming():
	navigation_agent.path_desired_distance = randf() * 1.5 + 0.5
	navigation_agent.target_desired_distance = randf() * 1.5 + 0.5
	current_state = State.ROAMING
	roam_target = get_random_position_in_range()
	navigation_agent.target_position = roam_target

func start_idle():
	current_state = State.IDLE
	idle_timer = randf_range(1.0, 3.0)

func start_panic(duration: float = 3.0):
	current_state = State.PANIC
	panic_timer = duration
	panic_retarget_timer = 0.0  # Immediately set first target
	navigation_agent.path_desired_distance = 2.0
	navigation_agent.target_desired_distance = 2.0

func set_panic_target():
	# Panic movement: random direction, shorter distance, more erratic
	var random_direction = Vector2.RIGHT.rotated(randf() * TAU)
	var random_distance = randf_range(30, 100)
	navigation_agent.target_position = global_position + random_direction * random_distance

func move_toward_target(_delta, speed: float):
	var next_position = navigation_agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	if !linear_velocity.is_zero_approx():
		last_velocity = linear_velocity
	apply_central_impulse(direction * speed)

func get_random_position_in_range() -> Vector2:
	var random_direction = Vector2.RIGHT.rotated(randf() * TAU)
	var random_distance = randf_range(50, 200)
	return global_position + random_direction * random_distance

func _animate() -> void:
	if last_velocity.x < 0.0:
		sprite_2d.flip_h = true
		little_hat.flip_h = true
	else:
		sprite_2d.flip_h = false
		little_hat.flip_h = false
	
	match current_state:
		State.IDLE:
			animation_player.play("IDLE")
		State.ROAMING:
			animation_player.play("RUN")
		State.PANIC:
			animation_player.play("PANIC")

# Call this when hit by a block
func hit_by_block(direction: Vector2, force_magnitude: float):
	start_panic(randf_range(2.0, 4.0))  # Panic for 2-4 seconds
	
	# Optional: apply knockback
	apply_central_force(direction * force_magnitude * 0.3)
