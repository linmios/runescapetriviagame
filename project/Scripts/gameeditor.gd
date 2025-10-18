extends Control

## the game that we will edit
var game : Game = Game.new()

## the current question that is being edited and displayed in the UI
var currentquestion : Question

var folderselected : bool = false

##UI elements
#region
@onready var primaryimage: TextureRect = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/TextureRect
@onready var revealimage: TextureRect = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/TextureRect

@onready var savebutton: Button = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Button2

@onready var difficultyselect: OptionButton = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer3/OptionButton

@onready var questionlist: ItemList = $VBoxContainer/HBoxContainer/VBoxContainer/ItemList

@onready var mainquestionedit: TextEdit = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer3/TextEdit

@onready var correctanswer: TextEdit = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/TextEdit
@onready var correctanswerreveal: TextEdit = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/TextEdit2
@onready var decoy1answer: TextEdit = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer2/HBoxContainer/TextEdit
@onready var decoy1reveal: TextEdit = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer2/HBoxContainer/TextEdit2
@onready var decoy2answer: TextEdit = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer3/HBoxContainer/TextEdit
@onready var decoy2reveal: TextEdit = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer3/HBoxContainer/TextEdit2
@onready var decoy3answer: TextEdit = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer4/HBoxContainer/TextEdit
@onready var decoy3reveal: TextEdit = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer4/HBoxContainer/TextEdit2
@onready var decoy4answer: TextEdit = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer5/HBoxContainer/TextEdit
@onready var decoy4reveal: TextEdit = $VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer5/HBoxContainer/TextEdit2

#endregion

##file dialog for selecting images
@onready var file_dialog: FileDialog = $FileDialog
##the path of the selected file
var selectedfile : String = ""

##save folder file path
var filepathsave : String = ""

enum fileselectaction {Savefile, PrimaryImage, SecondaryImage}

var savefileaction : fileselectaction = fileselectaction.Savefile



func questionedited():
	##change color of save button to notify a change has been made
	savebutton.add_theme_color_override("font_color", Color.RED)
	

func setupui(newgame : Game):
	
	##set the game that we are editing
	self.game = newgame
	
	
	##setup questionlist and select first question here
	updatequestionlist()
	questionlist.item_selected.emit(0)
	questionlist.select(0)

func loadfile(filepath):
	
	##load existing game to edit from given filepath
	self.game.loadfrompath(filepath)
	
	##set up the questions and select the first question
	updatequestionlist()
	loadquestion(0)
	questionlist.select(0, true)
	##add folder name to text to avoid saving duplicates
	var foldername : String = filepath
	##remove path from folder name
	foldername = foldername.erase(0, 19)
	##set timer spinbox value to existing
	
	$VBoxContainer/HBoxContainer/VBoxContainer/SpinBox.value = self.game.timelimit
	



func loadquestion(index : int):
	##load a question
	##check if the question actually exists
	if(self.game.questions.size() > 0 and self.game.questions[index] != null):
		
		##change the current edited question to the new question
		self.currentquestion = self.game.questions[index]
		
		##change the tracking variable to the current index
		self.currentquestion.questionindex = index
		
		##seting up UI elements to loaded information
		#region
		primaryimage.texture = currentquestion.primaryimage
		revealimage.texture = currentquestion.revealimage
		
		difficultyselect.select(self.currentquestion.difficulty)
		
		mainquestionedit.text = currentquestion.question
		
		correctanswer.text = currentquestion.correctanswer.primaryanswer
		correctanswerreveal.text = currentquestion.correctanswer.revealanswer
		decoy1answer.text = currentquestion.decoyanswers[0].primaryanswer
		decoy1reveal.text = currentquestion.decoyanswers[0].revealanswer
		decoy2answer.text = currentquestion.decoyanswers[1].primaryanswer
		decoy2reveal.text = currentquestion.decoyanswers[1].revealanswer
		decoy3answer.text = currentquestion.decoyanswers[2].primaryanswer
		decoy3reveal.text = currentquestion.decoyanswers[2].revealanswer
		decoy4answer.text = currentquestion.decoyanswers[3].primaryanswer
		decoy4reveal.text = currentquestion.decoyanswers[3].revealanswer
		#endregion
	

