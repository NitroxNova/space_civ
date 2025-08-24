extends Resource
class_name Item

static var data = load_items()

static func load_items():
	var item_text = FileAccess.open("res://game/items/items.json",FileAccess.READ).get_as_text()
	var t_data = JSON.parse_string(item_text)
	for item_name in t_data:
		if "harvest_start" in t_data[item_name]:
			var temp = t_data[item_name].harvest_start
			temp = temp.split(" ")
			t_data[item_name].harvest_start = {}
			t_data[item_name].harvest_start.month = Time["MONTH_"+temp[0].to_upper()]
			t_data[item_name].harvest_start.day = temp[1]
		if "harvest_end" in t_data[item_name]:
			var temp = t_data[item_name].harvest_end
			temp = temp.split(" ")
			t_data[item_name].harvest_end = {}
			t_data[item_name].harvest_end.month = Time["MONTH_"+temp[0].to_upper()]
			t_data[item_name].harvest_end.day = temp[1]
		if "harvest_per_acre" in t_data[item_name]:
			#pounds
			var temp = t_data[item_name].harvest_per_acre[0].split(" ")
			t_data[item_name].harvest_per_acre = [float(temp[0]),t_data[item_name].harvest_per_acre[1]]
	return t_data

static func list(item_name):
	#print(data)
	return data[item_name]
