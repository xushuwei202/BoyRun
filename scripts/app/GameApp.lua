
require("resource")
require("config")
require("app.Config.globals")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

local GameApp = class("GameApp", cc.mvc.AppBase)

function GameApp:ctor()
    GameApp.super.ctor(self)
end

function GameApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
   	self:enterSplashScen()
end

function GameApp:enterSplashScen()
	self:enterScene("splash.Scene", nil, "fade", 0.6, display.COLOR_BLACK)
end

function GameApp:enterMenuScene()
	self:enterScene("menu.Scene", nil, "fade", 0.6, display.COLOR_BLACK)
end


function GameApp:enterGameScene()
	self:enterScene("game.Scene", nil, "fade", 0.6, display.COLOR_WHITE)
end

return GameApp
