local Enemy = {}

Enemy.__index = Enemy

local Player = require("player")
local Game = require("game")
local utils = require("utils")

local ActiveEnemies = {}

local timer = 0

local EnemiesList = {
    dyno = {
        xvel = 200,
        yvel = 0,
        friction = 1,
        speed = 4,
        damage = 2,
        sprite = "sprites/dyno.png",
        points = 10,
        fly = false,
        sound = "sounds/dinoSound.wav"
    },
    miniDyno = {
        xvel = 500,
        yvel = 0,
        friction = 1,
        speed = 10,
        damage = 1,
        sprite = "sprites/miniDyno.png",
        fly = false,
        sound = "sounds/miniDyno.wav"
    },
    triceratops = {
        xvel = 300,
        yvel = 0,
        friction = 1,
        speed = 3,
        damage = 3,
        sprite = "sprites/triceratops.png",
        points = 30,
        fly = false,
        sound = "sounds/triceratops.wav"
    },
    health = {
        xvel = 600,
        yvel = 10,
        friction = 1,
        speed = 8,
        damage = -1,
        sprite = "sprites/meat.png",
        points = 0,
        fly = true
    }
}

local keyset = {}
for k in pairs(EnemiesList) do
    table.insert(keyset, k)
end

function Enemy.removeAll()
    ActiveEnemies = {}
end

function Enemy.new(x, y)
    local instance = setmetatable({}, Enemy)

    local enemy = EnemiesList[keyset[math.random(#keyset)]]

    instance.sprite = love.graphics.newImage(enemy.sprite)
    instance.width = instance.sprite:getWidth()
    instance.height = instance.sprite:getHeight()
    instance.fly = enemy.fly
    instance.x = x
    if instance.fly then
        instance.y = y - instance.height - math.random(0, Game.height)
    else
        instance.y = y - instance.height
    end
    instance.xvel = enemy.xvel
    instance.yvel = enemy.yvel
    instance.friction = enemy.friction
    instance.speed = enemy.speed
    instance.points = enemy.points
    instance.damage = enemy.damage
    instance.crashed = false
    if enemy.sound then
        instance.sound = love.audio.newSource(enemy.sound, "static")
        instance.sound:setVolume(0.1)
        instance.sound:play()
    end

    table.insert(ActiveEnemies, instance)
end

function Enemy:physics(dt)
    if self.x + self.width > 0 then
        self.x = self.x - self.xvel * dt
        self.y = self.y - self.yvel * dt
        self.xvel = self.xvel * (1 - math.min(dt * self.friction, 0))
        self.yvel = self.yvel * (1 - math.min(dt * self.friction, 1))
    end
end

function Enemy:collision(dt)
    if utils.check_collision(Player, self) and not self.crashed then
        if self.damage >= 0 then
            hitSound:play()
        elseif Player:notOnMaxHealth() then
            powerUp:play()
        end

        Player:damage(self)

        if Player:dead() then
            Game:gameOver()

            gameoverSound:play()
        end

        self.crashed = true
    end
end

function Enemy:update(dt)
    self:physics(dt)
    self:collision(dt)
end

function Enemy.updateAll(dt)
    timer = timer + dt
    if timer > 1 then
        Enemy.new(Game.width, Game.height)
        timer = 0
    end

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
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.draw(self.sprite, self.x + 2, self.y)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.sprite, self.x, self.y)
end

function Enemy.drawAll()
    for i, instance in ipairs(ActiveEnemies) do
        instance:draw()
    end
end

return Enemy
