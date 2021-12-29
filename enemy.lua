local Enemy = {}

Enemy.__index = Enemy

local Player = require("player")

local ActiveEnemies = {}

function Enemy.removeAll()
    ActiveEnemies = {}
end

function Enemy.new(x, y)
    local instance = setmetatable({}, Enemy)

    instance.x = x
    instance.y = y
    instance.xvel = 200
    instance.yvel = 0
    instance.friction = 1
    instance.speed = 2

    table.insert(ActiveEnemies, instance)
end

function Enemy.loadAssets()
    Enemy.sprite = love.graphics.newImage("sprites/dyno.png")

    Enemy.width = Enemy.sprite:getWidth()
    Enemy.height = Enemy.sprite:getHeight()
end

function Enemy:physics(dt)
    if self.x + self.width > 0 then
        self.x = self.x - self.xvel * dt
        self.y = self.y - self.yvel * dt
        self.xvel = self.xvel * (1 - math.min(dt * self.friction, 0))
        self.yvel = self.yvel * (1 - math.min(dt * self.friction, 1))
    end
end

function Enemy:update(dt)
    self:physics(dt)
end

function Enemy.updateAll(dt)
    for i, instance in ipairs(ActiveEnemies) do
        instance:update(dt)
    end
end

function Enemy.remove(index)
    table.remove(ActiveEnemies, index)
end

function Enemy.getEnemies()
    return ActiveEnemies
end

function Enemy:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

function Enemy.drawAll()
    for i, instance in ipairs(ActiveEnemies) do
        instance:draw()
    end
end

return Enemy
