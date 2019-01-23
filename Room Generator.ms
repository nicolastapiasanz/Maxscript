-------------------------------------------------------------------------------------
-- Script Name:	RoomGenerator.ms
-- Compatible:		Max 2018 and up
-- Version:		v1.0
-- Release date:   23 January 2019
-- Code by:		Nicolás Tapia
------------------------------------------------------------------------------------

wallsValues = #() 		-- Walls Values: Width, Height, Depth
wallsName = #() 		-- Walls Names: SM_Wall1_
wallsArray = #() 			-- Walls Array: Elements

windowsValues = #() 	-- Windows Values: Width, Height, In Module Height
windowsName = #() 	-- Windows Names: SM_Wall1_SM_Window1
windowsArray = #() 	-- Windows Array: Elements


doorsValues = #()		-- Doors Values: Width, Height
doorsName = #()			-- Doors Names: SM_Wall1_SM_Door1
doorsArray = #()			-- Doors Array: Elements

roomArray = #()			-- Room Array: All the modules which compose the room
cornersArray = #()		-- Corners Array: The corner generated
modulesPosition = 0		-- The position of the modules

lengthArray = #()		-- Length Array: The modules which compose the length of the room including the corners
widthArray = #()			-- Width Array: The modules which compose the width of the room

------- WALL

-- Add a wall to list
function addWall =(
	append wallsValues RoomGenerator.widthWall.value
	append wallsValues RoomGenerator.heightWall.value
	append wallsValues RoomGenerator.depthWall.value
	
	insertItem ("SM_Wall"+ ((wallsName.count+1)) as string + "_") wallsName 1
	RoomGenerator.wallsList.items = wallsName
	RoomGenerator.wallsList.selection = 1
	updateWallValues (wallsValues.count / 3)
)

-- Update wall values
function updateWallValues sel =(
	if(wallsValues.count >= 1) do(
		numero = sel * 3
		first = numero - 2
		second = numero - 1
		third = numero
		
		RoomGenerator.widthWall.value =   wallsValues[first]
		RoomGenerator.heightWall.value = wallsValues[second]
		RoomGenerator.depthWall.value = wallsValues[third] 
	)
)

-- Update wall width
function updateWallWidth val wallChanged=(
	local wallToChange = wallChanged * 3 - 2
	wallsValues[wallToChange] = val
)

-- Update wall height
-- All the walls change
function updateWallHeight val wallChanged=(
	local index = 0
	while index < wallsName.count do(
		index += 1
		local wallValue = 3 * index - 1
		wallsValues[wallValue] = val
	)
)

-- Update wall depth
-- All the walls change
function updateWallDepth val =(
	local index = 0
	while index < wallsName.count do(
		index += 1
		local wallValue = 3 * index
		wallsValues[wallValue] = val
	)
)

-- Delete wall selected
function deleteWall wallSelected =(
	deleteItem wallsName wallSelected
	if(wallsName.count == 0) then(
		wallSelected = 1
	)else
		wallSelected = (wallsValues.count / 3) - wallSelected + 1
	
	local wallNumber = wallSelected * 3 - 2
	deleteItem wallsValues wallNumber
	deleteItem wallsValues wallNumber
	deleteItem wallsValues wallNumber
	RoomGenerator.wallsList.items = wallsName
	RoomGenerator.wallsList.selection = 1
	updateWallValues (wallsValues.count / 3)
)


------- WINDOW

-- Add a window to list
function addWindow =(
	append windowsValues RoomGenerator.widthWindow.value
	append windowsValues RoomGenerator.heightWindow.value
	append windowsValues RoomGenerator.heightMWindow.value
	insertItem ("SM_Window"+ ((windowsName.count + 1)) as string) windowsName 1
	RoomGenerator.windowsList.items = windowsName
	RoomGenerator.wallsList.selection = 1
	updateWindowValues (windowsValues.count / 3)
)

