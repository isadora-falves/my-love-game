love.graphics.setDefaultFilter("nearest", "nearest")

local Background = require("background")
local Player = require("player")

local GUI = require("gui")
local Enemy = require("enemy")

life = 1

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
  y =  game.height - 166
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

  GUI:load()

  remaining_time = 40
  gameover = false

  hitSound = love.audio.newSource("sounds/hit.wav", "static")
  hitSound:setVolume(0.4)

  shotSound = love.audio.newSource("sounds/shot.wav", "static")
  shotSound:setVolume(0.4)

  gameoverSound = love.audio.newSource("sounds/gameover.wav", "static")
  gameoverSound:setVolume(0.4)

  winSound = love.audio.newSource("sounds/win.wav", "static")
  gameoverSound:setVolume(0.4)

  badguy = Enemy.newEnemy(game.width, game.height - 166)
end

-- Aqui fica todo o código que atualiza algo na tela
function love.update(dt)
  if gameover then
    return
  end

-- checa colisão entro o jogador e o inimigo
  Player:decrementCollisionTimeout()
  if checkCollision(Player, badguy) then
    if Player:damage() then
      hitSound:play()
    end

    if Player:dead() then
      hitSound:play()

      gameover = true
      gameoverSound:play()
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

  -- atualiza lista de tiros
  for i, v in ipairs(shots) do
    v.x = v.x + 4

    -- verifica se existe algum inimigo e se há colisão entre a bala e o inimigo
    -- o ideal é depois verificar em relação a uma lista de inimigos
    if enemyDeath == false and checkCollision(v, badguy) then
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
  Player:draw()
  GUI:draw(Player)

  -- renderiza inimigo se ele não estiver morto
  if enemyDeath == false then
    -- love.graphics.draw(enemy.sprite, enemy.x, enemy.y)
    badguy:draw()
  end

  -- renderiza tiros
  for i, v in ipairs(shots) do
    love.graphics.draw(love.graphics.newImage("sprites/shot.png"), v.x, v.y)
  end

  badguy:draw()
end

function shoot()
  if not gameover then
    shotSound:play()

    shot = {
      x = Player.x + Player.width,
      y = Player.y + Player.width/3,
      width = 2,
      height = 2
    }

    table.insert(shots, shot)
  end
end
