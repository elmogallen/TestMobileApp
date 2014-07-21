local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5

-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local ui = require( "scripts.ui" )

--------------------------------------------



-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	Utils.playSoundFX("buttonSound", 0.35)
	
	storyboard.gotoScene( "scripts.scenes.scene_menu", "fade", 500 )
	
	return true	-- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

local function onKeyEvent( event )
    -- If the "back" key was pressed on Android, then prevent it from backing out of your app.
    if ((event.keyName == "back" or event.keyName == "b") and event.phase == "up") then -- and (system.getInfo("platformName") == "Android") then
        onPlayBtnRelease()
        
        return true
    end

    -- Return false to indicate that this app is *not* overriding the received key.
    -- This lets the operating system execute its default handling of this key.
    return false
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newImageRect( "images/backgrounds/castle_background.jpg", 380, 570 )
	background.x, background.y = halfW, halfH
        background:addEventListener("tap", onPlayBtnRelease)
        
        local titleText = display.newText("Credits", 0, 0, FONT_AleAndWenches, 22)
        --titleText:setReferencePoint(display.TopCenterReferencePoint)
        titleText.anchorX = .5
        titleText.anchorY = 0
        titleText.x = halfW
        titleText.y = 16
        titleText:setFillColor(1)
        
        local options = 
        {
            --parent = groupObj,
            text = "Programming/Game Design\nDave Haynes\n\nMusic\n'Hitman'\n'Our Story Begins'\nKevin MacLeod (incompetech.com)\n\nArt\nMostly Daniel Ferencak\n(eatcreatures.com)\n\nTesters\nAvery Haynes\nJulia Haynes\nTanya Haynes\nDavid Johnson\nSergei Khvatkov\nCameron Lawrence\nAnnabel Lee\nHoward Lee\nDaniel Stepp\nRobert Treat",
            x = halfW,
            y = halfH + 50,
            width = 320,            --required for multiline and alignment
            height = 480,           --required for multiline and alignment
            font = FONT_AleAndWenches,   
            fontSize = 12,
            align = "center"          --new alignment field
        }
        
        local creditsText = display.newText(options)
--        titleText:setReferencePoint(display.TopCenterReferencePoint)
--        titleText.x = halfW
--        titleText.y = 130
        creditsText:setFillColor(1)
        
	-- all display objects must be inserted into group
	group:insert( background )
        group:insert( titleText )
        group:insert( creditsText )
end



-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    storyboard.removeAll()
    local group = self.view

    -- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
    Runtime:addEventListener( "key", onKeyEvent );
    
--    local options = {
--        service = "facebook",
--        message = "I just made it to level 20 in Puzzlewood for iOS!",
--        listener = function()
--        end
----        image = {
----           { filename = "pic.jpg", baseDir = system.ResourceDirectory },
----           { filename = "pic2.jpg", baseDir = system.ResourceDirectory }
----        },
----        url = "http://coronalabs.com"
--    }
--    native.showPopup("social", options)
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	Runtime:removeEventListener( "key", onKeyEvent );
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene