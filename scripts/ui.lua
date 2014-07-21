local Utils = require("scripts.utils")

local Public = {}

-----------------
-- Helper function for newButton utility function below
local newButtonHandler = function( self, event )
	
	local result = true

	local default = self[1]
	local over = self[2]
	
	-- General "onEvent" function overrides onPress and onRelease, if present
	local onEvent = self._onEvent
	local onPress = self._onPress
	local onRelease = self._onRelease

	local buttonEvent = {}
	if (self._id) then
		buttonEvent.id = self._id
	end

	local phase = event.phase
	if "began" == phase then
		if over then 
			default.isVisible = false
			over.isVisible = true
		end

		if onEvent then
			buttonEvent.phase = "press"
			result = onEvent( buttonEvent )
		elseif onPress then
			result = onPress( event )
		end

		-- Subsequent touch events will target button even if they are outside the contentBounds of button
		display.getCurrentStage():setFocus( self, event.id )
		self.isFocus = true
		
	elseif self.isFocus then
		local bounds = self.contentBounds
		local x,y = event.x,event.y
		local isWithinBounds = 
			bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

		if "moved" == phase then
			if over then
				-- The rollover image should only be visible while the finger is within button's contentBounds
				default.isVisible = not isWithinBounds
				over.isVisible = isWithinBounds
			end
			
		elseif "ended" == phase or "cancelled" == phase then 
			if over then 
				default.isVisible = true
				over.isVisible = false
			end
			
			if "ended" == phase then
				-- Only consider this a "click" if the user lifts their finger inside button's contentBounds
				if isWithinBounds then
					if onEvent then
						buttonEvent.phase = "release"
						result = onEvent( buttonEvent )
					elseif onRelease then
						result = onRelease( event )
					end
				end
			end
			
			-- Allow touch events to be sent normally to the objects they "hit"
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
		end
	end

	return result
end


---------------
-- Button class

