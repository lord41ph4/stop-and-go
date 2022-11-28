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

}

-- end test class

function overrideValue(original, override)
	if (math.abs(override) < 0.01) then
		return original, false
	end
	return override, true
end

function onTick()
	local x = input.getNumber(1)
	local y = input.getNumber(2)
	local z = input.getNumber(3)

	local x2 = input.getNumber(4)
	local y2 = input.getNumber(5)
	local z2 = input.getNumber(6)

	newX, modifiedX = overrideValue(x, x2)
	newY, modifiedY = overrideValue(y, y2)
	newZ, modifiedZ = overrideValue(z, z2)

	output.setNumber(1, newX)
	output.setNumber(2, newY)
	output.setNumber(3, newZ)
end

function onDraw()
	if modifiedX or modifiedY or modifiedZ then
		local width = screen.getWidth() - 10
		local halfWidth = math.floor(width / 2)
		local height = screen.getHeight()
		local halfHeight = math.floor(height / 2)
		screen.setColor(255, 165, 79)
		screen.drawRect((newX * halfWidth) + halfWidth - 1, (halfHeight + 1) - (newY * halfHeight), 3, 3)
	end
end


-- test call
onTick()
