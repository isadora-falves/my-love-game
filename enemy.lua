--enemy.lua
local enemyTBL = {} --this will store all the functions that operate on all the enemy entities
local enemy = {}
local enemyClass = {}
enemyClass.__index = function(t,i) return enemyClass[i] end --I don't know if this is necessary but I always write it

enemyTBL.newEnemy = function(x,y) -- now the newEnemy function will be stored inside the enemyTBL table
   local enmy = {} --temporary table to hold all the play atributes
   enmy.x = x
   enmy.y = y
   enmy.width = 100
   enmy.height = 100
   enmy.xvel = 200
   enmy.yvel = 0
   enmy.friction = 1
   enmy.speed = 2
   setmetatable(enmy, enemyClass) --this will link all the enemyClass functions to the newly created enemy.
   table.insert(enemy, enmy) --this will store the newly created enemy in the enemy table.
   return enmy
end

function enemyClass:physics(dt)
    self.x = self.x - self.xvel * dt
    self.y = self.y - self.yvel * dt
    self.xvel = self.xvel * (1 - math.min(dt*self.friction, 0))
    self.yvel = self.yvel * (1 - math.min(dt*self.friction, 1))
end

function enemyClass:draw()
    love.graphics.setColor(255,0,0)
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
 end

-- enemyTBL functions, these will operate on all the enemy entites with a single call
function enemyTBL.draw()
   for i,v in ipairs(enemy) do
      v:draw()
   end
end

--return enemyTBL instead of the old newEnemy
return enemyTBL
