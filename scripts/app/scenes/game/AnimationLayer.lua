--
-- Author: Your Name
-- Date: 2014-04-30 14:27:23
--

if type(RunnerStat)=="nil" then
	RunnerStat = {}
	RunnerStat.running = 0
	RunnerStat.jumpUp = 1
	RunnerStat.jumpDown = 2
end


local SimpleRecognizer = require("app.common.SimpleRecognizer")
local AnimationLayer = class("AnimationLayer", function()
	return display.newLayer()
end)


function AnimationLayer:ctor(space)
	self.stat = RunnerStat.running
	self.space = space

	self:init()
	self._debugNode = self.space:createDebugNode()
	self._debugNode:setVisible(false)
	self:addChild(self._debugNode,10)
end


function AnimationLayer:init()
	display.addSpriteFramesWithFile(s_runnerplist ,s_runner)
	self.spriteSheet = display.newBatchNode(s_runner)

	self:addChild(self.spriteSheet)

	self:initAction()

	self.sprite = display.newSprite("#runner0.png")
	self.spriteSheet:addChild(self.sprite)
	local contentSize = self.sprite:getContentSize()

	self.body = self.space:createBoxBody(1, contentSize.width, contentSize.height)
	self.body:setPosition(ccp(g_runnerStartX ,g_groundHight +contentSize.height*0.5))
	self.body:bind(self.sprite)
	self.body:applyImpulse(150,0)

	self.sprite:playAnimationForever(self.runningAction)

	self.recognizer = SimpleRecognizer:new()

	self:setTouchEnabled(true)
	self:setTouchMode(1)

	self:addTouchEventListener(function( event,x,y )
		return self:onTouch(event,x,y)
	end)

	self:scheduleUpdate(function(dt)
		self:update(dt)
	end)
end

function AnimationLayer:initAction()

	local frames = display.newFrames("runner%d.png", 0, 7)
	self.runningAction  = display.newAnimation(frames, 0.1)
	display.setAnimationCache("run", self.runningAction)

	local framesUp = display.newFrames("runnerJumpUp%d.png", 0, 3)
	self.jumpUpAction  = display.newAnimation(framesUp, 0.2)
	display.setAnimationCache("jumepUp", self.jumpUpAction)

	local framesDown = display.newFrames("runnerJumpDown%d.png", 0, 1)
	self.jumpDownAction  = display.newAnimation(framesDown, 0.3)
	display.setAnimationCache("jumepDown", self.jumpDownAction)

end

function AnimationLayer:jump()
	local this = self
	audio.playSound(s_music_jump)

	if self.stat == RunnerStat.running then
		self.body:applyImpulse(0, 250)
		self.stat = RunnerStat.jumpUp
		self.sprite:stopAllActions()
		self.sprite:playAnimationOnce(self.jumpUpAction)
	end
end

function AnimationLayer:onTouch(event,x,y)	
	local this = self
	if event == "began" then
		self.recognizer:beginPoint(x, y)
		return true
	elseif event == "moved" then
		self.recognizer:movePoint(x, y)
		return true
	elseif event == "ended" then
	local rtn = self.recognizer:endPoint()
		if rtn == "up" then
			this:jump()
		else
		end
		return false
	end
end


function AnimationLayer:getEyeX()
	return self.sprite:getPositionX() - g_runnerStartX
end

function AnimationLayer:update(dt)


	local velx,vely = self.body:getVelocity()

	if self.stat == RunnerStat.jumpUp then
		if vely < 0.1 then
			self.stat = RunnerStat.jumpDown
			self.sprite:stopAllActions()
			self.sprite:playAnimationOnce(self.jumpDownAction)
		end
	elseif self.stat == RunnerStat.jumpDown then
		if vely == 0 then
			self.stat = RunnerStat.running
			self.sprite:stopAllActions()
			self.sprite:playAnimationForever(self.runningAction)
		end
	end

	local eyeX = self.sprite:getPositionX() - g_runnerStartX
	local camera = self:getCamera()
	local eyeZ = CCCamera:getZEye()

	camera:setEyeXYZ(eyeX, 0, eyeZ)
	camera:setCenterXYZ(eyeX, 0, 0)
end

return AnimationLayer