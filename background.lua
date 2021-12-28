local Background = {}

function Background:load()
  self.background_image = love.graphics.newImage("sprites/background.jpg")
  self.background_x = 0
  self.background_spd = 500
end

function Background:update(dt)
  self.background_x = self.background_x - self.background_spd * dt
  local minimum_width = -love.graphics.getWidth()

  if self.background_x < minimum_width then
      self.background_x = 0
  end
end

function Background:draw()
  love.graphics.draw(self.background_image, self.background_x, 0)
  love.graphics.draw(self.background_image, self.background_x + self.background_image:getWidth(), 0)
end

return Background
