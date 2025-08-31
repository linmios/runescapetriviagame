extends Resource
class_name Answer

@export var primaryanswer : String = ""
@export var revealanswer : String = ""

func getprimary() -> String:
	
	return self.primaryanswer

func getreveal() -> String:
	if(self.revealanswer == "" or self.revealanswer == null):
		return self.primaryanswer
	else:
		return self.revealanswer
