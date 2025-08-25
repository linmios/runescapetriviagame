extends Control

var game : Game = load("res://gamedata/testgame.tres")


func _ready() -> void:
	await get_tree().physics_frame
	game.connect("changed", updatescene)

func _input(event: InputEvent) -> void:
	if(event is InputEventKey):
		if(event.keycode == KEY_SPACE and event.is_pressed()):
			game.nextquestion()


func updatescene():
	var question_scene: QuestionScene = $Control
	question_scene.setquestion(game.getquestion())
	question_scene.setup()
	
