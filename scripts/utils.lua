-- OBJECT TO HOLD LOCAL VARIABLES AND FUNCTIONS
local _ = {}

_.table_concat = function(first, second)
    for k,v in pairs(second) do 
        first[k] = v
    end
    
    return first
end

-- Shuffle items in a table
_.shuffle = function(t)
    local n = #t

    -- on iPod Touch 2g, the numbers weren't actually random!
    -- so now i'm trying to seed it to force it to be...
    --math.randomseed( os.time() )

    while n >= 2 do
    -- n is now the last pertinent index
            local k = math.random(n) -- 1 <= k <= n
            -- Quick swap
            t[n], t[k] = t[k], t[n]
            n = n - 1
    end

    return t
end



_.shuffleString = function(inputStr)
    local outputStr = ""
    local strLength = string.len(inputStr)
    local originalInputStr = inputStr
    
    if (strLength <= 1) then
        return inputStr
    end

    while (strLength ~= 0) do
        --get a random character of the input string
        local pos = math.random(strLength)

        --insert into output string
        outputStr = outputStr .. string.sub(inputStr,pos,pos)

        --remove the used character from input string
        inputStr = inputStr:sub(1, pos-1) .. inputStr:sub(pos+1)

        --get new length of the input string
        strLength = string.len(inputStr)
    end
    
    if (outputStr == originalInputStr) then
        -- let's try again until we get one that is not the same
        return _.shuffleString(originalInputStr)
    end

    return outputStr;
end


_.generateRandomSeedFromString = function(inputStr)
    local seed = 0
    local strLength = string.len(inputStr)
    if (strLength == 0) then
        return 0
    end
    
    _.forEachCharacter(inputStr, function(charIndex, character)
        seed = seed + string.byte(inputStr)
    end)
    
    print("Random Seed:", seed)
    return seed
end


