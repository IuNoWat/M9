extends Node2D

#ONREADY
@onready var my_scale = $/root/M9_1/my_scale
@onready var label = $Control/Bain/Control/Text
@onready var pos = $Control/Bain/Control/Pos
@onready var inventory = $camera/CanvasLayer/Inventory

#ENGINE - DATA
var text = "Default text"
var current_y = 500
var good_y = 500

#ENGINE - DRAGGING
var dragging = false
var of = Vector2(0,0)
var in_inventory = true

func _ready() -> void :
	label.text = text
	pass

func _process(delta: float) -> void:
	if dragging:
		position = get_global_mouse_position()-of
	if position.x<my_scale.offset.x+my_scale.cam_offset.x and in_inventory==false :
		position.x=my_scale.offset.x+my_scale.cam_offset.x
	if position.x>my_scale.offset.x+my_scale.cam_offset.x+600/my_scale.ratio and in_inventory==false :
		position.x=my_scale.offset.x+my_scale.cam_offset.x+600/my_scale.ratio
	
	
	current_y = position.y
	if in_inventory :
		pos.text = "?"
	else :
		pos.text = str(int(current_y))+" l"

func _on_button_button_down() -> void:
	get_parent().dragging=true
	dragging=true
	of=get_global_mouse_position()-global_position

func _on_button_button_up() -> void:
	dragging=false
	get_parent().dragging=false
	if in_inventory :
		in_inventory=false
