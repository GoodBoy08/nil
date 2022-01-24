--[[
    Credits:
        Hydroxide [Upbolt] : https://github.com/Upbolt/Hydroxide
        Belkworks : https://github.com/Belkworks
]]

-- # Script Env

local Players = game:service("Players")
local RunService = game:service("RunService")
local ReplicatedStorage = game:service("ReplicatedStorage")
local Player = Players["LocalPlayer"]

local Assets = ReplicatedStorage:WaitForChild("Assets")
local Network = Assets.Modules:WaitForChild("NetworkClass")
Network = require(Network)

local function gitImport(user, repository, branch, file)
    return loadstring(game:HttpGet(string.format("https://github.com/%s/%s/blob/%s/%s", user, repository, branch, file.."?raw=true")))()
end

local Library = gitImport("CatzCode", "Cattoware", "main", "libraries/ui.lua")
local ESPlib = gitImport("coolb0y08", "nil", "main", "esp.lua")
local quick = gitImport("Belkworks", "quick", "master", "init.lua")

-- # Main Code

local function getClosestTool(distance)
    if not Player or not Player["Character"] then return end

    local Path = workspace:WaitForChild("Terrain"):WaitForChild("Ignore").Tools
    
    for i,v in pairs(Path:GetChildren()) do
        if v:IsA("Model") and v.PrimaryPart then
            local magnitude = (v.PrimaryPart.Position-Player.Character.HumanoidRootPart.Position).Magnitude
            if magnitude <= distance then
                return v
            end
        end
    end
    
    return nil
end

local function getClosestDoor(distance)
    if not Player or not Player["Character"] then return end

    local Path = game:GetService("Workspace").Doors
    
    for i,v in pairs(Path:GetChildren()) do
        if v:IsA("Model") and v.PrimaryPart then
            local magnitude = (v.PrimaryPart.Position-Player.Character.HumanoidRootPart.Position).Magnitude
            if magnitude <= distance then
                return v
            end
        end
    end
    
    return nil
end

local function getClosestItem(distance)
    if not Player or not Player["Character"] then return end

    local Path = game:GetService("Workspace").Terrain.Ignore.Items
    
    for i,v in pairs(Path:GetChildren()) do
        if v:IsA("Model") and v.PrimaryPart then
            local magnitude = (v.PrimaryPart.Position-Player.Character.HumanoidRootPart.Position).Magnitude
            if magnitude <= distance then
                return v
            end
        elseif v:IsA("MeshPart") or v:IsA("Part") then
            local magnitude = (v.Position-Player.Character.HumanoidRootPart.Position).Magnitude
            if magnitude <= distance then
                return v
            end
        end
    end
    
    return nil
end

local function getClosestCharacter(distance)
    if not Player or not Player["Character"] then return end
    
    primaryPart = Player["Character"].PrimaryPart
    maxDistance = distance or math.huge

    for i,v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character then
            if v.Character.PrimaryPart then
                local magnitude = ((v.Character.PrimaryPart.Position)-(primaryPart.Position)).Magnitude
                if magnitude <= maxDistance then
                    return v.Character
                end
            end
        end
    end
    
    return nil
end

local Flags = Library["flags"]
local renderStepped = RunService.RenderStepped

renderStepped:Connect(function()
    if Player.Character then
        if Player.Character:FindFirstChild("Essentials") then
            local Essentials = Player.Character:FindFirstChild("Essentials")
            local ClientController = Essentials:FindFirstChild("ClientController")

            if Flags.NoDashCooldown and ClientController then
                setupvalue(getsenv(ClientController).dash_main, 1, 0)
            end

            if Flags.InfiniteStamina and ClientController then
                setupvalue(getsenv(ClientController).block_main, 4, math.huge)
            end
        end
    end

    if Player and Player:FindFirstChild("Settings") then
        local Settings = Player:FindFirstChild("Settings")
        if Settings:FindFirstChild("blockAmount") and Flags.InfiniteBlock then
            Settings.blockAmount.Value = 5
        end
    end
end)

-- # Library

Library.theme.accentcolor = Color3.fromRGB(3, 132, 252)
Library.theme.accentcolor2 = Color3.fromRGB(6, 103, 194)

local Window = Library:CreateWindow("cattohook", Vector3.new(492, 580), Enum.KeyCode.RightShift)

Window.Main.main.Modal = true

local Combat = Window:CreateTab("Combat")
local Visuals = Window:CreateTab("Visuals")
local Miscellaneous = Window:CreateTab("Miscellaneous")
local Settings = Window:CreateTab("Settings")

-- # Combat

Modifications = Combat:CreateSector("Modifications", "Right")

Modifications:AddToggle("Infinite Parry", false, nil, "InfiniteBlock")
Modifications:AddToggle("Infinite Stamina", false, nil, "InfiniteStamina")
Modifications:AddToggle("No Dash Cooldown", false, nil, "NoDashCooldown")
Modifications:AddToggle("No Fall", false, nil, "NoFall")
Modifications:AddSeperator("Melee Modifications")
Modifications:AddToggle("Enabled", false, nil, "Enabled")
Modifications:AddToggle("Always Special", false, nil, "Special")
Modifications:AddToggle("Change Delay", false, nil, "ChangeDelay"):AddSlider(0, .3, 10, 10, nil, "Delay")
Modifications:AddToggle("Change Charge Time", false, nil, "ChangeCharge"):AddSlider(0, .3, 10, 10, nil, "ChargeTime")

