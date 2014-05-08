--
-- Author: Your Name
-- Date: 2014-04-30 13:02:38
--
local Rock = {
	space,
	sprite,
	shape,
	_mapIndex = 0,
}

function Rock:new(spriteSheet,space,posX)
	local this = {}
	setmetatable(this, self)
	self.__index = self
	this.space = space

	this.sprite = display.newSprite("#rock.png", x, y)
	spriteSheet:addChild(this.sprite)

	this.body = this.space:createBoxBody(0, this.sprite:getContentSize().width, this.sprite:getContentSize().height)
	this.body:setPosition(ccp(posX,this.sprite:getContentSize().height/2+g_groundHight))
	this.body:bind(this.sprite)
	this.body:setCollisionType(SpriteTag.rock)
	this.body:setIsSensor(true)

	return this
end


function Rock:removeFromParent()
	self.space:removeBody(self.body)
	self.shape = nil
	self.sprite:removeFromParent()
	self.sprite = nil
end

function Rock:getShape()
	return self.shape
end


function Rock:getMapIndex()
	return self._mapIndex
end

function Rock:setMapIndex(value)
	self._mapIndex = value
end

return Rock