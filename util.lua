
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return	x1 < x2+w2
		and	x2 < x1+w1
		and	y1 < y2+h2
		and	y2 < y1+h1
end

function CheckMouseCollision(x,y,w,h)
	return CheckCollision(x, y, w, h, love.mouse.getX(), love.mouse.getY(), 4, 4) and love.mouse.isDown(1) and not oldmousedown
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