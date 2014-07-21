local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5

-------------------------------------------------
-- This class stores properties related to the bacgrounds in the game
-------------------------------------------------


-------------------------------------------------
-- PRIVATE FIELDS
-------------------------------------------------
local Particles = require("scripts.lib_particle_candy")

-- OBJECT TO HOLD LOCAL VARIABLES AND FUNCTIONS
local B = {}

B.backgroundMusic = nil
B.backgroundMusicHandle = nil
B.soundChannel = nil
B.background = nil
B.backgroundImage = nil
B.worlds = nil
B.worldIndex = nil

local displayStage
local backgroundGroup, particleSplatGroup

local Update = function(origin)
    local o = origin or "Background.Update: origin not specified"
    --print(o)
    
    if (Particles ~= nil) then
        Particles.Update()
    end
end
B.Update = Update

local CleanUp = function(origin)
    local o = origin or "Background.CleanUp: origin not specified"
    print("Background.CleanUp: " .. o)
    
    if (Particles ~= nil) then
        Particles.CleanUp()
    end
    
    display.remove(backgroundGroup)
    
    if (B.background ~= nil) then
        B.background:removeSelf()
        B.background = nil
    end
    
    B.backgroundImage = nil
    
    collectgarbage("collect")
end
B.CleanUp = CleanUp


