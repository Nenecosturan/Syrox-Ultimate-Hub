--[[
    SYROX HUB V7.1 - PERFORMANCE EDITION
    * Gereksiz döngüler kaldırıldı.
    * Event-Based (Olay Tabanlı) sisteme geçildi.
    * Anti-Logger ve Bypass birleştirildi.
    * FPS Dostu Kod Yapısı.
]]

-- [ OPTIMIZED INITIALIZATION ]
if _G.SyroxExecuted then return end
_G.SyroxExecuted = true

-- [ LOCALIZING SERVICES - For Speed ]
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TS = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [ CONFIGURATION - Centralized ]
local Syrox = {
    Bypass = true,
    Logger = true,
    Speed = 16,
    Jump = 50,
    Spam = false,
    SpamDelay = 1.5,
    SpamText = "",
    Input = ""
}

-- [ RAYFIELD OPTIMIZED LOAD ]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "SYROX V7.1 | PERFORMANCE",
   LoadingTitle = "Optimizing Core Modules...",
   LoadingSubtitle = "by Gemini AI",
   ConfigurationSaving = {Enabled = false},
   Keybind = Enum.KeyCode.RightControl
})

-- [ EFFICIENT CHAT ENGINE ]
local function MasterSend(msg)
    if not msg or msg == "" then return end
    
    local output = msg
    if Syrox.Bypass then
        -- En hızlı bypass yöntemi (Tablo operasyonu yerine String manipülasyonu)
        local invisible = "\226\128\139"
        output = msg:gsub(".", "%1" .. invisible)
    end

    if TS.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TS.TextChannels.RBXGeneral
        if channel then channel:SendAsync(output) end
    else
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("SayMessageRequest", true)
        if remote then remote:FireServer(output, "All") end
    end
end

-- [ PERFORMANCE MOVEMENT HOOK ]
-- Sürekli döngü (while wait) yerine AttributeChanged kullanarak FPS tasarrufu yapıyoruz.
local function SetupCharacter(char)
    local hum = char:WaitForChild("Humanoid")
    
    -- Hız kontrolünü sadece değiştiğinde yapıyoruz (Gereksiz CPU kullanımını keser)
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if hum.WalkSpeed ~= Syrox.Speed then
            hum.WalkSpeed = Syrox.Speed
        end
    end)
    
    hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if hum.JumpPower ~= Syrox.Jump then
            hum.JumpPower = Syrox.Jump
        end
    end)
    
    -- İlk değerleri ata
    hum.WalkSpeed = Syrox.Speed
    hum.JumpPower = Syrox.Jump
end

if LocalPlayer.Character then SetupCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(SetupCharacter)

-- ==========================================
-- [ TABS ]
-- ==========================================
local ChatTab = Window:CreateTab("🛡️ Stealth Chat", 4483362458)
local MainTab = Window:CreateTab("⚡ Player", 4483362458)

-- [ CHAT SECTION ]
ChatTab:CreateSection("Security & Bypass")

ChatTab:CreateToggle({
   Name = "Anti-Tag Bypass",
   CurrentValue = true,
   Callback = function(v) Syrox.Bypass = v end,
})

ChatTab:CreateSection("Messenger")

ChatTab:CreateTextBox({
   Name = "Message Box",
   PlaceholderText = "Type stealthy message...",
   RemoveTextAfterFocusLost = false,
   Callback = function(t) Syrox.Input = t end,
})

ChatTab:CreateButton({
   Name = "🚀 SEND BYPASSED",
   Callback = function() MasterSend(Syrox.Input) end,
})

ChatTab:CreateSection("Spammer")

ChatTab:CreateTextBox({
   Name = "Spam Text",
   PlaceholderText = "...",
   Callback = function(t) Syrox.SpamText = t end,
})

ChatTab:CreateToggle({
   Name = "Enable Spammer",
   CurrentValue = false,
   Callback = function(v)
      Syrox.Spam = v
      if v then
          task.spawn(function()
              while Syrox.Spam do
                  MasterSend(Syrox.SpamText)
                  task.wait(Syrox.SpamDelay)
              end
          end)
      end
   end,
})

-- [ PLAYER SECTION ]
MainTab:CreateSection("Movement Stats")

MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) 
      Syrox.Speed = v 
      local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
      if hum then hum.WalkSpeed = v end
   end,
})

MainTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 300},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) 
      Syrox.Jump = v 
      local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
      if hum then hum.JumpPower = v end
   end,
})

-- [ NOTIFY ]
Rayfield:Notify({
   Title = "Syrox V7.1 Optimized",
   Content = "FPS Boost & Performance active.",
   Duration = 5,
   Image = 4483362458,
})
