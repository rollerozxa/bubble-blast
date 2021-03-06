
scenes.game = {}

function initializeRandom()
	game.bubbles = {}
	for x = 0,4 do
		for y = 0,5 do
			table.insert(game.bubbles, {
				x = 32 + 64 * x,
				y = 64 + 64 * y,
				state = love.math.random(1,4)
			})
		end
	end
end

function initializeLevel()
	local leveljson = love.filesystem.read("levelpacks/1/"..game.level..".json")
	local leveldata = json.decode(leveljson)

	game.presses = leveldata.presses
	game.bubbles = {}
	for _,bubble in pairs(leveldata.bubbles) do
		table.insert(game.bubbles, {
			x = 32 + 64 * (bubble.x - 1),
			y = 64 + 64 * (bubble.y - 1),
			state = bubble.state
		})
	end
end

function breakBubble(key)
	local bubble = game.bubbles[key]

	if bubble.state < 4 then
		game.bubbles[key].state = bubble.state + 1
	else
		sounds.pop:clone():play()

		game.bubbles[key] = nil

		local dirs = { 'up', 'left', 'down', 'right' }

		for _,dir in pairs(dirs) do
			table.insert(game.particles, {
				x = bubble.x,
				y = bubble.y,
				dir = dir
			})
		end
	end
end

function scenes.game.init()
	if game.level == 0 then
		initializeRandom()
	else
		initializeLevel()
	end
end

function scenes.game.update()
	if (love.keyboard.isDown('n') and not oldndown) or CheckMouseCollision(320, 0, 32, 32) then
		scenes.game.init()
	end
	oldndown = love.keyboard.isDown('n')

	for key,bubble in pairs(game.bubbles) do
		if CheckMouseCollision(ScaledX(bubble.x), ScaledY(bubble.y), ScaledX(32), ScaledY(32)) then
			if game.presses == 0 then
				break
			end

			game.presses = game.presses - 1

			breakBubble(key)

			break
		end
	end

	for key,particle in pairs(game.particles) do
		local speed
		if TableEmpty(game.bubbles) then
			speed = 8
		else
			speed = 3
		end
		local deltaX, deltaY

		if particle.dir == 'up' then
			deltaX = 0
			deltaY = -speed
		elseif particle.dir == 'left' then
			deltaX = -speed
			deltaY = 0
		elseif particle.dir == 'down' then
			deltaX = 0
			deltaY = speed
		elseif particle.dir == 'right' then
			deltaX = speed
			deltaY = 0
		end

		game.particles[key].x = game.particles[key].x + deltaX
		game.particles[key].y = game.particles[key].y + deltaY

		if not CheckCollision(particle.x, particle.y, 32, 32, 0, 0, game.resolution.x, game.resolution.y) then
			game.particles[key] = nil
		end
	end

	for particleKey,particle in pairs(game.particles) do
		for bubbleKey,bubble in pairs(game.bubbles) do
			if CheckCollision(particle.x +7, particle.y +7, 18, 18, bubble.x, bubble.y, 32, 32) then
				breakBubble(bubbleKey)
				game.particles[particleKey] = nil
			end
		end
	end

	if TableEmpty(game.bubbles) and TableEmpty(game.particles) then
		if game.level == game.levelsUnlocked then
			game.levelsUnlocked = game.levelsUnlocked + 1
			savegame.set('levelsUnlocked', game.levelsUnlocked)
		end
		game.state = "selectlevel"
		game.newlyState = true
	end
end

function scenes.game.draw()
	for _,bubble in pairs(game.bubbles) do
		love.graphics.draw(assets.bubble[bubble.state], ScaledX(bubble.x), ScaledY(bubble.y), 0, ScaledX(), ScaledY())
		love.graphics.draw(assets.bubble_eyes, ScaledX(bubble.x), ScaledY(bubble.y), 0, ScaledX(), ScaledY())
	end

	for _,particle in pairs(game.particles) do
		love.graphics.draw(assets.particle, ScaledX(particle.x), ScaledY(particle.y), 0, ScaledX(), ScaledY())
	end

	love.graphics.setColor(0.5,0.5,1, 115/255)
	love.graphics.rectangle('fill', 0, 0, game.resolution.x, ScaledY(32))
	love.graphics.rectangle('fill', 0, game.resolution.y - ScaledY(32), game.resolution.x, ScaledY(32))
	love.graphics.setColor(1,1,1)

	love.graphics.draw(assets.refresh, AnchorTopRight(32), 0, 0, ScaledX(), ScaledY())

	if game.presses == 0 then
		love.graphics.setColor(1,0.6,0.6)
	end

	love.graphics.setFont(assets.fonts.defaultSmall)
	love.graphics.print(game.presses.." presses left", 15, 5)
end
