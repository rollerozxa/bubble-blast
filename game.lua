
-- game.lua: The main game scene

scenes.game = {}

local bubbles = {}
local particles = {}

local gui = {
	reload = {
		type = "tex_button",
		x = 32*9, y = 0,
		size = { x = 32, y = 32 },
		texture = "refresh",
		on_click = function()
			scenes.game.init()
		end,
		keybind = 'n'
	},
	menu = {
		type = "tex_button",
		x = 32*10, y = 0,
		size = { x = 32, y = 32 },
		texture = "menu",
		on_click = function()
			switchOverlay('pause')
		end,
		keybind = 'escape'
	},
}

-- Helper functions

local function initializeRandom()
	bubbles = {}
	for x = 0,4 do
		for y = 0,5 do
			table.insert(bubbles, {
				x = 32 + 64 * x,
				y = 64 + 64 * y,
				state = love.math.random(1,4),
				blinktimer = 0,
				hovered = false
			})
		end
	end
end

local function initializeLevel()
	local leveljson = love.filesystem.read("levelpacks/1/"..game.level..".json")
	local leveldata = json.decode(leveljson)

	game.presses = leveldata.presses
	game.max_presses = leveldata.presses
	bubbles = {}
	particles = {}
	for _,bubble in pairs(leveldata.bubbles) do
		table.insert(bubbles, {
			x = 32 + 64 * (bubble.x - 1),
			y = 64 + 64 * (bubble.y - 1),
			state = bubble.state,
			blinktimer = 0,
			hovered = false
		})
	end
end

local function breakBubble(key)
	local bubble = bubbles[key]

	if bubble.state < 4 then
		bubbles[key].state = bubble.state + 1
	else
		sounds.pop:clone():play()

		bubbles[key] = nil

		for _,dir in ipairs({ 'up', 'left', 'down', 'right' }) do
			table.insert(particles, {
				x = bubble.x,
				y = bubble.y,
				dir = dir
			})
		end
	end
end

-- Game scene functions

function scenes.game.init()
	if game.level == 0 then
		initializeRandom()
	else
		initializeLevel()
	end
end

function scenes.game.update()
	gtk.update(gui)

	for key,bubble in pairs(bubbles) do
		if mouseCollisionScaled(bubble.x, bubble.y, 32, 32) then
			if game.presses == 0 then
				break
			end

			bubbles[key].hovered = true

			if mouseClick() then
				game.presses = game.presses - 1

				breakBubble(key)

				break
			end
		else
			bubbles[key].hovered = false
		end
	end

	for key,particle in pairs(particles) do
		local speed
		if tableEmpty(bubbles) then
			speed = 8
		else
			speed = 3
		end

		local deltaX, deltaY = dirToDelta(particle.dir, speed)

		particles[key].x = particles[key].x + deltaX
		particles[key].y = particles[key].y + deltaY

		if not checkCollision(particle.x, particle.y, 32, 32, 0, 0, game.base_resolution.x, game.base_resolution.y) then
			particles[key] = nil
		end
	end

	for particleKey,particle in pairs(particles) do
		for bubbleKey,bubble in pairs(bubbles) do
			if checkCollision(particle.x +7, particle.y +7, 18, 18, bubble.x, bubble.y, 32, 32) then
				breakBubble(bubbleKey)
				particles[particleKey] = nil
			end
		end
	end

	if tableEmpty(bubbles) then
		switchOverlay('success')
	end
end

function scenes.game.draw()
	drawBG(121/255, 64/255, 148/255)

	for _,bubble in pairs(bubbles) do
		love.graphics.draw(assets.bubble[bubble.state], scaledX(bubble.x), scaledY(bubble.y), 0, scaledX(), scaledY())
		local eyes

		if bubble.blinktimer == 0 then
			if bubble.hovered then
				eyes = assets.eyes_squint
			else
				eyes = assets.bubble_eyes
			end


			if math.random() > 0.995 then
				bubble.blinktimer = 20
			end
		else
			eyes = assets.eyes_closed
			bubble.blinktimer = bubble.blinktimer - 1
		end
		love.graphics.draw(eyes, scaledX(bubble.x), scaledY(bubble.y), 0, scaledX(), scaledY())
	end

	for _,particle in pairs(particles) do
		love.graphics.draw(assets.particle, scaledX(particle.x), scaledY(particle.y), 0, scaledX(), scaledY())
	end

	love.graphics.setColor(0,0,0, 64/255)
	love.graphics.rectangle('fill', 0, 0, game.resolution.x, scaledY(32))
	love.graphics.rectangle('fill', 0, game.resolution.y - scaledY(32), game.resolution.x, scaledY(32))
	love.graphics.setColor(1,1,1)

	if game.presses == 0 then
		love.graphics.setColor(1,0.2,0.2)
	end

	love.graphics.setFont(fonts.sans.medium)
	love.graphics.print(S("%s touches left", game.presses), scaledX(15), scaledY(8), 0, scaledX(), scaledY())

	love.graphics.setColor(1,1,1)
	love.graphics.print(S("Level: %s", game.level), scaledX(15), scaledY(14*32+8), 0, scaledX(), scaledY())

	gtk.draw(gui)
end
