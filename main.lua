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

--Set Default Anchoring of Images to Top Left
display.setDefault( "anchorX", 0)
display.setDefault( "anchorY", 0)

--Task 1: Screen Rectangles
local graphicsArea = display.newRect( 0, 0, _W, (2 * _H) / 3)
graphicsArea:setFillColor( 0, 1, 0 )

local infoArea = display.newRect( 0, (2 * _H) / 3, _W, (_H) / 9)
infoArea:setFillColor( 1, 0, 0 )

local menuArea = display.newRect( 0, (7 * _H) / 9, _W, (2 * _H) / 9)
menuArea:setFillColor( 0, 0, 1 )

--sceneGroup:insert( graphicsRectangle )
--label
--local label1 = display.newText("1", rect1X, rect1Y, rectWidth, rectHeight )
--label1:setFillColor( 0, 0, 0 )
--sceneGroup:insert( label1 )  