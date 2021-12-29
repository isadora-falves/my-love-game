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
    instance.velx = 200
    instance.vely = -100
    instance.gravity = -400
    instance.ground = love.graphics.getHeight() - 62
    instance.damage = 3

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
        self.vely = self.vely - self.gravity * dt
    end

    if self.y > self.ground then
        self.vely = 0
        self.y = self.ground

        self.remove(index)
    end
end

function Meteor:collision(index)
    if utils.check_collision(Player, self) then
        if Player:damage(self) then
            hitSound:play()
        end

        if Player:dead() then
            hitSound:play()

            Game:gameOver()
            gameoverSound:play()
        end

        self.remove(index)
    end
end

function Meteor:update(dt, index)
    self:physics(dt, index)
    self:collision(index)
end

function Meteor.updateAll(dt)
    timer = timer + dt

    if timer > 1 then
        Meteor.new(love.math.random(0, game.width), -62)

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
    love.graphics.draw(self.sprite, self.x, self.y)
end

function Meteor.drawAll()
    for i, instance in ipairs(ActiveMeteors) do
        instance:draw()
    end
end

return Meteor
