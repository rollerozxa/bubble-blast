
-- gtk.lua: gay GUI toolkit (gay GTK)
--  it will give you lots of warm hugs <3

gtk = {}

local sparsifier = {}

function gtk.update(gui)
	for id, el in pairs(gui) do
		if not el.is_visible or el.is_visible() then
			if (mouseCollisionScaled(el.x, el.y, el.size.x, el.size.y) and mouseClick())
			 or (el.keybind and love.keyboard.isDown(el.keybind) and not sparsifier[id]) then
				el.on_click()
			end

			if el.keybind then
				sparsifier[id] = love.keyboard.isDown(el.keybind)
			end
		end
	end
end

function gtk.draw(gui)
	for id, el in pairs(gui) do
		if not el.is_visible or el.is_visible() then
			if el.type == "button" then
				if mouseCollisionScaled(el.x, el.y, el.size.x, el.size.y) then
					love.graphics.setColor(0,0,0.1)
				else
					love.graphics.setColor(0.1,0.1,0.1)
				end

				love.graphics.rectangle("fill", scaledX(el.x), scaledY(el.y), scaledX(el.size.x), scaledY(el.size.y))
				love.graphics.setColor(1,1,1)
				love.graphics.setFont(fonts.sans.medium)
				drawCenteredText(scaledX(el.x), scaledY(el.y+2), scaledX(el.size.x), scaledY(el.size.y), el.label)
			elseif el.type == "tex_button" then
				if mouseCollisionScaled(el.x, el.y, el.size.x, el.size.y) then
					love.graphics.setColor(0.1,0.1,0.1)
				else
					love.graphics.setColor(1,1,1)
				end

				love.graphics.draw(assets[el.texture], scaledX(el.x), scaledY(el.y), 0, scaledX(), scaledY())
			end
		end
	end
end
