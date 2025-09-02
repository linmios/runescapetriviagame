extends Control
class_name QuestionScene

@onready var questionlabel: Label = $VBoxContainer/PanelContainer/MarginContainer/Label
@onready var image: TextureRect = $VBoxContainer/PanelContainer2/MarginContainer/TextureRect

@onready var questioncounter: Label = $VBoxContainer/Label2


##answers 
@onready var label: Label = $VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/Label
@onready var label1: Label = $VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/Label
@onready var label2: Label = $VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer3/MarginContainer/Label
@onready var label3: Label = $VBoxContainer/VBoxContainer/HBoxContainer2/PanelContainer4/MarginContainer/Label
@onready var label4: Label = $VBoxContainer/VBoxContainer/HBoxContainer2/PanelContainer5/MarginContainer/Label

##progressbar for the timer
@onready var progress_bar: TextureProgressBar = $MarginContainer/ProgressBar

@onready var timer: Timer = $Timer


@onready var labels : Array[Label] = [label, label1, label2, label3, label4]

var question : Question

var currentorder : Array[int]

var game : Game 

##each click advances a stage. To gradually show different information
var UIstage : int = 0

var correctanswer : int

signal quit

func setquestion(newquestion : Question):
	##sets the question that is currently active in the seen
	if(newquestion != null):
		self.question = newquestion

func _process(delta: float) -> void:
	if(not timer.is_stopped()):
		##update the timer
		progress_bar.value = 60-timer.time_left


func newquestion():
	
	resetallinfo()
	
	newstage()
	

func _input(event: InputEvent) -> void:
	if(event is InputEventKey and self.visible == true):
		if(event.keycode == KEY_SPACE and event.is_pressed()):
			self.newstage()
		elif(event.keycode == KEY_LEFT and event.is_pressed()):
			self.goback()

func setgame(game : Game):
	self.game = game
	
	questionlabel.text = ""
	
	updatescene()
	resetallinfo()
	
	


func goback():
	
	UIstage -= 1
	
	if(UIstage < 0 or self.question.thisquestion == 0):
		newstage()
		setupquestion()
	else:
		UIstage = 0
		goback()
		return
	
	
	
	

func newstage():
	
	if(self.question == null):
		_on_questionstagecompleted()
		return
	
	##sets up UI after new question
	match self.UIstage:
		0: ##show just question
			setupquestion()
		1: ##show answers
			setupanswers()
		2: ##show correct answer
			showcorrect()
		3: ##new question
			UIstage = 0
			_on_questionstagecompleted()
			return
			
	
	UIstage += 1


func updatescene():
	
	self.setquestion(self.game.getquestion())
	self.newquestion()
	
	if(self.game.currentquestion != -1):
		questioncounter.text = "Question " + str(self.game.currentquestion+1) + "/" + str(self.game.questions.size())
	else:
		questioncounter.text = ""


func _on_questionstagecompleted() -> void:
	self.game.nextquestion()
	updatescene()


func _on_backaquestion() -> void:
	self.game.backquestion()
	updatescene()


func setupquestion():
	
	self.questionlabel.text = self.question.getdiffasString() + "\nQuestion : " + str(self.question.thisquestion+1) + "\n" +   self.question.question
	self.image.texture = self.question.primaryimage
	
	expandtext(self.questionlabel)
	
	##reset color back to white
	for x in self.labels:
		x.self_modulate = Color.WHITE

func expandtext(label : Label): 
	
	var size : int = 60
	label.add_theme_font_size_override("font_size", size)
	
	while (label.size.x > 499 or label.size.y > 122):
		label.add_theme_font_size_override("font_size", size)
		size -= 1
		if(size < 20):
			break


func setupanswers():
	
	##shuffles the answers, 0 being the correct answer
	var order : Array[int] = [0, 1, 2, 3 ,4]
	order.shuffle()
	self.currentorder = order
	##sets the suffled answers to the labels in the UI
	for x in order.size():
		
		
		if(order[x] == 0):
			##this is the correct question
			self.correctanswer = x
		labels[x].text = getoptionfromnumber(x) + self.question.getquestion(order[x])
		expandtext(labels[x])
	
	##start the timer
	timer.start(60.0)

func getoptionfromnumber(num : int) -> String:
	
	match num:
		0:
			return " A : "
		1:
			return " B : "
		2:
			return " C : "
		3:
			return " D : "
		4:
			return " E : "
	
	return " A : "


func showcorrect():
	
	print("Question : " + str(self.question.thisquestion) + ", Correct : " + str(self.correctanswer))
	self.labels[self.correctanswer].self_modulate = Color.GREEN
	self.image.texture = self.question.getreavealimage()
	for x in self.currentorder.size():
		if(self.currentorder[x] == 0):
			##this is the correct question
			self.correctanswer = x
		labels[x].text = getoptionfromnumber(x) + self.question.getrevealanswer(self.currentorder[x])
		expandtext(labels[x])
	

func resetallinfo():
	
	for x in labels:
		x.text = ""


func _on_quit_pressed() -> void:
	quit.emit()
