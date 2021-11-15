local request = (syn and syn.request) or (http and http.request) or http_request
local discord = {};
local HttpService = game:GetService("HttpService")

discord.api = {}

discord.fetch = function(tab)
    discord.api.invite = HttpService:JSONDecode(request({
        Url = ("https://discord.com/api/v6/invite/"..tab.invite);
        Method = ("GET");
    }).Body)

    wait(.1)

    discord.api.widget = HttpService:JSONDecode(request({
        Url = ("https://discord.com/api/guilds/"..tab.serverid.."/widget.json");
        Method = ("GET");
    }).Body)

    if tab.command == "active" then
        return(#discord.api.widget.members)
    elseif tab.command == "guild" then
        return(discord.api.invite.guild)
    elseif tab.command == "find" then
        for _,v in pairs(discord.api.widget.channels) do
            if v.name:find(tab.args) then
                return v
            end
        end
    end
end

return discord
--[[
    Usage:
        discord.fetch({
          command = "active";
          serverid = "881892180908703755";
          invite = "kzztHSgz"
        }) - Returns active members
        discord.fetch({
          command = "guild";
          serverid = "881892180908703755";
          invite = "kzztHSgz"
        }) - Fetches guild to get data example:
        print(discord.fetch({
          command = "guild";
          serverid = "881892180908703755";
          invite = "kzztHSgz"
        }).name)
    
    [/] Made by coolboy08#0064 [\]
    
    To use this thing you have to enable "Widgets" on your server:
        Go to Server Settings/Widget and Enable Server Widget:
        After that you need invite
        After you got invite paste it in discord.api.invite
        https://discord.com/api/v6/invite/INVITE CODE
        Paste server id in discord.api.widget
        https://discord.com/api/guilds/SERVER ID HERE/widget.json
        
    Done, easy.
]]
