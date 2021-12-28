love.graphics.setDefaultFilter("nearest", "nearest")

local Background = require("background")
local Player = require("player")

local GUI = require("gui")
local Enemy = require("enemy")
local Buttons = require("buttons")

life = 1

StartingTime = 40

game = {
    width = 843,
    height = 316,
    scale = 1
}

enemy = {
    velx = 2,
    vely = 0,
    width = 100,
    height = 166,
    x = game.width - 258,
    y = game.height - 166
}

shots = {}

enemyDeath = false

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

    GUI:load()

    remaining_time = StartingTime
    gameover = false

    hitSound = love.audio.newSource("sounds/hit.wav", "static")
    hitSound:setVolume(0.4)

    shotSound = love.audio.newSource("sounds/shot.wav", "static")
    shotSound:setVolume(0.4)

    gameoverSound = love.audio.newSource("sounds/gameover.wav", "static")
    gameoverSound:setVolume(0.4)

    winSound = love.audio.newSource("sounds/win.wav", "static")
    gameoverSound:setVolume(0.4)

    Enemy.new(game.width, game.height - 166)
end

-- Aqui fica todo o código que atualiza algo na tela
function love.update(dt)
    if gameover then
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
        -- VIR A MENSAGEM DE GANHOU
        -- colocar o bichinho pulando
        -- Botão de jogar novamente
        winSound:play()
    end

    Background:update(dt)
    Player:update(dt)
    Enemy.updateAll(dt)

    -- atualiza lista de tiros
    for i, v in ipairs(shots) do
        v.x = v.x + 4

        for pos, enemy in ipairs(Enemy.getEnemies()) do
            if checkCollision(v, enemy) then
                hitSound:play()

                table.remove(shots, i)

                Enemy.remove(pos)
            end
        end

        -- remove tiro da listagem quando ele toca na borda da tela
        if v.x >= game.width then
            table.remove(shots, i)
        end
    end

    -- Enemy:physics(dt)
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

    GUI:draw(Player)

    -- renderiza tiros
    for i, v in ipairs(shots) do
        love.graphics.draw(love.graphics.newImage("sprites/shot.png"), v.x, v.y)
    end

    Buttons:draw()
end

function shoot()
    if not gameover then
        shotSound:play()

        shot = {
            x = Player.x + Player.width,
            y = Player.y + Player.width / 3,
            width = 2,
            height = 2
        }

        table.insert(shots, shot)
    end
end

function reset()
    Player:load()
    GUI:load(Player)
    remaining_time = StartingTime
    gameover = false
    -- badguy = Enemy.newEnemy(600, 410)
    Buttons:reset()
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
