extends Control

var game : Game 
@onready var question_scene: QuestionScene = $Control 
@onready var rules: Control = $rules


func _ready() -> void:
	await get_tree().physics_frame
	##
	game.connect("newquestion", updatescene)
	game.connect("finished", gamefinished)
	

func _input(event: InputEvent) -> void:
	if(event is InputEventKey):
		if(event.keycode == KEY_SPACE and event.is_pressed()):
			if(question_scene != null):
				if(question_scene.visible == false):
					rules.queue_free()
					question_scene.visible = true
				else:
					question_scene.newstage()
		elif(event.keycode == KEY_LEFT and event.is_pressed()):
			if(question_scene != null):
				question_scene.goback()

func gamefinished():
	
	question_scene.queue_free()
	

func updatescene():
	
	question_scene.setquestion(game.getquestion())
	question_scene.newquestion()
	

func _on_questionstagecompleted() -> void:
	game.nextquestion()
	updatescene()


func _on_backaquestion() -> void:
	game.backquestion()
	updatescene()
	


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_loadandedit_pressed() -> void:
	pass # Replace with function body.


func _on_makenew_pressed() -> void:
	pass # Replace with function body.


func _on_loadandplay_pressed() -> void:
	pass # Replace with function body.
