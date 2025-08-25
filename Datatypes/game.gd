extends Resource
class_name Game
##questions in the game
@export var questions : Array[Question]
##no question has been selected yet
@export var currentquestion : int = -1

func nextquestion():
	##skips to the next question and emits changed
	self.currentquestion += 1
	
	self.changed.emit()


func getquestion() -> Question:
	##returns question
	if(self.currentquestion == -1):
		return null
	## adds the number which the question is to the question so it knows which index it is in
	self.questions[currentquestion].thisquestion = self.currentquestion
	return self.questions[currentquestion]
