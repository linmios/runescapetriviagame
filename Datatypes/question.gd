extends Resource
class_name Question

enum Difficulties {Easy, Medium, Hard, Elite, Master}

##main question
@export_multiline var question : String = ""

##image for question
@export var primaryimage : Texture2D
@export var revealimage : Texture2D

##answer that is correct
@export var correctanswer : Answer = Answer.new()

##4 answers that is incorrect
@export var decoyanswers : Array[Answer] = [Answer.new(),Answer.new(),Answer.new(),Answer.new()]

@export var difficulty : Difficulties = self.Difficulties.Easy

#which question this is in the list of questions
var thisquestion : int = -1

func getreavealimage() -> Texture2D:
	
	if(self.revealimage != null):
		return self.revealimage
	else:
		return self.primaryimage
	
	
func getdiffasString() -> String:
	return Difficulties.keys()[self.difficulty]

func getquestion(index : int) -> String:
	
	## returns correct answer or decoy answers
	if(index == 0):
		return self.correctanswer.primaryanswer
	else:
		return self.decoyanswers[index - 1].primaryanswer
	

func getrevealanswer(index : int) -> String:
	
	if(index == 0):
		return self.correctanswer.getreveal()
	else:
		return self.decoyanswers[index - 1].getreveal()
	

func saveself() -> Dictionary:
	var savedict : Dictionary = {
		"mainquestion" : self.question,
		"primarycorrect" : self.correctanswer.primaryanswer,
		"revealcorrect" : self.correctanswer.revealanswer,
		"primarydecoy1" : self.decoyanswers[0].primaryanswer,
		"revealdecoy1" : self.decoyanswers[0].revealanswer,
		"primarydecoy2" : self.decoyanswers[1].primaryanswer,
		"revealdecoy2" : self.decoyanswers[1].revealanswer,
		"primarydecoy3" : self.decoyanswers[2].primaryanswer,
		"revealdecoy3" : self.decoyanswers[2].revealanswer,
		"primarydecoy4" : self.decoyanswers[3].primaryanswer,
		"revealdecoy4" : self.decoyanswers[3].revealanswer,
		"difficulty" : self.difficulty,
	}
	
	
	return savedict

func loadquestion(dict : Dictionary):
	
	
	self.question = dict.get("mainquestion", "")
	self.correctanswer.primaryanswer = dict.get("primarycorrect", "")
	self.correctanswer.revealanswer = dict.get("revealcorrect", "")
	self.decoyanswers[0].primaryanswer = dict.get("primarydecoy1", "")
	self.decoyanswers[0].revealanswer = dict.get("revealdecoy1", "")
	self.decoyanswers[1].primaryanswer = dict.get("primarydecoy2", "")
	self.decoyanswers[1].revealanswer = dict.get("revealdecoy2", "")
	self.decoyanswers[2].primaryanswer = dict.get("primarydecoy3", "")
	self.decoyanswers[2].revealanswer = dict.get("revealdecoy3", "")
	self.decoyanswers[3].primaryanswer = dict.get("primarydecoy4", "")
	self.decoyanswers[3].revealanswer = dict.get("revealdecoy4", "")
	self.difficulty = dict.get("difficulty", self.Difficulties.Easy)
	
	
	
