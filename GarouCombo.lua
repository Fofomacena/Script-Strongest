-- GarouComboHub.lua
return function()
    --[[
    🐺 GAROU COMBO HUB - STRONGEST BATTLEGROUNDS
    🔥 Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/SEUUSER/SEUREPO/main/GarouComboHub.lua", true))()
    ]]

    -- Serviços
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    -- Mecânicas do Garou
    local GAROU = {
        BasicAttack = {key = "z", cooldown = 0.4},
        Skill1 = {key = "1", name = "God Slayer Fist", cooldown = 8},
        Skill2 = {key = "2", name = "Monster Calamity Slash", cooldown = 10},
        Skill3 = {key = "3", name = "Wolf Fang Fist", cooldown = 12},
        Ultimate = {key = "4", name = "Awakened Power", cooldown = 30}
    }

    -- Combo do vídeo (1 → ZZZ → 2 → 3)
    local VIDEO_COMBO = {
        GAROU.Skill1.key,
        GAROU.BasicAttack.key,
        GAROU.BasicAttack.key,
        GAROU.BasicAttack.key,
        GAROU.Skill2.key,
        GAROU.Skill3.key
    }

    -- Configurações
    local Settings = {
        AutoCombo = true,
        Humanizer = {
            Enabled = true,
            MinDelay = 0.1,
            MaxDelay = 0.2
        },
        Keybinds = {
            ToggleCombo = "F",
            ToggleGUI = "RightShift"
        }
    }

    -- Estado do combo
    local Combo = {
        Active = false,
        LastUsed = 0,
        CurrentStep = 1
    }

    -- Função principal do combo
    local function executeVideoCombo()
        if not Combo.Active then return end
        
        local now = tick()
        if now - Combo.LastUsed < 0.15 then return end
        
        local currentKey = VIDEO_COMBO[Combo.CurrentStep]
        
        -- Humanizer
        if Settings.Humanizer.Enabled then
            wait(math.random(Settings.Humanizer.MinDelay, Settings.Humanizer.MaxDelay))
        end
        
        -- Executa o input
        keypress(currentKey:byte())
        wait(0.05)
        keyrelease(currentKey:byte())
        
        Combo.CurrentStep = Combo.CurrentStep + 1
        if Combo.CurrentStep > #VIDEO_COMBO then
            Combo.CurrentStep = 1
        end
        
        Combo.LastUsed = now
    end

    -- Criação da GUI
    local function createGUI()
        local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-backups/main/uwuware"))()
        local window = Library:CreateWindow("GAROU COMBO HUB")
        
        local mainTab = window:AddTab("Main")
        local settingsTab = window:AddTab("Settings")
        
        mainTab:AddToggle("Auto Combo", Settings.AutoCombo, function(value)
            Combo.Active = value
        end)
        
        settingsTab:AddToggle("Humanizer", Settings.Humanizer.Enabled, function(value)
            Settings.Humanizer.Enabled = value
        end)
        
        settingsTab:AddSlider("Min Delay", 0, 200, 100, function(value)
            Settings.Humanizer.MinDelay = value/1000
        end)
        
        Library:Init()
        return Library
    end

    -- Keybinds
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode[Settings.Keybinds.ToggleCombo] then
            Combo.Active = not Combo.Active
        end
    end)

    -- Inicialização
    local Library = createGUI()
    
    -- Loop principal
    while true do
        if Combo.Active and character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            pcall(executeVideoCombo)
        end
        task.wait()
    end
end