-- Update window values
function updateWindowValues sel =(
	if(windowsValues.count >= 1) do(
		numero = sel * 3
		first = numero - 2
		second = numero - 1
		third = numero
		
		RoomGenerator.widthWindow.value =   windowsValues[first]
		RoomGenerator.heightWindow.value = windowsValues[second]
		RoomGenerator.heightMWindow.value = windowsValues[third] 
	)
)

-- Update window width
function updateWindowWidth val windowChanged=(
	local windowToChange = windowChanged * 3 - 2
	windowsValues[windowToChange] = val
)

-- Update window height
function updateWindowHeight val windowChanged=(
	local windowToChange = windowChanged * 3 - 1
	windowsValues[windowToChange] = val
)

-- Update the initial height of the window in the wall
function updateWindowHeightM val windowChanged=(
	local windowToChange = windowChanged * 3
	windowsValues[windowToChange] = val
)

-- Delete window selected
function deleteWindow windowSelected =(
	deleteItem windowsName windowSelected
	if(windowsName.count == 0) then(
		windowSelected = 1
	)else
		windowSelected = (windowsValues.count / 3) - windowSelected + 1
	local windowNumber = windowSelected * 3 - 2
	deleteItem windowsValues windowNumber
	deleteItem windowsValues windowNumber
	deleteItem windowsValues windowNumber
	RoomGenerator.windowsList.items = windowsName
	RoomGenerator.windowsList.selection = 1
	updateWindowValues (windowsValues.count / 3)
)

------- DOOR

-- Add a door to list
function addDoor =(
	append doorsValues RoomGenerator.widthDoor.value
	append doorsValues RoomGenerator.heightDoor.value
	insertItem ("SM_Door"+ (doorsName.count + 1) as string) doorsName 1
	RoomGenerator.doorsList.items = doorsName
	RoomGenerator.doorsList.selection = 1
	updateDoorValues (doorsValues.count / 2)
)

-- Update door values
function updateDoorValues sel =(
	if(doorsValues.count >= 1) do(
		numero = sel * 2
		first = numero - 1
		RoomGenerator.widthDoor.value = doorsValues[first]
		RoomGenerator.heightDoor.value = doorsValues[numero]
	)
)

-- Update door width
function updateDoorWidth val doorChanged =(
	local nDoorWidth = doorChanged * 2 - 1
	doorsValues[nDoorWidth] = val
)

-- Update door height
function updateDoorHeight val doorChanged =(
	local nDoorHeight = doorChanged * 2
	doorsValues[nDoorHeight] = val
)

-- Delete door selected
function deleteDoor doorSelected =(
	deleteItem doorsName doorSelected
	if(doorsName.count == 0) then(
		doorSelected = 1
	)else
		doorSelected = (doorsValues.count / 2) - doorSelected + 1
	local doorNumber = doorSelected * 2 - 1
	deleteItem doorsValues doorNumber
	deleteItem doorsValues doorNumber
	RoomGenerator.doorsList.items = doorsName
	RoomGenerator.doorsList.selection = 1
	updateDoorValues (doorsValues.count / 2)
)


------- GENERATE MODULES
-- Generate the modules
function generateModules =(
	delete $*
	wallsArray =  #()
	windowsArray = #()
	doorsArray = #()
	cornersArray = #()
	if(wallsName.count >= 1) do(
		if(windowsName.count >= 1) do(
			generateWindows()
		)
		if(doorsName.count >= 1) do(
			generateDoors()
		)
		generateWalls()
		generateCorners()
	)
	modulesPosition = 0
	
)

-- Generate walls modules
function generateWalls =(
	local index = 0
	while index < wallsName.count do(
		index += 1
		local wallValue = (wallsValues.count / 3) - index + 1
		local widthTemp = wallsValues[(wallValue * 3 - 2)]
		local heightTemp = wallsValues[(wallValue * 3 - 1)]
		local depthTemp = wallsValues[(wallValue * 3)]
		local boxObj = Box height:heightTemp length:widthTemp width:depthTemp
		boxObj.pivot = [-depthTemp/2 , -widthTemp/2, 0]
		boxObj.name = wallsName[index]
		boxObj.pos = [-300,modulesPosition,0]
		append wallsArray boxObj
		convertTo boxObj Editable_Poly
		modulesPosition += widthTemp
		modulesPosition += 30
	)
	
	wallsArray = reverseArray wallsArray
)

