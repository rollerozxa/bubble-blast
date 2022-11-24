
function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return	x1 < x2+w2
		and	x2 < x1+w1
		and	y1 < y2+h2
		and	y2 < y1+h1
end

function mouseCollision(x,y,w,h)
	return checkCollision(x, y, w, h, love.mouse.getX(), love.mouse.getY(), 4, 4)
end

function mouseCollisionScaled(x,y,w,h)
	return mouseCollision(scaledX(x), scaledY(y), scaledX(w), scaledY(h))
end

function mouseClick()
	return love.mouse.isDown(1) and not oldmousedown
end

function newImage(filename)
	return love.graphics.newImage("assets/"..filename..".png")
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

function anchorTopRight(offsetX)
	return game.resolution.x - scaledX(offsetX)
end

function drawCenteredText(rectX, rectY, rectWidth, rectHeight, text)
	local font       = love.graphics.getFont()
	local textWidth  = font:getWidth(text)
	local textHeight = font:getHeight()
	love.graphics.print(text, rectX+rectWidth/2, rectY+rectHeight/2, 0, scaledX(), scaledY(), textWidth/2, textHeight/2)
end

function switchState(state)
	game.state = state
	game.newlyState = true
end
