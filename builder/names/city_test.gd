extends Control

func _ready():
	var cn = City_Namer.new()
	cn.parse_names()
	for i in 100:
		print(cn.generate_name())