-- Generate windows modules
function generateWindows =(
	local indexWindows = 0
	while indexWindows < windowsName.count do(
		indexWindows += 1
		local windowValue = (windowsValues.count / 3) - indexWindows + 1
		local widthWindow = windowsValues[(windowValue * 3 - 2)]
		local heightWindow = windowsValues[(windowValue * 3 - 1)]
		local heightMWindow = windowsValues[(windowValue * 3)]
		local indexWalls = 0
		while indexWalls < wallsName.count do(
			indexWalls += 1
			local wallValue = (wallsValues.count / 3) - indexWalls + 1
			local widthWall = wallsValues[(wallValue * 3 - 2)]
			local heightWall = wallsValues[(wallValue * 3 - 1)]
			local depthWall = wallsValues[(wallValue * 3)]
			if((heightMWindow + heightWindow) >= heightWall ) do(
				if(heightMWindow >= heightWall) do(
						heightMWindow = heightWall - 2
				)
				heightWindow = heightWall - heightMWindow - 1
			)
			if(widthWindow >= widthWall) do(
				widthWindow = widthWall - 2
			)
			local boxObj = Box height:heightMWindow length:widthWall width:depthWall lengthsegs:3
			convertTo boxObj Editable_Poly
			polyop.moveVert boxObj #{3..4, 11..12}[0,((widthWall/3 * 0.5) - (widthWindow * 0.5)),0]
			polyop.moveVert boxObj #{5..6, 13..14}[0,(-(widthWall/3 * 0.5) + (widthWindow * 0.5)),0]
			polyop.extrudeFaces boxObj #{4, 6} heightWindow
			polyop.extrudeFaces boxObj #{4, 6} (heightWall - heightWindow - heightMWindow)
			polyOp.setFaceSelection boxObj #{25, 27}
			boxObj.bridge selLevel: #Face --bridge the selected polygons
			boxObj.pivot = [-depthWall/2 , -widthWall/2, 0]
			boxObj.name = wallsName[indexWalls] + windowsName[indexWindows]
			boxObj.pos = [-300,modulesPosition,0]
			append windowsArray boxObj
			modulesPosition += widthWall
			modulesPosition += 30
		)
	)
	windowsArray = reverseArray windowsArray
)

-- Generate doors modules
function generateDoors =(
	local indexDoors = 0
	while indexDoors < doorsName.count do(
		indexDoors += 1
		local doorValue = (doorsValues.count / 2) - indexDoors + 1
		local widthDoor = doorsValues[(doorValue * 2 - 1)]
		local heightDoor = doorsValues[(doorValue * 2)]
		local indexWalls = 0
		while indexWalls < wallsName.count do(
			indexWalls += 1
			local wallValue = (wallsValues.count / 3) - indexWalls + 1
			local widthWall = wallsValues[(wallValue * 3 - 2)]
			local heightWall = wallsValues[(wallValue * 3 - 1)]
			local depthWall = wallsValues[(wallValue * 3)]
			if(heightDoor >= heightWall) do(
				heightDoor = heightWall - 1
			)
			if(widthDoor >= widthWall) do(
				widthDoor = widthWall - 1
			)
			
			local boxObj = Box height:heightWall length:widthWall width:depthWall heightsegs:2 lengthsegs:3
			convertTo boxObj Editable_Poly
			polyop.moveVert boxObj #{3..4, 11..12, 19, 24}[0,((widthWall/3 * 0.5) - (widthDoor * 0.5)),0]
			polyop.moveVert boxObj #{5..6, 13..14, 20, 23}[0,(-(widthWall/3 * 0.5) + (widthDoor * 0.5)),0]
			polyop.moveVert boxObj #{17..24}[0,0,((heightWall*0.5) - (heightWall - heightDoor))]
			setFaceSelection boxObj #{10, 18}
			boxObj.bridge selLevel: #Face --bridge the selected polygons
			polyop.deleteFaces boxObj #{2, 23}			
			boxObj.pivot = [-depthWall/2 , -widthWall/2, 0]
			boxObj.name = wallsName[indexWalls] + doorsName[indexDoors]
			boxObj.pos = [-300,modulesPosition,0]
			append doorsArray boxObj
			modulesPosition += widthWall
			modulesPosition += 30
		)
	)
	doorsArray = reverseArray doorsArray
)

