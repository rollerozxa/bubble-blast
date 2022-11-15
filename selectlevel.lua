
scenes.selectlevel = {}

scenes.selectlevel.page = 1

function scenes.selectlevel.update()
	if MouseCollisionScaled(32, 64, 32, 32) and MouseClick() and scenes.selectlevel.page ~= 1 then
		scenes.selectlevel.page = scenes.selectlevel.page - 1
	end

	if MouseCollisionScaled(288, 64, 32, 32) and MouseClick() and scenes.selectlevel.page ~= 4 then
		scenes.selectlevel.page = scenes.selectlevel.page + 1
	end

	for i = 0,24 do
		local x = (i % 5) + 1
		local y = math.floor(i / 5)
		local levelnum = ((scenes.selectlevel.page - 1) * 25 ) + i + 1

		if MouseCollisionScaled(x * 64 - 32, 128 + y * 64, 32, 32) and MouseClick() and levelnum <= game.levelsUnlocked then
			game.level = levelnum
			game.state = "game"
			game.newlyState = true
		end
	end
end

function scenes.selectlevel.draw()
	love.graphics.setBackgroundColor(64/255, 120/255, 161/255)

	if scenes.selectlevel.page ~= 1 then
		love.graphics.draw(assets.arrow.left, ScaledX(32), ScaledY(64), 0, ScaledX(), ScaledY())
	end

	love.graphics.setFont(fonts.sans.medium)
	love.graphics.print("Page: "..scenes.selectlevel.page, ScaledX(140), ScaledY(64), 0, ScaledX(), ScaledY())
	love.graphics.setFont(fonts.sans.small)

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
			love.graphics.print(levelnum, ScaledX(x * 64 - 30), ScaledY(128 + y * 64 + 1), 0, ScaledX(), ScaledY())
		else
			love.graphics.draw(assets.lock, ScaledX(x * 64 - 32), ScaledY(128 + y * 64), 0, ScaledX(), ScaledY())
		end

		if levelnum < game.levelsUnlocked then
			love.graphics.draw(assets.lvlok, ScaledX(x * 64 - 32), ScaledY(128 + y * 64), 0, ScaledX(), ScaledY())
		end
	end
end
