
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return	x1 < x2+w2
		and	x2 < x1+w1
		and	y1 < y2+h2
		and	y2 < y1+h1
end

function CheckMouseCollision(x,y,w,h)
	return CheckCollision(x, y, w, h, love.mouse.getX(), love.mouse.getY(), 4, 4) and love.mouse.isDown(1) and not oldmousedown
end

function CheckMouseCollisionScaled(x,y,w,h)
	return CheckMouseCollision(ScaledX(x), ScaledY(y), ScaledX(w), ScaledY(h))
end

function NewImage(filename)
	return love.graphics.newImage("assets/"..filename..".png")
end

function TableEmpty(self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

function ScaledX(x)
	x = x or 1

	return x * game.resolution.x / game.base_resolution.x
end

function ScaledY(y)
	y = y or 1

	return y * game.resolution.y / game.base_resolution.y
end

function AnchorTopRight(offsetX)
	return game.resolution.x - ScaledX(offsetX)
end
