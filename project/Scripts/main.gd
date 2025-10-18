extends Control


@onready var question_scene: QuestionScene = $Control 
@onready var gamefileselect: FileDialog = $FileDialog

@onready var menubuttons: VBoxContainer = $VBoxContainer

enum loadfiletype {Play, Load}

var loadfileaction : loadfiletype = loadfiletype.Play

var temppathholder : String = ""

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
	gamefileselect.invalidate()
	loadfileaction = loadfiletype.Load
	gamefileselect.visible = true

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
	gamefileselect.invalidate()
	loadfileaction = loadfiletype.Play
	gamefileselect.visible = true


func startgame(filepath : String):
	
	var game = Game.new()
	game.loadfrompath(filepath)
	menubuttons.visible = false
	question_scene.visible = true
	question_scene.setgame(game)
	print("Start game at : " + filepath)


func _on_file_dialog_confirmed() -> void:
	if(temppathholder != ""):
		match loadfileaction:
			loadfiletype.Play:
				startgame(temppathholder)
			loadfiletype.Load:
				setupeditor(temppathholder)


func _on_file_dialog_dir_selected(dir: String) -> void:
	temppathholder = dir
