math.randomseed( os.time() )

local composer = require( "composer" )

local character = require("character")
local opponent = require("opponent")

attackTable = require("attackTable")

local interSceneData = require("interSceneData")
 
local scene = composer.newScene()

local score = 0

--For debugging only
local successFailureTable = {"Success","Failure"}
 
--Set Default Anchoring of Images to Top Left
display.setDefault( "anchorX", 0)
display.setDefault( "anchorY", 0) 

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local widget = require( "widget" )

local _W = display.contentWidth
local _H = display.contentHeight

local selectedAttackValue = "Shoot"
local currentPosition = "Standing"
--mostRecentActionText = display.newText("", _W / 2, (2 * _H) / 6)

local timingLoopCounter = 0

local attackHappening = false

function createAttackPicker( attackTable )
  local columnData = 
  { 
      { 
          align = "right",
          width = _W / 2,
          labelPadding = 10,
          startIndex = 1,
          labels = attackTable
      }
  }

  return widget.newPickerWheel(
  {
      x = 0, 
      y = (7 * _H) / 9,
      columns = columnData,
      style = "resizable",
      width = _W,
      rowHeight = ((2 * _H) / 9)/5,
      fontSize = 20
  })   

end

attackPicker = createAttackPicker( character[currentPosition][2] )

function getOpponentsDefense(position)
  --standing
  if (position == "Standing") then
    return opponent["Standing Defense"] * 5--times multiplier
   
  --top guard 
  elseif (position == "Top Turtle") or (position == "Top Guard") or (position == "Top Half Guard") then
    return opponent["Guard Passing Defense"] 
  
  --bottom guard
  elseif (position == "Bottom Half Guard") or (position == "Bottom Guard") or (position == "Bottom Turtle")   then
    return opponent["Guard Defense"] 
  
  --top control
  elseif (position == "Top Rear Mount") or (position == "Top Mount") or (position == "Top Side Control")   then
    return opponent["Top Defense"]
  
  --bottom position
  elseif  (position == "Bottom Side Control") or (position == "Bottom Mount") or (position == "Bottom Rear Mount")  then
    return opponent["Bottom Defense"] 
  
  --in a submission
  elseif (position == "Rear Naked Choke Defense") or (position == "Armbar Defense") or (position == "Collar Choke Defense") or (position == "Kimura Defense") or (position == "Americana Defense") or (position == "Anaconda Choke Defense") or (position == "Triangle Defense") or (position == "Omopalata Defense") then
    return opponent["Submission Defense"] 
  else
    return 1
  end
end

local function determineAttackResult (attackStrength,points,defense)
  
  --timing is a random number at this point
  myTiming = math.random(50,80)
  
  if myTiming * attackStrength >= defense then
    print("Attack success")
    score = score + points
    scoreText.text = score
    print("Current score: " .. score)
    return 1 --success
  else 
    print("Attack failure")
    return 2 --failure
  end
  
end

local function handleStrongButton( event )
  if ( "began" == event.phase ) then
    local opponentsDefense = getOpponentsDefense(currentPosition)
    handlePlayerAttack( "Strong", opponentsDefense )
  end
end

local function handleTechnicalButton( event )
  if ( "began" == event.phase ) then
    local opponentsDefense = getOpponentsDefense(currentPosition)
    handlePlayerAttack( "Technical", opponentsDefense )
  end
end

local function updateAttackStatsForPosition(position)

    myAttackStats.text = table.concat(character[currentPosition][1], ", ")
    opponentAttackStats.text = table.concat(opponent[currentPosition][1], ", ")
      
end

 -- Function to handle an opponents attack
 -- this differs from the handle player attack because we figure out what is needed from inside the function, instead of it being inputted it
