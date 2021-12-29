love.graphics.setDefaultFilter("nearest", "nearest")

local Background = require("background")
local Player = require("player")

local GUI = require("gui")
local Enemy = require("enemy")
local Shot = require("shot")
local Buttons = require("buttons")
local Meteor =  require("meteor")

life = 1

StartingTime = 40

game = {
    width = 843,
    height = 316,
    scale = 1,
    score = 0
}

function checkCollision(a, b)
    -- não-colisão no eixo x
    if b.x > a.x + a.width or a.x > b.x + b.width then

        return false
    end

    -- não-colisão no eixo y
    if b.y > a.y + a.height or a.y > b.y + b.height then

        return false
    end

    return true
end

-- Aqui ficam todas as configurações iniciais e carregamento de imagens e audios
function love.load()
    love.window.setMode(game.width * game.scale, game.height * game.scale)

    Background:load()
    Player:load()
    Enemy.loadAssets()
    Meteor.loadAssets()
    Shot.loadAssets()

    GUI:load()

    remaining_time = StartingTime
    gameover = false

    theme = love.audio.newSource("sounds/theme.wav", "static")
    theme:setVolume(0.4)
    theme:play()

    hitSound = love.audio.newSource("sounds/hit.wav", "static")
    hitSound:setVolume(0.4)

    gameoverSound = love.audio.newSource("sounds/gameover.wav", "static")
    gameoverSound:setVolume(0.4)

    winSound = love.audio.newSource("sounds/win.wav", "static")
    winSound:setVolume(0.4)
    start = game.width

    loadMeteors()
    loadEnemies()
end

-- Aqui fica todo o código que atualiza algo na tela
function love.update(dt)
    if gameover then
        theme:stop()
        Buttons:load()
        return
    end

    -- checa colisão entro o jogador e o inimigo
    Player:decrementCollisionTimeout()

    for pos, enemy in ipairs(Enemy.getEnemies()) do
        if checkCollision(Player, enemy) then
            if Player:damage() then
                hitSound:play()
            end

            if Player:dead() then
                hitSound:play()

                gameover = true
                gameoverSound:play()
            end
        end
    end

    remaining_time = remaining_time - dt

    if remaining_time <= 0 then
        gameover = true
        winSound:play()
    end

    Background:update(dt)
    Player:update(dt)
    Enemy.updateAll(dt)
    Meteor.updateAll(dt)
    Shot.updateAll(dt)

    for shotIndex, shot in ipairs(Shot.getShots()) do
        for enemyIndex, enemy in ipairs(Enemy.getEnemies()) do
            if checkCollision(shot, enemy) then
                hitSound:play()

                Shot.remove(shotIndex)

                Enemy.remove(enemyIndex)

                game.score = game.score + 10
            end
        end

        -- remove tiro da listagem quando ele toca na borda da tela
        if shot.x >= game.width then
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
    love.graphics.print(game.score, game.width - 70, 10)
end

function shoot()
    if not gameover then
        Shot.new(Player.x + Player.width, Player.y + Player.height / 2)
    end
end

function loadEnemies()
    Enemy.removeAll()
    for i = 1, 100 do
        Enemy.new(game.width + start * i, game.height - 123)
    end
end

function loadMeteors()
  Meteor.removeAll()
  for i = 1,100 do
    Meteor.new(love.math.random(0, game.width), 0)
  end
end

function reset()
    theme:play()
    game.score = 0
    Player:load()
    GUI:load(Player)
    remaining_time = StartingTime
    gameover = false
    Enemy.removeAll()
    Meteor.removeAll()
    Buttons:reset()
    loadEnemies()
end

function love.mousepressed(mx, my, button)
    if button == 1 then -- checks which button was pressed, refer to [url=https://love2d.org/wiki/love.mousepressed]wiki[/url]
        for i, v in pairs(Buttons:listButtons()) do
            -- check collision and restrict allowed repeat click speed
            if mx >= v[1] and mx <= v[1] + v[3] and my >= v[2] and my <= v[2] + v[4] and v[5] == 0 then
                if i == "continue" then
                    reset()
                elseif i == "quit" then
                    love.event.quit()
                end
            end
        end
    end
end
