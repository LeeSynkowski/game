local composer = require( "composer" )

local character = require("character")
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local widget = require( "widget" )

local _W = display.contentWidth
local _H = display.contentHeight

local selectedAttackValue = "Shoot"
local currentPosition = "Standing"

local positionValues = {"Standing","Guard Top","Guard Bottom","Mount Top","Mount Bottom","Side Control Top","Side Control Bottom"}
local attackValues = { "Shoot", "Pull Guard", "Foot Sweep" }

local function determineAttackResult (attackStrentgh)
  --either return true or false, or the name of resultant position
  
  --for now just rng against the input number ( or even just always return true)
  return false 
end

 -- Function to handle button events
local function handleStrongButton( event )
    actionText.text = "Strong " .. selectedAttackValue
    
    --get the character's Strong attack strength for the given poisition
    local strongAttackStrength = character["Standing"]
    print(strongAttackStrength[1])
    
    --determine attack result for that attack (success or failure)
    
    --determine the next position that will appear on screen
    
    --assign any points awarded
    
    --begin animation for that next scene
    
    if ( "ended" == event.phase ) then
      
      
        print( "Strong was pressed and released" )
    end
end

 -- Function to handle button events
local function handleTechnicalButton( event )
    actionText.text = "Technical  " .. selectedAttackValue
    
    if ( "ended" == event.phase ) then
        print( "Technical was pressed and released" )
    end
end
 
actionText = display.newText("",  _W/3, display.contentHeight)

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

attackPicker = widget.newPickerWheel(
{
    x = 0, 
    y = (7 * _H) / 9,
    columns = columnData,
    style = "resizable",
    width = _W,
    rowHeight = ((2 * _H) / 9)/5,
    fontSize = 20
}) 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    --Set Default Anchoring of Images to Top Left
    display.setDefault( "anchorX", 0)
    display.setDefault( "anchorY", 0)

    --Screen Rectangles
    local graphicsArea = display.newRect( 0, 0, _W, (2 * _H) / 3)
    graphicsArea:setFillColor( 0, 1, 0 )

    local infoArea = display.newRect( 0, (2 * _H) / 3, _W, (_H) / 9)
    infoArea:setFillColor( 1, 0, 0 )

    local menuArea = display.newRect( 0, (7 * _H) / 9, _W, (2 * _H) / 9)
    menuArea:setFillColor( 0, 0, 1 )

    --Keep this for adding scence structure
    sceneGroup:insert( graphicsArea  )
    sceneGroup:insert( infoArea  )
    sceneGroup:insert( menuArea  )
    
    local function attackValueSelected (event)
      selectedAttackValue = attackValues[event["row"]]
      print(selectedAttackValue)
    end 
    
    -- Set up the picker wheel columns
    local columnData = 
    { 
        { 
            align = "right",
            width = _W / 2,
            labelPadding = 10,
            startIndex = 1,
            labels = attackValues
        }
    }

    attackPicker = widget.newPickerWheel(
    {
        x = 0, 
        y = (7 * _H) / 9,
        columns = columnData,
        style = "resizable",
        width = _W,
        rowHeight = ((2 * _H) / 9)/5,
        fontSize = 20,
        onValueSelected = attackValueSelected
    }) 

    sceneGroup:insert( attackPicker  )

    local strongButton = widget.newButton(
        {
            label = "Strong",
            onEvent = handleStrongButton,
            emboss = false,
            shape = "circle",
            radius= 1/18 * _H,
            fillColor = { default={1,0.6,0,1}, over={1,0.1,0.7,0.4} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 4,
            top = (7 * _H) / 9 + 1/36 * _H,
            left = _W/2 + 1/36 * _H
        }
    )
    sceneGroup:insert( strongButton  )

    local technicalButton = widget.newButton(
        {
            label = "Tech",
            onEvent = handleTechnicalButton,
            emboss = false,
            shape = "circle",
            radius= 1/18 * _H,
            fillColor = { default={0.7,0.8,0,1}, over={1,0.1,0.7,0.4} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 4,
            top = _H - (_H/9) +  - 1/36 * _H,
            left = (3 * _W)/4 + 1/72 * _H -- * _H
        }
    )
    sceneGroup:insert( technicalButton  )
    
    actionText = display.newText("NOTHING YET", _W / 3, (2 * _H) / 6)
    actionText:setFillColor( 1, 1, 1 )
    sceneGroup:insert( actionText )
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene