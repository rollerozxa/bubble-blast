
-- i18n.lua: i18n helper functions

-- i18n support is experimental, please do not submit new translations yet

local strings = {}

local function init_i18n(lang)
	if lang == 'en' then return end

	local langdata = love.filesystem.read("lang/"..lang..".json")

	strings = json.decode(langdata)
end

function S(text)
	return strings[text] or text
end

init_i18n('en')
--init_i18n('sv')
