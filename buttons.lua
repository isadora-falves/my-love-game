local Buttons = {}

local graphic = {
   width = love.graphics.getWidth(),
   height = love.graphics.getHeight()
}

local sprites = {
   logo = love.graphics.newImage("sprites/logo.png"),
   playagain = love.graphics.newImage("sprites/play_again.png"),
   play = love.graphics.newImage("sprites/play.png"),
   continue = love.graphics.newImage("sprites/yes.png"),
   quit = love.graphics.newImage("sprites/no.png")
}

function Buttons:start()
   self.buttons = {
      logo = {graphic.width/3 - 50, (graphic.height/10)*2 - 100, sprites.logo:getWidth(), sprites.logo:getHeight()},
      play = {graphic.width/3 + 30, (graphic.height/10)*2 + 30, sprites.play:getWidth(), sprites.play:getHeight()}
   }
end

function Buttons:load()
   self.buttons = {
      playagain = {graphic.width/3 + 30, (graphic.height/10)*2 - 100, sprites.playagain:getWidth(), sprites.playagain:getHeight()},
      continue = {graphic.width/3 - 30, (graphic.height/10)*2, 144, sprites.continue:getWidth(), sprites.continue:getHeight()},
      quit = {(graphic.width/3) + 180, (graphic.height/10)*2, sprites.quit:getWidth(), sprites.quit:getHeight()}
   }
end

function Buttons:draw()
      if self.buttons == nil then
         return
      end

      for i,v in pairs(self.buttons) do
         love.graphics.draw(sprites[i], v[1], v[2])
      end
end

function Buttons:listButtons()
   if self.buttons == nil then
      return {}
   end

   return self.buttons
end

function Buttons:reset()
   self.buttons = {}
end

return Buttons
