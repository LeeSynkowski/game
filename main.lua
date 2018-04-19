-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Start Debugging
require('mobdebug').start()


local widget = require( "widget" )
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

--Keep this for adding scence structure
--sceneGroup:insert( graphicsRectangle )


 
-- Set up the picker wheel columns
local columnData = 
{ 
    { 
        align = "right",
        width = _W / 2,
        labelPadding = 10,
        startIndex = 1,
        labels = { "Shoot", "Pull Guard", "Foot Sweep" }
    }
}
 

local pickerWheel = widget.newPickerWheel(
{
    x = 0, 
    y = (7 * _H) / 9,
    columns = columnData,
    style = "resizable",
    width = _W,
    rowHeight = ((2 * _H) / 9)/5,
    fontSize = 20
})
 
local widget = require( "widget" )
 
-- Function to handle button events
local function handleButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
    end
end
 

local strongButton = widget.newButton(
    {
        label = "Strong",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "circle",
        radius= 1/18 * _H,
        fillColor = { default={1,0.6,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4,
        top = (7 * _H) / 9 + 1/36 * _H,
        left = _W/2 + 1/36 * _H
    }
)
 
