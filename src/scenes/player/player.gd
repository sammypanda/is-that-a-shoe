extends CharacterBody3D

# Mount nodes
@onready var head := $Head
@onready var camera := $Head/Camera3D

# Node Settings
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed = 5
@export var max_look_angle = deg_to_rad(90)
@export var min_look_angle = deg_to_rad(-80)

# Game Settings
var look_sensitivity = 0.01

# Important variables
var target_velocity = Vector3.ZERO

func _input(event):
	# --- Look Rotation --- #
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * look_sensitivity)
			camera.rotate_x(-event.relative.y * look_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, min_look_angle, max_look_angle)

func _physics_process(_delta):
	# --- Movement --- #
	var direction = Vector3.ZERO
	
	direction = head.transform.basis * Vector3( # make the head coords the basis of movement
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), # negotiate z
		0, # nothing for y
		Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward") # negotiate x
	).normalized()
	
	# Velocity when on the ground
	target_velocity.z = direction.z * speed
	target_velocity.x = direction.x * speed
	
#	if !velocity.is_zero_approx(): # if not standing still
#		print("moving") # activate bobbing
	
	velocity = target_velocity
	move_and_slide()
