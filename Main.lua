--[[
    SYROX HUB - PERFORMANCE OPTIMIZED FINAL (2026)
    Optimized for: Low Lag, No Memory Leaks, High Stability
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local connections = {} -- Bellek sızıntısını önlemek için bağlantı tablosu

-- GUI Temizliği
local oldGui = player.PlayerGui:FindFirstChild("SyroxUltimateHub")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SyroxUltimateHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

--==============================
-- OPTIMIZED BLUR
--==============================
local blur = Instance.new("DepthOfFieldEffect")
blur.Name = "SyroxBlur_Final"
blur.FarIntensity = 0; blur.FocusDistance = 0; blur.InFocusRadius = 0; blur.NearIntensity = 0
blur.Parent = Lighting

local function toggleBlur(state)
    TweenService:Create(blur, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {NearIntensity = state and 1 or 0}):Play()
end

--==============================
-- MAIN FRAME & SMOOTH DRAG
--==============================
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 550, 0, 320)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 120, 0)
stroke.Thickness = 2.5

-- Akıcı Sürükleme (Smooth Drag)
local dragToggle, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true; dragStart = input.Position; startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = false
    end
end)

--==============================
-- WINDOW CONTROLS (X & -)
--==============================
local controls = Instance.new("Frame", main)
controls.Size = UDim2.new(0, 80, 0, 30); controls.Position = UDim2.new(1, -90, 0, 10); controls.BackgroundTransparency = 1

local function createControlBtn(txt, color, pos, callback)
    local btn = Instance.new("TextButton", controls)
    btn.Size = UDim2.new(0, 25, 0, 25); btn.Position = pos; btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt; btn.TextColor3 = color; btn.Font = Enum.Font.Code; btn.TextSize = 16
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

createControlBtn("×", Color3.fromRGB(255, 50, 50), UDim2.new(0.6, 0, 0, 0), function()
    toggleBlur(false)
    for _, v in pairs(connections) do v:Disconnect() end -- Tüm özellikleri durdur
    local t = TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    t:Play(); t.Completed:Wait(); screenGui:Destroy(); blur:Destroy()
end)

local minimized = false
createControlBtn("-", Color3.fromRGB(255, 255, 255), UDim2.new(0.2, 0, 0, 0), function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 550, 0, 45) or UDim2.new(0, 550, 0, 320)
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

--==============================
-- PANEL & NAVIGATION SYSTEM
--==============================
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 75, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 20)

local container = Instance.new("Frame", main)
container.Position = UDim2.new(0, 90, 0, 50); container.Size = UDim2.new(1, -110, 1, -100); container.BackgroundTransparency = 1

local Panels = {}
local function newPanel(name)
    local f = Instance.new("ScrollingFrame", container)
    f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false
    f.ScrollBarThickness = 0; f.CanvasSize = UDim2.new(0,0,2,0)
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 10)
    Panels[name] = f
    return f
end

local function showPanel(name)
    for _, p in pairs(Panels) do p.Visible = false end
    Panels[name].Visible = true
end

--==============================
-- TOGGLE SYSTEM & FEATURES
--==============================
local function createToggle(parent, text, cb)
    local state = false
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = "  " .. text; btn.Font = Enum.Font.Code; btn.TextSize = 14; btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = state and Color3.fromRGB(255, 120, 0) or Color3.fromRGB(30, 30, 30)}):Play()
        cb(state)
    end)
end

local move = newPanel("Movement")
local combat = newPanel("Combat")

-- Movement Features
createToggle(move, "SPEED SPRINT", function(on)
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = on and 60 or 16 end
end)

local infJumpEnabled = false
createToggle(move, "INFINITE JUMP", function(on) infJumpEnabled = on end)
connections.InfJump = UIS.JumpRequest:Connect(function()
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if infJumpEnabled and h then h:ChangeState("Jumping") end
end)

-- Combat Features
createToggle(combat, "HITBOX EXPANDER", function(on)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = on and Vector3.new(10,10,10) or Vector3.new(2,2,1)
            v.Character.HumanoidRootPart.Transparency = on and 0.7 or 1
            v.Character.HumanoidRootPart.CanCollide = false
        end
    end
end)

-- Sidebar Buttons
local function sideBtn(icon, y, panel)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(0, 45, 0, 45); b.Position = UDim2.new(0.2, 0, y, 0); b.Text = icon
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 20; Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(function() showPanel(panel) end)
end

sideBtn("⚡", 0.1, "Movement")
sideBtn("🤖", 0.28, "Combat")

-- Init
main.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 550, 0, 320)}):Play()
toggleBlur(true)
showPanel("Movement")
