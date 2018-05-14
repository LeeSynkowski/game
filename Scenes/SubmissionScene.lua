local composer = require( "composer" )
 
local scene = composer.newScene()
 
local interSceneData = require("interSceneData") 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local _W = display.contentWidth
local _H = display.contentHeight

local widget = require( "widget" )

local function handleRestartButton( event )
    composer.removeScene("Scenes.ActionScene")
    composer.gotoScene( "Scenes.ActionScene" )
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
  
    matchOutcomeText = display.newText("", _W / 2, (3 * _H) / 6)
    resultOfLastAttackText:setFillColor( 1, 1, 1 )
    sceneGroup:insert( matchOutcomeText )
    
    if (interSceneData.position == "Submission") or (interSceneData.playerScore > interSceneData.opponentScore ) then
      matchOutcomeText.text = "You win!"
    elseif (interSceneData.position == "Tap") or (interSceneData.playerScore < interSceneData.opponentScore ) then
      matchOutcomeText.text = "You lose."
    elseif (interSceneData.playerScore == interSceneData.opponentScore ) then
      matchOutcomeText.text = "Tie."
    else
      matchOutcomeText.text = "Error."
    end
    
    local restartButton = widget.newButton(
    {
        label = "RESTART",
        onEvent = handleRestartButton,
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
    sceneGroup:insert( restartButton  )
    
    scoreLabel = display.newText("Current Score: ", 0, (1 * _H) / 12)
    sceneGroup:insert( scoreLabel )
    
    scoreText = display.newText("", _W / 2, (1 * _H) / 12)
    scoreText:setFillColor( 1, 1, 1 )
    sceneGroup:insert( scoreText )
    
    scoreText.text = "Plyr: " .. interSceneData.playerScore .. " Opp: " .. interSceneData.opponentScore
    
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