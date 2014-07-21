-----------------------------------------------------------------------------------------
--
-- This is a simple prototype; things are hard coded; it is very messy.
-- it is not really meant to be used as a starting point or anything. It is only for
-- testing. assddfdasfasd
--
-----------------------------------------------------------------------------------------

--screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5;


-- CUSTOM FONT - Ale and Wenches BB
-- if "Win" == system.getInfo( "platformName" ) then
--     FONT_AleAndWenches = "Ale and Wenches BB"
--     FONT_Georgia = "Georgia"
-- elseif "Android" == system.getInfo( "platformName" ) then
--     FONT_AleAndWenches = "ALEAWB_"
--     FONT_Georgia = "estre"
-- else
--     -- Mac and iOS
--     FONT_AleAndWenches = "AleandWenchesBB"
--     FONT_Georgia = "Georgia"
-- end



-- hide the status bar
--display.setStatusBar( display.HiddenStatusBar )

math.randomseed( os.time() ) -- make sure we have random numbers when we need them!



-- include the Corona "storyboard" module
local storyboard = require "storyboard"

-- load menu screen
storyboard.gotoScene( "scripts.scenes.scene_results" )


