local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5
local storyboard = require( "storyboard" )
local utils = require("scripts.utils")
local ui = require("scripts.ui")
local Particles = require("scripts.lib_particle_candy")

local scene = storyboard.newScene()
local swatchGroup
local group, background, backgroundGradientOverlay, originalBackground, textureBackground
local colorWheelIcon, colorWheelButton, particlesGroup
--local ui = require( "scripts.ui" )



local function onKeyEvent( event )
    -- If the "back" key was pressed on Android, then prevent it from backing out of your app.
    if ((event.keyName == "back" or event.keyName == "b") and event.phase == "up") then -- and (system.getInfo("platformName") == "Android") then
        -- go back
        
        return true
    elseif (event.keyName == "g" and event.phase == "up") then
        if (particlesGroup.phase == 1) then
            particlesGroup.phase = 2
            particlesGroup.alpha = .25
        elseif (particlesGroup.phase == 2) then
            particlesGroup.phase = 3
            particlesGroup.alpha = 0
        else
            particlesGroup.phase = 1
            particlesGroup.alpha = .07
        end
        
        return true
    end

    -- Return false to indicate that this app is *not* overriding the received key.
    -- This lets the operating system execute its default handling of this key.
    return false
end


local function changeBackgroundColor(num)
    -- display.remove(background)
    -- display.remove(backgroundGradientOverlay)
    -- display a background image

    --group:insert(textureBackground)
    
    if (background ~= nil) then
        originalBackground = background
    end

    if (num == 1) then
        background = display.newImageRect( "images/tv114_00995.jpg", 380, 570 )
    else
        background = display.newImageRect( "images/0c023_00800.jpg", 380, 570 )
    end

    background.x, background.y = halfW, halfH
    
    background.fill.effect = "filter.blurGaussian"

    background.fill.effect.horizontal.blurSize = 85
    background.fill.effect.horizontal.sigma = 140
    background.fill.effect.vertical.blurSize = 85
    background.fill.effect.vertical.sigma = 140
    background.alpha = 0
    group:insert(background)

    if (originalBackground ~= nil) then
        transition.to(originalBackground, {time=400, alpha=0, onComplete=function()
            display.remove(originalBackground)
            originalBackground = nil
            transition.cancel()
            print("should be removing originalBackground")
            utils.checkMemory()
        end})
    end

    transition.to(background, {time=500, alpha=.45, onComplete=function()
    end})


    if (backgroundGradientOverlay == nil) then
        backgroundGradientOverlay = display.newImageRect( "images/background-gradient.png", 380, 570 )
        backgroundGradientOverlay.x, backgroundGradientOverlay.y = halfW, halfH
    end


    
    group:insert(backgroundGradientOverlay)
    group:insert(particlesGroup)
    group:insert(swatchGroup)
    group:insert(colorWheelButton)
    
end



local function swatchGroupTouch(event)
    if (event.phase == "began") then
        swatchGroup.markX = swatchGroup.x  -- store x location
        swatchGroup.markY = swatchGroup.y  -- store y location
    elseif (event.phase == "moved") then

        local xDiff = (event.x - event.xStart)
        local x = (event.x - event.xStart) + swatchGroup.markX
        -- do nothing with y because we're only moving side to side
        swatchGroup.x = x
    elseif (event.phase == "ended") then
        local xDiff = (event.x - event.xStart)

        if (xDiff <= -20) then
            swatchGroup.x = swatchGroup.markX - 250
            changeBackgroundColor(2)
        elseif (xDiff >= 20) then
            swatchGroup.x = swatchGroup.markX + 250
            changeBackgroundColor(1)
        end

    end

    return true
end


local function showColorWheel()
    local backgroundOverlay
    local chosenColorRect
    local colorRects = {}
    local colorRectBackgrounds = {}

    backgroundOverlay = display.newRect(0,0, 380, 570)
    backgroundOverlay.x, backgroundOverlay.y = halfW, halfH
    backgroundOverlay:setFillColor(0)
    backgroundOverlay.alpha = 0
    group:insert(backgroundOverlay)

    local chosenColorR, chosenColorG, chosenColorB = 101/255, 80/255, 81/255

    backgroundOverlay:addEventListener("touch", function(event)
        display.colorSample(event.x, event.y, function(e)
            chosenColorR, chosenColorG, chosenColorB = e.r, e.g, e.b
            chosenColorRect:setFillColor(chosenColorR, chosenColorG, chosenColorB, 1)
        end)
        return true
    end)

    transition.to(backgroundOverlay, {time=200, alpha = .75, onComplete=function()
        -- color wheel
        chosenColorRect = display.newCircle(halfW, halfH, 40)
        chosenColorRect.x, chosenColorRect.y = halfW, halfH
        chosenColorRect:setFillColor(chosenColorR, chosenColorG, chosenColorB, 1)
        chosenColorRect.strokeWidth = 2
        chosenColorRect:setStrokeColor(1)
        group:insert(chosenColorRect)

        local i
        for i=1, 12 do
            local colorRectGroup = display.newGroup()

            local startColor
            if (i == 1) then
                startColor = {1, 78/255, 0} -- dark orange
            elseif (i == 2) then
                startColor = {1, 155/255, 0} -- lighter orange
            elseif (i == 3) then
                startColor = {1, 191/255, 0} -- lightest orange
            elseif (i == 4) then
                startColor = {1, 1, 0} -- yellow
            elseif (i == 5) then
                startColor = {220/255, 1, 0} -- light green
            elseif (i == 6) then
                startColor = {105/255, 1, 0} -- green
            elseif (i == 7) then
                startColor = {0, 146/255, 206/255} -- light blue
            elseif (i == 8) then
                startColor = {0, 71/255, 1} -- blue
            elseif (i == 9) then
                startColor = {61/255, 0, 164/255} -- blue purple
            elseif (i == 10) then
                startColor = {134/255, 0, 175/255} -- purple
            elseif (i == 11) then
                startColor = {167/255, 25/255, 75/255} -- purple red
            elseif (i == 12) then
                startColor = {1, 39/255, 18/255} -- red
            else
                startColor = {math.random(1,100)/100, math.random(1,100)/100, math.random(1,100)/100}
            end

            colorRectBackgrounds[i] = display.newRoundedRect(0, 0, 160, 60, 8)
            colorRectBackgrounds[i]:setFillColor( 1 )
            colorRectBackgrounds[i].strokeWidth = 1
            colorRectBackgrounds[i]:setStrokeColor(1)
            colorRectGroup:insert(colorRectBackgrounds[i])

            local gradient = {
                type="gradient",
                color1=startColor, color2={ 1, 1, 1 }, direction="left"
            }
            colorRects[i] = display.newRect(0, 0, 150, 60)
            colorRects[i]:setFillColor(gradient)
            colorRects[i].strokeWidth = 1
            colorRects[i]:setStrokeColor(1)

            -- colorRects[i].fill.effect = "generator.linearGradient"

            -- colorRects[i].fill.effect.color1 = startColor
            -- colorRects[i].fill.effect.position1  = { 0, 0 }
            -- colorRects[i].fill.effect.color2 = { 0.1, 0.1, 0.1, 1 }
            -- colorRects[i].fill.effect.position2  = { 1, 1 }

            colorRectGroup:insert(colorRects[i])

            colorRectGroup.anchorChildren = true
            colorRectGroup.anchorX = 0
            colorRectGroup.x, colorRectGroup.y = halfW, halfH
            group:insert(colorRectGroup)
            transition.to(colorRectGroup, {time=i*50, rotation=(i-1)*-23})
            
        end

        group:insert(chosenColorRect)
    end})
