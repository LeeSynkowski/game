-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Start Debugging
require('mobdebug').start()

--local composer = require( "composer" )

--composer.gotoScene( "Scenes.FirstType" )



local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

--Task 1: Screen Rectangles
local graphicsRectangle = display.newRect( 110, 110, 50, 50)
graphicsRectangle:setFillColor( 0, 1, 0 )

print("_W ",_W)
print("_H ",_H)
print("centerX ",centerX)
print("centerY ",centerY)

--sceneGroup:insert( graphicsRectangle )
--label
--local label1 = display.newText("1", rect1X, rect1Y, rectWidth, rectHeight )
--label1:setFillColor( 0, 0, 0 )
--sceneGroup:insert( label1 )  