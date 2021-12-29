local Meteor = {}

Meteor.__index = Meteor

local Player = require("player")

local ActiveMeteors = {}

function Meteor.removeAll()
    ActiveMeteors = {}
end

function Meteor.new(x, y)
    local instance = setmetatable({}, Meteor)

    instance.x = x
    instance.y = y
    instance.xvel = 200
    instance.yvel = 0
    instance.friction = 1
    instance.speed = 2

    table.insert(ActiveMeteors, instance)
end

function Meteor.loadAssets()
    Meteor.sprite = love.graphics.newImage("sprites/player.png")

    Meteor.width = Meteor.sprite:getWidth()
    Meteor.height = Meteor.sprite:getHeight()
end

function Meteor:physics(dt)
    if self.x + self.width > 0 then
        self.x = self.x - self.xvel * dt
        self.y = self.y - self.yvel * dt
        self.xvel = self.xvel * (1 - math.min(dt * self.friction, 0))
        self.yvel = self.yvel * (1 - math.min(dt * self.friction, 1))
    end
end

function Meteor:update(dt)
    self:physics(dt)
end

function Meteor.updateAll(dt)
    for i, instance in ipairs(ActiveMeteors) do
        instance:update(dt)
    end
end

function Meteor.remove(index)
    table.remove(ActiveMeteors, index)
end

function Meteor.getEnemies()
    return ActiveMeteors
end

function Meteor:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", 50, 50, 30, 30)
end

function Meteor.drawAll()
    for i, instance in ipairs(ActiveMeteors) do
        instance:draw()
    end
end

return Meteor
