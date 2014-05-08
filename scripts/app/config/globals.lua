--
-- Author: Your Name
-- Date: 2014-04-29 12:36:48
--


g_groundHight = 128;
g_runnerStartX = 80;

if type(TagOfLayer) == "nil" then
	TagOfLayer = {}
    TagOfLayer.background = 0;
    TagOfLayer.Animation = 1;
    TagOfLayer.Status = 2;
end

if type(SpriteTag) == "nil" then
	SpriteTag = {};
    SpriteTag.runner = 0;
    SpriteTag.coin = 1;
    SpriteTag.rock = 2;
end