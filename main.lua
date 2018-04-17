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

-- Displays App title
title = display.newText( "File Demo", centerX, centerY, native.systemFontBold, 20 )
title:setFillColor( 1,1,0 )