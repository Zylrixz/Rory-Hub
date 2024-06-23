local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Evade - Rory Hub",
    SubTitle = "by Zylrixz",
    TabWidth = 160,
    Size = UDim2.fromOffset(530, 450),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Rose",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})
-- Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    General = Window:AddTab({ Title = "General", Icon = "house" }),
    Esp = Window:AddTab({ Title = "Visual ESP", Icon = "eye" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Misc = Window:AddTab({ Title = "Miscellaneous", Icon = "list-plus" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
local Options = Fluent.Options

do
    function isnil(thing)
        return (thing == nil)
    end
    local function round(n)
        return math.floor(tonumber(n) + 0.5)
    end
    function UpdateEspPlayer()
        for i,v in pairs(game:GetService("Players"):GetChildren()) do
            pcall(function()
                if not isnil(v.Character) then
                    if EspPlayer then
                        if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild("NameEsp") then
                            local BillboardGui = Instance.new("BillboardGui", v.Character.Head)
                            BillboardGui.Name = "NameEsp"
                            BillboardGui.AlwaysOnTop = true
                            BillboardGui.ExtentsOffset = Vector3.new(0, 2.5, 0)
                            BillboardGui.Size = UDim2.new(15, 0, 2, 0)
                            local TextLabel = Instance.new("TextLabel", BillboardGui)
                            TextLabel.Name = (v.Name .." \n".. round((game:GetService("Players").LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude / 3) .." Distance")
                            TextLabel.BackgroundTransparency = 1
                            TextLabel.Size = UDim2.new(1, 0, 1, 0)
                            TextLabel.Font = Enum.Font.SourceSansBold
                            TextLabel.TextColor3 = Color3.fromRGB(85, 255, 0)
                            TextLabel.TextScaled = true
                            TextLabel.TextStrokeTransparency = 0
                            TextLabel.TextWrapped = true
                            local UIGradient = Instance.new("UIGradient", TextLabel)
                            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 0))}
                            UIGradient.Offset = Vector2.new(0, 0.2)
                            UIGradient.Rotation = 90
                        else
                            v.Character.Head["NameEsp"].TextLabel.Text = (v.Name .." \n".. round((game:GetService("Players").LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude / 3) .." Distance")
                        end
                    else
                        if v.Character.Head:FindFirstChild("NameEsp") then
                            v.Character.Head:FindFirstChild("NameEsp"):Destroy()
                        end
                    end
                end   
            end)
        end
    end
    
    spawn(function()
        while wait() do
            if EspPlayer then
                UpdateEspPlayer() 
            end
        end
    end)

    local ToggleEspPlayer = Tabs.Esp:AddToggle("ToggleEspPlayer", {Title = "ESP Player", Default = false })
    ToggleEspPlayer:OnChanged(function()
        EspPlayer = Value
        UpdateEspPlayer()
    end)
    Options.ToggleEspPlayer:SetValue(false)
end

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "FLUENT",
    Content = "Script loaded successfully.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
