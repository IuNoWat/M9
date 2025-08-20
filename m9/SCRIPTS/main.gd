extends Control

var echelle = 1
var fingers = {}
var other_pos = Vector2()
var distance = 0
var last_distance = 0
@onready var my_scale = $canva_container/canva
var BLOCS = []
@export var POS : PackedScene


func _ready() -> void:
	for i in range(0,6) :
		BLOCS.append(POS.instantiate())
		add_child(BLOCS[i])

func _process(delta: float) -> void :
	var direction = Input.get_axis("ui_left","ui_right")
	if direction :
		echelle=echelle+direction * 0.05
		if echelle<0.1 :
			echelle=0.1
		my_scale.echelle=echelle
	my_scale.pos_of_blocs = []
	for entry in BLOCS :
		my_scale.pos_of_blocs.append(entry.position)

func handle_zoom(event) :
	for key in fingers :
		if key!=str(event.index) :
			other_pos=fingers[key]
	distance=event.position.distance_to(other_pos)
	print(distance)
	if distance>last_distance :
		echelle=echelle + 0.1
	elif distance<last_distance:
		echelle=echelle - 0.1
	if echelle<0.1 :
			echelle=0.1
	my_scale.echelle=echelle
	last_distance=distance

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch :
		if event.pressed :
			fingers[str(event.index)]=event.position
		else :
			fingers.erase(str(event.index))
	if event is InputEventScreenDrag :
		fingers[str(event.index)]=event.position
		if len(fingers)==2 :
			handle_zoom(event)
