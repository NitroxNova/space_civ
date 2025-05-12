@tool
extends Node3D

@export var update : bool:
	set(value):
		move_vertex_meshes()

var vertex1 : Vector3
var vertex2 : Vector3
var vertex3 : Vector3
@export var vertex_string = "":
	set(value):
		vertex_string = value
		move_vertex_meshes()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_vertex_meshes()

func move_vertex_meshes():
	var strip_string = vertex_string.replace("(","")
	strip_string = strip_string.replace(")","")
	strip_string = strip_string.replace("[","")
	strip_string = strip_string.replace("]","")
	var vertex_floats = strip_string.split_floats(",",false)
	#print(vertex_floats)
	vertex1 = Vector3(vertex_floats[0],vertex_floats[1],vertex_floats[2])
	vertex2 = Vector3(vertex_floats[3],vertex_floats[4],vertex_floats[5])
	vertex3 = Vector3(vertex_floats[6],vertex_floats[7],vertex_floats[8])
	$vertex1.position = vertex1
	$vertex2.position = vertex2
	$vertex3.position = vertex3
	place_triangle()

func place_triangle():
	var tile_mesh = $Origin/Tile
	var tile = []
	tile.append(vertex1)
	tile.append(vertex2)
	tile.append(vertex3)
	var center_point = (tile[0] + tile[1] + tile[2]) /3
	var tm_scale = tile[0].distance_to(center_point)
	tile_mesh.scale = Vector3(tm_scale,tm_scale,tm_scale)
	tile_mesh.position = Vector3.UP * Vector3.ZERO.distance_to(center_point)
	$Origin.look_at(center_point)
	$Origin.rotation.x -= PI/2
	#print(tile_mesh.global_position)
	#print(center_point)
	var axis = center_point.normalized()
	tile_mesh.look_at(tile[0],axis)
