love.graphics.setDefaultFilter("nearest", "nearest")

local Background = require("background")
local Player = require("player")
local Enemy = require("enemy")
local Shot = require("shot")
local Buttons = require("buttons")
local Meteor = require("meteor")
local GUI = require("gui")
local Game = require("game")

local utils = require("utils")

started = false

-- Aqui ficam todas as configurações iniciais e carregamento de imagens e audios
function love.load()
    Game:load()
    Background:load()
    Player:load()
    Meteor.loadAssets()
    Shot.loadAssets()
    GUI:load()

    theme = love.audio.newSource("sounds/theme.wav", "static")
    theme:setVolume(0.1)

    hitSound = love.audio.newSource("sounds/hit.wav", "static")
    hitSound:setVolume(0.4)

    powerUp = love.audio.newSource("sounds/powerUp.wav", "static")
    powerUp:setVolume(0.4)

    gameoverSound = love.audio.newSource("sounds/gameover.wav", "static")
    gameoverSound:setVolume(0.4)

    winSound = love.audio.newSource("sounds/win.wav", "static")
    winSound:setVolume(0.4)
end

-- Aqui fica todo o código que atualiza algo na tela
function love.update(dt)
    if not started then
        Buttons:start()

        return
    end

    -- evitar que o jogo fique muito rápido
    dt = math.min(dt, 1 / 60)

    if Game:gameFinished() then
        Buttons:load()
        theme:stop()
        return
    end

    Game:update(dt)

    if Game.remaining_play_time <= 0 then
        Game:gameOver()
        winSound:play()
    end

    Background:update(dt)
    Player:update(dt)
    Enemy.updateAll(dt)
    Meteor.updateAll(dt)
    Shot.updateAll(dt)

    for shotIndex, shot in ipairs(Shot.getShots()) do
        for enemyIndex, enemy in ipairs(Enemy.getEnemies()) do
            if enemy.damage >= 0 then
                if utils.check_collision(shot, enemy) then
                    hitSound:play()

                    Shot.remove(shotIndex)

                    Enemy.remove(enemyIndex)
                    Game:addScore(enemy.points)
                end
            end
        end

        -- remove tiro da listagem quando ele toca na borda da tela
        if shot.x >= Game.width then
            Shot.remove(shotIndex)
        end
    end
end

-- Atira ao clicar em 'space'
function love.keypressed(key)
    if key == "space" then
        shoot()
    end

    if key == "escape" then
        love.event.quit()
    end
end

-- Todo o código que serve pra renderizar algo fica aqui
function love.draw()
    Background:draw()
    Player:draw()
    Enemy.drawAll()
    Meteor.drawAll()
    Shot.drawAll()

    GUI:draw(Player)

    Buttons:draw()

    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(Game.score, Game.width - 98, 10)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(Game.score, Game.width - 100, 10)
end

function shoot()
    if not Game:gameFinished() then
        Shot.new(Player.x + Player.width, Player.y + Player.height / 2)
    end
end

function reset()
    theme:play()
    Game:newGame()
    Player:load()
    GUI:load(Player)
    Enemy.removeAll()
    Meteor.removeAll()
    Buttons:reset()
end

function love.mousepressed(mx, my, button)
    if button == 1 then -- checks which button was pressed, refer to [url=https://love2d.org/wiki/love.mousepressed]wiki[/url]
        for i, v in pairs(Buttons:listButtons()) do
            -- check collision and restrict allowed repeat click speed
            if mx >= v.x and mx <= v.x + v.width and my >= v.y and my <= v.y + v.height then
                if i == "continue" or i == "play" then
                    started = true
                    reset()
                elseif i == "quit" then
                    love.event.quit()
                end
            end
        end
    end
end
