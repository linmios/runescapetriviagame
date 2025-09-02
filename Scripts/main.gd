extends Control


@onready var question_scene: QuestionScene = $Control 
@onready var gameselectscene  : PackedScene = load("res://Scenes/fileselect.tscn")

@onready var menubuttons: VBoxContainer = $VBoxContainer
	

func _ready() -> void:
	question_scene.quit.connect(gamequit)
	
	
	var dir : DirAccess = DirAccess.open("user://")
	if(not dir.dir_exists("Images")):
		dir.make_dir("Images")
	

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_loadandedit_pressed() -> void:
	var selectfile : Node = gameselectscene.instantiate()
	add_child(selectfile)
	selectfile.selected.connect(setupeditor)

func setupeditor(filepath : String):
	
	var editscene : PackedScene = load("res://Scenes/gameeditor.tscn")
	var editgame : Node = editscene.instantiate()
	add_child(editgame)
	editgame.loadfile(filepath)



func _on_makenew_pressed() -> void:
	var editscene : PackedScene = load("res://Scenes/gameeditor.tscn")
	var editgame : Node = editscene.instantiate()
	add_child(editgame)

func gamequit():
	question_scene.visible = false
	menubuttons.visible = true


func _on_loadandplay_pressed() -> void:
	var selectfile : Node = gameselectscene.instantiate()
	add_child(selectfile)
	selectfile.selected.connect(startgame)


func startgame(filepath : String):
	
	var game = Game.new()
	game.loadfrompath(filepath)
	menubuttons.visible = false
	question_scene.visible = true
	question_scene.setgame(game)
	print("Start game at : " + filepath)
