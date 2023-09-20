extends Node3D

@onready var player : CharacterBody3D = $"../Player"
@onready var child_mesh : MeshInstance3D = get_node("ShoeBoundary")
@export var shoe_distance_threshold : int

func _physics_process(_delta):
	var sparkle_event : bool = global_transform.origin.distance_to(
		player.global_transform.origin
	) > shoe_distance_threshold
	
	child_mesh.visible = sparkle_event # only show 'Shoe' mesh when 'sparkle_event' time
