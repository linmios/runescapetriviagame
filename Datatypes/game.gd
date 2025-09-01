extends Resource
class_name Game
##questions in the game
@export var questions : Array[Question]
##no question has been selected yet
@export var currentquestion : int = -1



signal newquestion
signal finished

func nextquestion():
	##skips to the next question
	self.currentquestion += 1

func backquestion():
	##skips to the previous question
	self.currentquestion -= 1
	if(self.currentquestion < 0):
		self.currentquestion = 0

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

func savegame() -> Array[Dictionary]:
	
	var returnarray : Array[Dictionary]
	
	for x in self.questions:
		returnarray.append(x.saveself())
	
	
	return returnarray

func loadgame(data : Array[Dictionary]):
	
	self.questions = []
	
	for x in data.size():
		var loadedquestion = Question.new()
		loadedquestion.loadquestion(data[x])
		self.questions.append(loadedquestion)
	

func loadfrompath(loadpath : String):
	
	var file = FileAccess.open(loadpath, FileAccess.READ) 
	
	var gamedata : Array[Dictionary]
	
	if(file.file_exists(loadpath)):
		while file.get_position() < file.get_length():
			var dict = JSON.parse_string(file.get_line())
			gamedata.append(dict)
		file.close()
	
	
	self.loadgame(gamedata)