function handleOpponentAttack( defense )

    attackHappening = true
    
    --1) Figure out what attack option is picked (using random selection at this point)
    --local values = attackPicker:getValues()
    local values = opponent[currentPosition][2]
    
    --need to add the number of options in the opponent table because it is a pain to count the size of a lua table
    local numberOfOptions = opponent[currentPosition][3]
    
    --Get the value for each column in the wheel, by column index
    print("Opponent attack values : ", values)

    selectedAttackValue = values[math.random(1,numberOfOptions)]
    
    --2) Determine if it is a Technical or Strong Attack
    local tableIndex = math.random(1,2)    
    
    print("Opponent attackType .. selectedAttackValue = " .. tableIndex .. selectedAttackValue)
    mostRecentActionText.text = "Opp  " .. tableIndex .. selectedAttackValue
    
    --3) Find attack strength for the character
    --get the character's Attack strength for the given position and attack type
    local attackStrength = opponent[currentPosition][1][tableIndex]
    
    --4) Find the attack result
    --determine attack result for that attack success
    --right now this uses generic random timing, which we may need to change
    local attackResult =  determineAttackResult(attackStrength,attackTable[selectedAttackValue][3],defense)
  
    --5) Determine the next position
    --determine the next position that will appear on screen for success
    currentPosition = attackTable[selectedAttackValue][attackResult]
    
    --6) Update display to reflect the new position
    --update stat info for current scene changes
    updateAttackStatsForPosition(currentPosition)
    currentPositionText.text = currentPosition 
    
    if currentPosition == "Submission" then
      interSceneData.score = score
      Runtime:removeEventListener("enterFrame", gameLoop)
      composer.gotoScene( "Scenes.SubmissionScene" )
    end
    --create new picker wheel with a list of current attacks
    attackPicker = createAttackPicker( character[currentPosition][2])

    --debug printing and temp display values
    print(successFailureTable[attackResult] .." going to  " .. attackTable[selectedAttackValue][attackResult])
    resultOfLastAttackText.text = successFailureTable[attackResult]
    currentPositionText.text = currentPosition 
    print( tableIndex .. " was pressed" )

    attackHappening = false
end



function gameLoop(event)
  --my looping actions go here
  --if some condition then handleOpponentAttack
  timingLoopCounter = timingLoopCounter + 1
  
  if (math.fmod(timingLoopCounter,99) == 0) and (currentPosition ~= "Submission") and (currentPosition ~= "Tap") or (attackHappening == false) then
    print("Inside gameloop event  " .. timingLoopCounter)
    -- if some random chance
    -- then perform an opponent attack
    defense = 5 --need to create getPlayersDefense(currentPosition)
    handleOpponentAttack( defense )
  end
end

Runtime:addEventListener("enterFrame", gameLoop)


 -- Function to handle a player attack
function handlePlayerAttack( attackType,defense )

    --1) Figure out what attack option is picked
    local values = attackPicker:getValues()

    selectedAttackValue = values[1].value
    
    print("attackType .. selectedAttackValue = " .. attackType .. selectedAttackValue)
    mostRecentActionText.text = attackType .. selectedAttackValue
    
    --2) Determine if it is a Technical or Strong Attack
    --is it a technical or strong attack
    local tableIndex
    if attackType == "Strong" then
      tableIndex = 1
    else
      tableIndex = 2
    end
    
    --3) Find attack strength for the character
    --get the character's Attack strength for the given position and attack type
    local attackStrength = character[currentPosition][1][tableIndex]
    
    --4) Find the attack result
    --determine attack result for that attack success
    local attackResult =  determineAttackResult(attackStrength,attackTable[selectedAttackValue][3],defense)
  
    --5) Determine the next position
    --determine the next position that will appear on screen for success
    currentPosition = attackTable[selectedAttackValue][attackResult]
    
    --6) Update display to reflect the new position
    --update stat info for current scene changes
    updateAttackStatsForPosition(currentPosition)
    currentPositionText.text = currentPosition 
    
    if currentPosition == "Submission" then
      interSceneData.score = score
      Runtime:removeEventListener("enterFrame", gameLoop)
      composer.gotoScene( "Scenes.SubmissionScene" )
    end
    --create new picker wheel with a list of current attacks
    attackPicker = createAttackPicker( character[currentPosition][2])

    --debug printing and temp display values
    print(successFailureTable[attackResult] .." going to  " .. attackTable[selectedAttackValue][attackResult])
    resultOfLastAttackText.text = successFailureTable[attackResult]
    currentPositionText.text = currentPosition 
    print( attackType .. " was pressed" )