_.spairs = function(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


_.contains = function(t, element)
  for _, value in pairs(t) do
    if value == element then
      return true
    end
  end
  return false
end


_.findIndex = function(t, element)
    local i
    for i=1,#t do
        if t[i] == element then
            return i
        end
    end
    return nil
end


_.checkMemory = function()
   collectgarbage( "collect" )
   local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
   print( memUsage_str, "TEXTURE = " ..(system.getInfo("textureMemoryUsed") / (1024 * 1024)), system.getInfo( "maxTextureSize" ) )
end


-- Note that this function does not work on Android for files in the System.ResourceDirectory
-- if they have the following extensions: .html, .htm., .3gp, .m4v, .mp4, .png, .jpg, and .ttf.
-- So, it's only good for checking for existence of .txt files really.
-- See Android limitations: http://docs.coronalabs.com/api/library/system/pathForFile.html
_.fileExists = function(fileName, base)
  assert(fileName, "fileName does not exist")
  local base = base or system.ResourceDirectory
  local filePath = system.pathForFile( fileName, base )
  local exists = false
 
  if (filePath) then
    local fileHandle = io.open( filePath, "r" )
    if (fileHandle) then
      exists = true
      io.close(fileHandle)
    end
  end
 
  return(exists)
end


-- object starts large, then gets smaller, then back to normal
-- example:  utils.scaleAndReturn(rectangle, 700, -.10, -.10, "goButton" )
-- note that id is required if you'll be running the same transition over again on the same item
_.scaleAndReturn = function(obj, speed, xScale, yScale)
    local trans, scale, scaleBack
    
    speed = speed or 1000
    xScale = xScale or .25
    yScale = yScale or .25
    local tag = tostring(obj) .. "-scaleAndReturn"
    
    
    scale = function(e)
        if (obj == nil or obj.isVisible ~= true or obj.alpha == 0) then
            --print("cancelling " .. tag, obj)
            transition.cancel(tag)
        else
            --print("    scale: ", tag, obj, obj.isVisible, obj.alpha)
            trans = transition.scaleBy(obj, { time=speed, xScale=xScale, yScale=yScale, tag=tag, onComplete=scaleBack })
        end
    end


    scaleBack = function(e)
        if (obj == nil or obj.isVisible ~= true or obj.alpha == 0) then
            --print("cancelling " .. tag, obj)
            transition.cancel(tag)
        else
            --print("scaleBack: ", tag, obj, obj.isVisible, obj.alpha)
            trans = transition.scaleBy(obj, { time=speed, xScale=xScale * -1, yScale=yScale * -1, tag=tag, onComplete=scale })
        end
    end
    
    
    if (obj ~= nil) then
        -- if you try to start the same transition again on the same object...
        -- attempt to cancel previous transition
        --print("cancelling " .. tag .. " in obj ~= nil section")
        transition.cancel(tag)
        -- return object to original size before starting the transition again
        obj.xScale = 1
        obj.yScale = 1
        
        trans = scaleBack()
    end
    
    return trans -- so that you can cancel it manually with transition.cancel(trans)
end


-- Fades an object in and out over time
-- Example:
--   pulsate(rectangle, 1000, .5, 1)
_.pulsate = function(obj, speed, minAlpha, maxAlpha)
    local fadeIn, fadeOut
    local trans
    
    speed = speed or 1000
    minAlpha = minAlpha or 0
    maxAlpha = maxAlpha or 1
    local tag = tostring(obj) .. "-pulsate"

    function fadeIn(e)
        if (obj ~= nil and obj.isVisible == true) then
            trans = transition.to(obj, { time=speed, alpha=maxAlpha, onComplete=fadeOut, tag=tag })
        elseif (obj ~= nil) then
            transition.cancel(tag)
        end
    end

    function fadeOut(e)
        if (obj ~= nil and obj.isVisible == true) then
            trans = transition.to(obj, { time=speed, alpha=minAlpha, onComplete=fadeIn, tag=tag })
        elseif (obj ~= nil) then
            transition.cancel(tag)
        end
    end

    if (obj ~= nil) then
        -- so that you can cancel it manually with transition.cancel(trans)
        trans = fadeOut()
    end
    
    return trans
end

-- Get OS version number
versionNumber = tonumber(string.sub(system.getInfo("platformVersion"),1,3))


-- SOUND EFFECTS
local soundFX

-- if "Android" == system.getInfo( "platformName" ) and versionNumber < 4.2 then
--     -- setup to play sounds on older android devices as fast as possible, with no volume control
--     soundFX = {
--         scoreSound = media.newEventSound("audio/award.wav"),
--         scoreShortSound = media.newEventSound("audio/short_award.wav"),
--         hurt1Sound = media.newEventSound("audio/hurtsound1.wav"),
--         hurt2Sound = media.newEventSound("audio/hurtsound2.wav"),
--         beep0Sound = media.newEventSound("audio/shortbeep0.wav"),
--         beep1Sound = media.newEventSound("audio/shortbeep1.wav"),
--         beep2Sound = media.newEventSound("audio/shortbeep2.wav"),
--         beep3Sound = media.newEventSound("audio/shortbeep3.wav"),
--         beep4Sound = media.newEventSound("audio/shortbeep4.wav"),
--         sword1Sound = media.newEventSound("audio/sword1.wav"),
--         sword2Sound = media.newEventSound("audio/sword2.wav"),
--         buttonSound = media.newEventSound("audio/woodclick.wav"),
--         impactSound = media.newEventSound("audio/heroicimpact.wav"),
--         doubleImpactSound = media.newEventSound("audio/doubleimpact.wav"),
--         pageTurnSound = media.newEventSound("audio/pageturn.wav"),
--         doorOpeningSound = media.newEventSound("audio/door_opening.wav"),
--         doorClosingSound = media.newEventSound("audio/door_closing.wav"),
--         tickSound = media.newEventSound("audio/tick.wav"),
--         chimeSound = media.newEventSound("audio/magicwand.wav"),
--         timeBonusSound = media.newEventSound("audio/speech_timebonus.wav"),
--         healthBonusSound = media.newEventSound("audio/speech_healthbonus.wav"),
--         diceWoodSound = media.newEventSound("audio/dicewood.wav"),
--         coinSound = media.newEventSound("audio/coins.wav"),
--         defeatSound = media.newEventSound("audio/defeat.wav"),
--         swordImpactSound1 = media.newEventSound("audio/swordflesh.wav"),
--         swordImpactSound2 = media.newEventSound("audio/swordimpact.wav")
--     }
-- else
--     soundFX = {
--         scoreSound = audio.loadSound("audio/award.wav"),
--         scoreShortSound = audio.loadSound("audio/short_award.wav"),
--         hurt1Sound = audio.loadSound("audio/hurtsound1.wav"),
--         hurt2Sound = audio.loadSound("audio/hurtsound2.wav"),
--         beep0Sound = audio.loadSound("audio/shortbeep0.wav"),
--         beep1Sound = audio.loadSound("audio/shortbeep1.wav"),
--         beep2Sound = audio.loadSound("audio/shortbeep2.wav"),
--         beep3Sound = audio.loadSound("audio/shortbeep3.wav"),
--         beep4Sound = audio.loadSound("audio/shortbeep4.wav"),
--         sword1Sound = audio.loadSound("audio/sword1.wav"),
--         sword2Sound = audio.loadSound("audio/sword2.wav"),
--         buttonSound = audio.loadSound("audio/woodclick.wav"),
--         impactSound = audio.loadSound("audio/heroicimpact.wav"),
--         doubleImpactSound = audio.loadSound("audio/doubleimpact.wav"),
--         pageTurnSound = audio.loadSound("audio/pageturn.wav"),
--         doorOpeningSound = audio.loadSound("audio/door_opening.wav"),
--         doorClosingSound = audio.loadSound("audio/door_closing.wav"),
--         tickSound = audio.loadSound("audio/tick.wav"),
--         chimeSound = audio.loadSound("audio/magicwand.wav"),
--         timeBonusSound = audio.loadSound("audio/speech_timebonus.wav"),
--         healthBonusSound = audio.loadSound("audio/speech_healthbonus.wav"),
--         diceWoodSound = audio.loadSound("audio/dicewood.wav"),
--         coinSound = audio.loadSound("audio/coins.wav"),
--         defeatSound = audio.loadSound("audio/defeat.wav"),
--         swordImpactSound1 = audio.loadSound("audio/swordflesh.wav"),
--         swordImpactSound2 = audio.loadSound("audio/swordimpact.wav")
--     }
-- end


-- playSoundFX plays a sound from the soundFX table
_.playSoundFX = function(sound, volume)
    volume = volume or .25
    
    if "Android" == system.getInfo( "platformName" ) and versionNumber < 4.2 then
        -- plays sound with no volume control
        media.playEventSound( soundFX[sound] )
    else
        local soundChannel = audio.findFreeChannel()
        audio.setVolume(volume, { channel=soundChannel })
        audio.play(soundFX[sound], { channel=soundChannel })
    end
    
    
end


-- basic array slicing method, taking from left
-- doesn't handle negative values to slice from the end
_.take = function(t, num)
    if (t == nil) then
        return nil
    end
    
    if (num > #t) then
        num = #t
    end
    
    local nums = {}
    local i
    
    for i=1, num do
        nums[#nums+1] = t[i]
    end
    
    return nums
end

-- you give it a start and end num, and it generates all the numbers in between,
-- then shuffles them
_.shuffleRandom = function(num1, num2) 
    
    -- default behavior of math.random(5) for example
    if (num2 == nil or num2 < num1) then
        num2 = num1
        num1 = 1
    end
    
    local i
    local nums = {}
    
    for i=num1, num2 do
        nums[#nums+1] = i
    end
    
    return _.shuffle(nums)
end


_.trim = function(s)
  return s:gsub("^%s*(.-)%s*$", "%1")
end


_.getRandomWord = function(numChars)
    local filePath = system.pathForFile( "data/wordlist.txt", system.ResourceDirectory )
    -- io.open opens a file at filePath. returns nil if no file found
    local file = io.open( filePath, "r" )
    if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        io.close( file )
        file = nil

        local lineArray = {}
        local line
        -- build a list of words with that number of characters
        for line in io.lines(filePath) do
            line = line:gsub("%s+", "") -- remove spaces
            line = _.trim(line) -- trim whitespace
            if string.len(line) == numChars then
                lineArray[#lineArray + 1] = line
            end
        end

        -- select one from the list
        local selectedWord = lineArray[math.random(#lineArray)]

        return selectedWord:upper()
    end
end


_.forEachCharacter = function(str, func)
    local charIndex
    local character
    local wordLength = string.len(str)

    for charIndex=1,wordLength do
        character = str:sub(charIndex,charIndex):upper()
        func(charIndex, character)
    end
end


_.cleanDisplayObjects = function(obj)
    if (obj ~= nil and obj.numChildren and obj.numChildren > 0) then
        local i
        for i=obj.numChildren, 1, -1 do
            if (obj[i] ~= nil) then
                _.cleanDisplayObjects(obj[i])
            end
        end
    end
    
    if (obj ~= nil) then
        obj.parent:remove(obj)
        obj = nil
    end
end


---============================================================
-- add comma to separate thousands
-- 
local function comma_value(amount)
  local formatted = amount
  local k
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

---============================================================
-- rounds a number to the nearest decimal places
--
local function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

--===================================================================
-- given a numeric value formats output with comma to separate thousands
-- and rounded to given decimal places
--
-- Example Usage:
--amount = 1333444.1
--print(format_num(amount,2))
--print(format_num(amount,-2,"US$"))
--
--amount = -22333444.5634
--print(format_num(amount,2,"$"))
--print(format_num(amount,2,"$","()"))
--print(format_num(amount,3,"$","NEG "))
_.format_num = function(amount, decimal, prefix, neg_prefix)
  local str_amount,  formatted, famount, remain

  decimal = decimal or 2  -- default 2 decimal places
  neg_prefix = neg_prefix or "-" -- default negative sign

  famount = math.abs(round(amount,decimal))
  famount = math.floor(famount)

  remain = round(math.abs(amount) - famount, decimal)

        -- comma to separate the thousands
  formatted = comma_value(famount)

        -- attach the decimal portion
  if (decimal > 0) then
    remain = string.sub(tostring(remain),3)
    formatted = formatted .. "." .. remain .. string.rep("0", decimal - string.len(remain))
  end

        -- attach prefix string e.g '$' 
  formatted = (prefix or "") .. formatted 

        -- if value is negative then format accordingly
  if (amount<0) then
    if (neg_prefix=="()") then
      formatted = "("..formatted ..")"
    else
      formatted = neg_prefix .. formatted 
    end
  end

  return formatted
end



return _