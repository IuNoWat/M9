extends Node2D

#CONSTANTS
var abs_min = 0
var abs_max = 500
var min = 0
var max = 500

#SCALE DIMENSION
var x_offset = 50
var y_offset = 30


#SCALE CARACTERISTICS
var current_unit = 5
var current_dec = 50

#SCALE STYLE
@export var scale_color : Color
@export var line_color : Color
@onready var camera = $"../camera"
var line_thick = 2
var line_width = 15
var dec_thick = 4
var dec_width = 30
var scale_font = 16

#ENGINE
var y_pos
var base_add=4
var ratio = 1

var pos_of_blocs = []


func _draw() :
	#Define Ratio and units
	
	if ratio < 0.9 :
		current_unit = 50
		current_dec = 500
	elif ratio < 5 :
		current_unit = 10
		current_dec = 100
	else :
		current_unit = 1
		current_dec = 10

		
	

	
	
	#BASELINE
	draw_line(Vector2(x_offset,y_offset),Vector2(x_offset,y_offset+max),scale_color,dec_thick)
	
	#NUMBERS
	var num_of_dec=max/current_dec
	for i in range(0,num_of_dec+1) :
		var y=y_offset+i*current_dec
		draw_string(ThemeDB.fallback_font,Vector2(x_offset-scale_font*3.25,y+scale_font/3),str(min+i*current_dec),HORIZONTAL_ALIGNMENT_LEFT,-1,scale_font)
		draw_line(Vector2(x_offset-line_width,y),Vector2(x_offset+dec_width,y),scale_color,dec_thick)
	#UNITS
	var num_of_unit=max/current_unit
	for i in range(0,num_of_unit+1) :
		var y=y_offset+i*current_unit
		draw_line(Vector2(x_offset,y),Vector2(x_offset+line_width,y),scale_color,line_thick)
	

	for pos in pos_of_blocs :
		draw_dashed_line(Vector2(x_offset,pos.y),Vector2(pos.x+2,pos.y),line_color,line_thick,line_thick*10)

func update_scale(camera) :
	ratio = camera.zoom.x
	x_offset = 150 / ratio
	y_offset = 30 / ratio
	line_thick = 2 / ratio
	line_width = 30 / ratio
	dec_thick = 5 / ratio
	dec_width = 60 / ratio
	scale_font = 40 / ratio

func get_scale_offset() :
	return x_offset+dec_width

func _process(float) :
	update_scale(camera)
	queue_redraw()
