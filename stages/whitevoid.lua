function onCreate()
   makeLuaSprite("whitespace", null, -300, -600)
	makeGraphic("whitespace", 1280, 720, 'FFFFFF')
	scaleObject("whitespace", 2, 2)
	setScrollFactor("whitespace", 0, 0)
	screenCenter("whitespace", 'xy')
	addLuaSprite("whitespace", false)

   makeLuaSprite("gradient", "dream/woah", -900, -500)
	setScrollFactor("gradient", 0, 0)
   scaleObject("gradient", 1, 1, true)
   setBlendMode('gradient', 'hardlight')
   addLuaSprite("gradient", false)

	makeLuaSprite("floor", "dream/floor", -1900, -600)
	setScrollFactor("floor", 1.15, 1.15)
	scaleObject("floor", 1.5, 1, true)

   makeLuaSprite("bg", "dream/bg", -600, -100)
   setScrollFactor("bg", 0.3, 0.2)
   scaleObject("bg", 0.9, 0.9)

   makeLuaSprite("overlay", "dream/green", -1000, 100)
	setScrollFactor("overlay", 1, 1)
   scaleObject("overlay", 1.5, 1, true)
   setBlendMode('overlay', 'overlay')

   makeLuaSprite("mountain", "dream/mountains", -700, -100)
   setScrollFactor("mountain", 0.4, 0.3)
   scaleObject("mountain", 1, 1)

   addLuaSprite("overlay", true)
   addLuaSprite("bg", false)
   addLuaSprite("mountain", false)
	addLuaSprite("floor", false)
end

function onCreatePost()
	initLuaShader("perspective")
	setPerspective("floor", 0.5)

    setScrollFactor("gfGroup", 0.775, 0.775)

	runHaxeCode("game.comboGroup.cameras = [game.camGame];")
end

local vanish_offset = { x = 0, y = 0 }
local sprites = {}

function setPerspective(tag, depth)
	depth = tonumber(depth) or 1

	if sprites[tag] then
		sprites[tag].depth = depth
	else
		sprites[tag] = {
			x = getProperty(tag .. ".x"),
			y = getProperty(tag .. ".y"),
			width = getProperty(tag .. ".width"),
			height = getProperty(tag .. ".height"),
			scale = { x = getProperty(tag .. ".scale.x"), y = getProperty(tag .. ".scale.y") },
			depth = depth
		}

		setSpriteShader(tag, "perspective")
		setShaderFloatArray(tag, "u_top", { 0, 1 })
		setShaderFloat(tag, "u_depth", depth)
	end
end

function removePerspective(tag)
	local sprite = sprites[tag]
	if sprite then
		scaleObject(tag, sprite.scale.x, sprite.scale.y, true)
		setProperty(tag .. ".x", sprite.x)
		setProperty(tag .. ".y", sprite.y)

		removeSpriteShader(tag)

		sprites[tag] = nil
	end
end

function setVanishOffset(x, y)
	if x then vanish_offset.x = tonumber(x) or 0 end
	if y then vanish_offset.y = tonumber(y) or 0 end
end

for _, func in pairs({ "max" }) do _G[func] = math[func] end

function onUpdatePost()
	local cam = {
		x = getProperty("camGame.scroll.x") + screenWidth / 2 + vanish_offset.x,
		y = getProperty(
			"camGame.scroll.y") + screenHeight / 2 + vanish_offset.y
	}

	for tag, sprite in pairs(sprites) do
		local vanish = { x = (cam.x - sprite.x) / sprite.width, y = 1 - (cam.y - sprite.y) / sprite.height }
		local top = { sprite.depth * vanish.x, sprite.depth * (vanish.x - 1) + 1 }

		if top[2] > 1 then
			scaleObject(tag, sprite.scale.x * (1 + sprite.depth * (vanish.x - 1)),
				sprite.scale.y * (sprite.depth * vanish.y), true)
		elseif top[1] < 0 then
			scaleObject(tag, sprite.scale.x * (1 - sprite.depth * (vanish.x)), sprite.scale.y * (sprite.depth * vanish.y),
				true)
			setProperty(tag .. ".x", sprite.x + sprite.width * sprite.depth * vanish.x)
		else
			scaleObject(tag, sprite.scale.x, sprite.scale.y * (sprite.depth * vanish.y), true)
		end

		setProperty(tag .. ".y", sprite.y + sprite.height * (1 - sprite.depth * max(vanish.y, 0)))

		setShaderFloatArray(tag, "u_top", top)
	end
end
