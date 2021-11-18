--[[
    Yes i know this sucks as hell.
    Inspired by kiriot & cattoware esp.
    Credits to Quenty for cool module :sunglasses:
]]

local signal = loadstring(game:HttpGet('https://raw.githubusercontent.com/Quenty/NevermoreEngine/version2/Modules/Shared/Events/Signal.lua'))();

------------------------// Services \\------------------------

local Workspace = game:GetService("Workspace");
local RunService = game:GetService("RunService");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local StarterPlayer = game:GetService("StarterPlayer");
local StarterPack = game:GetService("StarterPack");
local StarterGui = game:GetService("StarterGui");
local CoreGui = game:GetService("CoreGui");
local Lighting = game:GetService("Lighting");

------------------------// Variables \\------------------------

local Player = Players.LocalPlayer;
local Camera = Workspace.CurrentCamera;
local Mouse = Player:GetMouse();

------------------------// Settings \\------------------------

local ESP = {
    ["Boxes"] = false;
        ["BoxesColor"] = Color3.fromRGB(255, 255, 255);
        ["BoxesOutline"] = Color3.fromRGB(0, 0, 0);
        ["BoxesThickness"] = 1;
    ["Names"] = false;
        ["NamesColor"] = Color3.fromRGB(255, 255, 255);
        ["NamesOutline"] = true;
            ["NamesOutlineClr"] = Color3.fromRGB(0, 0, 0);
        ["ShowDistance"] = true;
    ["Tracers"] = false;
        ["TracersColor"] = Color3.fromRGB(255, 255, 255);
        ["UnlockTracers"] = true;
        ["TracersThickness"] = 1;
        ["TracersTransparency"] = 1;
    ["Chams"] = false;
        ["ChamsTransparency"] = 0.5;
        ["ChamsAlwaysOnTop"] = true;
        ["ChamsAllyColor"] = Color3.fromRGB(43, 73, 194);
        ["ChamsEnemyColor"] = Color3.fromRGB(194, 43, 43);
    ["Tools"] = false;
        ["ToolsColor"] = Color3.fromRGB(255, 255, 255);
        ["ToolsOutline"] = true;
            ["ToolsOutlineClr"] = Color3.fromRGB(0, 0, 0);
    ["Healthbar"] = false;
        ["HealthBarThickness"] = 1;
        ["HealthBarOutline"] = Color3.fromRGB(0, 0, 0);
    -- Settings :
    ["TextSize"] = 16;
    ["Font"] = "Monospace";
    ["Secret"] = false;
    -- Functions :
    ["Functions"] = {};
    ["Events"] = {};
}

------------------------// Events \\------------------------

ESP["Events"].UpdateChams = signal.new()
ESP["Events"].UpdateNames = signal.new()
ESP["Events"].UpdateBoxes = signal.new()
ESP["Events"].UpdateTracers = signal.new()
ESP["Events"].Toggle = signal.new()

------------------------// Setting up \\------------------------

if game.CoreGui:FindFirstChild("Chams") then
    game.CoreGui:FindFirstChild("Chams"):Destroy()
end

ESP.ChamsFold = Instance.new("Folder");
ESP.ChamsFold.Parent = game.CoreGui;
ESP.ChamsFold.Name = "Chams";

------------------------// Chams Function \\------------------------