-- # Visuals

ESP = Visuals:CreateSector("ESP", "Left")

ESP:AddToggle("Enabled", false, function(...)
    if not (...) then
        Boxes:Set(false)
        Names:Set(false)
        Tracers:Set(false)
    end
    ESPlib.Enabled = (...)
end)

ESP:AddColorpicker("Color", Color3.fromRGB(3, 132, 252), function(...)
    ESPlib.Color = (...)
end)

local Boxes = ESP:AddToggle("Boxes", false, function(...)
    ESPlib.Boxes = (...)
end)

local Names = ESP:AddToggle("Names", false, function(...)
    ESPlib.Names = (...)
end)

local Tracers = ESP:AddToggle("Tracers", false, function(...)
    ESPlib.Tracers = (...)
end)

-- # Miscellaneous

AutoDespawn = Miscellaneous:CreateSector("Auto Despawn", "Left")

AutoDespawn:AddToggle("Enabled", false, nil, "AutoDespawn"):AddSlider(1, 35, 99, 1, nil, "AutoDespawnHP")

AutoFarm = Miscellaneous:CreateSector("Auto Farm", "Right")

AutoFarm:AddToggle("Auto Pick Tools", false, function(t)
    if(t==(true))then
        ToolLoop = game.RunService.RenderStepped:Connect(function()
            if getClosestTool(15) then
                Network:InvokeServer("collectTool", getClosestTool(15))
            end
        end)
    elseif(not(t)and(ToolLoop))then
        ToolLoop:Disconnect()
    end
end, "AutoPickTools")

AutoFarm:AddToggle("Auto Break Doors", false, function(t)
    if(t==(true))then
        DoorLoop = game.RunService.RenderStepped:Connect(function()
            if getClosestDoor(15) then
                Network:InvokeServer("break door", getClosestDoor(15))
            end
        end)
    elseif(not(t)and(DoorLoop))then
        DoorLoop:Disconnect()
    end
end, "AutoBreakDoor")

AutoFarm:AddToggle("Auto Pick Items", false, function(t)
    if(t==(true))then
        ItemLoop = game.RunService.RenderStepped:Connect(function()
            if getClosestItem(15) then
                Network:InvokeServer("collectItem", getClosestItem(15))
            end
        end)
    elseif(not(t)and(ItemLoop))then
        ItemLoop:Disconnect()
    end
end, "AutoPickItems")

AutoFarm:AddToggle("Auto Open Lockers", false, function(t)
    if(t==(true))then
        local function interactlocker(l)
            Network:InvokeServer("loot i)-interact", l)
        end

        local function lockermain(l)
            if not l:FindFirstChild("__cooldown") then
                pcall(interactlocker, l)
            end
            
            l.ChildRemoved:Connect(function()
                pcall(function()
                    if Library.flags.AutoOpenLockers then
                        pcall(interactlocker, l)
                    end
                end)
            end)
        end

        task.spawn(function()
            for i,v in pairs(game:GetService("Workspace").Terrain.Ignore.Supplies:GetChildren()) do
                task.spawn(function()
                    lockermain(v)
                end)
                task.wait(.1)
            end
        end)
        
        task.spawn(function()
            for i,v in pairs(game:GetService("Workspace").Terrain.Ignore.Loot:GetChildren()) do
                task.spawn(function()
                    lockermain(v)
                end)
                task.wait(.1)
            end
        end)
        
        task.spawn(function()
            for i,v in pairs(game:GetService("Workspace").Terrain.Ignore.Lockers:GetChildren()) do
                task.spawn(function()
                    lockermain(v)
                end)
                task.wait(.1)
            end
        end)
    end
end, "AutoOpenLockers")

-- # Settings

-- # Connections

if Player.Character then
    local Flags = Library.flags
    local Character = Player.Character
    local Humanoid = Character:FindFirstChild("Humanoid")

    if Humanoid then
        Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if Humanoid.Health <= Flags.AutoDespawnHP and Flags.AutoDespawn  then
                Network:FireServer("load")
                Network:InvokeServer("load")
            end
        end)
    end
end

Player.CharacterAppearanceLoaded:Connect(function(Character)
    local Flags = Library.flags
    local Humanoid = Character:WaitForChild("Humanoid")

    if Humanoid then
        Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if Humanoid.Health <= Flags.AutoDespawnHP and Flags.AutoDespawn then
                Network:FireServer("load")
                Network:InvokeServer("load")
            end
        end)
    end
end)

local old
old = hookmetamethod(game, "__namecall", function(...)
    if getnamecallmethod() == "TakeDamage" then
        if Library.flags.NoFall then
            return wait(9e0)
        end
    end
    
    return old(...)
end)

__Invoke = Network.InvokeServer
Network.InvokeServer = function(...)
    local args = {...}
    
    if args[2] == "hit" and Library.flags.Enabled then
        if args[4] then
            if Library.flags.Special then
                args[4].special = true
                args[5] = 3
            end

            if Library.flags.ChangeDelay then
                args[4].delay = Library.flags.Delay
            end

            if Library.flags.ChangeCharge then
                args[4].chargeTime = Library.flags.ChargeTime
            end
        end
    end
    
    return __Invoke(...)
end

__Fire = Network.FireServer
Network.FireServer = function(...)
    local args = {...}
    
    if args[2] == "fall" then
        if Library.flags.NoFall then
            return wait(9e0)
        end
    end

    return __Fire(...)
end
