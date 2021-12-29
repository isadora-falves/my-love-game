local Buttons = {}
local graphic = {
   width = love.graphics.getWidth(),
   height = love.graphics.getHeight()
}

function Buttons:load()
   self.buttons = {
      continue = {graphic.width/3 + 60, (graphic.height/10)*2, graphic.width/10, (graphic.height/10)*2, 0}, -- left (left edge, top edge, width, height, timer)
      quit = {(graphic.width/3) + 150, (graphic.height/10)*2, graphic.width/10, (graphic.height/10)*2, 0} -- right
   }
end

function Buttons:draw()
      if self.buttons == nil then
         return
      end
      
      for i,v in pairs(self.buttons) do 
            opacity = 100 + v[5] * 400 -- change opacity over time to indicate
            love.graphics.setColor(255,255,255,opacity)
            love.graphics.rectangle("fill",v[1],v[2],v[3],v[4])
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
