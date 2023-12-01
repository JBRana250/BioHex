extends Control

func draw_triangle(pos, dir, trianglesize, color):
	var a: Vector2 = pos + dir * trianglesize
	var b: Vector2 = pos + dir.rotated(2*PI/3) * trianglesize
	var c: Vector2 = pos + dir.rotated(4*PI/3) * trianglesize
	var points = PackedVector2Array([a, b, c])
	draw_polygon(points, PackedColorArray([color]))
	
class Vector:
	var vstart: Vector3 # Origin
	var vend: Vector3  # End
	var vwidth: float  # Line width
	var vcolor: Color  # Draw color
	var vperm: bool #Temp or perm

	func _init(_start, _end, _width, _color, _perm):
		vstart = _start
		vend = _end
		vwidth = _width
		vcolor = _color
		vperm = _perm

	func draw(node, camera):
		var start: Vector2 = camera.unproject_position(vstart)
		var end: Vector2 = camera.unproject_position(vend)
		node.draw_line(start, end, vcolor, vwidth)
		node.draw_triangle(end, start.direction_to(end), vwidth*2, vcolor)

func add_vector(_start, _end, _width, _color, _perm):
	if visible == true:
		vectors.append(Vector.new(_start, _end, _width, _color, _perm))
	
var vectors = []  # Array to hold all registered values.

func _process(_delta):
	if not visible:
		return
	queue_redraw()

func _draw():
	if !Globals.camera:
		return
	var camera = Globals.camera
	for vector in vectors:
		vector.draw(self, camera)
		if vector.vperm == false:
			vectors.erase(vector)
			
func _input(event):
	if Input.is_action_just_pressed("debugoverlay_savecurrentvectors") and event.is_action("debugoverlay_savecurrentvectors"):
		for vector in vectors:
			if vector.vperm == false:
				vector.vperm = true
	if Input.is_action_just_pressed("debugoverlay_clearcurrentvectors") and event.is_action("debugoverlay_clearcurrentvectors"):
		vectors.clear()