local ShowBackground = function (sceneGroup)
    displayStage = display.getCurrentStage()
    
    if (origin == "gameboard" or origin == "areaselect" or origin == "story" or origin == "shop") then
        displayStage:insert( sceneGroup )
        return
    end
    
    B.worlds = worlds
    B.worldIndex = worldIndex
   
    -- starting background music
    B.playBackgroundMusic = playBackgroundMusic
    if (B.playBackgroundMusic ~= nil and B.playBackgroundMusic == true) then
        PlayBackgroundMusic()
    end
    
    backgroundGroup = display.newGroup()
    
    B.backgroundImage = "images/backgrounds/" .. worlds[worldIndex].imagePrefix .. "_background.jpg"
    B.background = display.newImageRect( B.backgroundImage, 380, 570 )
    B.background.x = halfW
    B.background.y = halfH
    backgroundGroup:insert( B.background )
    
    
    local particlesGroup = display.newGroup()
    
    if (worlds[worldIndex].effects == "darkforest") then
        Particles.CreateEmitter("FirefliesEmitter", halfW, halfH , 0, false, true)
	particlesGroup:insert(Particles.GetEmitter("FirefliesEmitter"))
        backgroundGroup:insert(particlesGroup)

	Particles.CreateParticleType ("Fireflies", 
		{
		imagePath          = "images/flare.png",
		imageWidth         = 128,
		imageHeight        = 128,
		velocityStart      = 15,
		velocityVariation  = 30,
		weight             = 0, -- -.1,
                randomMotionMode = 2,
		rotationVariation  = 360,
		rotationChange     = 45,
                directionVariation = 45,
		useEmitterRotation = true,
		alphaStart         = 0.0,
		fadeInSpeed        = .5,
		fadeOutSpeed       = -.5,
		fadeOutDelay       = 6000,
		scaleStart         = .02,
		scaleVariation     = .15,
		killOutsideScreen  = true,
		emissionShape      = 1,		
		emissionRadius     = 400,
		blendMode          = "add",
		lifeTime           = 8000,
		colorStart         = {100/255,100/255,0},
                colorChange        = {25/255, 25/255, 25/255}
		} )


	-- FEED EMITTERS (EMITTER NAME, PARTICLE TYPE NAME, EMISSION RATE, DURATION, DELAY)
	Particles.AttachParticleType("FirefliesEmitter", "Fireflies", 5, 99999,0) 

	-- TRIGGER THE EMITTERS
	Particles.StartEmitter("FirefliesEmitter")
        
    elseif (worlds[worldIndex].effects == "snowyplains") then
        Particles.CreateEmitter("SnowEmitter", screenW*0.5, -100, 180, false, true)
	particlesGroup:insert(Particles.GetEmitter("SnowEmitter"))
        backgroundGroup:insert(particlesGroup)

        -- DEFINE PARTICLE TYPE PROPERTIES
        local Properties 				= {}
        Properties.imagePath			= "images/snow.png"
        Properties.imageWidth			= 64	-- PARTICLE IMAGE WIDTH  (newImageRect)
        Properties.imageHeight			= 64	-- PARTICLE IMAGE HEIGHT (newImageRect)
        Properties.velocityStart		= 25	-- PIXELS PER SECOND
        Properties.velocityVariation	= 50
        Properties.directionVariation	= 45
        Properties.alphaStart			= 0		-- PARTICLE START ALPHA
        Properties.fadeInSpeed			= 2.0	-- PER SECOND
        Properties.fadeOutSpeed			= -1.0	-- PER SECOND
        Properties.fadeOutDelay			= 7000	-- WHEN TO START FADE-OUT
        Properties.scaleStart			= 0.5	-- PARTICLE START SIZE
        Properties.scaleVariation		= 3.0
        Properties.scaleInSpeed			= 0.25
        Properties.weight				= 0.01	-- PARTICLE WEIGHT (>0 FALLS DOWN, <0 WILL RISE UPWARDS)
        Properties.rotationChange		= 30	-- ROTATION CHANGE PER SECOND
        Properties.emissionShape		= 1		-- 0 = POINT, 1 = LINE, 2 = RING, 3 = DISC
        Properties.emissionRadius		= 240	-- SIZE / RADIUS OF EMISSION SHAPE
        Properties.killOutsideScreen	= false	-- PARENT LAYER MUST NOT BE NESTED OR ROTATED! 
        Properties.lifeTime				= 8500  -- MAX. LIFETIME OF A PARTICLE
        Properties.useEmitterRotation	= false	--INHERIT EMITTER'S CURRENT ROTATION
        Properties.blendMode			= "add" -- SETS BLEND MODE ("add" OR "normal", DEFAULT IS "normal")
        Particles.CreateParticleType ("Snow", Properties)

        -- FEED EMITTERS (EMITTER NAME, PARTICLE TYPE NAME, EMISSION RATE, DURATION, DELAY)
        Particles.AttachParticleType("SnowEmitter", "Snow" , 4, 99999, 100) 

        -- TRIGGER THE EMITTER
        Particles.StartEmitter("SnowEmitter")
        
    elseif (worlds[worldIndex].effects == "desert") then
        Particles.CreateEmitter("TumbleweedEmitter", -50, 300, 90, false, true)
        --Particles.CreateEmitter("Beams" , 260, 32, 0, false, true)
        Particles.CreateEmitter("Beams" , 256, 30, 0, false, true)
        Particles.CreateEmitter("SunflareEmitter", 256, 30, 0, false, true)
        
	particlesGroup:insert(Particles.GetEmitter("TumbleweedEmitter"))
        particlesGroup:insert(Particles.GetEmitter("SunflareEmitter"))
        particlesGroup:insert(Particles.GetEmitter("Beams"))
        backgroundGroup:insert(particlesGroup)

	Particles.CreateParticleType ("Tumbleweed", 
		{
		imagePath          = "images/wisp.png",
		imageWidth         = 128,
		imageHeight        = 128,
		velocityStart      = 120,
		velocityVariation  = 60,
		weight             = 0,
		rotationVariation  = 180,
		rotationChange     = 150,
                directionVariation = 5,
		useEmitterRotation = true,
		alphaStart         = .15,
		fadeInSpeed        = .5,
		fadeOutSpeed       = -.5,
		fadeOutDelay       = 8000,
		scaleStart         = .65,
		scaleVariation     = .35,
		killOutsideScreen  = false,
		emissionShape      = 1,
		emissionRadius     = 150,
		blendMode          = "multiply",
		lifeTime           = 8000,
		colorStart         = {151 / 255, 120 / 255, 65 / 255},
		} )
                
        Particles.CreateParticleType ("BeamParticles", 
		{
		imagePath         = "images/beam.png",
		imageWidth        = 128,	
		imageHeight       = 32,	
		xReference        = -64,	
		velocityStart     = 0,	
		alphaStart        = 0,	
		fadeInSpeed       = 1.5,	
		fadeOutSpeed      = -1.0,
		fadeOutDelay      = 1000,
		scaleStart        = 2,
		scaleVariation    = 2,
		rotationVariation = 360,	
		rotationChange    = 4,	
		weight            = 0,	
		emissionShape     = 0,	
		killOutsideScreen = false,
		blendMode         = "add",
		lifeTime          = 3000,
		} )

        Particles.CreateParticleType ("SunFlare", 
		{
		imagePath          = "images/flare.png",
		imageWidth         = 128,
		imageHeight        = 128,
		directionVariation = 360,
		rotationVariation  = 360,
		rotationChange     = 5,
		useEmitterRotation = false,
		alphaStart         = 0.0,
		fadeInSpeed        = 1.0,
		fadeOutSpeed       = -1.0,
		fadeOutDelay       = 1000,
		scaleStart         = 2,
		scaleVariation     = 0,
		killOutsideScreen  = false,
		emissionShape      = 2,		
		emissionRadius     = 1,
		blendMode          = "add",
		lifeTime           = 3000,
		} )
        

	-- FEED EMITTERS (EMITTER NAME, PARTICLE TYPE NAME, EMISSION RATE, DURATION, DELAY)
        Particles.AttachParticleType("Beams", "BeamParticles" , 5, 99999, 0) 
        Particles.AttachParticleType("SunflareEmitter", "SunFlare"  , 2, 99999,0) 
	Particles.AttachParticleType("TumbleweedEmitter", "Tumbleweed", .25, 99999,0) 

	-- TRIGGER THE EMITTERS
	Particles.StartEmitter("TumbleweedEmitter")
        --Particles.StartEmitter("Beams")
        Particles.StartEmitter("SunflareEmitter")
        
        -- Add sun overlay
        local sun = display.newImageRect( "images/sun.png", 87, 87 )
        sun.anchorX = 1
        sun.anchorY = 0
        sun.x = 300
        sun.y = -6
        backgroundGroup:insert(sun)
        
    elseif (worlds[worldIndex].effects == "graveyard") then
        -- CREATE EMITTERS (NAME, SCREENW, SCREENH, ROTATION, ISVISIBLE, LOOP)
	Particles.CreateEmitter("E1", screenW*.5, -256, 170, false, true)
	Particles.CreateEmitter("E3", screenW*.35, screenH*.95, 0, false, true)
	Particles.CreateEmitter("E4", screenW*.5, screenH*.5, 160, false, true)
        
	particlesGroup:insert(Particles.GetEmitter("E1"))
	particlesGroup:insert(Particles.GetEmitter("E3"))
	particlesGroup:insert(Particles.GetEmitter("E4"))
        backgroundGroup:insert(particlesGroup)

	-- DEFINE PARTICLE TYPES
	Particles.CreateParticleType ("Rain", 
		{
		imagePath          = "images/rain.png",
		imageWidth         = 256,	
		imageHeight        = 256,	
		velocityStart      = 600,
		velocityVariation  = 150,
		directionVariation = 10,
		autoOrientation    = true,
		useEmitterRotation = true,
		alphaStart         = 0.0,
		fadeInSpeed        = 5.0,
		fadeOutSpeed       = -0.75,
		fadeOutDelay       = 500,
		scaleStart         = 0.5,
		scaleVariation     = 0.3,
		scaleInSpeed       = 1,
		emissionShape      = 1,
		emissionRadius     = 400,
		killOutsideScreen  = false,
		lifeTime           = 1500,
		blendMode          = "screen",
		colorStart         = {100/255,100/255,125/255},
		yReference         = 96/480,
		} )

	Particles.CreateParticleType ("RainDistance", 
		{
		imagePath          = "images/rain.png",
		imageWidth         = 256,	
		imageHeight        = 256,	
		velocityStart      = 400,
		velocityVariation  = 100,
		directionVariation = 10,
		autoOrientation    = true,
		useEmitterRotation = true,
		alphaStart         = 0.0,
		fadeInSpeed        = 5.0,
		fadeOutSpeed       = -0.75,
		fadeOutDelay       = 500,
		scaleStart         = 0.3,
		scaleVariation     = 0.25,
		scaleInSpeed       = 1,
		emissionShape      = 1,
		emissionRadius     = 400,
		killOutsideScreen  = false,
		lifeTime           = 1500,
		blendMode          = "screen",
		colorStart         = {100/255,100/255,125/255},
		yReference         = 96/480,
		} )

	Particles.CreateParticleType ("Splats",
		{
		imagePath          = "images/water_splat1.png",
		imageWidth         = 64,	
		imageHeight        = 16,	
		alphaStart         = .25,		
		alphaVariation     = .25,		
		fadeInSpeed        = 1.5,	
		fadeOutSpeed       = -3,	
		fadeOutDelay       = 250,	
		scaleStart         = 0.05,	
		scaleVariation     = 0.05,
		scaleInSpeed       = 1,
		scaleMax           = .5,
		lifeTime           = 1000,  
		emissionShape      = 0,	
		emissionShape      = 3,		
		emissionRadius     = 160,
		blendMode          = "alpha",
		colorStart         = {225/255,225/255,255/255},
		killOutsideScreen  = true,
		} )


	-- FEED EMITTERS (EMITTER NAME, PARTICLE TYPE NAME, EMISSION RATE, DURATION, DELAY)
	Particles.AttachParticleType("E1", "Rain" ,15, 99999,0) 
	Particles.AttachParticleType("E1", "RainDistance" ,10, 99999,0) 
	Particles.AttachParticleType("E3", "Splats",25, 99999,0) 

	-- TRIGGER THE EMITTERS
	Particles.StartEmitter("E1")
	Particles.StartEmitter("E3")
        
    elseif (worlds[worldIndex].effects == "cave") then
        
        Particles.CreateEmitter("BatsEmitter", halfW, halfH, 0, false, true)
        
	particlesGroup:insert(Particles.GetEmitter("BatsEmitter"))
        backgroundGroup:insert(particlesGroup)

	Particles.CreateParticleType ("Bats", 
		{
		imagePath          = "images/bat.png",
		imageWidth         = 160,
		imageHeight        = 60,
                weight             = 0,
                randomMotionMode   = 2,
		velocityStart      = 300,
		velocityVariation  = 100,
		rotationVariation  = 360,
                rotationChange     = 90,
                faceEmitter        = true,
                autoOrientation    = true,
                directionVariation = 360,
		--useEmitterRotation = true,
		alphaStart         = 1,
		scaleStart         = .2,
		scaleVariation     = .2,
		killOutsideScreen  = false,
		emissionShape      = 2, -- 2 = circle
		emissionRadius     = 400,
		lifeTime           = 4500,
                randomMotionInterval = 100
		} )


	-- FEED EMITTERS (EMITTER NAME, PARTICLE TYPE NAME, EMISSION RATE, DURATION, DELAY)
	Particles.AttachParticleType("BatsEmitter", "Bats", .5, 99999, 0) 

	-- TRIGGER THE EMITTERS
	Particles.StartEmitter("BatsEmitter")
        
    elseif (worlds[worldIndex].effects == "underworld") then
        Particles.CreateEmitter("FirefliesEmitter", halfW, halfH, 0, false, true)
	particlesGroup:insert(Particles.GetEmitter("FirefliesEmitter"))
        backgroundGroup:insert(particlesGroup)

	Particles.CreateParticleType ("Fireflies", 
		{
		imagePath          = "images/wisp.png",
		imageWidth         = 128,
		imageHeight        = 128,
		velocityStart      = 10,
		velocityVariation  = 35,
		weight             = 0,
                randomMotionMode = 2,
		rotationVariation  = 360,
		rotationChange     = 45,
                directionVariation = 45,
		useEmitterRotation = true,
		alphaStart         = 0.0,
		fadeInSpeed        = .5,
		fadeOutSpeed       = -.5,
		fadeOutDelay       = 6000,
		scaleStart         = .015,
		scaleVariation     = .10,
		killOutsideScreen  = true,
		emissionShape      = 1,		
		emissionRadius     = 400,
		blendMode          = "add",
		lifeTime           = 10000,
		colorStart         = {128/255,0,0},
                colorChange        = {25/255, 35/255, 35/255}
		} )


	-- FEED EMITTERS (EMITTER NAME, PARTICLE TYPE NAME, EMISSION RATE, DURATION, DELAY)
	Particles.AttachParticleType("FirefliesEmitter", "Fireflies", 5, 99999,0) 

	-- TRIGGER THE EMITTERS
	Particles.StartEmitter("FirefliesEmitter")
    end
    
    -- CREATE EMITTER
    Particles.CreateEmitter("BigSplatEmitter", halfW, halfH, 0, false, false)

    -- DEFINE FLAME PARTICLE TYPES
    Particles.CreateParticleType ("BigSplat", 
    {
    imagePath          = "images/splat.png",
    imageWidth         = 128,
    imageHeight        = 128, -- 96
    velocityStart      = 0,	
    alphaStart         = 1,	
    fadeInSpeed        = 0,	
    fadeOutSpeed       = -1,
    fadeOutDelay       = 1000,
    scaleStart         = 0.1,
    scaleVariation     = 0,
    scaleInSpeed       = 20,
    scaleMax           = 2.5,
    rotationVariation  = 360, -- 10
    rotationChange     = 0,
    weight             = 0.001,	
    bounceX            = false, 
    bounceY            = false, 
    bounciness         = 0.75,
    emissionShape      = 0,
    emissionRadius     = 140,
    killOutsideScreen  = false,	
    lifeTime           = 8000, 
    autoOrientation    = false,	
    useEmitterRotation = false,	
    blendMode          = "normal", 
    colorChange        = {-30,-70,-70},
    } )

    -- FEED EMITTER
    Particles.AttachParticleType("BigSplatEmitter", "BigSplat", 1, 9999,0) 
    particleSplatGroup = display.newGroup()
    particleSplatGroup:insert(Particles.GetEmitter("BigSplatEmitter"))
    
    --sceneGroup:insert(backgroundGroup)
    
    displayStage:insert( backgroundGroup )
    displayStage:insert( particleSplatGroup )
    displayStage:insert( sceneGroup )
end
B.ShowBackground = ShowBackground


local function doSplat(group)
    displayStage:insert( backgroundGroup )
    displayStage:insert( particleSplatGroup )
    displayStage:insert( group )
    Particles.GetEmitter("BigSplatEmitter").rotation = math.random()*360;
    Particles.GetEmitter("BigSplatEmitter").x = halfW
    Particles.GetEmitter("BigSplatEmitter").y = halfH
    Particles.StartEmitter("BigSplatEmitter", true)
end
B.doSplat = doSplat


return B