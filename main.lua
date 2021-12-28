require("background")
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
  gravity = -660
}

enemy = {
    x = game.width - 258,
    y = game.height - 128,
    velx = 2,
    vely = 0,
    width = 129,
    height = 128,
}

function love.load()

    love.window.setMode(

      game.width * game.scale,

      game.height * game.scale

    )


    Background:load()
    player.sprite = love.graphics.newImage("sprites/parrot.png")
    player.y = game.height - player.height
    player.ground = player.y



    -- colocar imagem correta

    enemy.sprite = love.graphics.newImage("sprites/parrot.png")



    -- player.image:setFilter("nearest", "nearest")

    -- enemy.image:setFilter("nearest", "nearest")



    -- hitSound = love.audio.newSource("hit.wav", "static")

    -- hitSound:setVolume(0.4)

end



function love.update(dt)
    if love.keyboard.isDown("right", "d") then
        player.x = player.x + player.velx
    end

    if love.keyboard.isDown("left", "a") then
        player.x = player.x - player.velx
    end

    if love.keyboard.isDown("up", "w") then
      if player.vely == 0 then
        player.vely = player.jump
      end
    end

    if player.vely ~= 0 then
      player.y = player.y + player.vely * dt
      player.vely = player.vely - player.gravity * dt
    end

    if player.y > game.height - player.height then
      player.vely = 0
      player.y = game.height - player.height
    end

    if player.x < 0 then
      player.x = 0
    end

    if player.x + player.width > game.width then
      player.x = game.width - player.width
    end


    Background:update(dt)
end



function love.draw()
    Background:draw()

    love.graphics.draw(player.sprite, player.x, player.y)
    love.graphics.draw(enemy.sprite, enemy.x, enemy.y)

end



-- function love.keypressed( key )
--     if love.keyboard.isDown("up") and playerCanJump then
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

--       hitSound:lay()

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
