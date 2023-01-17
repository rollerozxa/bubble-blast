
-- util.lua: Misc. utility and helper functions

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return	x1 < x2+w2
		and	x2 < x1+w1
		and	y1 < y2+h2
		and	y2 < y1+h1
end

function mouseCollision(x,y,w,h)
	-- Safe area around the cursor that still treats it as a press, for fat fingered fucks
	local safearea = 16
	return checkCollision(
		x+offset.x, y+offset.y, w, h,
		love.mouse.getX()-safearea, love.mouse.getY()-safearea, safearea*2, safearea*2)
end

function mouseCollisionScaled(x,y,w,h)
	return mouseCollision(scaledX(x), scaledY(y), scaledX(w), scaledY(h))
end

function mouseClick()
	return love.mouse.isDown(1) and not oldmousedown
end

function newImage(filename, nearest)
	local img = love.graphics.newImage("assets/"..filename..".png")

	if nearest then
		img:setFilter("linear", "linear", 16)
	else
		img:setFilter("nearest", "nearest", 16)
	end

	return img
end

function newSound(filename)
	return love.audio.newSource("sounds/"..filename..".ogg", "static")
end

function tableEmpty(self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

function scaledX(x)
	x = x or 1

	return x * game.resolution.x / game.base_resolution.x
end

function scaledY(y)
	y = y or 1

	return y * game.resolution.y / game.base_resolution.y
end

function drawCenteredText(rectX, rectY, rectWidth, rectHeight, text)
	local font       = love.graphics.getFont()
	local textWidth  = font:getWidth(text)
	local textHeight = font:getHeight()
	love.graphics.print(text, rectX+rectWidth/2, rectY+rectHeight/2, 0, scaledX(), scaledY(), textWidth/2, textHeight/2)
end

function drawBG(r,g,b)
	love.graphics.setColor(r/1.25,g/1.25,b/1.25)
	love.graphics.rectangle('fill', 0-offset.x, 0-offset.y, love.graphics.getWidth()+(offset.x*2), love.graphics.getHeight()+(offset.y*2))
	love.graphics.setColor(r,g,b)
	love.graphics.rectangle('fill', 0, 0, game.resolution.x, game.resolution.y)

	love.graphics.setColor(1,1,1)
end

function switchState(state)
	game.state = state
	game.newlyState = true
end

function switchOverlay(state)
	if game.overlay ~= state then
		game.overlay = state
		game.newlyOverlay = true
	end
end

function dirToDelta(dir, speed)
	local deltaX, deltaY

	if dir == 'up' then
		deltaX = 0
		deltaY = -speed
	elseif dir == 'left' then
		deltaX = -speed
		deltaY = 0
	elseif dir == 'down' then
		deltaX = 0
		deltaY = speed
	elseif dir == 'right' then
		deltaX = speed
		deltaY = 0
	end

	return deltaX, deltaY
end

function switchScreenAlign(align)
	game.screen_align = align
	love.resize(love.graphics.getWidth(), love.graphics.getHeight())
end
