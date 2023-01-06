
-- fonts.lua: Font loading

local function newFont(name, size)
	return love.graphics.newFont("fonts/"..name..".ttf", size)
end

function initFonts()
	local fontfaces = {
		sans = 'undefined-medium',
		--sans_bold = 'Roboto-Bold'
	}

	local fontsizes = {
		small = 18,
		medium = 20,
		big = 24,
		mediumbig = 30,
		bigger = 40}

	local fonts = {}

	for id, name in pairs(fontfaces) do
		fonts[id] = {}

		for sizename, size in pairs(fontsizes) do
			fonts[id][sizename] = newFont(name, size)
		end
	end

	return fonts
end
