local ESP = {
    ChamsColor = Color3.fromRGB(255, 255, 255);
    ChamsEnabled = true;
    TextColor = Color3.fromRGB(255, 255, 255);
    Collectibles = true;
}

local camera = game:GetService("Workspace").CurrentCamera
local ChangeChams = Instance.new("BindableEvent", game.CoreGui)
function Chams(parent, face)
	local SurfaceGui = Instance.new("SurfaceGui",parent) 
	SurfaceGui.Parent = parent
	SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SurfaceGui.Face = Enum.NormalId[face]
	SurfaceGui.LightInfluence = 0
	SurfaceGui.ResetOnSpawn = false
	SurfaceGui.Name = "Body"
	SurfaceGui.AlwaysOnTop = true
	local Frame = Instance.new("Frame",SurfaceGui)
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.Size = UDim2.new(1,0,1,0)
	
	game:GetService("RunService").RenderStepped:Connect(function()
	    Frame.BackgroundColor3 = ESP.ChamsColor
	    SurfaceGui.Enabled = ESP.ChamsEnabled
	end)
end

for i,v in pairs(game:GetService("Workspace").Collectibles:GetChildren()) do
    if v:IsA("MeshPart") or v:IsA("Part") then
        local Text = Drawing.new("Text")
        Text.Transparency = 1
        Text.Visible = false
        Text.Color = Color3.new(1,1,1)
        Text.Size = 12
        Text.Center = true
        Text.Outline = true

        Chams(v, "Back")
        Chams(v, "Front")
        Chams(v, "Top")
        Chams(v, "Bottom")
        Chams(v, "Right")
        Chams(v, "Left")

        game:GetService("RunService").RenderStepped:Connect(function()
            local Vector, onScreen = camera:worldToViewportPoint(v.Position)
            if onScreen then
                Text.Text = tostring(v.Name)
                Text.Size = 16
                Text.Visible = true
                Text.Position = Vector2.new(workspace.Camera:WorldToViewportPoint(v.Position).X, workspace.Camera:WorldToViewportPoint(v.Position).Y - 30)
            else
                Text.Visible = false
            end
        end)
    elseif v:IsA("Model") then
        local Text = Drawing.new("Text")
        Text.Transparency = 1
        Text.Visible = false
        Text.Color = Color3.new(1,1,1)
        Text.Size = 12
        Text.Center = true
        Text.Outline = true

        Chams(v.PrimaryPart, "Back")
        Chams(v.PrimaryPart, "Front")
        Chams(v.PrimaryPart, "Top")
        Chams(v.PrimaryPart, "Bottom")
        Chams(v.PrimaryPart, "Right")
        Chams(v.PrimaryPart, "Left")

        game:GetService("RunService").RenderStepped:Connect(function()
            local Vector, onScreen = camera:worldToViewportPoint(v.PrimaryPart.Position)
            if onScreen then
                Text.Text = tostring(v.Name)
                Text.Size = 16
                Text.Color = ESP.TextColor
                Text.Visible = ESP.Collectibles
                Text.Position = Vector2.new(workspace.Camera:WorldToViewportPoint(v.PrimaryPart.Position).X, workspace.Camera:WorldToViewportPoint(v.PrimaryPart.Position).Y - 30)
            else
                Text.Visible = false
            end
        end)
    end
end

return ESP