ESP["Functions"].CreateCham = function(tab)
    local IsCharacter = tab.character;
    local Properties = tab.properties;
    local AutoRemove = tab.autoremove;
    local Chams = {};
    
    if Properties then
        Properties.Parent = ESP.ChamsFold;
        Properties.Size = (tab.adornee.Size)+Vector3.new(0.5, 0.5, 0.5);
        Properties.ZIndex = 10;
        Properties.Adornee = tab.adornee
    end
    
    if(IsCharacter) then
        local _Player = Players:GetPlayerFromCharacter(tab.adornee.Parent)
        if _Player then
            local TeamColor = _Player:GetPropertyChangedSignal("TeamColor"):Connect(function()
                if ESP["Secret"] and _Player.TeamColor == Player.TeamColor then
                    _Color = ESP.ChamsAllyColor
                elseif ESP["Secret"] and _Player.TeamColor ~= Player.TeamColor then
                    _Color = ESP.ChamsEnemyColor
                elseif not ESP["Secret"] and _Player.TeamColor == Player.TeamColor then
                    _Color = ESP.ChamsEnemyColor
                elseif not ESP["Secret"] and _Player == Player then
                    _Color = ESP.ChamsAllyColor
                else
                    _Color = ESP.ChamsEnemyColor
                end
            end)
            
            if ESP["Secret"] and _Player.TeamColor == Player.TeamColor then
                _Color = ESP.ChamsAllyColor
            elseif ESP["Secret"] and _Player.TeamColor ~= Player.TeamColor then
                _Color = ESP.ChamsEnemyColor
            elseif not ESP["Secret"] and _Player == Player then
                _Color = ESP.ChamsAllyColor
            elseif not ESP["Secret"] and _Player.TeamColor == Player.TeamColor then
                _Color = ESP.ChamsEnemyColor
            else
                _Color = ESP.ChamsEnemyColor
            end
        end
    end
    
    Chams.Cham = Instance.new("BoxHandleAdornment")
    Chams.Cham.Name = tostring(tab.adornee).." Cham";
    Chams.Cham.Adornee = tab.adornee;

    Chams.Cham.AlwaysOnTop = ESP["ChamsAlwaysOnTop"];
    Chams.Cham.Color3 = IsCharacter == true and _Color or tab.Color or ESP.ChamsAlly;
    Chams.Cham.Size = (tab.adornee.Size)+Vector3.new(0.5, 0.5, 0.5);
    Chams.Cham.Transparency = (ESP.ChamsTransparency);
    Chams.Cham.Visible = ESP.Chams;

    Chams.Cham.ZIndex = 10;
    Chams.Cham.Parent = ESP.ChamsFold;

    if tab.allowupdate == true then
        ESP["Events"].UpdateChams:Connect(function(prop)
            Chams.Cham.Color3 = _Color
            Chams.Cham.AlwaysOnTop = ESP["ChamsAlwaysOnTop"]
            Chams.Cham.Transparency = ESP["ChamsTransparency"]
            Chams.Cham.Visible = ESP["Chams"]
        end)
    else
        Chams.Update = function(properties)
            Chams.Cham.Color3 = Properties["Color3"]
            Chams.Cham.AlwaysOnTop = Properties["AlwaysOnTop"]
            Chams.Cham.Transparency = Properties["Transparency"]
            Chams.Cham.Visible = Properties["Visible"]
        end
    end

    if(AutoRemove) then
        local PropertyChanged = tab.adornee:GetPropertyChangedSignal("Parent"):Connect(function()
            if tab.adornee.Parent == nil then
                Chams.Cham:Destroy()
                if AncestryChanged then
                    AncestryChanged:Disconnect()
                end
                
                if PropertyChanged then
                    PropertyChanged:Disconnect()
                end
                
                if TeamColor then
                    TeamColor:Disconnect()
                end
            end
        end)
        
        local AncestryChanged = tab.adornee.AncestryChanged:Connect(function(_, parent)
            if parent == nil then
                Chams.Cham:Destroy()
                if AncestryChanged then
                    AncestryChanged:Disconnect()
                end
                
                if PropertyChanged then
                    PropertyChanged:Disconnect()
                end
                
                if TeamColor then
                    TeamColor:Disconnect()
                end
            end
        end)
    end

    return Chams
end

------------------------// Names Function \\------------------------

