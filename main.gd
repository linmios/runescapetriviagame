extends Control


@onready var question_scene: QuestionScene = $Control 
@onready var gameselectscene = load("res://fileselect.tscn")

@onready var menubuttons: VBoxContainer = $VBoxContainer


func gamefinished():
	
	question_scene.queue_free()
	

func _ready() -> void:
	question_scene.quit.connect(gamequit)


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_loadandedit_pressed() -> void:
	var selectfile = gameselectscene.instantiate()
	add_child(selectfile)
	selectfile.selected.connect(setupeditor)

func setupeditor(filepath : String):
	
	var editscene = load("res://gameeditor.tscn")
	var editgame = editscene.instantiate()
	add_child(editgame)
	editgame.loadfile(filepath)



func _on_makenew_pressed() -> void:
	var editscene = load("res://gameeditor.tscn")
	var editgame = editscene.instantiate()
	add_child(editgame)

func gamequit():
	question_scene.visible = false
	menubuttons.visible = true


func _on_loadandplay_pressed() -> void:
	var selectfile = gameselectscene.instantiate()
	add_child(selectfile)
	selectfile.selected.connect(startgame)


func startgame(filepath : String):
	
	var game = Game.new()
	game.loadfrompath(filepath)
	menubuttons.visible = false
	question_scene.visible = true
	question_scene.setgame(game)
	print("Start game at : " + filepath)
