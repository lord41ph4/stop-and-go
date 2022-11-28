properties = {}

numbers = {}
numbers[1] = 1 -- x direction
numbers[2] = 0 -- y direction = throttle
numbers[3] = 1 -- index
numbers[4] = 0 -- engineRps


booleans = {}

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
		return 32
	end,
	getHeight = function()
		return 32
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

	end

}

-- end test class

function throttleForTurn(direction, throttle, index)
	if direction > 0 then
		-- front left and back right
		if index == 1 or index == 4 then
			return direction
		end
	end
	if direction < 0 then
		-- front right and back left
		if index == 2 or index == 3 then
			return -direction
		end
	end
	if index == 0 then
		return throttle
	end
	return 0
end

function throttleForSideways(direction, index)
	-- front left and back left
	if index == 1 or index == 3 then
		return direction
	end
	-- front right and back right
	if index == 2 or index == 4 then
		return -direction
	end
	return 0
end

function computeEngineThrottle(direction, throttle, engineRole)
	if not (throttle == 0) then
		return throttleForTurn(direction, throttle, engineRole)
	end
	if not (direction == 0) then
		return throttleForSideways(direction, engineRole)
	end
	return 0
end

function onTick()
	local direction = input.getNumber(1)
	local throttle = input.getNumber(2)
	local engineRole = input.getNumber(3)
	local engineRps = input.getNumber(4)

	local engineThrottle = computeEngineThrottle(direction, throttle, engineRole)

	local onSignal = false
	local starter = false
	if engineThrottle > 0 then
		onSignal = true
		if engineRps < 5 then
			starter = true
		end
	end
	output.setBool(1, onSignal)
	output.setBool(2, starter)
	output.setNumber(1, direction)
	output.setNumber(2, engineThrottle)
end

-- test call
onTick()
