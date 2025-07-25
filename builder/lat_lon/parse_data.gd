extends Node

var temp_25:float = 84
var temp_0:float = 329 
var rain_2000:float = 45
var rain_0:float = 328

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var image : Image = load("res://builder/lat_lon/Relationship_between_latitude_vs._temperature_and_precipitation.png")
	var top_line = 35 #to avoid the colored key at the top
	var bottom_line = 345
	var left_line = 99 #incluisive
	var right_line = 459 #exclusive
	var temperature_array = []
	var rain_array = []
	for x in range(left_line,right_line):
		#print(image.get_pixel(x,0))
		var temperature_value = 0
		var temperature_count = 0
		var rain_value = 0
		var rain_count = 0
		for y in range(top_line,bottom_line):
			var color = image.get_pixel(x,y)
			if (color == Color.WHITE):
				continue
			elif color.r == color.g and color.g == color.b:
				continue
			#can be both	
			if color.r > .7:
				temperature_value += y * color.r
				#print(y)
				temperature_count += 1 * color.r
			if color.b > .7:
				rain_value += y * color.b
				rain_count += 1 * color.b
			if color.r < .7 and color.b <.7:
				print(color)
		var curr_temp = temperature_value/temperature_count
		curr_temp = (curr_temp - temp_0) / (temp_25 - temp_0) #percent through range
		curr_temp = curr_temp * (25.0-0) + 0
		temperature_array.append(curr_temp)
		var curr_rain = rain_value/rain_count
		curr_rain = (curr_rain - rain_0) / (rain_2000 - rain_0) #percent through range
		curr_rain = curr_rain * (2000.0-0) + 0 
		rain_array.append(curr_rain)
	
	print(temperature_array)
	print(rain_array)
	
	var save_data = {temp=temperature_array,rain=rain_array}
	var file_path = "res://builder/lat_lon/latitude_temperature_rain.json"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
