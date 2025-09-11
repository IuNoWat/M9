extends Node2D

#CONSTANTS
var min = 0
var max = 5000
var mode = "FREE"
var unit_verbose = "litres d'eau"
var unit = "l"

#ONREADY
@onready var my_scale = %my_scale
@onready var my_camera = $camera
@onready var view = $".."
@onready var test = $camera/CanvasLayer/test
@onready var mode_toggle = $camera/CanvasLayer/toggle
@onready var inventory = $camera/CanvasLayer/Inventory

#ENGINE
var max_zoom=15
var min_zoom=0.25
var inventory_open = false

#POS
var BLOCS = []
@export var POS : PackedScene
var dragging=false

var fingers = {}
var other_pos = Vector2()
var distance = 0
var focus = 0
var last_distance = 0


var DATA = [
	{
		"text":"Une douche de 5 minutes",
		"good_y":50
	},
	{
		"text":"Une douche de 15 minutes",
		"good_y":150
	},
	{
		"text":"Un bain de 30 minutes",
		"good_y":200
	},
]

func mode_free() :
	mode = "FREE"

func mode_set(min,max,zoom) :
	mode = "SET"
	min=min
	max=max
	my_camera.zoom=Vector2(zoom,zoom)
	my_camera.position = Vector2(view.get_visible_rect().size.x/2/my_camera.zoom.x,view.get_visible_rect().size.y/2/my_camera.zoom.y)

func _ready() -> void:
	#Place Camera
	my_camera.position = Vector2(view.get_visible_rect().size.x/2/my_camera.zoom.x,view.get_visible_rect().size.y/2/my_camera.zoom.y)
	#Add POS from DATA
	for i in range(0,len(DATA)) :
		BLOCS.append(POS.instantiate())
		BLOCS[i].text=DATA[i]["text"]
		BLOCS[i].good_y=DATA[i]["good_y"]
		BLOCS[i].position.y=20+20*i
		BLOCS[i].position.x=25+25*i
		add_child(BLOCS[i])
	#Start in set mode
	mode_set(0,250,5)

func _process(delta: float) -> void :
	
	mode_toggle.text = mode # Show the current mode on the toogle button
	
	#Give my_scale the positiosn of the blocs so it can draw the dashed line
	var i = 0
	for entry in BLOCS :		
		entry.scale = Vector2(1 / my_camera.zoom.x,1/my_camera.zoom.y)
		if entry.in_inventory :
			entry.position.x=(inventory.position.x+30)/my_scale.ratio
			entry.position.y=(600+100*i)/my_scale.ratio
			print(entry.position)
		i+=1

func handle_zoom(event) :
	for key in fingers :
		if key!=str(event.index) :
			other_pos=fingers[key]
	distance=event.position.distance_to(other_pos)
	if distance>last_distance :
		my_camera.zoom=my_camera.zoom*1.05
		if my_camera.zoom.x>max_zoom :
			my_camera.zoom = Vector2(max_zoom,max_zoom)
	elif distance<last_distance:
		my_camera.zoom=my_camera.zoom*0.95
		if my_camera.zoom.x<min_zoom :
			my_camera.zoom = Vector2(min_zoom,min_zoom)
	last_distance=distance

func _input(event: InputEvent) -> void:
	#DEBUG
	if mode=="FREE" :
		if event is InputEventScreenTouch :
			if event.pressed :
				fingers[str(event.index)]=event.position
			else :
				fingers.erase(str(event.index))
		if event is InputEventScreenDrag :
			fingers[str(event.index)]=event.position
			if len(fingers)==1 and dragging==false :
				my_camera.position.y -= event.relative.y / my_scale.ratio
				if my_camera.position.y<my_scale.offset.y-(my_scale.base_offset.y*2/my_scale.ratio)+my_scale.screen_size/2 :
					my_camera.position.y=my_scale.offset.y-(my_scale.base_offset.y*2/my_scale.ratio)+my_scale.screen_size/2
				if my_camera.position.y>max-my_scale.current_range+my_scale.screen_size/2 :
					my_camera.position.y=max-my_scale.current_range+my_scale.screen_size/2
			if len(fingers)==2 and dragging==false :
				handle_zoom(event)


func _on_toggle_pressed() -> void:
	if mode == "FREE" :
		mode_set(0,250,5)
	else :
		mode_free()

func _on_test_pressed() -> void:
	var last_tween
	for entry in BLOCS :
		if entry.in_inventory==false and entry.position.y!=entry.good_y :
			var dist = abs(entry.position.y-entry.good_y)
			var tween = get_tree().create_tween()
			tween.tween_property(entry,"position",Vector2(entry.position.x,entry.good_y),2).set_ease(Tween.EASE_OUT)
			await tween.finished
			last_tween = tween
	#await last_tween.finished


func _on_inv_toggle_pressed() -> void:
	var tween = get_tree().create_tween()
	print(inventory.position)
	if inventory_open :
		tween.tween_property(inventory,"position",Vector2(888,545),0.5).set_ease(Tween.EASE_OUT)
		inventory_open=false
	else :
		tween.tween_property(inventory,"position",Vector2(588,545),0.5).set_ease(Tween.EASE_OUT)
		inventory_open=true
	await tween.finished
