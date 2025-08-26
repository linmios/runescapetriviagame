extends Control

var game : Game = load("res://gamedata/testgame.tres")
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

func gamefinished():
	
	question_scene.queue_free()
	

func updatescene():
	
	question_scene.setquestion(game.getquestion())
	question_scene.newquestion()
	


func _on_questionstagecompleted() -> void:
	game.nextquestion()
	updatescene()
