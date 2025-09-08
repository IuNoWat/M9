extends Control

var M9_1_loaded = preload("res://SCENES/M9_1.tscn")
var M9_1_instance = M9_1_loaded.instantiate()
var M9_2 = preload("res://SCENES/m9_1.gd")
var M9_3 = preload("res://SCENES/m9_1.gd")




func _on_btn_m_9_1_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/M9_1.tscn")

func _on_btn_m_9_2_pressed() -> void:
	pass # Replace with function body.

func _on_btn_m_9_3_pressed() -> void:
	pass # Replace with function body.
