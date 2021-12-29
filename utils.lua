local utils = {}

function utils.check_collision(a, b)
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

return utils
