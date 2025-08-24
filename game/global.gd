extends Node

var time : float = 0
var planets : Array

func _process(delta:float):
	time += delta
	for planet in planets:
		planet.process(delta)