-- Generate corners modules
function generateCorners =(
	local heightTemp = wallsValues[2]
	local depthTemp = wallsValues[3]
	local boxObj = Box height:heightTemp length:depthTemp width:depthTemp
	boxObj.pivot = [-depthTemp/2 , -depthTemp/2, 0]
	boxObj.name = ("SM_Corner_")
	boxObj.pos = [-300,modulesPosition,0]
	convertTo boxObj Editable_Poly
	append cornersArray boxObj
	modulesPosition += depthTemp
	modulesPosition += 30
	
)

------- GENERATE ROOM
-- Generate room
function generateRoom roomLength roomWidth xPos yPos zPos floorCount =(

	local widthWalls = #()
	local maxValue = 0
	local maxIndex = 0
	
	-- Clean old values
	checkValidNodes lengthArray
	checkValidNodes widthArray
	checkValidNodes roomArray
	
	cleanArray lengthArray
	cleanArray widthArray
	cleanArray roomArray
	
	-- Store width walls
	local index = 0
	while index < wallsName.count do(
		index += 1
		append widthWalls wallsValues[(index * 3 - 2)]		
	)
	
	-- ROOM LENGTHS
	-- First corner
	local newCorner = instance cornersArray[1]
	newCorner.pos = [xPos,yPos,zPos]
	yPos += wallsValues[3]
	-- Add to lengthArray
	append lengthArray newCorner
	
	-- New copies from arrays to not lose them
	local arrayWalls = copy wallsArray #nomap
	local arrayWidth = copy widthWalls #nomap
	-- Reverse array to access easier
	arrayWalls = reverseArray arrayWalls
	arrayWidth = reverseArray arrayWidth
	-- Generate length walls
	generateLength roomLength arrayWidth arrayWalls xPos yPos zPos
	
	-- Duplicate the walls
	local i = 0
	local size = lengthArray.count
	while i < size do(
		i += 1
		local newWall = instance lengthArray[i]
		newWall.pos.x += (roomWidth + wallsValues[3])
		append lengthArray newWall
		append roomArray newWall
	)
	
	-- ROOM WIDTHS
	-- New copies from arrays to not lose them
	local arrayWalls2 = copy wallsArray #nomap
	local arrayWidth2 = copy widthWalls #nomap
	-- Reverse array to access easier
	arrayWalls2 = reverseArray arrayWalls2
	arrayWidth2 = reverseArray arrayWidth2
	-- Generate width walls
	generateWidth roomWidth arrayWidth2 arrayWalls2 (xPos + wallsValues[3]) yPos zPos
	
	-- Duplicate the walls
	i = 0
	size = widthArray.count
	while i < size do(
		i += 1
		local newWall = instance widthArray[i]
		newWall.pos.y += (roomLength + wallsValues[3])
		append widthArray newWall
		append roomArray newWall
	)
	
	-- MORE FLOORS
	-- Duplicate old floors
	local count = 1
	local heightFloor = 0
	local sizeLength = lengthArray.count
	local sizeWidth = widthArray.count
	while count < floorCount do(
		
		count += 1
		heightFloor += wallsValues[2]
		i=0
		while i < sizeLength do(
			i += 1
			local newWall = instance lengthArray[i]
			newWall.pos.z += heightFloor
			append lengthArray newWall
			append roomArray newWall
		)
		
		i = 0
		while i < sizeWidth do(
			i += 1
			local newWall = instance widthArray[i]
			newWall.pos.z += heightFloor
			append widthArray newWall
			append roomArray newWall
		)
	)
	
	
)

