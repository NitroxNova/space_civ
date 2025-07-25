extends Resource
#d20
#https://polytope.miraheze.org/wiki/Icosahedron
#https://en.wikipedia.org/wiki/Regular_icosahedron
class_name Icosahedron_Builder

const init_vertices = [Vector3(0.000000, 10.000000, 0.000000),
	Vector3(-0.000000, 4.472136, 8.944272),
	Vector3(8.506508, 4.472136, 2.763932),
	Vector3(5.257311, 4.472136, -7.236068),
	Vector3(-5.257311, 4.472136, -7.236068),
	Vector3(-8.506508, 4.472136, 2.763932),
	Vector3(5.257311, -4.472136, 7.236068),
	Vector3(8.506508, -4.472136, -2.763932),
	Vector3(0.000000, -4.472136, -8.944272),
	Vector3(-8.506508, -4.472136, -2.763932),
	Vector3(-5.257311, -4.472136, 7.236068),
	Vector3(-0.000000, -10.000000, -0.000000)]
	
const init_faces = [ [1,2,3],[1,3,4],[1,4,5],[1,5,6],[1,6,2],
[2,7,3],[3,7,8],[3,8,4],[4,8,9],[4,9,5],
[5,9,10],[5,10,6],[6,10,11],[6,11,2],[2,11,7],
[7,12,8],[8,12,9],[9,12,10],[10,12,11],[11,12,7]]

var new_vertices = []
var new_faces = []
var radius = 10.0

func _init(_radius:float):
	new_vertices = init_vertices.duplicate(true)
	new_faces = init_faces.duplicate(true)
	radius = _radius
	subdivide()
	subdivide()
	subdivide()
	subdivide()
	subdivide()
	#subdivide()

func subdivide():
	var temp_faces = []
	for face in new_faces:
		var nv_size = new_vertices.size()
		for idx in 3:
			var id1 = face[idx]
			var id2 =  nv_size + idx + 1
			var id3 = nv_size + (idx+2)%3 + 1
			temp_faces.append([id1,id2,id3])
		temp_faces.append([nv_size+1,nv_size+2,nv_size+3])
		for idx in 3:	
			var id1 = face[idx]
			var id2 = face[(idx+1)%3]
			var mid_point = (new_vertices[id1-1] + new_vertices[id2-1])/2
			new_vertices.append(mid_point)
	new_faces = temp_faces	
			
	
func create_mesh():
	var sf_arrays = []
	sf_arrays.resize(Mesh.ARRAY_MAX)
	sf_arrays[Mesh.ARRAY_VERTEX] = PackedVector3Array()
	sf_arrays[Mesh.ARRAY_INDEX] = PackedInt32Array()
	for coords in new_vertices:
		sf_arrays[Mesh.ARRAY_VERTEX].append(project_to_sphere(coords))
	for face in new_faces:
		for id in face:
			sf_arrays[Mesh.ARRAY_INDEX].append(id-1)
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,sf_arrays)
	return mesh

func project_to_sphere(coords:Vector3):
	var angle = coords - Vector3.ZERO
	angle = angle.normalized()
	angle = angle * radius
	return angle
	
