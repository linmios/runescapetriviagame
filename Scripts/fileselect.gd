extends Control

signal selected

var pathselected : String = ""

@onready var filelist: ItemList = $VBoxContainer/ItemList

var filepaths : Array[String] = []

func _ready() -> void:
	
	var dir = DirAccess.open("user://Triviagames/")
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				filepaths.append("user://Triviagames/" + file_name)
				filelist.add_item(file_name)
				print("Found directory: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	



func _on_select_pressed() -> void:
	
	selected.emit(self.pathselected)
	self.queue_free()


func _on_cancel_pressed() -> void:
	self.queue_free()


func _on_file_selected(index: int) -> void:
	self.pathselected = self.filepaths[index]
