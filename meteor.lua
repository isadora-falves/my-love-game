local Meteor = {}

Meteor.__index = Meteor

local Player = require("player")
local Game = require("game")
local utils = require("utils")

local ActiveMeteors = {}
local timer = 0

function Meteor.removeAll()
    ActiveMeteors = {}
end

function Meteor.new(x, y)
    local instance = setmetatable({}, Meteor)

    instance.x = x
    instance.y = y
    instance.velx = -40
    instance.vely = -80
    instance.gravity = -240
    instance.ground = love.graphics.getHeight() - 62
    instance.damage = 3
    instance.crashed = false

    table.insert(ActiveMeteors, instance)
end

function Meteor.loadAssets()
    Meteor.sprite = love.graphics.newImage("sprites/meteor.png")

    Meteor.width = Meteor.sprite:getWidth()
    Meteor.height = Meteor.sprite:getHeight()
end

function Meteor:physics(dt, index)
    if self.vely ~= 0 then
        self.y = self.y + self.vely * dt
        self.x = self.x + self.velx * dt

        self.vely = self.vely - self.gravity * dt
        self.velx = self.velx + self.gravity * dt
    end

    if self.y > self.ground then
        self.vely = 0
        self.velx = 0
        self.y = self.ground

        self.remove(index)
    end
end

function Meteor:collision(index)
    if utils.check_collision(Player, self) and not self.crashed then
        Player:damage(self)

        hitSound:play()

        if Player:dead() then
            hitSound:play()

            Game:gameOver()
            gameoverSound:play()
        end

        self.crashed = true
    end
end

function Meteor:update(dt, index)
    self:physics(dt, index)
    self:collision(index)
end

function Meteor.updateAll(dt)
    timer = timer + dt

    if timer > 1 then
        Meteor.new(love.math.random(Game.width / 2.75, Game.width * 1.5), -62)

        timer = 0
    end

    for i, instance in ipairs(ActiveMeteors) do
        instance:update(dt, i)
    end
end

function Meteor.remove(index)
    table.remove(ActiveMeteors, index)
end

function Meteor.getEnemies()
    return ActiveMeteors
end

function Meteor:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.draw(self.sprite, self.x + 2, self.y, 0.785398)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.sprite, self.x, self.y, 0.785398)
end

function Meteor.drawAll()
    for i, instance in ipairs(ActiveMeteors) do
        instance:draw()
    end
end

return Meteor
