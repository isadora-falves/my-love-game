local Shot = {}

Shot.__index = Shot

local ActiveShots = {}

local Player = require("player")

function Shot.new(x, y)
    shotSound:play()

    local instance = setmetatable({}, Shot)

    instance.x = x
    instance.y = y

    table.insert(ActiveShots, instance)
end

function Shot.loadAssets()
    Shot.sprite = love.graphics.newImage("sprites/shot.png")

    Shot.width = Shot.sprite:getWidth()
    Shot.height = Shot.sprite:getHeight()

    shotSound = love.audio.newSource("sounds/shot.wav", "static")
    shotSound:setVolume(0.4)
end

function Shot:update(dt)
    self.x = self.x + 4
end

function Shot:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

function Shot.getShots()
    return ActiveShots
end

function Shot.remove(index)
    table.remove(ActiveShots, index)
end

function Shot.updateAll(dt)
    for i, instance in ipairs(ActiveShots) do
        instance:update(dt)
    end
end

function Shot.drawAll()
    for i, instance in ipairs(ActiveShots) do
        instance:draw()
    end
end

return Shot
