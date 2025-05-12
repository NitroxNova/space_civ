extends Node3D

const blank_tile = preload("res://terrain_tiles/blank_tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var planet_builder = Planet_Builder.new($Planet)
	var mesh = planet_builder.build()
	$MeshInstance3D.mesh = mesh
	add_child(planet_builder.planet)
