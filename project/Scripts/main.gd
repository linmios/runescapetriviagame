extends Control


@onready var question_scene: QuestionScene = $Control 
@onready var gameselectscene  : PackedScene = load("res://Scenes/fileselect.tscn")

@onready var menubuttons: VBoxContainer = $VBoxContainer
	

func _ready() -> void:
	##connect question scene quit signal to return to menu
	question_scene.quit.connect(gamequit)
	
	
	##makes sure there is one directory to keep images for easy access when creating
	##if there is one existing it doesnt create it
	var dir : DirAccess = DirAccess.open("user://")
	if(not dir.dir_exists("Images")):
		dir.make_dir("Images")
	

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_loadandedit_pressed() -> void:
	##loads scene to edit games, loads existing file
	var selectfile : Node = gameselectscene.instantiate()
	add_child(selectfile)
	selectfile.selected.connect(setupeditor)

func setupeditor(filepath : String):
	##sets up the editor based on file path
	var editscene : PackedScene = load("res://Scenes/gameeditor.tscn")
	var editgame : Node = editscene.instantiate()
	add_child(editgame)
	editgame.loadfile(filepath)



func _on_makenew_pressed() -> void:
	##starts editing scene but with brand new game
	var editscene : PackedScene = load("res://Scenes/gameeditor.tscn")
	var editgame : Node = editscene.instantiate()
	add_child(editgame)

func gamequit():
	##an ongoing trivia game was quit and returned to main menu
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