Public.newButton = function( params )
	local button, default, over, size, font, textColor, offset
	
	if params.default then
		button = display.newGroup()
		if (params.width and params.height) then
			default = display.newImageRect( params.default, params.width, params.height )
		else
			default = display.newImage( params.default )
		end
                
                if (params.anchorX ~= nil) then
                    default.anchorX = params.anchorX
                end

                if (params.anchorY ~= nil) then
                    default.anchorY = params.anchorY
                end
                
		button:insert( default, true )
	end
	
	if params.over then
		if (params.over == "") then
			if (params.width and params.height) then
				over = display.newImageRect( params.default, params.width * 1.1, params.height * 1.1)
			else
				over = display.newImage( params.default )
			end
                        
			over:setFillColor( 176 / 255, 255 / 255 )
		else
			if (params.width and params.height) then
				over = display.newImageRect( params.over, params.width, params.height )
			else
				over = display.newImage( params.over )
			end
		end
                
                if (params.anchorX ~= nil) then
                    over.anchorX = params.anchorX
                end

                if (params.anchorY ~= nil) then
                    over.anchorY = params.anchorY
                end
		
		over.isVisible = false
		button:insert( over, true )
	end
        
        
	
	-- Public methods
	function button:setText( newText )
	
		local labelText = self.text
		if ( labelText ) then
			labelText:removeSelf()
			self.text = nil
		end

		local labelShadow = self.shadow
		if ( labelShadow ) then
			labelShadow:removeSelf()
			self.shadow = nil
		end

		local labelHighlight = self.highlight
		if ( labelHighlight ) then
			labelHighlight:removeSelf()
			self.highlight = nil
		end
		
		if ( params.size and type(params.size) == "number" ) then size=params.size else size=20 end
		if ( params.font ) then font=params.font else font=native.systemFontBold end
		if ( params.textColor ) then textColor=params.textColor else textColor={ 255/255, 255/255, 255/255, 255/255 } end
		
		-- Optional vertical correction for fonts with unusual baselines (I'm looking at you, Zapfino)
		if ( params.offset and type(params.offset) == "number" ) then offset=params.offset else offset = 0 end
		
		if ( params.emboss ) then
			-- Make the label text look "embossed" (also adjusts effect for textColor brightness)
			local textBrightness = ( textColor[1] + textColor[2] + textColor[3] ) / 3
			
			labelHighlight = display.newText( newText, 0, 0, font, size )
			if ( textBrightness > 127) then
				labelHighlight:setFillColor( 255/255, 255/255, 255/255, 20/255 )
			else
				labelHighlight:setFillColor( 255/255, 255/255, 255/255, 140/255 )
			end
			button:insert( labelHighlight, true )
			labelHighlight.x = labelHighlight.x + 1.5; labelHighlight.y = labelHighlight.y + 1.5 + offset
			self.highlight = labelHighlight

			labelShadow = display.newText( newText, 0, 0, font, size )
			if ( textBrightness > 127) then
				labelShadow:setFillColor( 0, 0, 0, 128/255 )
			else
				labelShadow:setFillColor( 0, 0, 0, 20/255 )
			end
			button:insert( labelShadow, true )
			labelShadow.x = labelShadow.x - 1; labelShadow.y = labelShadow.y - 1 + offset
			self.shadow = labelShadow
		end
		
		labelText = display.newText( newText, 0, 0, font, size )
		labelText:setFillColor( textColor[1], textColor[2], textColor[3], textColor[4] )
		button:insert( labelText, true )
		labelText.y = labelText.y + offset
		self.text = labelText
	end
	
	if params.text then
		button:setText( params.text )
	end
	
	if ( params.onPress and ( type(params.onPress) == "function" ) ) then
		button._onPress = params.onPress
	end
	if ( params.onRelease and ( type(params.onRelease) == "function" ) ) then
		button._onRelease = params.onRelease
	end
	
	if (params.onEvent and ( type(params.onEvent) == "function" ) ) then
		button._onEvent = params.onEvent
	end
		
	-- Set button as a table listener by setting a table method and adding the button as its own table listener for "touch" events
	button.touch = newButtonHandler
	button:addEventListener( "touch", button )

	if params.x then
		button.x = params.x
	end
	
	if params.y then
		button.y = params.y
	end
	
	if params.id then
		button._id = params.id
	end

	return button
end


--------------
-- Label class

Public.newLabel = function( params )
	local labelText
	local size, font, textColor, align
	local t = display.newGroup()
        local offset = 0
	
	if ( params.bounds ) then
		local bounds = params.bounds
		local left = bounds[1]
		local top = bounds[2]
		local width = bounds[3]
		local height = bounds[4]
	
		if ( params.size and type(params.size) == "number" ) then size=params.size else size=20 end
		if ( params.font ) then font=params.font else font=native.systemFontBold end
		if ( params.textColor ) then textColor=params.textColor else textColor={ 255/255, 255/255, 255/255, 255/255 } end
		if ( params.offset and type(params.offset) == "number" ) then offset=params.offset else offset = 0 end
		if ( params.align ) then align = params.align else align = "center" end
		
		if ( params.text ) then
			labelText = display.newText( params.text, 0, 0, font, size )
			labelText:setFillColor( textColor[1], textColor[2], textColor[3], textColor[4] )
			t:insert( labelText )
			-- TODO: handle no-initial-text case by creating a field with an empty string?
	
			if ( align == "left" ) then
				labelText.x = left + labelText.contentWidth * 0.5
			elseif ( align == "right" ) then
				labelText.x = (left + width) - labelText.contentWidth * 0.5
			else
				labelText.x = ((2 * left) + width) * 0.5
			end
		end
		
		labelText.y = top + labelText.contentHeight * 0.5

		-- Public methods
		function t:setText( newText )
			if ( newText ) then
				labelText.text = newText
				
				if ( "left" == align ) then
					labelText.x = left + labelText.contentWidth / 2
				elseif ( "right" == align ) then
					labelText.x = (left + width) - labelText.contentWidth / 2
				else
					labelText.x = ((2 * left) + width) / 2
				end
			end
		end
		
		function t:setFillColor( r, g, b, a )
			local newR = 255/255
			local newG = 255/255
			local newB = 255/255
			local newA = 255/255

			if ( r and type(r) == "number" ) then newR = r end
			if ( g and type(g) == "number" ) then newG = g end
			if ( b and type(b) == "number" ) then newB = b end
			if ( a and type(a) == "number" ) then newA = a end

			labelText:setFillColor( r, g, b, a )
		end
	end
	
	-- Return instance (as display group)
	return t
	
end


-- Shows a popup with an overlay in the background;
-- the developer will still need to put items on the popup
Public.createPopup = function(contentGroup, showOkButton, overlayTapHidesPopup)
    -- make it so that if you click off the popup, it goes away;
    showOkButton = showOkButton or false
    overlayTapHidesPopup = overlayTapHidesPopup or false
    
    local popupGroup = display.newGroup()
    
    local popupOverlay = display.newRect(0, 0, 380, 570)
    popupOverlay.strokeWidth = 0
    popupOverlay:setFillColor( 0, 0, 0, .8 )
    popupOverlay:setStrokeColor( 0, 0, 0, 0 )
    popupOverlay.x = halfW
    popupOverlay.y = halfH
    popupGroup:insert(popupOverlay)
    
    local popup = display.newImageRect("images/popup.jpg", 256, 256)
    popup.x = halfW
    popup.y = halfH
    popup:addEventListener("touch", function(event)
        -- grab touches so they don't go through to things underneath
        return true
    end)
    popupGroup:insert(popup)
    
    
    if (showOkButton == true) then
        -- this is just a convenient way to add an OK button; not recommended for a lot of use
        -- you don't have to use it; you can do your own thing
        local popupOkButton = Public.newButton{
            default = "images/ok_button.png",
            over = "",
            onRelease = function()
                Utils.playSoundFX("buttonSound")
                popupGroup.isVisible = false
            end,
            width = 105,
            height = 54
        }
        popupOkButton.x = halfW
        popupOkButton.y = 364
        popupGroup:insert(popupOkButton)
        --Utils.scaleAndReturn(popupOkButton, 700, -.075, -.075 )
        popupGroup:insert(popupOkButton)
    end
    
    
    if (overlayTapHidesPopup) then
        popupOverlay:addEventListener("touch", function(event)
            if (event.phase == "began") then
                popupGroup.isVisible = false
                return true
            end
        end)
    else
        popupOverlay:addEventListener("touch", function(event)
            if (event.phase == "began") then
                return true
            end
        end)
    end
    
    popupGroup:insert(contentGroup)
    
    popupGroup.isVisible = false
    return popupGroup
end

return Public