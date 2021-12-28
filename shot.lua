local Spot = {
    img = love.graphics.newImage("assets/spike.png")
}

Shot.__index = Shot

Shot.width = Shot.img:getWidth()
Shot.height = Shot.img:getHeight()

local ActiveShots = {}
local Player = require("player")

function Shot.new(x, y)
    local instance = setmetatable({}, Shot)
    instance.x = x
    instance.y = y

    self.sprite = love.graphics.newImage("sprites/shot.png")

    table.insert(ActiveShots, instance)
end

function Spike:update(dt)

end

function Spike:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
end

function Spike.updateAll(dt)
    for i, instance in ipairs(ActiveSpikes) do
        instance:update(dt)
    end
end

function Spike.drawAll()
    for i, instance in ipairs(ActiveSpikes) do
        instance:draw()
    end
end
