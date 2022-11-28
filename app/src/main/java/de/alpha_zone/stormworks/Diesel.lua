properties = {}
properties["Min RPS"] = 6
properties["Max RPS"] = 22

numbers = {}
numbers[1] = 0 -- rps
numbers[2] = 0 -- controller throttle
numbers[3] = 0 -- engine RPS
numbers[4] = 0 -- real RPS

booleans = {}
booleans[1] = true -- engine on
booleans[2] = false -- starter pressed


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

function generateEngineState(minRps, maxRps)
	local minThrottle = math.floor(((maxRps / minRps) / 13) * 10) / 10
	return { throttle = 0, targetThrottle = 0, minThrottle = minThrottle, minRps = minRps, maxRps = maxRps, rps = 0, clutch = 0, reverse = false }
end

function computeEngineState(engineState, realRps)
	local throttle = engineState.targetThrottle
	local clutch = 1
	local reverse = throttle < 0
	local balancedRotation = true
	if reverse then
		throttle = -throttle
		if realRps > engineState.minRps then
			balancedRotation = false
			throttle = 0
			clutch = 1
			reverse = false
		elseif realRps > 0 and engineState.clutch > 0 and not engineState.reverse then
			balancedRotation = false
			clutch = 0
			reverse = false
		elseif realRps > 0 then
			realRps = 0
		end
	else
		if -realRps > engineState.minRps then
			balancedRotation = false
			throttle = 0
			clutch = 1
			reverse = true
		elseif realRps < 0 and engineState.clutch > 0 and engineState.reverse then
			balancedRotation = false
			clutch = 0
			reverse = false
		elseif realRps < 0 then
			realRps = 0
		end
	end

	if balancedRotation then
		local relativeDifference = (engineState.rps - realRps) / engineState.rps
		if relativeDifference < 0.7 then
			clutch = math.min(1, math.floor(0.1 + math.cos(relativeDifference) * 100) / 100)
		elseif math.abs(engineState.targetThrottle) > 0 then
			clutch = 0.5
		else
			clutch = 0
		end
	end

	engineState.reverse = reverse
	engineState.clutch = clutch
	engineState.throttle = math.max(engineState.minThrottle, throttle)
end

-- Tick function that will be executed every logic tick
function onTick()
	local minRps = property.getNumber("Min RPS")
	local maxRps = property.getNumber("Max RPS")

	local on = input.getBool(1)
	local starter = input.getBool(2)

	local givenThrottle = input.getNumber(2)

	local rps = input.getNumber(3)
	local realRps = input.getNumber(4)

	if (engineState == nil) then
		engineState = generateEngineState(minRps, maxRps)
	end
	engineState.targetThrottle = givenThrottle
	engineState.rps = rps

	if (on) then
		if (starter) then
			engineState.clutch = 0
			engineState.throttle = 100
		else
			computeEngineState(engineState, realRps)
		end
	else
		starter = false
		engineState.throttle = 0
		engineState.clutch = 100
	end
	output.setNumber(1, engineState.throttle)
	output.setNumber(2, engineState.clutch)
	output.setNumber(3, engineState.rps)
	output.setNumber(4, realRps)
	output.setNumber(5, minRps)
	output.setNumber(6, maxRps)

	output.setBool(1, on)
	output.setBool(2, starter)
	output.setBool(3, engineState.reverse)
end

-- test call
onTick()