func savecurrentquestion():
	
	##make sure we are not trying to save a null question
	if(self.currentquestion != null):
		
		
		##saving information from UI elements to question data
		#region
		currentquestion.primaryimage = primaryimage.texture
		currentquestion.revealimage = revealimage.texture
		
		currentquestion.question = mainquestionedit.text
		
		@warning_ignore("int_as_enum_without_cast")
		self.currentquestion.difficulty = difficultyselect.get_selected_id()
		
		currentquestion.correctanswer.primaryanswer = correctanswer.text
		currentquestion.correctanswer.revealanswer = correctanswerreveal.text
		currentquestion.decoyanswers[0].primaryanswer = decoy1answer.text
		currentquestion.decoyanswers[0].revealanswer = decoy1reveal.text 
		currentquestion.decoyanswers[1].primaryanswer = decoy2answer.text
		currentquestion.decoyanswers[1].revealanswer = decoy2reveal.text 
		currentquestion.decoyanswers[2].primaryanswer = decoy3answer.text
		currentquestion.decoyanswers[2].revealanswer = decoy3reveal.text
		currentquestion.decoyanswers[3].primaryanswer = decoy4answer.text 
		currentquestion.decoyanswers[3].revealanswer = decoy4reveal.text
		#endregion


func _on_questionlistitem_selected(index: int) -> void:
	##a new question has been selected so first we save the previous question
	savecurrentquestion()
	
	##check if it is last item
	if(index == questionlist.item_count-1):
		##it is the last item which is "New Question" so we are adding a new question
		
		## make new question
		self.currentquestion = Question.new()
		##tell new question what position it has in the question array
		self.currentquestion.questionindex = index
		self.game.questions.append(self.currentquestion)
		updatequestionlist()
		loadquestion(index)
	else:
		##otherwise load question clicked
		loadquestion(index)
	

func updatequestionlist():
	
	questionlist.clear()
	
	if(self.game.questions.size() < 1):
		self.game.questions.append(Question.new())
	
	for x in self.game.questions.size():
		questionlist.add_item("Question : " + str(x))
	
	questionlist.add_item("(+) Add New Question")
	



func _on_selectmainimage_pressed() -> void:
	file_dialog.invalidate()
	savefileaction = fileselectaction.PrimaryImage
	file_dialog.visible = true
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE


func _on_selectrevealimage_pressed() -> void:
	file_dialog.invalidate()
	savefileaction = fileselectaction.SecondaryImage
	file_dialog.visible = true
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE


func _on_save_pressed() -> void:
	
	if(folderselected):
		savebutton.add_theme_color_override("font_color", Color.WHITE)
		
		##save time limit value
		self.game.timelimit = $VBoxContainer/HBoxContainer/VBoxContainer/SpinBox.value
		
		savecurrentquestion()
		
		##get array of dictionary from game.save
		
		self.game.savegame(filepathsave)
	else:
		file_dialog.invalidate()
		savefileaction = fileselectaction.Savefile
		file_dialog.visible = true
		file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR




func _on_exit_pressed() -> void:
	self.queue_free()


func _on_file_dialog_confirmed() -> void:
	
	if(savefileaction != fileselectaction.Savefile):
		
		var image = Image.new()
		image.load(self.selectedfile)
		if(image != null):
			var texture = ImageTexture.new()
			#texture.create_from_image(image)
			texture.set_image(image)
			
			if(self.addtoprimary):
				self.primaryimage.texture = texture
			else:
				self.revealimage.texture = texture
	else:
		folderselected = true
		_on_save_pressed()

func _on_file_dialog_file_selected(path: String) -> void:
	self.selectedfile = path


func _on_file_dialog_dir_selected(dir: String) -> void:
	if(savefileaction == fileselectaction.Savefile):
		filepathsave = dir