ESP["Functions"].CreateLabel = function(tab)
    if tab.part then
        local AutoRemove = tab.autoremove;
        local AllowChange = tab.allowupdate;
        local Names = {};
        
        Names.Label = Drawing.new("Text")
        Names.Label.Transparency = 1
        Names.Label.Visible = ESP["Names"]
        Names.Label.Color = ESP["NamesColor"]
        Names.Label.Size = ESP["TextSize"]
        Names.Label.Outline = ESP["NamesOutline"]
        Names.Label.OutlineColor = ESP["NamesOutlineClr"]
        Names.Label.Outline = true
        Names.Label.Center = true

        if ESP["Font"] == "Monospace" then
            Names.Label.Font = 3;
        elseif ESP["Font"] == "Plex" then
            Names.Label.Font = 2;
        elseif ESP["Font"] == "System" then
            Names.Label.Font = 1;
        elseif ESP["Font"] == "UI" then
            Names.Label.Font = 0;
        end

        if AutoRemove then
            local AncestryChanged = tab.part.AncestryChanged:Connect(function(_, parent)
                if parent == nil then
                    Names.Label:Remove()
                    if AncestryChanged then
                        AncestryChanged:Disconnect()
                    end
                end
            end)
        end

        if AllowChange then
            ESP["Events"].UpdateNames:Connect(function()
                Names.Label.Visible = ESP["Names"]
                Names.Label.Color = ESP["NamesColor"]
                Names.Label.Size = ESP["TextSize"]
                Names.Label.Outline = ESP["NamesOutline"]
                Names.Label.OutlineColor = ESP["NamesOutlineClr"]

                if ESP["Font"] == "Monospace" then
                    Names.Label.Font = 3;
                elseif ESP["Font"] == "Plex" then
                    Names.Label.Font = 2;
                elseif ESP["Font"] == "System" then
                    Names.Label.Font = 1;
                elseif ESP["Font"] == "UI" then
                    Names.Label.Font = 0;
                end
            end)
        else
            Names.Update = function(prop)
                Names.Label.Visible = prop["Names"]
                Names.Label.Color = prop["NamesColor"]
                Names.Label.Size = prop["TextSize"]
                Names.Label.Outline = prop["NamesOutline"]
                Names.Label.OutlineColor = prop["NamesOutlineClr"]
            end
        end

        return Names
    end
end

------------------------// Boxes Function \\------------------------

ESP["Functions"].CreateBox = function(tab)
    local Boxes = {}
    Boxes.BoxOutline = Drawing.new("Square")
    Boxes.BoxOutline.Visible = ESP["Boxes"]
    Boxes.BoxOutline.Color = ESP["BoxesOutline"]
    Boxes.BoxOutline.Thickness = ESP["BoxesThickness"]+3
    Boxes.BoxOutline.Transparency = 1
    Boxes.BoxOutline.Filled = false

    Boxes.Box = Drawing.new("Square")
    Boxes.Box.Visible = ESP["Boxes"]
    Boxes.Box.Color = ESP["BoxesColor"]
    Boxes.Box.Thickness = ESP["BoxesThickness"]
    Boxes.Box.Transparency = 1
    Boxes.Box.Filled = false

    if tab.allowupdate then
        ESP["Events"].UpdateBoxes:Connect(function()
            Boxes.BoxOutline.Visible = ESP["Boxes"]
            Boxes.BoxOutline.Color = ESP["BoxesOutline"]
            Boxes.BoxOutline.Thickness = ESP["BoxesThickness"]+2
            Boxes.BoxOutline.Transparency = 1
            Boxes.BoxOutline.Filled = false
    
            Boxes.Box.Visible = ESP["Boxes"]
            Boxes.Box.Color = ESP["BoxesColor"]
            Boxes.Box.Thickness = ESP["BoxesThickness"]
            Boxes.Box.Transparency = 1
            Boxes.Box.Filled = false
        end)
    end

    if tab.autoremove then
        local AncestryChanged = tab.part.AncestryChanged:Connect(function(_, parent)
            if parent == nil then
                Boxes.Box:Remove()
                Boxes.BoxOutline:Remove()
                if AncestryChanged then
                    AncestryChanged:Disconnect()
                end
            end
        end)
    end
    
    return Boxes
end

------------------------// Tracers Function \\------------------------

ESP["Functions"].CreateTracer = function(tab)
    local Tracer = {}
    Tracer.Tracer = Drawing.new("Line")
    Tracer.Tracer.Visible = ESP["Tracers"]
    Tracer.Tracer.Color = ESP["TracersColor"]
    Tracer.Tracer.Thickness = ESP["TracersThickness"]
    Tracer.Tracer.Transparency = ESP["TracersTransparency"]

    if tab.allowupdate then
        ESP["Events"].UpdateTracers:Connect(function()
            Tracer.Tracer.Visible = ESP["Tracers"]
            Tracer.Tracer.Color = ESP["TracersColor"]
            Tracer.Tracer.Thickness = ESP["TracersThickness"]
            Tracer.Tracer.Transparency = ESP["TracersTransparency"]
        end)
    end

    if tab.autoremove then
        local AncestryChanged = tab.part.AncestryChanged:Connect(function(_, parent)
            if parent == nil then
                Tracer.Tracer:Remove()
                if AncestryChanged then
                    AncestryChanged:Disconnect()
                end
            end
        end)
    end
    
    return Tracer