end

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
    attackPicker = createAttackPicker( character[currentPosition][2] )
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
    
    mostRecentActionText = display.newText("", _W / 2, (2 * _H) / 6)
    mostRecentActionText:setFillColor( 1, 1, 1 )
    sceneGroup:insert( mostRecentActionText )
    
    currentPositionText = display.newText("", _W / 2, (1 * _H) / 6)
    currentPositionText:setFillColor( 1, 1, 1 )
    sceneGroup:insert( currentPositionText )
    
    currentPositionText.text = currentPosition
    
    resultOfLastAttackText = display.newText("", _W / 2, (3 * _H) / 6)
    resultOfLastAttackText:setFillColor( 1, 1, 1 )
    sceneGroup:insert( resultOfLastAttackText )
    
    scoreText = display.newText("", _W / 2, (1 * _H) / 12)
    scoreText:setFillColor( 1, 1, 1 )
    sceneGroup:insert( scoreText )
    
    scoreText.text = score
    
    mostRecentActionLabel = display.newText("Most Recent Action: ", 0, (2 * _H) / 6)
    currentPositionLabel = display.newText("Current Position: ", 0, (1 * _H) / 6)
    resultOfLastAttackLabel = display.newText("Result of Last Attack: ", 0, (3 * _H) / 6)
    scoreLabel = display.newText("Current Score: ", 0, (1 * _H) / 12)
    
    clockText = display.newText("01:33", 0, (1 * _H) / 24, native.systemFontBold, 20)
    clockText:setFillColor( 1, 1, 1 )
    
    sceneGroup:insert( mostRecentActionLabel )
    sceneGroup:insert( currentPositionLabel )
    sceneGroup:insert( resultOfLastAttackLabel )
    sceneGroup:insert( scoreLabel )
    sceneGroup:insert( clockText )
        
    -- Keep track of time in seconds
    local secondsLeft = 1 * 99   -- 20 minutes * 60 seconds

    local function updateTime()
      -- decrement the number of seconds
      secondsLeft = secondsLeft - 1

      -- time is tracked in seconds.  We need to convert it to minutes and seconds
      local minutes = math.floor( secondsLeft / 60 )
      local seconds = secondsLeft % 60
      
      -- make it a string using string format.  
      local timeDisplay = string.format( "%01d:%02d", minutes, seconds )
      clockText.text = timeDisplay
      
      if secondsLeft == 0 then
        interSceneData.score = score
        composer.gotoScene( "Scenes.SubmissionScene" )
      end
    end

    -- run the timer
    local countDownTimer = timer.performWithDelay( 1000, updateTime, secondsLeft )
    
    myAttackStatsLabel = display.newText("My Stats: ", 0, ((2 * _H) / 3) + ((_H / 18)))
    opponentAttackStatsLabel = display.newText("Op Stats: ", _W/2, (((2 * _H) / 3) + (_H/ 18)) )
        
    myAttackStats = display.newText("", _W/4, ((2 * _H) / 3) + ((_H / 18)))
    opponentAttackStats = display.newText("", 3*_W/4, (((2 * _H) / 3) + (_H/ 18)) ) 
    
    sceneGroup:insert( myAttackStatsLabel  )
    sceneGroup:insert( myAttackStats  )    
    sceneGroup:insert( opponentAttackStatsLabel )    
    sceneGroup:insert( opponentAttackStats  )
    
    updateAttackStatsForPosition(currentPosition)

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