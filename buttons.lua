local Buttons = {}

local scale = 2

local graphic = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

local sprites = {
    logo = love.graphics.newImage("sprites/logo.png"),
    playagain = love.graphics.newImage("sprites/play_again.png"),
    play = love.graphics.newImage("sprites/play.png"),
    continue = love.graphics.newImage("sprites/yes.png"),
    quit = love.graphics.newImage("sprites/no.png")
}

function Buttons:start()
    graphic = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight()
    }

    self.buttons = {
        logo = {
            x = (graphic.width / 2) - (sprites.logo:getWidth() / 2) - 2,
            y = sprites.logo:getHeight(),
            width = sprites.logo:getWidth(),
            height = sprites.logo:getHeight()
        },
        play = {
            x = (graphic.width / 2) - (sprites.play:getWidth() / 2),
            y = sprites.logo:getHeight() * 2,
            width = sprites.play:getWidth(),
            height = sprites.play:getHeight()
        }
    }
end

function Buttons:load()
    self.buttons = {
        playagain = {
            x = (graphic.width / 2) - (sprites.playagain:getWidth() / 2),
            y = (graphic.height / 2) - sprites.playagain:getHeight(),
            width = sprites.playagain:getWidth(),
            height = sprites.playagain:getHeight()
        },
        continue = {
            x = (graphic.width / 2) - sprites.continue:getWidth(),
            y = (graphic.height / 2) + 20,
            width = sprites.continue:getWidth(),
            height = sprites.continue:getHeight()
        },
        quit = {
            x = (graphic.width / 2),
            y = (graphic.height / 2) + 20,
            width = sprites.quit:getWidth(),
            height = sprites.quit:getHeight()
        }
    }
end

function Buttons:draw()
    if self.buttons == nil then
        return
    end

    for i, v in pairs(self.buttons) do
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(sprites[i], v.x, v.y)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(sprites[i], v.x, v.y)
    end
end

function Buttons:listButtons()
    if self.buttons == nil then
        return {}
    end

    return self.buttons
end

function Buttons:reset()
    self.buttons = {}
end

return Buttons
