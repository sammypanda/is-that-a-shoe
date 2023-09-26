extends Node3D

@export var player : CharacterBody3D
@export var shoe_distance_threshold : int
@onready var camera_control
var looked_at : bool = false

func _ready():
	self.visible = false
	assert(shoe_distance_threshold != 0 || null, "The shoe distance threshold is unset or 0")
	assert(player != null, "The player object is not defined")
	
func handle_sparkle(glowing):	
	self.visible = glowing
	
	match looked_at:
		true:
			# stop one-time triggering events from re-triggering
			looked_at = glowing
		false:
			if glowing:
				# one time triggering events in shoe glow lifetime go here:
				CameraControl.request_camera_attention.emit(self.global_transform.origin)
				looked_at = true

func _physics_process(_delta):
	var should_sparkle : bool = global_transform.origin.distance_to(
		player.global_transform.origin
	) > shoe_distance_threshold
	
	handle_sparkle(should_sparkle)
