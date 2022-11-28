properties = {}

numbers = {}
numbers[1] = 64 -- resolution x
numbers[2] = 64 -- resolution y
numbers[3] = 40 -- input 1 X
numbers[4] = 20 -- input 1 Y
numbers[5] = 30 -- input 2 X
numbers[6] = 30 -- input 2 Y
numbers[7] = 0 -- z


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

	local vectorX = 0
	local vectorY = 0
	local vectorZ = input.getNumber(7)

	local startEngine = false;
	local lightsOn = false;
	if width ~= nil then
		if movement == nil then
			local padWidth = width - 10
			local padHeight = height
			movement = generateJoyPad(0, (height / 2) - (padHeight / 2), padWidth, padHeight)
		end
		vectorX, vectorY = checkJoyPad(inputX, inputY, movement)

		if firstFloor == nil then
			local starterWidth = 8
			local starterHeight = 8
			firstFloor = generateJoyPad(width - starterWidth, 0, starterWidth, starterHeight)
		end
		startEngine = checkPressedState(inputX, inputY, firstFloor, false)

		if secondFloor == nil then
			local starterWidth = 8
			local starterHeight = 8
			secondFloor = generateJoyPad(width - starterWidth, 9, starterWidth, starterHeight)
		end
		lightsOn = checkPressedState(inputX, inputY, secondFloor, true)
	end
	output.setNumber(1, vectorX)
	output.setNumber(2, vectorY)
	output.setNumber(3, vectorZ)
	output.setBool(1, true)
	output.setBool(2, startEngine)
	output.setBool(3, lightsOn)
end

function drawShape(joyPad)
	if joyPad ~= nil then
		if joyPad.isPressed or joyPad.pressedState then
			screen.drawRectF(joyPad.x, joyPad.y, joyPad.width, joyPad.height)
		else
			screen.drawRect(joyPad.x, joyPad.y, joyPad.width, joyPad.height)
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

	drawJoyPad(movement)
	screen.setColor(255, 0, 0)
	drawShape(firstFloor)
	screen.setColor(255, 255, 0)
	drawShape(secondFloor)
end

-- test call
onTick()
onDraw()
onTick()
numbers[3] = 40 -- input 1 X
numbers[4] = 20 -- input 1 Y
booleans[1] = true -- input 1 pressed
booleans[2] = false -- input 2 pressed
onTick()
