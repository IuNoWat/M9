extends Node2D

var dragging = false
var of = Vector2(0,0)


func _ready() -> void :
	pass

func _process(delta: float) -> void:
	if dragging:
		position = get_global_mouse_position()-of

func _on_button_button_down() -> void:
	get_parent().dragging=true
	dragging=true
	of=get_global_mouse_position()-global_position

func _on_button_button_up() -> void:
	dragging=false
	get_parent().dragging=false
