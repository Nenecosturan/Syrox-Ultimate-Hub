--[[
    SYROX HUB - ULTIMATE ALL-IN-ONE (2026)
    Düzeltmeler: 4 Panel Aktif, Hitbox Fix, Minimize Protection, Script Executor
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- GUI Temizliği
local oldGui = player.PlayerGui:FindFirstChild("SyroxUltimateHub")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SyroxUltimateHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

--==============================
-- GLOBAL STATES
--==============================
local States = {Hitbox = false, Sprint = false, InfJump = false}
local Panels = {}
local minimized = false

--==============================
-- MAIN FRAME & BLUR
--==============================
local blur = Instance.new("DepthOfFieldEffect", Lighting)
blur.NearIntensity = 0; blur.FarIntensity = 0; blur.FocusDistance = 0; blur.InFocusRadius = 0

local main = Instance.new("Frame", screenGui)
main.Name = "Main"
main.Size = UDim2.new(0, 550, 0, 320)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.ClipsDescendants = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 120, 0)
stroke.Thickness = 2.5

-- Dragging Logic
local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

--==============================
-- CONTAINERS & SIDEBAR
--==============================
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 75, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 20)

local container = Instance.new("Frame", main)
container.Position = UDim2.new(0, 90, 0, 50)
container.Size = UDim2.new(1, -110, 1, -100)
container.BackgroundTransparency = 1

--==============================
-- PANEL FACTORY
--==============================
local function newPanel(name)
    local f = Instance.new("ScrollingFrame", container)
    f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false
    f.ScrollBarThickness = 0; f.CanvasSize = UDim2.new(0,0,2,0)
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 10)
    Panels[name] = f
    return f
end

local function showPanel(name)
    if minimized then return end
    for _, p in pairs(Panels) do p.Visible = false end
    Panels[name].Visible = true
end

--==============================
-- UI CONTROLS (X / -)
--==============================
local controls = Instance.new("Frame", main)
controls.Size = UDim2.new(0, 80, 0, 30); controls.Position = UDim2.new(1, -90, 0, 10); controls.BackgroundTransparency = 1

local function createCtrl(txt, color, pos, callback)
    local b = Instance.new("TextButton", controls)
    b.Size = UDim2.new(0, 25, 0, 25); b.Position = pos; b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = txt; b.TextColor3 = color; b.Font = Enum.Font.Code; b.TextSize = 16
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(callback)
end

createCtrl("×", Color3.fromRGB(255, 50, 50), UDim2.new(0.6, 0, 0, 0), function() 
    TweenService:Create(blur, TweenInfo.new(0.3), {NearIntensity = 0}):Play()
    screenGui:Destroy() 
end)

createCtrl("-", Color3.fromRGB(255, 255, 255), UDim2.new(0.2, 0, 0, 0), function()
    minimized = not minimized
    local targetY = minimized and 45 or 320
    container.Visible = not minimized
    sidebar.Visible = not minimized
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 550, 0, targetY)}):Play()
end)

--==============================
-- 4 PANELS INITIALIZATION
--==============================
local moveP = newPanel("Movement")
local combatP = newPanel("Combat")
local scriptP = newPanel("Scripts")
local setP = newPanel("Settings")

local function createToggle(parent, text, cb)
    local state = false
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = "  " .. text; btn.Font = Enum.Font.Code; btn.TextSize = 13; btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = state and Color3.fromRGB(255, 120, 0) or Color3.fromRGB(30, 30, 30)}):Play()
        cb(state)
    end)
end

-- 1. Movement
createToggle(moveP, "SPEED SPRINT (60)", function(on) if player.Character then player.Character.Humanoid.WalkSpeed = on and 60 or 16 end end)
createToggle(moveP, "INFINITE JUMP", function(on) States.InfJump = on end)
UIS.JumpRequest:Connect(function() if States.InfJump then player.Character.Humanoid:ChangeState("Jumping") end end)

-- 2. Combat (Hitbox Fix)
createToggle(combatP, "HITBOX EXPANDER (SANE)", function(on)
    States.Hitbox = on
    task.spawn(function()
        while States.Hitbox do
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Size = Vector3.new(5, 5, 5)
                    v.Character.HumanoidRootPart.Transparency = 0.8
                    v.Character.HumanoidRootPart.CanCollide = false
                end
            end
            task.wait(1)
        end
    end)
end)

-- 3. Scripts (Executor)
local execBox = Instance.new("TextBox", scriptP)
execBox.Size = UDim2.new(1, -10, 0, 100); execBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
execBox.Text = ""; execBox.PlaceholderText = "Paste Luau Script Here..."; execBox.TextColor3 = Color3.fromRGB(255,255,255)
execBox.TextWrapped = true; execBox.ClearTextOnFocus = false; execBox.TextYAlignment = Enum.TextYAlignment.Top
Instance.new("UICorner", execBox)

local execBtn = Instance.new("TextButton", scriptP)
execBtn.Size = UDim2.new(1, -10, 0, 35); execBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
execBtn.Text = "EXECUTE"; execBtn.Font = Enum.Font.CodeBold; execBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", execBtn)
execBtn.MouseButton1Click:Connect(function() loadstring(execBox.Text)() end)

-- 4. Settings
createToggle(setP, "ANTI-LAG (REMOVE TEXTURES)", function(on)
    if on then
        for _,v in pairs(game:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
        end
    end
end)

--==============================
-- SIDEBAR BUTTONS (4 TOTAL)
--==============================
local function sideBtn(icon, y, panel)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(0, 45, 0, 45); b.Position = UDim2.new(0.2, 0, y, 0)
    b.Text = icon; b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 20; Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(function() showPanel(panel) end)
end

sideBtn("⚡", 0.1, "Movement")
sideBtn("🤖", 0.28, "Combat")
sideBtn("💾", 0.46, "Scripts")
sideBtn("⚙️", 0.64, "Settings")

-- Init
TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 550, 0, 320)}):Play()
TweenService:Create(blur, TweenInfo.new(0.5), {NearIntensity = 1}):Play()
showPanel("Movement")
