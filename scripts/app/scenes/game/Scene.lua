--
-- Author: Your Name
-- Date: 2014-04-29 10:14:49
--

collectgarbage("setpause"  ,  100)
collectgarbage("setstepmul"  ,  5000)


local BackgroundLayer = require("app.scenes.game.BackgroundLayer")
local AnimationLayer = require("app.scenes.game.AnimationLayer")
local StatusLayer = require("app.scenes.game.StatusLayer")
local GameOverLayer = require("app.scenes.game.GameOverLayer")

local WALL_THICKNESS = 128

local GameScene = class("GameScene", function()
		return display.newScene("GameScene")
end)


function GameScene:ctor()

end


function GameScene:onEnter()
	self:initPhysics()
	
	self.shapesToRemove = {}

	self:addChild(BackgroundLayer.new(self.world),0,TagOfLayer.background)
	self:addChild(AnimationLayer.new(self.world),0,TagOfLayer.Animation)
	self:addChild(StatusLayer.new(),0,TagOfLayer.Status)
	audio.playMusic(s_music_background, true)


	self:scheduleUpdate(function(dt)
		self:update(dt)
	end)
end

function GameScene:initPhysics()
	self.world = CCPhysicsWorld:create(0, -350)
	self:addChild(self.world)
	local wallBottom = self.world:createBoxBody(0, 4294967295,g_groundHight)

	self:setPosition(ccp(0,0))

	self.world:addCollisionScriptListener(handler(self,self.collisionCoinBegin), SpriteTag.runner, SpriteTag.coin)

	self.world:addCollisionScriptListener(handler(self,self.collisionRockBegin), SpriteTag.runner, SpriteTag.rock)
	-- self.worldDebug = self.world:createDebugNode()
	-- self:addChild(self.worldDebug)
end

function GameScene:collisionCoinBegin(eventType,event )

	table.insert(self.shapesToRemove, event:getBody2())

	local statusLayer = self:getChildByTag(TagOfLayer.Status)
	statusLayer:addCoin(1)

	audio.playEffect(s_music_pickup_coin)
	return true
end

function GameScene:collisionRockBegin( eventType,event)
	-- CCDirector:sharedDirector():pause()
	self:addChild(GameOverLayer.new())
	audio.stopMusic(isReleaseData)
	audio.stopAllSounds();
	return true
end

function GameScene:update(dt)
	self.world:step(dt)

	for i=1,#self.shapesToRemove do
		local  shape = self.shapesToRemove[i]
		self:getChildByTag(TagOfLayer.background):removeObjectByShape(shape)
	end

	self.shapesToRemove = {}
end


function GameScene:onExit()

end

return GameScene