end



-- Called when the scene's view does not exist:
function scene:createScene( event )
	group = self.view

    swatchGroup = display.newGroup()
    swatchGroup:addEventListener("touch", swatchGroupTouch)

    textureBackground = display.newImageRect( "images/background.jpg", 380, 570 )
    textureBackground.x, textureBackground.y = halfW, halfH
    group:insert(textureBackground)


    local swatch1 = display.newImageRect( "images/tv114_00995.jpg", 220, 220 )
    swatch1.x, swatch1.y = halfW, halfH

    local swatch1shadow = display.newImageRect( "images/black-square.png", 245, 245 )
    swatch1shadow.x, swatch1shadow.y = swatch1.x, swatch1.y 
    swatchGroup:insert(swatch1shadow)
    swatchGroup:insert(swatch1)


    local swatch2 = display.newImageRect( "images/0c023_00800.jpg", 220, 220 )
    swatch2.x, swatch2.y = screenW + 90, halfH

    local swatch2shadow = display.newImageRect( "images/black-square.png", 245, 245 )
    swatch2shadow.x, swatch2shadow.y = swatch2.x, swatch2.y 

    -- swatch2shadow.fill.effect = "filter.blurGaussian"
    -- swatch2shadow.fill.effect.horizontal.blurSize = 20
    -- swatch2shadow.fill.effect.horizontal.sigma = 10
    -- swatch2shadow.fill.effect.vertical.blurSize = 20
    -- swatch2shadow.fill.effect.vertical.sigma = 10

    swatchGroup:insert(swatch2shadow)
    swatchGroup:insert(swatch2) 

    group:insert(swatchGroup)

    colorWheelButton = ui.newButton{
        default = "images/color_wheel_icon.png",
        over = "",
        onRelease=function()
            -- open color picker ui
            showColorWheel()
        end,
        width = 39,
        height = 35
    }
    colorWheelButton.x, colorWheelButton.y = screenW - 32, halfH - 150


    particlesGroup = display.newGroup()
    
    Particles.CreateEmitter("FirefliesEmitter", halfW, halfH , 0, false, true)
    particlesGroup:insert(Particles.GetEmitter("FirefliesEmitter"))
    group:insert(particlesGroup)

    Particles.CreateParticleType ("Fireflies", 
        {
        imagePath          = "images/blurrylight.png",
        imageWidth         = 256,
        imageHeight        = 256,
        velocityStart      = 10,
        velocityVariation  = 25,
        weight             = 0, -- -.1,
        randomMotionMode   = 2,
        rotationVariation  = 360,
        rotationChange     = 45,
        directionVariation = 45,
        useEmitterRotation = true,
        alphaStart         = 0.0,
        
        fadeInSpeed        = .5,
        fadeOutSpeed       = -.5,
        fadeOutDelay       = 4000,
        scaleStart         = .15,
        scaleVariation     = .45,
        killOutsideScreen  = false,
        emissionShape      = 3,     
        emissionRadius     = 300,
        blendMode          = "add",
        lifeTime           = 9000,
        colorStart         = {1, 1, 1},
        colorChange        = {25/255, 25/255, 25/255}
        } )
    particlesGroup.alpha = 0

    -- FEED EMITTERS (EMITTER NAME, PARTICLE TYPE NAME, EMISSION RATE, DURATION, DELAY)
    Particles.AttachParticleType("FirefliesEmitter", "Fireflies", 2, 99999, 0) 

    -- TRIGGER THE EMITTERS
    Particles.StartEmitter("FirefliesEmitter")

    changeBackgroundColor(1)
end


local function frameUpdate()
    Particles.Update()
end





-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    storyboard.removeAll()
    local group = self.view

    -- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
    Runtime:addEventListener( "key", onKeyEvent );
    Runtime:addEventListener( "enterFrame", frameUpdate )
    
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