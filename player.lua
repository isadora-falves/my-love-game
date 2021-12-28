local Player = {}

function Player:load()
    self.sprite = love.graphics.newImage("sprites/player.png")

    jumpSound = love.audio.newSource("sounds/jump.wav", "static")
    jumpSound:setVolume(0.4)

    self.width = 100
    self.height = 110
    self.x = 0
    self.y = love.graphics.getHeight() - self.height
    self.velx = 6
    self.vely = 0
    self.jumpAmount = -460
    self.gravity = -660
    self.health = {
        current = 3
    }
    self.colors = {
	    red = 1,
	    green = 1,
	    blue = 1,
	    speed = 2
    }
    self.collision_timeout = 1
    self.defaultCollisionTimeout = 175
end

function Player:update(dt)
    self:move()
    self:jump(dt)
    self:untintPlayer(dt)
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

    if self.vely ~= 0 then
        self.y = self.y + self.vely * dt
        self.vely = self.vely - self.gravity * dt
    end

    if self.y > love.graphics.getHeight() - self.height then
        self.vely = 0
        self.y = love.graphics.getHeight() - self.height
    end
end

function Player:draw()
	love.graphics.setColor(self.colors.red, self.colors.green, self.colors.blue, 1)
	love.graphics.draw(self.sprite, self.x, self.y)
	love.graphics.setColor(1, 1, 1, 1)
end

function Player:tintRed()
	self.colors.green = 0
	self.colors.blue = 0
end

function Player:damage()
		if self:validCollission() then
			self:resetCollissionTimeout()
			self.health.current = self.health.current - 1
			self:tintRed()
			return true
		else
			return false
		end
end

function Player:validCollission()
	isValidCollission = self.collision_timeout < 0


	return isValidCollission
end

function Player:dead()
	isDead = self.health.current == 0

	return isDead
end

function Player:untintPlayer(dt)
	speed = self.colors.speed
	colors = self.colors

	colors.green = math.min(colors.green + speed * dt, 1)
	colors.blue = math.min(colors.blue + speed * dt, 1)
	colors.red = math.min(colors.red + speed * dt, 1)
end

function Player:resetCollissionTimeout()
	self.collision_timeout = self.defaultCollisionTimeout
end

function Player:decrementCollisionTimeout()
	self.collision_timeout = self.collision_timeout - 1
end

return Player

