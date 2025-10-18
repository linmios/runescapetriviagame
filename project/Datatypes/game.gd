extends Resource
class_name Game
##questions in the game
@export var questions : Array[Question]
##which question the game is currently on, -1 being no question yet, on start it will +1 to 0, the first question
@export var currentquestion : int = -1

@export var timelimit : float = 0.0

##is emited when the last question has been displayed
signal finished

func nextquestion():
	##skips to the next question
	self.currentquestion += 1
	if(self.currentquestion > self.questions.size()):
		self.currentquestion = 0


func getquestion() -> Question:
	##returns question
	if(self.currentquestion == -1):
		return null
	elif(self.currentquestion == self.questions.size()):
		finished.emit()
		return
	## adds the number which the question is to the question so it knows which index it is in
	self.questions[currentquestion].questionindex = self.currentquestion
	return self.questions[currentquestion]


##saves the game into a GameData.bin in the given filepath, filepath here being name of the folder
func savegame(filepath : String):
	
	## the array of data which the questions are entered into
	var dataarray : Array[Dictionary]
	
	for x in self.questions:
		##each question returns itself as a dictionary
		dataarray.append(x.saveself())
	
	##the complete savepath
	var savepath : String =  filepath
	var folderpath : String = savepath
	
	##open the file
	var file : FileAccess = FileAccess.open(savepath+"/GameData.bin", FileAccess.WRITE)
	
	##if the folder doesnt exist we create it
	if(file == null):
		DirAccess.make_dir_absolute(savepath)
		##open the newly created file
		file = FileAccess.open(savepath+"/GameData.bin", FileAccess.WRITE)
	
	##saving the data from the array into a GameData.bin
	var jstr
	
	jstr = JSON.stringify(self.timelimit)
	file.store_line(jstr)
	
	for x in dataarray:
		jstr = JSON.stringify(x)
		file.store_line(jstr)
	
	file.close()
	
	
	##save images
	for x in self.questions.size():
		##checks if we have any questions in use and saves them as .png
		if(self.questions[x].primaryimage != null):
			var saveimage : Image = self.questions[x].primaryimage.get_image()
			saveimage.save_png(folderpath+str(x)+"A.png")
		if(self.questions[x].revealimage != null):
			var saveimage : Image = self.questions[x].revealimage.get_image()
			saveimage.save_png(folderpath+str(x)+"B.png")
	
	
	



##loads the game based on a data from a list of dicionaries
func loadgame(data : Array[Dictionary]):
	
	##resets the information
	self.questions = []
	
	for x in data.size():
		##creates the question
		var loadedquestion = Question.new()
		##sets the information
		loadedquestion.loadquestion(data[x])
		##adds it the the games list of questions
		self.questions.append(loadedquestion)
	

##self loading game from a filepath
func loadfrompath(loadpath : String):
	##opens the file
	var file : FileAccess = FileAccess.open(loadpath + "/GameData.bin", FileAccess.READ) 
	
	var gamedata : Array[Dictionary]
	
	if(FileAccess.file_exists(loadpath + "/GameData.bin")):
		
		##first read timelimit
		self.timelimit = JSON.parse_string(file.get_line())
		
		##while there is still data in the file we add it to the list
		while file.get_position() < file.get_length():
			var dict = JSON.parse_string(file.get_line())
			gamedata.append(dict)
		file.close()
	
	##sets all data of itself by the information loaded
	self.loadgame(gamedata)
	
	
	
	##load images
	for x in self.questions.size():
		
		var revealimage : Image = Image.new()
		var primaryimage : Image = Image.new()
		##checks if there is any .png files it can load for the corresponding questions
		if(FileAccess.file_exists(loadpath+"/"+str(x)+"A.png")):
			primaryimage.load(loadpath+"/"+str(x)+"A.png")
		if(FileAccess.file_exists(loadpath+"/"+str(x)+"B.png")):
			revealimage.load(loadpath+"/"+str(x)+"B.png")
		if(not primaryimage.is_empty()):
			self.questions[x].primaryimage = ImageTexture.create_from_image(primaryimage)
		if(not revealimage.is_empty()):
			self.questions[x].revealimage = ImageTexture.create_from_image(revealimage)
		
		
	
	
	
