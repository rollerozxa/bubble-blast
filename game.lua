
-- game.lua: The main game scene

scenes.game = {}

local bubbles = {}
local particles = {}

local gui = {
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
	game.presses = 10
	game.max_presses = 10
	bubbles = {}
	particles = {}
	presses = {}
	for x = 0,4 do
		for y = 0,5 do
			table.insert(bubbles, {
				x = 32 + 64 * x,
				y = 64 + 64 * y,
				state = love.math.random(2,4),
				blinktimer = 0,
				hovered = false
			})
		end
	end
end

local function initializeLevel()
	local leveldata = levels[game.levelpack][game.level]

	game.presses = leveldata.presses
	game.max_presses = leveldata.presses
	bubbles = {}
	particles = {}
	presses = {}
	for _,bubble in pairs(leveldata.bubbles) do

		-- level 1-32 hack to fix
		if game.level == 32 and game.levelpack == 1 and bubble.x == 5 and bubble.y == 2 then
			bubble.st = 4
		end

		table.insert(bubbles, {
			x = 32 + 64 * (bubble.x - 1),
			y = 64 + 64 * (bubble.y - 1),
			state = bubble.st,
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
		if mouseCollisionScaled(bubble.x, bubble.y, 32, 32) and not game.overlay then
			if game.presses == 0 then
				break
			end

			bubbles[key].hovered = true

			if mouseClick() then
				game.presses = game.presses - 1

				breakBubble(key)

				table.insert(presses, ((bubble.x - 32)/64 +1).."-"..((bubble.y - 64)/64 +1))

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
			speed = 4
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
			if checkCollision(particle.x, particle.y, 32, 32, bubble.x, bubble.y, 32, 32) then
				breakBubble(bubbleKey)
				particles[particleKey] = nil
			end
		end
	end

	if game.presses == 0 and tableEmpty(particles) and not tableEmpty(bubbles) then
		if savegame.get('timesLost') >= 15 and game.level == game.levelsUnlocked then
			switchOverlay('skip')
		else
			switchOverlay('lose')
		end
	end

	if tableEmpty(bubbles) then
		-- LAST LEVEL!!!
		if game.level == 100 and game.levelpack == 5 then
			switchOverlay('final')
		else
			switchOverlay('success')
		end
	end
end

function scenes.game.draw()
	drawBG(121/255, 64/255, 148/255)

	for _,bubble in pairs(bubbles) do
		love.graphics.draw(assets.bubble[bubble.state], scaledX(bubble.x), scaledY(bubble.y), 0, scaledX(0.25), scaledY(0.25))
		local eyes

		if bubble.blinktimer == 0 then
			eyes = bubble.hovered and assets.eyes_squint or assets.bubble_eyes

			if math.random() > 0.995 then
				bubble.blinktimer = 20
			end
		else
			eyes = assets.eyes_closed
			bubble.blinktimer = bubble.blinktimer - 1
		end
		love.graphics.draw(eyes, scaledX(bubble.x), scaledY(bubble.y), 0, scaledX(0.25), scaledY(0.25))
	end

	for _,particle in pairs(particles) do
		love.graphics.draw(assets.particle, scaledX(particle.x), scaledY(particle.y), 0, scaledX(0.25), scaledY(0.25))
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
	love.graphics.print(S("Level: %s-%s", game.levelpack, game.level), scaledX(15), scaledY(14*32+8), 0, scaledX(), scaledY())

	gtk.draw(gui)
end
