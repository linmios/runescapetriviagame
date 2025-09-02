extends Control

##emits when a file path have been selected 
signal selected

##the file path that have been clicked in the itemlist
var pathselected : String = ""

##an item list displaying the found loadable saves
@onready var filelist: ItemList = $VBoxContainer/ItemList

##internal saving of filepaths that are referenced to when itemlist is selected
var filepaths : Array[String] = []

func _ready() -> void:
	
	##open directory where save games are stored
	var dir : DirAccess = DirAccess.open("user://Triviagames/")
	
	##adds each discovered savegame directory to the UI itemlist and internal Array for reference
	if dir:
		dir.list_dir_begin()
		var file_name : String = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				filepaths.append("user://Triviagames/" + file_name)
				filelist.add_item(file_name)
				print("Found directory: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	



func _on_select_pressed() -> void:
	##when the select button is pressed, we will emit the filepath and close the file select window
	selected.emit(self.pathselected)
	self.queue_free()


func _on_cancel_pressed() -> void:
	##close file select window
	self.queue_free()


func _on_file_selected(index: int) -> void:
	##we save the last clicked filepath to send if final select button is pressed.
	self.pathselected = self.filepaths[index]
