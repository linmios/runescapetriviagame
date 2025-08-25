extends Resource
class_name Question

##main question
@export_multiline var question : String = ""

##image for question
@export var image : Texture2D

##answer that is correct
@export var correctanswer : String = ""

##4 answers that is incorrect
@export var decoyanswers : Array[String] = []

#which question this is in the list of questions
var thisquestion : int = -1

func getquestion(index : int) -> String:
	
	## returns correct answer or decoy answers
	if(index == 0):
		return correctanswer
	else:
		return decoyanswers[index - 1]
	
	
