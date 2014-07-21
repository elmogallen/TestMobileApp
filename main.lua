-----------------------------------------------------------------------------------------
--
-- main.lua - This is a simple prototype; things are hard coded; it is very messy.
-- it is not really meant to be used as a starting point or anything. It is only for
-- testing. assddfdasfasd
--
-----------------------------------------------------------------------------------------
--local loadsave = require("scripts.loadsave")
--utils = require("scripts.utils")

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



-- Displaying fonts on system
--local fonts = native.getFontNames()
--
--count = 0
--
---- Count the number of total fonts
--for i,fontname in ipairs(fonts) do
--    count = count+1
--end
--
--print( "\rFont count = " .. count )
--
--local name = "georgia"     -- part of the Font name we are looking for
--
--name = string.lower( name )
--
---- Display each font in the terminal console
--for i, fontname in ipairs(fonts) do
--    j, k = string.find( string.lower( fontname ), name )
--
--    if( j ~= nil ) then
--
--        print( "fontname = " .. tostring( fontname ) )
--
--    end
--end


