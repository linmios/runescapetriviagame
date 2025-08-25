extends Resource
class_name Question
@export_multiline var question : String = ""
@export var image : Texture2D

@export var correctanswer : String = ""

@export var decoyanswers : Array[String] = []

var thisquestion : int = -1

func getquestion(index : int) -> String:
	
	if(index == 0):
		return correctanswer
	else:
		return decoyanswers[index - 1]
	
	
