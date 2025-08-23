extends Node2D

var fingers = {}
var other_pos = Vector2()
var distance = 0
var focus = 0
var last_distance = 0
@onready var my_scale = $canvas
@onready var my_camera = $camera
var BLOCS = []
@export var POS : PackedScene
var dragging=false
var max_zoom=4
var min_zoom=0.25

func _ready() -> void:
	for i in range(0,6) :
		BLOCS.append(POS.instantiate())
		add_child(BLOCS[i])

func _process(delta: float) -> void :
	my_scale.pos_of_blocs = []
	for entry in BLOCS :
		my_scale.pos_of_blocs.append(entry.position)
		entry.scale = Vector2(1 / my_camera.zoom.x,1/my_camera.zoom.y)
	print(my_camera.zoom)


func handle_zoom(event) :
	for key in fingers :
		if key!=str(event.index) :
			other_pos=fingers[key]
	distance=event.position.distance_to(other_pos)
	if distance>last_distance :
		my_camera.zoom=my_camera.zoom*1.1
		if my_camera.zoom.x>5 :
			my_camera.zoom = Vector2(10,10)
	elif distance<last_distance:
		my_camera.zoom=my_camera.zoom*0.9
		if my_camera.zoom.x<0.25 :
			my_camera.zoom = Vector2(0.20,0.20)
	for entry in BLOCS :
		entry.position.x = my_scale.get_scale_offset()
	last_distance=distance

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch :
		if event.pressed :
			fingers[str(event.index)]=event.position
		else :
			fingers.erase(str(event.index))
	if event is InputEventScreenDrag :
		fingers[str(event.index)]=event.position
		if len(fingers)==1 and dragging==false :
			my_camera.position.y-=event.relative.y
		if len(fingers)==2 and dragging==false :
			handle_zoom(event)
