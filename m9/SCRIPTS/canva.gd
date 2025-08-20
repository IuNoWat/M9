extends Control

#SCALE DIMENSION
var window_size = DisplayServer.window_get_size()
var x_offset = 30
var y_offset = 30
var scale_width = (window_size.x*0.20)-x_offset*2
var scale_heigth = (window_size.y)-y_offset*2

#SCALE CARACTERISTICS
var base_unit_interval = 10
var base_dec_interval = 50
var base_nb_visible_unit = int(scale_heigth/base_unit_interval)
var base_nb_visible_dec = int(scale_heigth/base_dec_interval)

var unit_interval
var dec_interval
var nb_visible_unit
var nb_visible_dec

var echelle = 1

#SCALE STYLE
@export var scale_color : Color
@export var line_color : Color
var line_thick = 2
var line_width = 15
var dec_thick = 4
var dec_width = 30

#ENGINE
var y_pos

var pos_of_blocs = []

func apply_scale(scale) :
	unit_interval = base_unit_interval * scale
	dec_interval = base_dec_interval * scale
	nb_visible_unit = int(scale_heigth/unit_interval)+1
	nb_visible_dec = int(scale_heigth/dec_interval)+1

func _draw() :
	
	apply_scale(echelle)
	
	draw_line(Vector2(x_offset,y_offset),Vector2(x_offset,y_offset+scale_heigth),scale_color,dec_thick)
	for i in range(0,nb_visible_unit) :
		y_pos=y_offset+unit_interval*i
		draw_line(Vector2(x_offset,y_pos),Vector2(x_offset+line_width,y_pos),scale_color,line_thick)
	for i in range(0,nb_visible_dec) :
		y_pos=y_offset+dec_interval*i
		draw_line(Vector2(x_offset,y_pos),Vector2(x_offset+dec_width,y_pos),scale_color,line_thick)
	
	for pos in pos_of_blocs :
		draw_dashed_line(Vector2(x_offset,pos.y),Vector2(pos.x+2,pos.y),line_color,2,5)

func _process(float) :
	queue_redraw()

func set_echelle(echelle) :
	echelle=echelle
	
	
	
