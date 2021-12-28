local Background = require("background")
local GUI = require("gui")
local Enemy = require("enemy")

life = 1

game = {
    width = 843,
    height = 316,
    scale = 1
}

player = {
    x = 0,
    width = 129,
    height = 128,
    velx = 6,
    vely = 0,
    jump = -460,
    gravity = -660,
    health = {
        current = 3
    }
}

enemy = {
    x = game.width - 258,
    y = game.height - 128,
    velx = 2,
    vely = 0,
    width = 129,
    height = 128
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
    GUI:load()
    player.sprite = love.graphics.newImage("sprites/parrot.png")
    player.y = game.height - player.height
    player.ground = player.y

    -- colocar imagem correta

    enemy.sprite = love.graphics.newImage("sprites/parrot.png")

    remaining_time = 40
    gameover = false

    hitSound = love.audio.newSource("sounds/hit.wav", "static")
    hitSound:setVolume(0.4)

    jumpSound = love.audio.newSource("sounds/jump.wav", "static")
    jumpSound:setVolume(0.4)

    shotSound = love.audio.newSource("sounds/shot.wav", "static")
    shotSound:setVolume(0.4)

    gameoverSound = love.audio.newSource("sounds/gameover.wav", "static")
    gameoverSound:setVolume(0.4)

    winSound = love.audio.newSource("sounds/win.wav", "static")
    gameoverSound:setVolume(0.4)

    badguy = Enemy.newEnemy(600, 410)
end

-- Aqui fica todo o código que atualiza algo na tela
function love.update(dt)
    if gameover then
        return
    end

    if love.keyboard.isDown("right", "d") then
        player.x = player.x + player.velx
    end

    if love.keyboard.isDown("left", "a") then
        player.x = player.x - player.velx
    end

    -- pula
    if love.keyboard.isDown("up", "w") then
        if player.vely == 0 then
            player.vely = player.jump

            jumpSound:play()
        end
    end

    -- verifica se o jogador está no jump e faz o movimento de descida
    if player.vely ~= 0 then
        player.y = player.y + player.vely * dt
        player.vely = player.vely - player.gravity * dt
    end

    if player.y > game.height - player.height then
        player.vely = 0
        player.y = game.height - player.height
    end

    -- mantém o jogador renderizando dentro da tela
    if player.x < 0 then
        player.x = 0
    end

    if player.x + player.width > game.width then
        player.x = game.width - player.width
    end

    -- checa colisão entro o jogador e o inimigo
    if checkCollision(player, enemy) then
        hitSound:play()

        gameover = true
        gameoverSound:play()
    end

    remaining_time = remaining_time - dt
    -- print("remaining_time " .. (remaining_time))

    if remaining_time <= 0 then
        gameover = true
        -- VIR A MENSAGEM DE GANHOU
        -- colocar o bichinho pulando
        -- Botão de jogar novamente
        winSound:play()
    end

    Background:update(dt)

    -- atualiza lista de tiros
    for i, v in ipairs(shots) do
        v.x = v.x + 4

        -- verifica se existe algum inimigo e se há colisão entre a bala e o inimigo
        -- o ideal é depois verificar em relação a uma lista de inimigos
        if enemyDeath == false and checkCollision(v, enemy) then
            hitSound:play()

            table.remove(shots, i)

            enemyDeath = true
        end

        -- remove tiro da listagem quando ele toca na borda da tela
        if v.x >= game.width then
            table.remove(shots, i)
        end
    end

    badguy:physics(dt)
end

-- Atira ao clicar em 'space'
function love.keypressed(key)
    if key == "space" then
        shoot()
    end
end

-- Todo o código que serve pra renderizar algo fica aqui
function love.draw()
    Background:draw()
    GUI:draw(player)

    -- renderiza o jogador
    love.graphics.draw(player.sprite, player.x, player.y)

    -- renderiza inimigo se ele não estiver morto
    if enemyDeath == false then
        love.graphics.draw(enemy.sprite, enemy.x, enemy.y)
    end

    -- renderiza tiros
    for i, v in ipairs(shots) do
        love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
    end

    badguy:draw()
end

function shoot()
    if not gameover then
        shotSound:play()

        shot = {
            x = player.x + player.width,
            y = player.y + player.height - player.height / 3,
            width = 4,
            height = 4
        }

        table.insert(shots, shot)
    end
end
