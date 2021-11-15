local library = {}
library.loadmodule = function(t)
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/catboy08/nil/main/modules/"..t..".lua"))()
end

library.load = function(t)
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/catboy08/nil/main/games/"..t.PlaceId..".lua"))()
end
return library
