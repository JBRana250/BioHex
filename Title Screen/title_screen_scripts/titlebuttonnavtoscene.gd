extends ButtonNavToSceneScript

func _wait(seconds):
	var t = Timer.new()
	t.set_wait_time(seconds)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await(t.timeout)
	return

func _on_pressed():
	var color_lerp_step = 0
	var camera = Globals.camera
	
	camera.enabled = false
	
	for i in range(50):
		color_lerp_step += 0.1
		self_modulate = Color.WHITE.lerp(Color(0, 0, 0, 0), color_lerp_step)
		
		camera.position.z = lerp(float(camera.position.z), 0.0, 0.025)
		await(_wait(0.005))
	
	super()
