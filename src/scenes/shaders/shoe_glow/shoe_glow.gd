extends Node3D

@export var player : CharacterBody3D
@export var shoe_distance_threshold : int
@onready var camera_control
var looked_at : bool = false

func _ready():
	self.visible = false
	assert(shoe_distance_threshold != 0 || null, "The shoe distance threshold is unset or 0")
	assert(player != null, "The player object is not defined")

func _physics_process(_delta):
	var sparkle_event : bool = global_transform.origin.distance_to(
		player.global_transform.origin
	) > shoe_distance_threshold
	
	self.visible = sparkle_event # only show 'Shoe' mesh when 'sparkle_event' time
	
	if sparkle_event:
		CameraControl.request_camera_attention.emit(self.global_transform.origin)