-- Check valid nodes and delete them
function checkValidNodes arrayCheck =(
	for i = arrayCheck.count to 1 by -1 where not isValidNode arrayCheck[i] do( 
		deleteItem arrayCheck i
	)
)

-- Clean array
function cleanArray arrayTemp=(
	checkValidNodes arrayTemp
	for elem in arrayTemp do selectmore elem
	delete selection
	deselect $*
	checkValidNodes arrayTemp
)

-- Generate room length
function generateLength roomLength arrayWidth arrayWalls xPos yPos zPos =(
	local xPosition = xPos
	local yPosition = yPos
	local zPosition = zPos
	local restLength = roomLength
	local maxLength = amax (arrayWidth)
	local maxIndex = findItem arrayWidth maxLength
	if(maxLength <= roomLength) then(
		
		local newWall = instance arrayWalls[maxIndex]
		newWall.pos = [xPosition,yPosition,zPosition]
		yPosition += maxLength
		append lengthArray newWall
		append roomArray newWall
		restLength -= maxLength
	)else(
		deleteItem arrayWidth maxIndex
		deleteItem arrayWalls maxIndex

	)
	
	if(arrayWidth.count > 0) then(
		generateLength restLength arrayWidth arrayWalls xPosition yPosition zPosition
	)else(
		local newCorner = instance cornersArray[1]
		newCorner.pos = [xPosition,(yPosition + roomLength),zPosition]
		append lengthArray newCorner
		append roomArray newCorner
	)
	

)

-- Generate room width
function generateWidth roomWidth arrayWidth2 arrayWalls2 xPos yPos zPos =(
	local xPosition = xPos
	local yPosition = yPos
	local zPosition = zPos
	local restWidth = roomWidth
	local maxLength = amax (arrayWidth2)
	local maxIndex = findItem arrayWidth2 maxLength
	if(maxLength <= roomWidth) then(
		
		local newWall = instance arrayWalls2[maxIndex]
		newWall.pos = [xPosition,yPosition,zPosition]
		rot_newWall = eulerangles 0 0 -90
		rotate newWall rot_newWall
		xPosition += maxLength
		append widthArray newWall
		append roomArray newWall
		restWidth -= maxLength
	)else(
		deleteItem arrayWidth2 maxIndex
		deleteItem arrayWalls2 maxIndex
	)
	
	if(arrayWidth2.count > 0) then(
		generateWidth restWidth arrayWidth2 arrayWalls2 xPosition yPosition zPosition
	)
)

-- Reverse array
function reverseArray array1 =(
	array2 = #()
	for idx = array1.count to 1 by -1 do (append array2 array1[idx])
	return array2
)

-- Find a maxValue in array
function findMaxValue widthWalls =(
	local maxValue = 0
	local index = 0
	while index < widthWalls.count do(
		index += 1
		if(widthWalls[index] > maxValue) do(
			maxValue = widthWalls[index] 
		)
	)
	
	return maxValue
)


--- CHANGES
-- General Change Method
function ChangeModule modulesArray=(
	checkValidNodes roomArray
	local element = selection as array
	if(element[1] != undefined and modulesArray.count >= 1) do(
		elementName = element[1].name
		local nElement = 1
		local sElement = ""
		if(findString elementName "SM_Wall" == 1) do(
			sElement = "SM_Wall" + elementName[8]
			local index = 1
			while index <= modulesArray.count do(
			
				if(findString modulesArray[index].name sElement == 1) do(
					nElement = index
				)
				index += 1
			)
			
			local newElement = instance modulesArray[nElement]
			newElement.rotation  = element[1].rotation
			newElement.pos = element[1].pos
			
			index = 1
			while index < roomArray.count do(
			
				if(newElement.name == roomArray[index].name) do(
					delete roomArray[index]
				)
				index += 1
			)
			
			append roomArray newElement
			delete element[1]
			deselect $*
				
		)
	)
)

-- Change To Window
function ChangeToWindow =(
	ChangeModule windowsArray
)

-- Change To Door
function ChangeToDoor =(
	ChangeModule doorsArray
)

-- Change To Wall
function ChangeToWall =(
	ChangeModule wallsArray
)





