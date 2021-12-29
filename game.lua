local Game = {}

function Game:load()
    self.hearts = {}
    self.width = 1024
    self.height = 384
    self.scale = 1
    self.score = 0
    self.gameover = true
    self.remaining_play_time = 40

    love.window.setMode(self.width * self.scale, self.height * self.scale)
end

function Game:draw(player)
    self:displayHearts(player)
end

function Game:gameFinished()
    gameover = self.gameover

    return gameover
end

function Game:update(dt)
    self.remaining_play_time = self.remaining_play_time - dt
end

function Game:addScore(score)
    self.score = self.score + score
end

function Game:gameOver()
    self.gameover = true
end

function Game:newGame()
    self.gameover = false
    self.score = 0
    self.remaining_play_time = 40
end

return Game
