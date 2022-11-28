properties = {}

numbers = {}
numbers[1] = 64 -- resolution x
numbers[2] = 64 -- resolution y
numbers[3] = 26 -- input 1 X
numbers[4] = 32 -- input 1 Y
numbers[5] = 30 -- input 2 X
numbers[6] = 30 -- input 2 Y


booleans = {}
booleans[1] = true -- input 1 pressed
booleans[2] = false -- input 2 pressed


function out(type, index, value)
	print(string.format("%s[%d]: %s", type, index, tostring(value)))
end

output = {
	setNumber = function(index, value)
		out("number", index, value)
	end, setBool = function(index, value)
		out("bool", index, value)
	end
}

input = {
	getNumber = function(index)
		return numbers[index]
	end, getBool = function(index)
		return booleans[index]
	end
}

property = {
	getNumber = function(index)
		return properties[index]
	end, getBool = function(index)
		return properties[index]
	end
}

screen = {
	getWidth = function()
		return numbers[1]
	end,
	getHeight = function()
		return numbers[2]
	end,
	drawRect = function(x, y, width, height)
		print("draw rect ", x, y, width, height)
	end,
	drawRectF = function(x, y, width, height)
		print("draw filled rect", x, y, width, height)
	end,
	setColor = function(r, g, b, a)

	end,
	drawLine = function(x1, y1, x2, y2)

	end,
	drawClear = function()
	end,

	drawTextBox = function(x, y, width, height, text, horizontalAlign, verticalAlign)
		print("draw text box", x, y, width, height, text, horizontalAlign, verticalAlign)
	end

}

-- end test class

function generateJoyPad(padX, padY, padWidth, padHeight)
	local midX = math.floor(padWidth / 2)
	local midY = math.floor(padHeight / 2)
	return { x = padX, y = padY, width = padWidth, height = padHeight, middleX = midX, middleY = midY, deadZone = 1, isPressed = false, lastPressed = false, pressedState = false, storedX = midX, storedY = midY, label = "" }
end

function checkPressedState(x, y, joyPad, toggle)
	local inside = x >= joyPad.x and y >= joyPad.y and x <= joyPad.x + joyPad.width and y <= joyPad.y + joyPad.height;
	joyPad.lastPressed = joyPad.isPressed
	joyPad.isPressed = isPressed and inside
	if toggle then
		if joyPad.lastPressed and not joyPad.isPressed then
			joyPad.pressedState = not joyPad.pressedState
		end
	else
		joyPad.pressedState = joyPad.isPressed
	end
	return joyPad.pressedState
end

function deadZoned(distance, middle, deadZone)
	if distance < 0 and (distance + deadZone) >= 0 then
		distance = 0
	elseif distance > 0 and (distance - deadZone) <= 0 then
		distance = 0
	end
	return math.floor((distance / middle) * 10) / 10
end

function checkJoyPad(x, y, joyPad)
	checkPressedState(x, y, joyPad, false)
	if joyPad.isPressed then
		joyPad.storedX = x - joyPad.x
		joyPad.storedY = y - joyPad.y
	end
	local xMove = joyPad.storedX - joyPad.middleX
	local xMoveR = deadZoned(xMove, joyPad.middleX, joyPad.deadZone)

	local yMove = joyPad.middleY - joyPad.storedY
	local yMoveR = deadZoned(yMove, joyPad.middleY, joyPad.deadZone)

	return xMoveR, yMoveR;
end

function onTick()
	inputX = input.getNumber(3)
	inputY = input.getNumber(4)
	isPressed = input.getBool(1)

	local firstFloorChosen = false;
	local secondFloorChosen = false;
	local thirdFloorChosen = false;

	lastFloor = floor
	if width ~= nil then
		local gridWidth = width / 3
		local gridHeight = height / 3
		if firstFloor == nil then
			local starterWidth = gridWidth
			local starterHeight = gridHeight
			firstFloor = generateJoyPad(gridWidth, 0, starterWidth, starterHeight)
			firstFloor.label = "1"
		end
		firstFloorChosen = checkPressedState(inputX, inputY, firstFloor, false)

		if secondFloor == nil then
			local starterWidth = gridWidth
			local starterHeight = gridHeight
			secondFloor = generateJoyPad(gridWidth, gridHeight, starterWidth, starterHeight)
			secondFloor.label = "2"
		end
		secondFloorChosen = checkPressedState(inputX, inputY, secondFloor, false)
		if thirdFloor == nil then
			local starterWidth = gridWidth
			local starterHeight = gridHeight
			thirdFloor = generateJoyPad(gridWidth, gridHeight * 2, starterWidth, starterHeight)
			thirdFloor.label = "3"
		end
		thirdFloorChosen = checkPressedState(inputX, inputY, thirdFloor, false)
	end

	if (firstFloorChosen) then
		floor = 0
	elseif (secondFloorChosen) then
		floor = 1
	elseif (thirdFloorChosen) then
		floor = 2
	else
		floor = lastFloor
	end
	output.setNumber(1, floor)
end

function drawShape(joyPad)
	if joyPad ~= nil then
		local x = joyPad.x
		local y = joyPad.y
		local w = joyPad.width
		local h = joyPad.height
		local t = joyPad.label
		if (t ~= "") then
			screen.drawTextBox(x, y, w, h, t, 0, 0)
		end
		if joyPad.isPressed or joyPad.pressedState then
			screen.drawRectF(x, y, w, h)
		else
			screen.drawRect(x, y, w, h)
		end
	end
end

function drawJoyPad(joyPad)
	if joyPad ~= nil then
		screen.setColor(255, 255, 255, 128)
		drawShape(joyPad)
		screen.drawLine(joyPad.x + joyPad.middleX, joyPad.y, joyPad.x + joyPad.middleX, joyPad.y + joyPad.height)
		screen.drawLine(joyPad.x, joyPad.y + joyPad.middleY, joyPad.x + joyPad.width, joyPad.y + joyPad.middleY)
		screen.setColor(255, 255, 255)
		screen.drawRect(joyPad.x + joyPad.storedX - 1, joyPad.y + joyPad.storedY - 1, 3, 3)
	end
end

function onDraw()
	width = screen.getWidth()
	height = screen.getHeight()
	drawShape(thirdFloor)
	drawShape(secondFloor)
	drawShape(firstFloor)
end

-- test call
onTick()
onDraw()
onTick()
