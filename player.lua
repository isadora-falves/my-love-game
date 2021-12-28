local Player = {}

function Player:load()
    self.sprite = love.graphics.newImage("sprites/parrot.png")

    jumpSound = love.audio.newSource("sounds/jump.wav", "static")
    jumpSound:setVolume(0.4)

    self.width = 129
    self.height = 128
    self.x = 0
    self.y = love.graphics.getHeight() - self.height
    self.ground = self.y
    self.velx = 6
    self.vely = 0
    self.jumpAmount = -460
    self.gravity = -660
    self.health = {
        current = 3
    }
end

function Player:update(dt)
    self:move()
    self:jump(dt)
    self:fall(dt)
end

function Player:move()
    if love.keyboard.isDown("right", "d") then
        self.x = self.x + self.velx
    end

    if love.keyboard.isDown("left", "a") then
        self.x = self.x - self.velx
    end

    if self.x < 0 then
        self.x = 0
    end

    if self.x + self.width > love.graphics.getWidth() then
        self.x = love.graphics.getWidth() - self.width
    end
end

function Player:jump(dt)
    if love.keyboard.isDown("up", "w") then
        if self.vely == 0 then
            self.vely = self.jumpAmount

            jumpSound:play()
        end
    end
end

function Player:fall(dt)
    if self.vely ~= 0 then
        self.y = self.y + self.vely * dt
        self.vely = self.vely - self.gravity * dt
    end

    if self.y > self.ground then
        self.vely = 0
        self.y = self.ground
    end
end

function Player:happy(dt)
    if self.vely == 0 then
        self.vely = -200
    end
end

function Player:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Player
