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
    local humanoid = character:WaitForChild("Humanoid")

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
        CurrentStep = 1,
        Cooldowns = {
            Skill1 = 0,
            Skill2 = 0,
            Skill3 = 0,
            Ultimate = 0
        }
    }

    -- Função para verificar cooldowns
    local function checkCooldowns()
        local now = tick()
        for skill, cooldownEnd in pairs(Combo.Cooldowns) do
            if now < cooldownEnd then
                return false
            end
        end
        return true
    end

    -- Função principal do combo
    local function executeVideoCombo()
        if not Combo.Active or not checkCooldowns() then return end
        
        local now = tick()
        if now - Combo.LastUsed < 0.15 then return end
        
        local currentKey = VIDEO_COMBO[Combo.CurrentStep]
        
        -- Humanizer
        if Settings.Humanizer.Enabled then
            task.wait(math.random(Settings.Humanizer.MinDelay, Settings.Humanizer.MaxDelay))
        end
        
        -- Executa o input
        if currentKey == "z" then
            keypress(0x5A) -- Tecla Z
        else
            local keyCode = tonumber(currentKey) + 0x30 -- Converte para código de tecla
            keypress(keyCode)
        end
        task.wait(0.05)
        
        if currentKey == "z" then
            keyrelease(0x5A)
        else
            local keyCode = tonumber(currentKey) + 0x30
            keyrelease(keyCode)
        end
        
        -- Atualiza cooldowns
        if currentKey == GAROU.Skill1.key then
            Combo.Cooldowns.Skill1 = now + GAROU.Skill1.cooldown
        elseif currentKey == GAROU.Skill2.key then
            Combo.Cooldowns.Skill2 = now + GAROU.Skill2.cooldown
        elseif currentKey == GAROU.Skill3.key then
            Combo.Cooldowns.Skill3 = now + GAROU.Skill3.cooldown
        end
        
        -- Avança para o próximo passo do combo
        Combo.CurrentStep = Combo.CurrentStep + 1
        if Combo.CurrentStep > #VIDEO_COMBO then
            Combo.CurrentStep = 1
        end
        
        Combo.LastUsed = now
    end

    -- Criação da GUI
    local function createGUI()
        local success, Library = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-backups/main/uwuware"))()
        end)
        
        if not success then
            warn("Falha ao carregar a biblioteca de UI")
            return nil
        end
        
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
        
        settingsTab:AddSlider("Max Delay", 100, 500, 200, function(value)
            Settings.Humanizer.MaxDelay = value/1000
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
    while task.wait(0.1) do
        if Combo.Active and character and humanoid and humanoid.Health > 0 then
            pcall(executeVideoCombo)
        end
    end
end
