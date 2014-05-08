--
-- Author: Your Name
-- Date: 2014-04-11 17:27:21
--
collectgarbage("setpause"  ,  100)
collectgarbage("setstepmul"  ,  5000)


local SplashScene = class("SplashScene", function()
		return display.newScene("SplashScene")
	end)


function SplashScene:ctor()
	
	local bg = display.newSprite(s_HelloBG,display.cx,display.cy)
	self:addChild(bg)
	local handle
	handle = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function()
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(handle)
			handle = nil
			app:enterMenuScene()
		end, 1, false)
end


function SplashScene:onExit()
	-- self:markAutoCleanupImage("res/Splash.jpg")
end
return SplashScene