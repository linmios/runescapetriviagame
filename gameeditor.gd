extends Control


var game : Game = Game.new()
var currentquestion : Question
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

func _ready() -> void:
	##for DEBUG
	setupui(self.game)


func questionedited():
	##change color of save button to notify a change has been made
	savebutton.add_theme_color_override("font_color", Color.RED)
	

func setupui(newgame : Game):
	
	self.game = newgame
	
	##setup questionlist and select first question here
	updatequestionlist()
	questionlist.item_selected.emit(0)
	questionlist.select(0)



func loadquestion(index : int):
	
	if(self.game.questions.size() > 0 and self.game.questions[index] != null):
		self.currentquestion = self.game.questions[index]
		
		self.currentquestion.thisquestion = index
		
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
		
	

func savecurrentquestion():
	
	if(self.currentquestion != null):
		
		currentquestion.primaryimage = primaryimage.texture
		currentquestion.revealimage = revealimage.texture
		
		currentquestion.question = mainquestionedit.text
		
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
	


func _on_questionlistitem_selected(index: int) -> void:
	##if previous question is not null, save it
	savecurrentquestion()
	
	##check if is last item
	if(index == questionlist.item_count-1):
		##new item pressed
		self.currentquestion = Question.new()
		self.currentquestion.thisquestion = index
		##it is last item, add a new question and load it
		self.game.questions.append(self.currentquestion)
		updatequestionlist()
		loadquestion(index)
	else:
		##otherwise load question clicked
		loadquestion(index)
	

func updatequestionlist():
	
	questionlist.clear()
	
	for x in self.game.questions.size():
		questionlist.add_item("Question : " + str(x))
	
	questionlist.add_item("(+) Add New Question")
	


func _on_selectmainimage_pressed() -> void:
	pass # Replace with function body.


func _on_selectrevealimage_pressed() -> void:
	pass # Replace with function body.


func _on_save_pressed() -> void:
	
	
	savebutton.add_theme_color_override("font_color", Color.WHITE)
	
	savecurrentquestion()
	
	var foldername : String = $VBoxContainer/HBoxContainer/VBoxContainer/TextEdit.text
	
	if(foldername == ""):
		return
	
	##get array of dictionary from game.save
	
	var data : Array[Dictionary] = self.game.savegame()
	
	var savepath : String =  "user://Triviagames/" + foldername + "/"
	
	
	
	
	
	var file = FileAccess.open(savepath+"GameData.bin", FileAccess.WRITE)
	
	if(file == null):
		DirAccess.make_dir_absolute(savepath)
		file = FileAccess.open(savepath+"GameData.bin", FileAccess.WRITE)
	
	var jstr
	
	for x in data:
		jstr = JSON.stringify(x)
		file.store_line(jstr)
	
	file.close()
	


func _on_exit_pressed() -> void:
	self.queue_free()
