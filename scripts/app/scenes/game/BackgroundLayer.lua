--
-- Author: Your Name
-- Date: 2014-04-29 12:32:36
--

local Coin = require("app.views.Coin")
local Rock = require("app.views.Rock")
local BackgroundLayer = class("BackgroundLayer", function( )
	return display.newLayer()
end)


function BackgroundLayer:ctor(world)
	self.objects = {}
	self.world = world
	self:init()
end


function BackgroundLayer:init()
	self.map00 = CCTMXTiledMap:create(s_map00)
	self:addChild(self.map00)

	self.mapWidth = self.map00:getContentSize().width

	self.map01 = CCTMXTiledMap:create(s_map01)
	self.map01:setPosition(ccp(self.mapWidth,0))
	self:addChild(self.map01)

	display.addSpriteFramesWithFile(s_background_plist,s_background)
	self.spriteSheet = display.newBatchNode(s_background , capacity)
	self:addChild(self.spriteSheet)

	self:loadObjects(self.map00, 0)
	self:loadObjects(self.map01, 1)

	self:scheduleUpdate(function(dt)
		self:update(dt)
	end)
end

function BackgroundLayer:loadObjects(map,mapIndex)
	local coinGroup = map:objectGroupNamed("coin")
	local coinArray = coinGroup:getObjects()

	

	local dict = nil
	local len = coinArray:count()-1
	for i=0,len do
		dict = tolua.cast(coinArray:objectAtIndex(i),"CCDictionary")
		if dict == nil then
			break
		end
		local key = "x"
		local x = (tolua.cast(dict:objectForKey(key), "CCString")):intValue()
		key = "y"
		local y = (tolua.cast(dict:objectForKey(key), "CCString")):intValue()

		local coin = Coin:new(self.spriteSheet,self.world,ccp(x+self.mapWidth*mapIndex,y))
		coin:setMapIndex(mapIndex)
		table.insert(self.objects, coin)
	end


	local rockGroup = map:objectGroupNamed("rock")
	local rockArray = rockGroup:getObjects()

	dict = nil
	len = rockArray:count()-1

	for i=0,len do
		dict = tolua.cast(rockArray:objectAtIndex(i),"CCDictionary")
		if dict == nil then
			break
		end
		local key = "x"
		local x = (tolua.cast(dict:objectForKey(key), "CCString")):intValue()
		key = "y"
		local y = (tolua.cast(dict:objectForKey(key), "CCString")):intValue()

		local rock = Rock:new(self.spriteSheet,self.world,(x+self.mapWidth*mapIndex))
		rock:setMapIndex(mapIndex)
		self.objects[#self.objects+1] = rock
	end
end

function BackgroundLayer:removeObjects(mapIndex)

	local function removeItem(obj,index)
		for i=1,#obj do

			if obj[i]:getMapIndex() == index then
				obj[i]:removeFromParent()
				table.remove(obj,i)
				return true
			end
			return false
		end

		return false
	end

	while removeItem(self.objects,mapIndex) do

	end
	
end

function BackgroundLayer:removeObjectByShape(shape)
	
	for i=1,#self.objects do
		if self.objects[i]:getShape() == shape then
			self.objects[i]:removeFromParent()
			table.remove(self.objects,i)
			break
		end
	end
end

function BackgroundLayer:checkAndReload(eyeX)
	local newMapIndex = math.floor(eyeX/self.mapWidth)

	if self.mapIndex == newMapIndex then
		return false
	end

	if 0 == newMapIndex%2 then
		self.map01:setPositionX(self.mapWidth*(newMapIndex+1))
		self:loadObjects(self.map01, newMapIndex+1)
	else
		self.map00:setPositionX(self.mapWidth * (newMapIndex + 1));
		self:loadObjects(self.map00, newMapIndex + 1);
	end

	self:removeObjects(newMapIndex-1)
	self.mapIndex = newMapIndex

	return true
end

function BackgroundLayer:onEnter()
	self.world:start()
end

function BackgroundLayer:update(dt)
	local animationLayer = self:getParent():getChildByTag(TagOfLayer.Animation)
	local eyeX = animationLayer:getEyeX()
	self:checkAndReload(eyeX)

	local camera = self:getCamera()
	local eyeZ = CCCamera:getZEye()
	camera:setEyeXYZ(eyeX, 0, eyeZ)
	camera:setCenterXYZ(eyeX, 0, 0)
end

return BackgroundLayer