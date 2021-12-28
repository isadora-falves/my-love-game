-- jump *gabi
-- um inimigo ok
-- aumentar o numero de inimigos
-- movimentação do inimigo *rodrigo
-- atirar ao toque do botão (space) *luiz
-- resolver colisão - se bater no inimo = morre/perde vide
                    -- se a bala bater = morre
-- background correndo *mat
-- 40 segundos para cada fase
-- finalização: ganhou/perdeu

-- evolução
    -- criar blocos de plataforma escada/tijolo..
    -- pontuação
    -- aumentar vidas (3)
    -- botão de start
    -- som


life = 1

game = {
    width = 896,
    height = 896,
    scale = 1
}

groundLevel = game.height - 128

player = {
    ground = groundLevel,
    x = 0,
    y = groundLevel,
    width = 22,
    height = 34,
    velx = 2,
    vely = 68,
    jumpVel = -40
}

enemy = {
    x = game.width - 129,
    y = game.height - 128,
    velx = 2,
    vely = 0,
    width = 16,
    height = 16
}

playerCanJump = true

function love.load()
    love.window.setMode(
      game.width * game.scale,
      game.height * game.scale
    )

    game.background = love.graphics.newImage("sprites/background.png")
    player.sprite = love.graphics.newImage("sprites/parrot.png")

    -- colocar imagem correta
    enemy.sprite = love.graphics.newImage("sprites/parrot.png")

    -- player.image:setFilter("nearest", "nearest")
    -- enemy.image:setFilter("nearest", "nearest")

    -- hitSound = love.audio.newSource("hit.wav", "static")
    -- hitSound:setVolume(0.4)
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        player.x = player.x + player.velx
    end

    if love.keyboard.isDown("left") then
        player.x = player.x - player.velx
    end

    -- verificar se existe uma tecla melhor para fazer o up/jump
    -- if love.keyboard.isDown("up") then
    --     player.y = player.vely
    --     -- playerCanJump = false
    -- end

    if love.keyboard.isDown('up') and player.y == player.ground then
        player.y = player.y - player.vely
        -- player.yvel = player.jumpVel
        -- player.y = player.y + player.vely

        playerCanJump = false
    end

    if playerCanJump == false then
        player.y = player.y + player.vely

        playerCanJump = true
    end
end

function love.draw()
    love.graphics.draw(game.background, 0, 0)
    love.graphics.draw(player.sprite, player.x, player.y)
    love.graphics.draw(enemy.sprite, enemy.x, enemy.y)
end

-- function love.keypressed( key )
--     if love.keyboard.isDown('up') and playerCanJump then
--       player.yvel = player.jumpVel
--       playerCanJump = false
--     end
--   end









-- codigo do caio

--   function checkCollision(a, b)
--     -- não-colisão no eixo x
--     if
--       b.x > a.x + a.width or
--       a.x > b.x + b.width then

--       return false
--     end

--     -- não-colisão no eixo y
--     if
--       b.y > a.y + a.height or
--       a.y > b.y + b.height then

--       return false
--     end

--     return true
--   end

--

--   function love.keypressed(key)
--     if key == "escape" then
--       love.event.quit()
--     end
--   end

--   function love.update()
--     -- player
--     if love.keyboard.isDown("left") then
--       player.x = player.x - player.velx
--     end

--     if love.keyboard.isDown("right") then
--       player.x = player.x + player.velx
--     end

--     if player.x < 0 then
--       player.x = 0
--     end

--     if player.x + player.width > game.width then
--       player.x = game.width - player.width
--     end

--     -- bola
--     ball.vely = ball.vely + 0.1

--     ball.x = ball.x + ball.velx
--     ball.y = ball.y + ball.vely

--     if
--       checkCollision(ball, player) or
--       ball.y + ball.height > game.height then

--       ball.vely = -7
--       hitSound:play()
--     end

--     if
--       ball.x < 0 or
--       ball.x + ball.width > game.width then

--       ball.velx = ball.velx * -1
--       hitSound:play()
--     end
--   end

--   function love.draw()
--     love.graphics.scale(game.scale, game.scale)

--     -- definimos a cor azul
--     love.graphics.setColor(90/255, 215/255, 250/255)
--     love.graphics.rectangle("fill", 0, 0, game.width, game.height)

--     love.graphics.setColor(255/255, 255/255, 255/255)
--     -- love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
--     love.graphics.draw(player.image, player.x, player.y)
--     love.graphics.draw(ball.image, ball.x, ball.y)
--   end
