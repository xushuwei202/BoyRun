--
-- Author: Your Name
-- Date: 2014-04-29 15:21:58
--
local Coin = {
	space,
	sprite,
	shape,
	_mapIndex = 0,
}


function Coin:new(spriteSheet,space,pos)
	local this = {}
	setmetatable(this, self)
	self.__index = self


	this.space = space


	local frames = display.newFrames("coin%d.png", 0, 7)
	this.animation = display.newAnimation(frames, 0.2)


	this.sprite = display.newSprite("#coin0.png")
	spriteSheet:addChild(this.sprite)

	local  radius = 0.95 * this.sprite:getContentSize().width/2

	this.body = this.space:createCircleBody(0, radius)
	this.body:setPosition(pos)
	this.body:bind(this.sprite)
	this.body:setCollisionType(SpriteTag.coin)
	this.body:setIsSensor(true)

	this.sprite:playAnimationForever(this.animation)

	return this
end

function Coin:removeFromParent()
	self.space:removeBody(self.body)
	self.shape = nil
	self.sprite:removeFromParent()
	self.sprite = nil
end

function Coin:getShape()
	return self.body
end

function Coin:getMapIndex()
	return self._mapIndex
end

function Coin:setMapIndex(value)
	self._mapIndex = value
end

return Coin