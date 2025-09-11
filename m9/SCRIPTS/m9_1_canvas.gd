extends Node2D

#ENGINE
var ratio #zoom of the cameran used to deduce the screen size on the canvas
var screen_min #minimum value visible on the camera
var screen_max #maximum value visible on the camera
var screen_size #Total size of the camera in canvas's pixel
var cam_offset #Movements of the camera along the y axis (through touch drag) used to adapt draw()
var current_range #Range of value visible on screen between screen_min and screen_max
var blocs = [] #Positions of the blocs 

#SCALE DIMENSION
var base_offset = Vector2(20,20)
var offset

#SCALE CARACTERISTICS
var current_unit
var current_dec

#SCALE STYLE
@export var scale_color : Color
@export var line_color : Color
@onready var parent = get_parent()
@onready var camera = $"../camera"
var base_line_thick = 2
var base_line_width = 30
var base_dec_thick = 6
var base_dec_width = 60
var base_dashed_thick = 3
var base_dashed_width = 40
var base_scale_font = 30
var line_thick
var line_width
var dec_thick
var dec_width
var dashed_thick = 4
var dashed_width = 40
var scale_font

#DEBUG
var pos_of_finger

func _process(float) :
	queue_redraw()

func _draw() :
	#Use the camera ratio to deduce the size of the camera on the canvas, and the visible min and max values
	ratio = camera.zoom.x
	cam_offset=camera.position-Vector2(parent.view.get_visible_rect().size.x/2/ratio,parent.view.get_visible_rect().size.y/2/ratio)
	offset=base_offset/ratio

	screen_size = parent.view.get_visible_rect().size.y/ratio
	screen_min = int( cam_offset.y + offset.y  )
	screen_max = int( cam_offset.y + screen_size - offset.y*2 )
	
	#Adapt the style to the ratio	
	line_thick = base_line_thick / ratio
	line_width = base_line_width / ratio
	dec_thick = base_dec_thick / ratio
	dec_width = base_dec_width  / ratio
	dashed_thick = base_dashed_thick / ratio
	dashed_width = base_dashed_width  / ratio
	scale_font = base_scale_font / ratio
	
	#BASELINE
	draw_line(Vector2(cam_offset.x+offset.x,screen_min),Vector2(cam_offset.x+offset.x,screen_max),scale_color,10/ratio/2)
	#SCREEN_MIN
	draw_line(Vector2(cam_offset.x+offset.x-3/ratio,screen_min),Vector2(cam_offset.x+offset.x+10/ratio,screen_min),scale_color,line_thick)
	draw_string(ThemeDB.fallback_font,Vector2(cam_offset.x+offset.x+15/ratio,screen_min+scale_font*0.4),str(screen_min),HORIZONTAL_ALIGNMENT_LEFT,-1,scale_font)
	#SCREEN_MAX
	draw_line(Vector2(cam_offset.x+offset.x-3/ratio,screen_max),Vector2(cam_offset.x+offset.x+10/ratio,screen_max),scale_color,line_thick)
	draw_string(ThemeDB.fallback_font,Vector2(cam_offset.x+offset.x+15/ratio,screen_max+scale_font*0.4),str(screen_max),HORIZONTAL_ALIGNMENT_LEFT,-1,scale_font)

	#RANGE
	#Calc the range and choose how the scale will be displayed
	current_range = abs(screen_max-screen_min)
	if current_range<150 :
		current_unit = 1
		current_dec = 10
	elif current_range<500 :
		current_unit = 5
		current_dec = 50
	elif current_range<1500 :
		current_unit = 10
		current_dec = 100
	else :
		current_unit = 50
		current_dec = 500

	#NUMBERS
	#Show the decimals
	#Declare the closer decimals from screen_min
	var first_dec = screen_min - screen_min%current_dec
	#Add the decimals on all the visible space
	for i in range(1,(current_range/current_dec)+1) :
		draw_line(Vector2(cam_offset.x+offset.x-3/ratio,first_dec+current_dec*i),Vector2(cam_offset.x+offset.x+20/ratio,first_dec+current_dec*i),scale_color,dec_thick)
		draw_dashed_line(Vector2(cam_offset.x+offset.x+110/ratio,first_dec+current_dec*i),Vector2(cam_offset.x+offset.x+1000/ratio,first_dec+current_dec*i),scale_color,line_thick/2,line_thick*10)
		draw_string(ThemeDB.fallback_font,Vector2(cam_offset.x+offset.x+25/ratio,first_dec+current_dec*i+scale_font*0.4),str(first_dec+current_dec*i)+" "+parent.unit,HORIZONTAL_ALIGNMENT_LEFT,-1,scale_font)


	#Show the units
	#Declare the closer unit from screen_min
	var first_unit = screen_min - screen_min%current_unit
	#Add the units on all the visible space
	for i in range(1,(current_range/current_unit)+1) :
		draw_line(Vector2(cam_offset.x+offset.x-3/ratio,first_unit+i*current_unit),Vector2(cam_offset.x+offset.x+10/ratio,first_unit+i*current_unit),scale_color,line_thick)

	#DASHED LINES

	for bloc in parent.BLOCS :
		if bloc.in_inventory==false :
			draw_dashed_line(Vector2(cam_offset.x+offset.x,bloc.position.y),Vector2(bloc.position.x+2,bloc.position.y),line_color,dashed_thick,dashed_thick*5)

	#DEBUG
	#Show position of finger touching screen on canvas
	for finger in parent.fingers :
		pos_of_finger = parent.fingers[finger] / ratio + cam_offset
		draw_circle(pos_of_finger,10/ratio*3,scale_color)
		draw_string(ThemeDB.fallback_font,pos_of_finger,str(pos_of_finger),HORIZONTAL_ALIGNMENT_LEFT,-1,scale_font)
