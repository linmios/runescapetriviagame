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

func savegame(filepath : String):
	
	var dataarray : Array[Dictionary]
	
	for x in self.questions:
		dataarray.append(x.saveself())
	
	var savepath : String =  "user://Triviagames/" + filepath + "/"
	var folderpath : String = savepath
	
	var file = FileAccess.open(savepath+"GameData.bin", FileAccess.WRITE)
	
	if(file == null):
		DirAccess.make_dir_absolute(savepath)
		file = FileAccess.open(savepath+"GameData.bin", FileAccess.WRITE)
	
	var jstr
	
	for x in dataarray:
		jstr = JSON.stringify(x)
		file.store_line(jstr)
	
	file.close()
	
	
	##save images
	for x in self.questions.size():
		
		if(self.questions[x].primaryimage != null):
			var saveimage : Image = self.questions[x].primaryimage.get_image()
			saveimage.save_png(folderpath+str(x)+"A.png")
		if(self.questions[x].revealimage != null):
			var saveimage : Image = self.questions[x].revealimage.get_image()
			saveimage.save_png(folderpath+str(x)+"B.png")
	
	
	




func loadgame(data : Array[Dictionary]):
	
	self.questions = []
	
	for x in data.size():
		var loadedquestion = Question.new()
		loadedquestion.loadquestion(data[x])
		self.questions.append(loadedquestion)
	

func loadfrompath(loadpath : String):
	
	var file = FileAccess.open(loadpath + "/GameData.bin", FileAccess.READ) 
	
	var gamedata : Array[Dictionary]
	
	if(file.file_exists(loadpath + "/GameData.bin")):
		while file.get_position() < file.get_length():
			var dict = JSON.parse_string(file.get_line())
			gamedata.append(dict)
		file.close()
	
	self.loadgame(gamedata)
	
	
	
	##load images
	for x in self.questions.size():
		
		var revealimage : Image = Image.new()
		var primaryimage : Image = Image.new()
		
		if(FileAccess.file_exists(loadpath+"/"+str(x)+"A.png")):
			primaryimage.load(loadpath+"/"+str(x)+"A.png")
		if(FileAccess.file_exists(loadpath+"/"+str(x)+"B.png")):
			revealimage.load(loadpath+"/"+str(x)+"B.png")
		if(not primaryimage.is_empty()):
			self.questions[x].primaryimage = ImageTexture.create_from_image(primaryimage)
		if(not revealimage.is_empty()):
			self.questions[x].revealimage = ImageTexture.create_from_image(revealimage)
		
		
	
	
	
