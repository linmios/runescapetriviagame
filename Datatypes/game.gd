extends Resource
class_name Game
@export var questions : Array[Question]
@export var currentquestion : int = -1

func nextquestion():
	
	self.currentquestion += 1
	
	self.changed.emit()


func getquestion() -> Question:
	if(self.currentquestion == -1):
		return null
	self.questions[currentquestion].thisquestion = currentquestion
	return self.questions[currentquestion]
