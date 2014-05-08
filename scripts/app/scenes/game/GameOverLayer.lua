--
-- Author: shuwei.xu
-- Date: 2014-05-08 22:20:12
--
local GameOverLayer = class("GameOverLayer", function()
	return CCLayerColor:create(ccc4(0,0,0,150))
end)

function GameOverLayer:ctor()
	self:init()
end


function GameOverLayer:init()
    local function onRestart()
      CCDirector:sharedDirector():resume()
      app:enterGameScene()
    end

	 local menuItemRestart = ui.newImageMenuItem({
      image = s_restart_n,
      imageSelected = s_restart_s,
      listener = onRestart
    })

    local menu = ui.newMenu({menuItemRestart})
    menu:setPosition(ccp(display.cx, display.cy))
    self:addChild(menu)
end

function GameOverLayer:onRestart()
	CCDirector:sharedDirector():resume()
	app:enterGameScene()
end

return GameOverLayer