local GUI = {}

function GUI:load()
   self.hearts = {}
   self.hearts.img = love.graphics.newImage("sprites/heart.png")
   self.hearts.width = self.hearts.img:getWidth()
   self.hearts.height = self.hearts.img:getHeight()
   self.hearts.x = -20
   self.hearts.y = 15
   self.hearts.scale = 1
   self.hearts.spacing = self.hearts.width * self.hearts.scale + 10
end

function GUI:update(dt)

end

function GUI:draw(player)
   self:displayHearts(player)
end

function GUI:displayHearts(player)
   for i=1,player.health.current do
      local x = self.hearts.x + self.hearts.spacing * i
      love.graphics.setColor(0,0,0,0.5)
      love.graphics.draw(self.hearts.img, x + 2, self.hearts.y + 2, 0, self.hearts.scale, self.hearts.scale)
      love.graphics.setColor(1,1,1,1)
      love.graphics.draw(self.hearts.img, x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale)
   end
end

return GUI
