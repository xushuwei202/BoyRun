--
-- Author: Your Name
-- Date: 2014-04-29 10:14:44
--
collectgarbage("setpause",100)
collectgarbage("setstepmul",5000)

local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

function MenuScene:ctor()

	local layer = display.newLayer();

	local spritebg = display.newSprite(s_HelloBG , display.cx, display.cy)
	layer:addChild(spritebg)

	local function onPlay()
	   app:enterGameScene()
	end 


	local menuItemPlay = ui.newImageMenuItem({
      image = s_start_n,
      imageSelected = s_start_s,
      listener = onPlay
    })

    local menu = ui.newMenu({menuItemPlay})
    menu:setPosition(ccp(display.cx,display.cy))
    layer:addChild(menu)
	self:addChild(layer)

	audio.preloadMusic(s_music_background)
	audio.preloadEffect(s_music_jump)
	audio.preloadEffect(s_music_pickup_coin)
end

return MenuScene