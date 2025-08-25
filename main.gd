extends Control

var game : Game = load("res://gamedata/testgame.tres")
@onready var question_scene: QuestionScene = $Control 

func _ready() -> void:
	await get_tree().physics_frame
	##
	game.connect("newquestion", updatescene)

func _input(event: InputEvent) -> void:
	if(event is InputEventKey):
		if(event.keycode == KEY_SPACE and event.is_pressed()):
			question_scene.newstage()


func updatescene():
	
	question_scene.setquestion(game.getquestion())
	question_scene.newquestion()
	


func _on_questionstagecompleted() -> void:
	game.nextquestion()
	updatescene()
