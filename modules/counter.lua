local counter = {};

counter.load = function()
    return game:HttpGet("https://coolzware.000webhostapp.com/counter/.php")
end

counter.get = function()
    return game:HttpGet("https://coolzware.000webhostapp.com/counter/.txt")
end

return counter
