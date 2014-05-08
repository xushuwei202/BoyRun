--
-- Author: Your Name
-- Date: 2014-04-30 16:45:15
--


local Point = {
	X,
	Y
}

function Point:new(x,y)
	local this = {}
	setmetatable(this, self)
	self.__index = self

	this.X = x
	this.Y = y

	return this
end


local SimpleRecognizer = {
	points = {},
	result =""
}

function SimpleRecognizer:new()
	local this = {}
	setmetatable(this, self)
	self.__index = self

	return this
end

function SimpleRecognizer:beginPoint(x,y)
	self.points = {}
	self.result = ""
	self.points[#self.points+1] = Point:new(x,y)
end

function SimpleRecognizer:movePoint(x,y)
	self.points[#self.points+1] = Point:new(x,y)

	if self.result == "not support" then
		return
	end

	local newRtn = ""

	local len = #self.points
	local dx = self.points[len].X - self.points[len-1].X
	local dy = self.points[len].Y - self.points[len-1].Y

	if math.abs(dx) >math.abs(dy) then
		if dx>0 then
			newRtn = "right"
		else
			newRtn = "left"
		end
	else
		if dy>0 then
			newRtn = "up"
		else
			newRtn = "down"
		end
	end

	if self.result == "" then
		self.result = newRtn
		return
	end

	if self.result ~= newRtn then
		self.result = "not support"
	end
end


function SimpleRecognizer:endPoint()
	if #self.points<3 then
		return "error"
	end

	return self.result
end

function SimpleRecognizer:getPoints()
	return self.points
end


return SimpleRecognizer