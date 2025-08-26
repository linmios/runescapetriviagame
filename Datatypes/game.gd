extends Resource
class_name Game
##questions in the game
@export var questions : Array[Question]
##no question has been selected yet
@export var currentquestion : int = -1

signal newquestion
signal finished


func nextquestion():
	##skips to the next question and emits newquestion
	self.currentquestion += 1
	


func getquestion() -> Question:
	##returns question
	if(self.currentquestion == -1):
		return null
	elif(self.currentquestion == self.questions.size()):
		finished.emit()
		return
	## adds the number which the question is to the question so it knows which index it is in
	self.questions[currentquestion].thisquestion = self.currentquestion
	return self.questions[currentquestion]
