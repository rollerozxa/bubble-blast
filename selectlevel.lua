
scenes.selectlevel = {}

scenes.selectlevel.page = 1

function scenes.selectlevel.update()
	if CheckMouseCollision(32, 64, 32, 32) and scenes.selectlevel.page ~= 1 then
		scenes.selectlevel.page = scenes.selectlevel.page - 1
	end

	if CheckMouseCollision(288, 64, 32, 32) and scenes.selectlevel.page ~= 4 then
		scenes.selectlevel.page = scenes.selectlevel.page + 1
	end

	for i = 0,24 do
		local x = (i % 5) + 1
		local y = math.floor(i / 5)
		local levelnum = ((scenes.selectlevel.page - 1) * 25 ) + i + 1

		if CheckMouseCollision(x * 64 - 32, 128 + y * 64, 32, 32) and levelnum <= game.levelsUnlocked then
			game.level = levelnum
			game.state = 3
			game.newlyState = true
		end
	end
end

function scenes.selectlevel.draw()
	if scenes.selectlevel.page ~= 1 then
		love.graphics.draw(assets.arrow.left, 32, 64)
	end

	love.graphics.setFont(assets.fonts.defaultMedium)
	love.graphics.print("Page: "..scenes.selectlevel.page, 128, 64)
	love.graphics.setFont(assets.fonts.default)

	if scenes.selectlevel.page ~= 4 then
		love.graphics.draw(assets.arrow.right, 288, 64)
	end

	for i = 0,24 do
		local x = (i % 5) + 1
		local y = math.floor(i / 5)
		local levelnum = ((scenes.selectlevel.page - 1) * 25 ) + i + 1

		love.graphics.setColor(0.1,0.1,0.1)
		love.graphics.rectangle('fill', x * 64 - 32, 128 + y * 64, 32, 32)

		love.graphics.setColor(1,1,1)
		if levelnum <= game.levelsUnlocked then
			love.graphics.print(levelnum, x * 64 - 28, 128 + y * 64 + 5)
		else
			love.graphics.draw(assets.lock, x * 64 - 32, 128 + y * 64)
		end

		if levelnum < game.levelsUnlocked then
			love.graphics.draw(assets.lvlok, x * 64 - 32, 128 + y * 64)
		end
	end
end
