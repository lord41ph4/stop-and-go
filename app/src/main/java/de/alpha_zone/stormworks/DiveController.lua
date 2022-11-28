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



-- Tick function that will be executed every logic tick
function onTick()

end

-- test call
onTick()