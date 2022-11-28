properties = {}
properties["Min RPS"] = 4
properties["Max RPS"] = 22

numbers = {}
numbers[1] = 0 -- x move
numbers[2] = 0 -- y move
numbers[3] = 0 -- z move
numbers[4] = 3 -- diesel rps
numbers[5] = 0 -- electric rps
numbers[6] = 1 -- battery charge

booleans = {}
booleans[1] = true -- engine on
booleans[2] = false -- starter pressed
booleans[3] = false -- use electric


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
	local state = {
		minRps = minRps,
		maxRps = maxRps,
		lastRps = 0,
		rps = 0,
		lastThrottle = 0,
		throttle = 0,
		lastClutch = 0,
		clutch = 0,
		lastReverse = false,
		reverse = false
	}
	return state
end

function markLastValues(engine)
	engine.lastRps = engine.rps
	engine.lastClutch = engine.clutch
	engine.lastThrottle = engine.throttle
	engine.lastReverse = engine.reverse
end

function zeroOut(engine)
	engine.clutch = 0
	engine.throttle = 0
	engine.reverse = false
end

function computeThrottle(engine, targetThrottle)
	local targetReverse = targetThrottle < 0
	targetThrottle = math.abs(targetThrottle)
	if engine.lastReverse == targetReverse then
		if engine.minRps > 0 and targetThrottle > 0 then
			engine.clutch = math.min(1, engine.clutch + 0.005)
		else
			engine.clutch = 1
		end
	else
		engine.clutch = 0
		if (engine.lastClutch == 0) then
			engine.reverse = targetReverse
		end
	end
	if targetThrottle == 0 then
		if engine.rps > engine.minRps and engine.lastClutch > 0 then
			engine.clutch = 1
		else
			engine.clutch = 0
		end
	end
	if (engine.rps < engine.maxRps and engine.lastThrottle < targetThrottle) or engine.rps < engine.minRps then
		if (targetThrottle - engine.lastThrottle > 0.3) then
			engine.throttle = engine.lastThrottle + 0.3
		else
			engine.throttle = math.min(1, engine.throttle + 0.01)
		end

	elseif engine.rps > engine.minRps and engine.lastThrottle > targetThrottle then
		if (engine.lastThrottle - targetThrottle > 0.5) then
			engine.throttle = engine.lastThrottle - 0.5
		else
			engine.throttle = math.max(0.01, engine.throttle - 0.01)
		end
	end
end

-- Tick function that will be executed every logic tick
function onTick()
	local minRps = property.getNumber("Min RPS")
	local maxRps = property.getNumber("Max RPS")
	local targetXMove = input.getNumber(1)
	local targetYMove = input.getNumber(2)
	local targetZMove = input.getNumber(3)
	local dieselRps = input.getNumber(4)
	local electricRps = input.getNumber(5)
	local batteryCharge = input.getNumber(6)

	local on = input.getBool(1)
	local starter = input.getBool(2)
	local useElectric = input.getBool(3)

	local generatorClutch = 0
	local propellerClutch = 0

	local reverse = false

	if (electric == nil) then
		electric = generateEngineState(0, maxRps)
	end
	markLastValues(electric)
	electric.rps = electricRps

	if (diesel == nil) then
		diesel = generateEngineState(minRps, maxRps)
	end
	markLastValues(diesel)
	diesel.rps = dieselRps

	if (on) then
		if (useElectric) then
			zeroOut(diesel)
			computeThrottle(electric, targetYMove)
			reverse = electric.reverse
		else
			zeroOut(electric)
			if (starter) then
				diesel.throttle = 1
				diesel.clutch = 1
				electric.throttle = 1
				electric.clutch = 1
				propellerClutch = 0
				generatorClutch = 0
				reverse = false
			else
				if batteryCharge < 0.90 then
					generatorClutch = 1
				end
				computeThrottle(diesel, targetYMove)
				reverse = diesel.reverse
			end
		end
	else
		zeroOut(electric)
		zeroOut(diesel)
	end

	if (math.abs(targetYMove) > 0.01) then
		propellerClutch = 1
	end

	output.setNumber(1, targetXMove)
	output.setNumber(2, targetYMove)
	output.setNumber(3, targetZMove)

	output.setNumber(4, electric.throttle)
	output.setNumber(5, electric.clutch)
	output.setNumber(6, propellerClutch)

	output.setNumber(7, diesel.throttle)
	output.setNumber(8, diesel.clutch)
	output.setNumber(9, generatorClutch)

	output.setBool(1, on)
	output.setBool(2, starter)
	output.setBool(3, reverse)
end

-- test call
onTick()
--diesel.throttle = 1
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()
onTick()