-- UI
rollout RoomGenerator "Room Generator" width:808 height:488
(
	GroupBox 'geometryTitle' "Geometry" pos:[8,8] width:792 height:272 align:#left
	-- Walls
	listbox 'wallsList' "Walls" pos:[20,30] width:250 height:6 items:#("") align:#left 
 
	
	button 'wallButton' "Add Wall" pos:[20,135] width:250 height:20 align:#left
	button 'removeWallButton' "Remove Wall" pos:[20,158] width:250 height:20 align:#left
	
	GroupBox 'wallPropertiesTitle' "Wall Module Properties" pos:[20,180] width:250 height:52 align:#left
	spinner 'widthWall' "Width:" pos:[31,205] width:43 height:16 range:[0,255,100] align:#left
	spinner 'heightWall' "Height:" pos:[111,205] width:40 height:16 range:[110,255,255] align:#left
	spinner 'depthWall' "Depth:" pos:[192,205] width:42 height:16 range:[0,50,25] align:#left
	-- Windows
	listbox 'windowsList' "Windows" pos:[280,30] width:250 height:6 items:#("") align:#left
	
	button 'windowButton' "Add Window" pos:[280,135] width:250 height:20 align:#left
	button 'removeWindowButton' "Remove Window" pos:[280,158] width:250 height:20 align:#left
	
	GroupBox 'windowPropertiesTitle' "Window Module Properties" pos:[280,180] width:250 height:52 align:#left
	spinner 'widthWindow' "Width:" pos:[291,205] width:43 height:16 range:[0,150,60] type:#float align:#left
	spinner 'heightWindow' "Height:" pos:[371,205] width:40 height:16 range:[0,120,120] type:#float align:#left
	spinner 'heightMWindow' "MHeight" pos:[447,205] width:39 height:16 range:[40,200,100] type:#float align:#left
	-- Doors
	listbox 'doorsList' "Doors" pos:[540,30] width:250 height:6 items:#("") align:#left
	
	button 'doorButton' "Add Door" pos:[540,135] width:250 height:20 align:#left
	button 'removeDoorButton' "Remove Door" pos:[540,158] width:250 height:20 align:#left
	
	GroupBox 'doorPropertiesTitle' "Door Module Properties" pos:[568,180] width:172 height:52 align:#left
	spinner 'widthDoor' "Width:" pos:[579,205] width:43 height:16 range:[0,150,90] type:#float align:#left
	spinner 'heightDoor' "Height:" pos:[659,205] width:40 height:16 range:[0,210,210] type:#float align:#left
	
	button 'modulesButton' "Generate Modules" pos:[20,240] width:772 height:32 align:#left
	
	-------------
	
	GroupBox 'buildingsTitle' "Buildings" pos:[8,288] width:792 height:112 align:#left
	-- Pivot
	GroupBox 'pivotTitle' "Pivot" pos:[22,313] width:146 height:81 align:#left
	spinner 'xPivot' "X" pos:[40,331] width:93 height:16 range:[-500,500,0] type:#float align:#left
	spinner 'yPivot' "Y" pos:[40,351] width:93 height:16 range:[-500,500,0] type:#float align:#left
	spinner 'zPivot' "Z" pos:[40,371] width:93 height:16 range:[-500,500,0] type:#float align:#left
	-- Building Properties
	GroupBox 'buildingsPropertiesTitle' "Building Properties" pos:[184,312] width:192 height:81 align:#left
	spinner 'floors' "Floors" pos:[192,328] width:148 height:16 range:[0,10,1] type:#integer align:#left
	spinner 'roomLength' "Room Length" pos:[192,350] width:111 height:16 range:[0,500,200] type:#float align:#left
	spinner 'roomWidth' "Room Width" pos:[192,372] width:117 height:16 range:[0,500,200] type:#float align:#left
	button 'roomButton' "Generate Room" pos:[400,310] width:384 height:75 align:#left
	
	-------------
	
	GroupBox 'changeTitle' "Change Mode" pos:[8,408] width:792 height:72 align:#left
	button 'windowChangeButton' "Change To Window" pos:[20,432] width:250 height:40 align:#left
	button 'doorChangeButton' "Change To Door" pos:[280,432] width:250 height:40 align:#left
	button 'wallChangeButton' "Change to Wall" pos:[540,432] width:250 height:40 align:#left
	
	-- WALL
	on wallsList selected sel do(
		local wallSelected = (wallsValues.count / 3) - sel + 1
		updateWallValues wallSelected
	)
	
	on wallButton pressed do
		addWall()
	
	on removeWallButton pressed do(
		if(wallsName.count >= 1) do(
			local wallSelected = wallsList.selection
			deleteWall wallSelected
		)
	)
	
	on widthWall changed val do(
		if(wallsValues.count >= 1) do(
				wallChanged = wallsList.selection
				wallChanged = (wallsValues.count / 3) - wallChanged + 1
				updateWallWidth val wallChanged
		)
	)
	
	on heightWall changed val do(
		if(wallsValues.count >= 1) do(
				wallChanged = wallsList.selection
				wallChanged = (wallsValues.count / 3) - wallChanged + 1
				updateWallHeight val wallChanged
		)
	)
	
	on depthWall changed val do(
		if(wallsValues.count >= 1) do(
				updateWallDepth val
		)
	)
	
	-- WINDOW
	on windowsList selected sel do(
		windowSelected = (windowsValues.count / 3) - sel + 1
		updateWindowValues windowSelected
	)
	
	on windowButton pressed do
		addWindow()
	
	on removeWindowButton pressed do(
		if(windowsName.count >= 1) do(
			local windowSelected = windowsList.selection
			deleteWindow windowSelected
		)
	)
	
	on widthWindow changed val do(
		if(windowsValues.count >= 1) do(
			windowChanged = windowsList.selection
			windowChanged = (windowsValues.count / 3) - windowChanged + 1
			updateWindowWidth val windowChanged
		)
	)
	
	on heightWindow changed val do(
		if(windowsValues.count >= 1) do(
			windowChanged = windowsList.selection
			windowChanged = (windowsValues.count / 3) - windowChanged + 1
			updateWindowHeight val windowChanged
		)
	)
	
	on heightMWindow changed val do(
		if(windowsValues.count >= 1) do(
			windowChanged = windowsList.selection
			windowChanged = (windowsValues.count / 3) - windowChanged + 1
			updateWindowHeightM val windowChanged
		)
	)
	
	-- DOOR
	on doorsList selected sel do(
		doorSelected = (doorsValues.count/2) - sel + 1
		updateDoorValues doorSelected
	)
	
	on doorButton pressed do
		addDoor()
	
	on removeDoorButton pressed do(
		if(doorsName.count >= 1) do(
			local doorSelected = doorsList.selection
			deleteDoor doorSelected
		)
	)
	
	on widthDoor changed val do(
		if(doorsValues.count >= 1) do(
			wDoorChange = doorsList.selection
			wDoorChange = (doorsValues.count / 2) - wDoorChange + 1
			updateDoorWidth val wDoorChange
		)
	)
	
	on heightDoor changed val do(
		if(doorsValues.count >= 1) do(
			hDoorChange = doorsList.selection
			hDoorChange = (doorsValues.count / 2) - hDoorChange + 1
			updateDoorHeight val hDoorChange
		)
	)
	
	-- GENERATE MODULES
	on modulesButton pressed do
		generateModules()
	
	-- GENERATE ROOM
	on roomButton pressed do(
		if(wallsArray.count >= 1) do(
			if(wallsName.count <= wallsArray.count) then(
					generateRoom roomLength.value roomWidth.value xPivot.value yPivot.value zPivot.value floors.value
			)else
				print("You have to create the modules first.")
		)
	)
	
	-- CHANGES
	on windowChangeButton pressed do(
		ChangeToWindow()
	)
	
	on doorChangeButton pressed do(
		ChangeToDoor()
	)
	
	on wallChangeButton pressed do(
		ChangeToWall()
	)
)

createDialog RoomGenerator