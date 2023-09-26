extends Node3D

@export var player : CharacterBody3D
@export var shoe_distance_threshold : int
@export var lock_attention : bool = true
@onready var camera_control
var looked_at : bool = false

func _ready():
	self.visible = false
	assert(shoe_distance_threshold != 0 || null, "The shoe distance threshold is unset or 0")
	assert(player != null, "The player object is not defined")

func handle_sparkle(differential, offset):
	var glowing = differential >= 0
	var attention = differential + offset >= 0
	
	self.visible = glowing
	
	if lock_attention && attention:
		CameraControl.request_camera_attention.emit(self.global_transform.origin)
	
	match looked_at:
		true:
			# stop one-time triggering events from re-triggering
			looked_at = glowing
		false:
			# one time triggering events in shoe glow lifetime can go here:
			if attention && !lock_attention: # if is far enough away to grab 'attention'
				CameraControl.request_camera_attention.emit(self.global_transform.origin)
				looked_at = true

func _physics_process(_delta):
	var threshold_differential: int = global_transform.origin.distance_to(
		player.global_transform.origin
	) - shoe_distance_threshold
	
	handle_sparkle(threshold_differential, -4)
