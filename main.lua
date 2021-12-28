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

    shots = {}
    
    Background:load()
    player.sprite = love.graphics.newImage("sprites/parrot.png")
    player.y = game.height - player.height
    player.ground = player.y



    -- colocar imagem correta

    enemy.sprite = love.graphics.newImage("sprites/parrot.png")

    remaining_time = 40
    gameover = false

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
        playSound("jump")
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

    remaining_time = remaining_time - dt
    print("remaining_time " .. (remaining_time))

    if remaining_time <= 0 then
        gameover = true
        -- aqui tem que parar o jogo e fazer o perdeu
    end

    Background:update(dt)
end



function love.draw()
    Background:draw()

    love.graphics.draw(player.sprite, player.x, player.y)
    love.graphics.draw(enemy.sprite, enemy.x, enemy.y)

    for i,v in ipairs(shots) do
      love.graphics.rectangle("fill",v.starting_x, v.starting_y, v.width, v.height)
      v.starting_x = v.starting_x + 4
  end

end

function love.keypressed(key)
    if key == "space" then
        shoot()
    end
end

function shoot()
    playSound("shot")
 
    shot = {
        starting_x = player.x + player.width,
        starting_y = player.y + player.height - player.height/3,
        width = 4,  
        height = 4
    }

    table.insert(shots,shot)
end

function playSound(audio)
  sound = love.audio.newSource("sounds/" .. audio .. ".wav", "static")
  sound:setVolume(0.4)
  sound:play()
end