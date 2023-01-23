
-- gtk.lua: gay GUI toolkit (gay GTK)
--  it will give you lots of warm hugs <3

gtk = {}

local sparsifier = {}

function gtk.update(gui, is_overlay)
	for id, el in pairs(gui) do
		if not el.is_visible or el.is_visible() and (is_overlay or not game.overlay) then
			if el.type == "button"
			 or el.type == "tex_button" then
				if (mouseCollisionScaled(el.x, el.y, el.size.x, el.size.y) and mouseClick())
				or (el.keybind and love.keyboard.isDown(el.keybind) and not sparsifier[id])
				or (el.keybind == "escape" and game.fucking_android_back_button_hack) then
					el.on_click()
					sounds.click:clone():play()
				end

				if el.keybind then
					sparsifier[id] = love.keyboard.isDown(el.keybind)
				end
			end
		end
	end
end

function gtk.draw(gui, is_overlay)
	for id, el in pairs(gui) do
		if not el.is_visible or el.is_visible() then
			if el.type == "button" then
				if mouseCollisionScaled(el.x, el.y, el.size.x, el.size.y) and (is_overlay or not game.overlay) then
					love.graphics.setColor(0,0,0.1)
				else
					love.graphics.setColor(0.1,0.1,0.1)
				end

				love.graphics.rectangle("fill", scaledX(el.x), scaledY(el.y), scaledX(el.size.x), scaledY(el.size.y))
				love.graphics.setColor(1,1,1)
				-- Allow for custom drawing on the button that can override the text
				if not el.on_draw or not el.on_draw() then
					love.graphics.setFont(fonts.sans.medium)
					drawCenteredText(scaledX(el.x), scaledY(el.y+2), scaledX(el.size.x), scaledY(el.size.y), el.label)
				end
			elseif el.type == "tex_button" then
				if mouseCollisionScaled(el.x, el.y, el.size.x, el.size.y) and (is_overlay or not game.overlay) then
					love.graphics.setColor(0.1,0.1,0.1)
				else
					love.graphics.setColor(1,1,1)
				end

				if not el.scale then
					el.scale = 1
				end

				love.graphics.draw(assets[el.texture], scaledX(el.x), scaledY(el.y), 0, scaledX(el.scale), scaledY(el.scale))
			elseif el.type == "label" then
				love.graphics.setColor(1,1,1)

				love.graphics.print(el.label, scaledX(el.x), scaledY(el.y), 0, scaledX(), scaledY())
			end
		end
	end
end
