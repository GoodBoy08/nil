local library = {}
library.loadmodule = function(t)
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/catboy08/nil/main/modules/"..t))()
end

return library
