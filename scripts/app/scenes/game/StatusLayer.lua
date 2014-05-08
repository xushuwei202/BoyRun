--
-- Author: shuwei.xu
-- Date: 2014-05-08 21:18:58
--
local StatusLayer = class("StatusLayer", function()
	return display.newLayer()
end)


function StatusLayer:ctor()
	self.coins = 0
	self:init()
end

function StatusLayer:init()
	self.labelCoin = ui.newTTFLabel({
			text = "Coins:0",
			font = "Helvetica",
			size = 20,
			color = ccc3(0, 0, 0),
			align = ui.TEXT_ALIGN_CENTER
		})
	self.labelCoin:setPosition(ccp(70,display.height-20))
	self:addChild(self.labelCoin)

	self.labelMeter =  ui.newTTFLabel({
			text = "OM",
			font = "Helvetica",
			size = 20,
			color = ccc3(0, 0, 0),
			align = ui.TEXT_ALIGN_CENTER
		})

		self.labelMeter:setPosition(ccp(display.width-70,display.height-20))
		self:addChild(self.labelMeter)
end

function StatusLayer:addCoin(num)
	self.coins = self.coins+num
	self.labelCoin:setString("Coins:"..self.coins)
end

function updateMeter( px )
	 self.labelMeter:setString(toint(px / 10) + "M");
end

return StatusLayer