extends Control

#CONSTANTS
var abs_min = 500
var abs_max = 1000
var min = 500
var max = 1000

#SCALE DIMENSION
var window_size = DisplayServer.window_get_size()
var x_offset = 150
var y_offset = 30
var scale_width = (window_size.x*0.20)-x_offset*2
var scale_heigth = (window_size.y)-y_offset*2

#SCALE CARACTERISTICS
var ratio_1_pixel = scale_heigth/float(max-min)
var ratio_1_relatif = float(max-min)/scale_heigth
var current_unit = 5
var current_dec = 50

#SCALE STYLE
@export var scale_color : Color
@export var line_color : Color
var line_thick = 2
var line_width = 15
var dec_thick = 4
var dec_width = 30

#ENGINE
var y_pos
var base_add=4
var unit_offset=0

var pos_of_blocs = []


func _draw() :
	#Define Ratio and units
	ratio_1_pixel = scale_heigth/float(max-min)
	ratio_1_relatif = float(max-min)/scale_heigth
	var range=max-min
	if range<100 :
		current_unit = 5
		current_dec = 10
	elif range<300 :
		current_unit = 10
		current_dec = 50
	else :
		current_unit = 10
		current_dec = 100
	
	#BASELINE
	draw_line(Vector2(x_offset,y_offset),Vector2(x_offset,y_offset+scale_heigth),scale_color,dec_thick)
	
	#NUMBERS
	var num_of_dec=range/current_dec
	for i in range(0,num_of_dec+1) :
		var y=y_offset+i*current_dec*ratio_1_pixel
		draw_string(ThemeDB.fallback_font,Vector2(10,y+5),str(min+i*current_dec)+" ("+str(y)+")")
		draw_line(Vector2(x_offset-line_width,y),Vector2(x_offset+dec_width,y),scale_color,dec_thick)
	#UNITS
	var num_of_unit=range/current_unit
	for i in range(0,num_of_unit+1) :
		var y=y_offset+i*current_unit*ratio_1_pixel
		draw_line(Vector2(x_offset,y),Vector2(x_offset+line_width,y),scale_color,line_thick)
	

	for pos in pos_of_blocs :
		draw_dashed_line(Vector2(x_offset,pos.y),Vector2(pos.x+2,pos.y),line_color,2,5)

func zoom_in(focus) :
	var relative_focus=from_abs_to_rel(focus)
	
	var value = int((max-relative_focus)*base_add/min)
	print(value)
	min+=value
	max-=base_add-value

func zoom_out(focus) :
	var relative_focus=from_abs_to_rel(focus)
	var value = int((max-relative_focus)*base_add/min)
	print(value)
	min-=value
	max+=base_add-value


func from_abs_to_rel(coord) :
	return min+(coord-y_offset)/ratio_1_pixel
	#print((event.position.y+y_offset)*ratio_1_pixel)

func moove(value) :
	min-=value
	max-=value

func _process(float) :
	queue_redraw()
