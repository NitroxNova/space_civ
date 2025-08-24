extends Resource
class_name City_Namer

const namelist = ["Albany","Amsterdam","Annapolis","Atlanta","Augusta","Austin",
		"Barcelona","Baton Rouge","Bejing","Bismarck","Blackwell","Boise","Boston","Buda",
		"Carson City","Cedar Park","Charleston","Cheyenne","Chicago","Columbia","Columbus","Concord",
		"Dallas","Denver","Des Moines","Dover","Dubai","El Paso","Edinburg","Fort Worth", "Frankfort","Fredericksburg", 
		"Harrisburg","Hartford","Helena","Honolulu","Houston","Huntsville","Indianapolis","Jackson","Jacksonville","Jefferson City","Johannesburg","Juneau",
		"Lago Vista","Lakeway","Lansing","Las Vegas", "Leander","Lincoln","Little Rock","London","Los Angeles",
		"Madison","Memphis","Miami","Montgomery","Montpelier","Nashville","New York City","Oklahoma City","Olympia","Orlando",
		"Paris","Pflugerville","Phoenix","Pierre","Portland","Providence","Raleigh","Richmond","Riverwood","Rome", "Round Rock",
		"Sacramento","Saint Louis","Saint Paul","Saint Petersburg","Salem","Salt Lake City","San Antonio","San Francisco","Santa Fe","Springfield",
		"Tallahassee","Tampa","Tokyo","Topeka","Toronto","Trenton","Tulsa","Venice","Whiterun"]

var name_table = {} #position, prev letter -> next letter, count
var min_length = namelist[0].length()
var max_length = namelist[0].length()

func parse_names():
	
	for city_name in namelist:
		if city_name.length() < min_length:
			min_length = city_name.length()
		if city_name.length() > max_length:
			max_length = city_name.length()
	#print(min_length)
	#print(max_length)
	for i in range(max_length*-1,max_length,1):
		name_table[i] = {}
	
	for city_name in namelist:
		for l_idx in city_name.length():
			var letter = city_name[l_idx]
			var prev_letter = ""
			if l_idx > 0:
				prev_letter = city_name[l_idx-1]
			add_letter_to_table(l_idx,prev_letter,letter)
			var r_idx = l_idx - city_name.length()
			add_letter_to_table(r_idx,prev_letter,letter)
	normalize_table()
	#print(name_table)		
	#print(l_idx," ",letter)

func generate_name():
	var name_length:int = (randi_range(min_length,max_length) + randi_range(min_length,max_length))/2
	#print(name_length)
	var word : String = name_table[0][""].keys().pick_random()
	while word.length() < name_length:
		var letter = next_letter(word.length(),word.length()-name_length,word[-1])
		word += letter
		if letter == "":
			return generate_name()
		if letter == " " and word.length() == name_length-1: #no space at end of word
			return generate_name()
	#print(name_length)
	#make sure same character isnt more than 2x in a row
	for i in word.length()-2:
		if word[i] == word[i+1] and word[i] == word[i+2]:
			return generate_name()
	return word
	
	

func next_letter(idx,r_idx,prev_letter):
	var letter = ""
	#print(name_table[idx][prev_letter])
	var rand = randf_range(0,1)
	var threshold:float = 0
	if prev_letter in name_table[idx] and prev_letter in name_table[r_idx]:
		rand = randf_range(0,2)
	if prev_letter in name_table[idx]:
		for n_idx in name_table[idx][prev_letter]:
			threshold += name_table[idx][prev_letter][n_idx]
			if rand < threshold:
				letter = n_idx
				return letter
	if prev_letter in name_table[r_idx]:
		for n_idx in name_table[r_idx][prev_letter]:
			threshold += name_table[r_idx][prev_letter][n_idx]
			if rand < threshold:
				letter = n_idx
				return letter
	#printerr("no match for ",prev_letter, " at ", idx, " or ", r_idx)
	return letter
	
func add_letter_to_table(idx,prev_letter,letter):
	if prev_letter not in name_table[idx]:
		name_table[idx][prev_letter] = {}
	if letter not in name_table[idx][prev_letter]:
		name_table[idx][prev_letter][letter] = 0
	name_table[idx][prev_letter][letter] += 1

func normalize_table():
	for idx in name_table:
		for prev_letter in name_table[idx]:
			var total:float = 0
			for letter in name_table[idx][prev_letter]:
				total += name_table[idx][prev_letter][letter]
			for letter in name_table[idx][prev_letter]:
				name_table[idx][prev_letter][letter] /= total
				