end

------------------------// Tools Function \\------------------------

ESP["Functions"].CreateTool = function(tab)
    local Tool = {}
    Tool.Gun = Drawing.new("Text")
    Tool.Gun.Transparency = 1
    Tool.Gun.Visible = ESP["Tools"]
    Tool.Gun.Color = ESP["ToolsColor"]
    Tool.Gun.OutlineColor = ESP["ToolsOutlineClr"]
    Tool.Gun.Size = ESP["TextSize"]
    Tool.Gun.Center = true
    Tool.Gun.Outline = true
    
    if ESP["Font"] == "Monospace" then
        Tool.Gun.Font = 3;
    elseif ESP["Font"] == "Plex" then
        Tool.Gun.Font = 2;
    elseif ESP["Font"] == "System" then
        Tool.Gun.Font = 1;
    elseif ESP["Font"] == "UI" then
        Tool.Gun.Font = 0;
    end
    
    if tab.allowupdate then
        ESP["Events"].UpdateNames:Connect(function()
            Tool.Gun.Transparency = 1
            Tool.Gun.Visible = ESP["Tools"]
            Tool.Gun.Color = ESP["ToolsColor"]
            Tool.Gun.OutlineColor = ESP["ToolsOutlineClr"]
            Tool.Gun.Size = ESP["TextSize"]
            Tool.Gun.Center = true
            Tool.Gun.Outline = true
            
            if ESP["Font"] == "Monospace" then
                Tool.Gun.Font = Drawing.Fonts[3];
            elseif ESP["Font"] == "Plex" then
                Tool.Gun.Font = Drawing.Fonts[2];
            elseif ESP["Font"] == "System" then
                Tool.Gun.Font = Drawing.Fonts[1];
            elseif ESP["Font"] == "UI" then
                Tool.Gun.Font = Drawing.Fonts[0];
            end
        end)
    end

    if tab.autoremove then
        local AncestryChanged = tab.part.AncestryChanged:Connect(function(_, parent)
            if parent == nil then
                Tool.Gun:Remove()
                if AncestryChanged then
                    AncestryChanged:Disconnect()
                end
            end
        end)
    end
    
    return Tool
end

------------------------// Healthbar Function \\------------------------

ESP["Functions"].CreateHealthbar = function(tab)
    local HealthBar = {}
    HealthBar.HealthBarOutline = Drawing.new("Square")
    HealthBar.HealthBarOutline.Thickness = ESP["HealthBarThickness"]+2
    HealthBar.HealthBarOutline.Filled = false
    HealthBar.HealthBarOutline.Color = ESP["HealthBarOutline"]
    HealthBar.HealthBarOutline.Transparency = 1
    HealthBar.HealthBarOutline.Visible = ESP["Healthbar"]

    HealthBar.HealthBar = Drawing.new("Square")
    HealthBar.HealthBar.Thickness = ESP["HealthBarThickness"]
    HealthBar.HealthBar.Filled = false
    HealthBar.HealthBar.Transparency = 1
    HealthBar.HealthBar.Visible = ESP["Healthbar"]

    if tab.allowupdate then
        ESP["Events"].UpdateBoxes:Connect(function()
            HealthBar.HealthBar.Thickness = ESP["HealthBarThickness"]
            HealthBar.HealthBar.Filled = false
            HealthBar.HealthBar.Transparency = 1
            HealthBar.HealthBar.Visible = ESP["Healthbar"]
            HealthBar.HealthBarOutline.Thickness = ESP["HealthBarThickness"]+2
            HealthBar.HealthBarOutline.Filled = false
            HealthBar.HealthBarOutline.Color = ESP["HealthBarOutline"]
            HealthBar.HealthBarOutline.Transparency = 1
            HealthBar.HealthBarOutline.Visible = ESP["Healthbar"]
        end)
    end

    if tab.autoremove then
        local AncestryChanged = tab.part.AncestryChanged:Connect(function(_, parent)
            if parent == nil then
                HealthBar.HealthBarOutline:Remove()
                HealthBar.HealthBar:Remove()
                if AncestryChanged then
                    AncestryChanged:Disconnect()
                end
            end
        end)
    end

    return HealthBar
end

return ESP
