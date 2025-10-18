extends Resource
class_name Answer

##the answer that is reveal at the beginning of the question
@export var primaryanswer : String = ""
##the answer that is reveal when the correct answer has been revealed (Optional)
@export var revealanswer : String = ""

func getprimary() -> String:
	##returns primary answer
	return self.primaryanswer

func getreveal() -> String:
	##checks if there is a revealanswer, if not returns just normal answer
	if(self.revealanswer == "" or self.revealanswer == null):
		return self.primaryanswer
	else:
		return self.revealanswer
