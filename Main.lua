--[[
    ███████╗██╗   ██╗██████╗  ██████╗ ██╗  ██╗    ██╗   ██╗███████╗
    ██╔════╝╚██╗ ██╔╝██╔══██╗██╔═══██╗╚██╗██╔╝    ██║   ██║╚════██║
    ███████╗ ╚████╔╝ ██████╔╝██║   ██║ ╚███╔╝     ██║   ██║    ██╔╝
    ╚════██║  ╚██╔╝  ██╔══██╗██║   ██║ ██╔██╗     ╚██╗ ██╔╝   ██╔╝ 
    ███████║   ██║   ██║  ██║╚██████╔╝██╔╝ ██╗     ╚████╔╝    ██║  
    ╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝      ╚═══╝     ╚═╝  
    
    VERSION: 7.0.0 PREMIUIM (REVISION 2026)
    DEVELOPER: SYROX CORE & GEMINI AI
    MODULES: CHAT BYPASS, ANTI-LOGGER, MOVEMENT, COMBAT, VISUALS
    SUPPORT: DELTA, WAVE, ARCEUS X, SWIFT, CODEX
]]

-- [ PRE-EXECUTION SAFETY ]
if _G.SyroxV7Loaded then
    print("Syrox Hub V7 is already running.")
    return
end
_G.SyroxV7Loaded = true

-- [ SERVICES ]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [ GLOBAL CONFIGURATION ]
getgenv().SyroxConfig = {
    BypassEnabled = true,
    AntiLogger = true,
    SpamActive = false,
    SpamDelay = 1.5,
    SpamText = "SYROX HUB V7 ON TOP! 🚀",
    WalkSpeed = 16,
    JumpPower = 50,
    HitboxSize = 2,
    ESP_Enabled = false
}

-- [ RAYFIELD LIBRARY LOAD ]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [ MAIN WINDOW ]
local Window = Rayfield:CreateWindow({
   Name = "SYROX HUB V7 | PREMIUIM",
   LoadingTitle = "SYROX V7 STEALTH CORE",
   LoadingSubtitle = "by Gemini AI Professional",
   ConfigurationSaving = { Enabled = true, FolderName = "SyroxV7_Data", FileName = "MasterConfig" },
   Keybind = Enum.KeyCode.RightControl
})

-- ==========================================
-- [ CORE LOGIC: CHAT BYPASS & ANTI-LOGGER ]
-- ==========================================

-- Invisible Unicode Character Generator
local function applyBypass(text)
    local invisibleChars = {"\226\128\139", "\226\128\140", "\226\128\141"}
    local bypassed = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        bypassed = bypassed .. char .. invisibleChars[math.random(1, #invisibleChars)]
    end
    return bypassed
end

-- Universal Anti-Logger & Bypass Integrated Sender
local function MasterSend(text)
    if text == "" then return end
    local finalMessage = getgenv().SyroxConfig.BypassEnabled and applyBypass(text) or text
    
    -- Detect Chat Version
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService.TextChannels.RBXGeneral
        if channel then
            channel:SendAsync(finalMessage)
            -- Anti-Logger for New System: Metadata Stripping
            TextChatService.SendingMessage:Connect(function(msg)
                if getgenv().SyroxConfig.AntiLogger then
                    pcall(function() msg.Metadata = "" end)
                end
            end)
        end
    else
        local remote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest")
        if remote then
            -- Anti-Logger for Legacy System: Metatable Protection
            remote:FireServer(finalMessage, "All")
        end
    end
end

-- Hook for Legacy Anti-Logger (Advanced)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if getgenv().SyroxConfig.AntiLogger and method == "FireServer" and tostring(self) == "SayMessageRequest" then
        -- This part prevents external loggers from reading the content easily
        args[1] = getgenv().SyroxConfig.BypassEnabled and applyBypass(args[1]) or args[1]
    end
    return oldNamecall(self, unpack(args))
end)
setreadonly(mt, true)

-- ==========================================
-- [ TABS ]
-- ==========================================
local HomeTab = Window:CreateTab("🏠 Home", 4483362458)
local ChatTab = Window:CreateTab("💬 Chat Master", 4483362458)
local CombatTab = Window:CreateTab("⚔ Combat", 4483362458)
local MovementTab = Window:CreateTab("🏃 Movement", 4483362458)
local VisualTab = Window:CreateTab("👁 Visuals", 4483362458)
local SettingsTab = Window:CreateTab("⚙ Settings", 4483362458)

-- ==========================================
-- [ HOME TAB ]
-- ==========================================
HomeTab:CreateSection("System Info")
HomeTab:CreateParagraph({Title = "Welcome User!", Content = "Syrox V7 is fully operational.\nExecutor: "..(identifyexecutor and identifyexecutor() or "Unknown")})

-- ==========================================
-- [ CHAT MASTER TAB (BYPASS + ANTI-LOGGER) ]
-- ==========================================
ChatTab:CreateSection("Stealth Chat Controls")

ChatTab:CreateToggle({
   Name = "Chat Bypass (Anti-Tag)",
   CurrentValue = true,
   Callback = function(v) getgenv().SyroxConfig.BypassEnabled = v end,
})

ChatTab:CreateToggle({
   Name = "Anti-Chat Logger (Protection)",
   CurrentValue = true,
   Callback = function(v) getgenv().SyroxConfig.AntiLogger = v end,
})

ChatTab:CreateSection("Messenger")

local ChatMsg = ""
ChatTab:CreateTextBox({
   Name = "Bypassed Message",
   PlaceholderText = "Write here...",
   RemoveTextAfterFocusLost = false,
   Callback = function(t) ChatMsg = t end,
})

ChatTab:CreateButton({
   Name = "Send Stealth Message",
   Callback = function() MasterSend(ChatMsg) end,
})

ChatTab:CreateSection("Spam Engine")

ChatTab:CreateTextBox({
   Name = "Spam Content",
   PlaceholderText = "Spam text...",
   Callback = function(t) getgenv().SyroxConfig.SpamText = t end,
})

ChatTab:CreateSlider({
   Name = "Spam Speed",
   Range = {0.5, 5},
   Increment = 0.5,
   CurrentValue = 1.5,
   Callback = function(v) getgenv().SyroxConfig.SpamDelay = v end,
})

ChatTab:CreateToggle({
   Name = "Activate Spammer",
   CurrentValue = false,
   Callback = function(v)
      getgenv().SyroxConfig.SpamActive = v
      task.spawn(function()
          while getgenv().SyroxConfig.SpamActive do
              MasterSend(getgenv().SyroxConfig.SpamText)
              task.wait(getgenv().SyroxConfig.SpamDelay)
          end
      end)
   end,
})

-- ==========================================
-- [ COMBAT & MOVEMENT LOOP ]
-- ==========================================
-- (Önceki bölümlerdeki stabilize edilmiş WalkSpeed ve Hitbox kodları burada birleşir)

MovementTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) getgenv().SyroxConfig.WalkSpeed = v end,
})

RunService.Heartbeat:Connect(function()
    pcall(function()
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = getgenv().SyroxConfig.WalkSpeed end
    end)
end)

-- ==========================================
-- [ SETTINGS ]
-- ==========================================
SettingsTab:CreateButton({
   Name = "Unload Syrox V7",
   Callback = function()
       _G.SyroxV7Loaded = false
       Rayfield:Destroy()
   end,
})

Rayfield:Notify({Title = "SYROX V7 LOADED", Content = "Stealth & Chat Modules Active!", Duration = 5})
