extends Resource
class_name Building

@export var type : Building_Type
@export var storage : Dictionary = {}

func process(delta:float):
	#print("process building")
	if type.display_name == "Wheat Farm":
		var item_data = Item.list("winter_wheat_plant")
		var harvest_start = item_data.harvest_start.duplicate()
		harvest_start.year = Time.get_date_dict_from_unix_time( Game.time).year
		harvest_start = Time.get_unix_time_from_datetime_dict(harvest_start)
		
		var harvest_end_dict = item_data.harvest_end.duplicate()
		harvest_end_dict.year = Time.get_date_dict_from_unix_time( Game.time).year
		var harvest_end = Time.get_unix_time_from_datetime_dict(harvest_end_dict)
		#if harvest_end < harvest_start:
			#harvest_end_dict.year += 1
			#harvest_end = Time.get_unix_time_from_datetime_dict(harvest_end_dict)
		
		if harvest_start < Game.time and harvest_end > Game.time:
			#print("harvesting wheat")
			var total_time = harvest_end - harvest_start
			var amount_harvested = (delta / total_time) *  item_data.harvest_per_acre[0]
			var item_name =  item_data.harvest_per_acre[1]
			if item_name not in storage:
				storage[item_name] = 0
			storage[item_name] += amount_harvested
			
		#var harvest_start = Time.get_unix_time_from_datetime_string(.harvest_start)
		#print(harvest_start)
