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
    instance.velx = 200
    instance.vely = -460
    instance.gravity = -660
    instance.ground = love.graphics.getHeight() - 62

    table.insert(ActiveMeteors, instance)
end

function Meteor.loadAssets()
    Meteor.sprite = love.graphics.newImage("sprites/meteor.png")

    Meteor.width = Meteor.sprite:getWidth()
    Meteor.height = Meteor.sprite:getHeight()
end

function Meteor:physics(dt)
    print(self.x)
    if self.vely ~= 0 then
        self.y = self.y + self.vely * dt
        self.vely = self.vely - self.gravity * dt
    end

    if self.y > self.ground then
        self.vely = 0
        self.y = self.ground
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
    love.graphics.draw(self.sprite, self.x, self.y)
end

function Meteor.drawAll()
    for i, instance in ipairs(ActiveMeteors) do
        instance:draw()
    end
end

return Meteor
