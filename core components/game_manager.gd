extends Node

var reset_count = 0

func increment_reset_count():
	reset_count += 1
	
func get_reset_count():
	return reset_count
