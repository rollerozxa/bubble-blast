
scenes.selectlevel = {}

scenes.selectlevel.page = 1

function scenes.selectlevel.update()
	if CheckMouseCollisionScaled(32, 64, 32, 32) and scenes.selectlevel.page ~= 1 then
		scenes.selectlevel.page = scenes.selectlevel.page - 1
	end

	if CheckMouseCollisionScaled(288, 64, 32, 32) and scenes.selectlevel.page ~= 4 then
		scenes.selectlevel.page = scenes.selectlevel.page + 1
	end

	for i = 0,24 do
		local x = (i % 5) + 1
		local y = math.floor(i / 5)
		local levelnum = ((scenes.selectlevel.page - 1) * 25 ) + i + 1

		if CheckMouseCollisionScaled(x * 64 - 32, 128 + y * 64, 32, 32) and levelnum <= game.levelsUnlocked then
			game.level = levelnum
			game.state = 3
			game.newlyState = true
		end
	end
end

function scenes.selectlevel.draw()
	if scenes.selectlevel.page ~= 1 then
		love.graphics.draw(assets.arrow.left, ScaledX(32), ScaledY(64), 0, ScaledX(), ScaledY())
	end

	love.graphics.setFont(assets.fonts.defaultMedium)
	love.graphics.print("Page: "..scenes.selectlevel.page, ScaledX(128), ScaledY(64), 0, ScaledX(), ScaledY())
	love.graphics.setFont(assets.fonts.default)

	if scenes.selectlevel.page ~= 4 then
		love.graphics.draw(assets.arrow.right, ScaledX(288), ScaledY(64), 0, ScaledX(), ScaledY())
	end

	for i = 0,24 do
		local x = (i % 5) + 1
		local y = math.floor(i / 5)
		local levelnum = ((scenes.selectlevel.page - 1) * 25 ) + i + 1

		love.graphics.setColor(0.1,0.1,0.1)
		love.graphics.rectangle('fill', ScaledX(x * 64 - 32), ScaledY(128 + y * 64), ScaledX(32), ScaledY(32))

		love.graphics.setColor(1,1,1)
		if levelnum <= game.levelsUnlocked then
			love.graphics.print(levelnum, ScaledX(x * 64 - 28), ScaledY(128 + y * 64 + 5), 0, ScaledX(), ScaledY())
		else
			love.graphics.draw(assets.lock, ScaledX(x * 64 - 32), ScaledY(128 + y * 64), 0, ScaledX(), ScaledY())
		end

		if levelnum < game.levelsUnlocked then
			love.graphics.draw(assets.lvlok, ScaledX(x * 64 - 32), ScaledY(128 + y * 64), 0, ScaledX(), ScaledY())
		end
	end
end
