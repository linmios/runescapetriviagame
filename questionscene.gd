extends Control
class_name QuestionScene

@onready var questionlabel: Label = $VBoxContainer/PanelContainer/Label
@onready var image: TextureRect = $VBoxContainer/PanelContainer2/MarginContainer/TextureRect
@onready var label: Label = $VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/Label
@onready var label1: Label = $VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/Label
@onready var label2: Label = $VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer3/MarginContainer/Label
@onready var label3: Label = $VBoxContainer/VBoxContainer/HBoxContainer2/PanelContainer4/MarginContainer/Label
@onready var label4: Label = $VBoxContainer/VBoxContainer/HBoxContainer2/PanelContainer5/MarginContainer/Label
@onready var progress_bar: TextureProgressBar = $MarginContainer/ProgressBar

@onready var timer: Timer = $Timer


@onready var labels : Array[Label] = [label, label1, label2, label3, label4]

var question : Question

var correctanswer : int

func setquestion(newquestion : Question):
	##sets the question that is currently active in the seen
	if(newquestion != null):
		self.question = newquestion

func _process(delta: float) -> void:
	if(not timer.is_stopped()):
		##update the timer
		progress_bar.value = 60-timer.time_left


func setup():
	##sets up UI after new question
	self.questionlabel.text  = "Question : " + str(self.question.thisquestion) + "\n" +   self.question.question
	self.image.texture = self.question.image
	
	##shuffles the answers, 0 being the correct answer
	var order : Array[int] = [0, 1, 2, 3 ,4]
	order.shuffle()
	
	##sets the suffled answers to the labels in the UI
	for x in order.size():
		labels[order[x]].text = self.question.getquestion(x)
	
	##start the timer
	timer.start(60.0)
	
