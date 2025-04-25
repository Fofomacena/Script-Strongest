-- GarouComboHub.lua
return function()
    --[[
    🐺 GAROU COMBO HUB - STRONGEST BATTLEGROUNDS
    🔥 Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/Fofomacena/Script-Strongest/main/GarouComboHub.lua", true))()
    ]]

    -- Serviços
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    -- Configurações do Combo
    local Settings = {
        ComboSequence = {"1", "z", "z", "z", "2", "3"}, -- 1 → ZZZ → 2 → 3
        ComboDelay = 0.2,
        ToggleKey = "f",
        Humanizer = {
            Enabled = true,
            MinDelay = 0.1,
            MaxDelay = 0.3
        },
        Notifications = true
    }

    -- Estado do Combo
    local Combo = {
        Active = false,
        CurrentStep = 1,
        LastExecuted = 0
    }

    -- Mapeamento de Teclas
    local KeyCodes = {
        ["1"] = 0x31,
        ["2"] = 0x32,
        ["3"] = 0x33,
        ["4"] = 0x34,
        ["z"] = 0x5A
    }

    -- Função para Executar Inputs
    local function executeInput(key)
        local keyCode = KeyCodes[key]
        if keyCode then
            keypress(keyCode)
            task.wait(0.05)
            keyrelease(keyCode)
            return true
        end
        return false
    end

    -- Função Principal do Combo
    local function executeCombo()
        if not Combo.Active or not character or humanoid.Health <= 0 then return end

        local now = tick()
        if now - Combo.LastExecuted < Settings.ComboDelay then return end

        -- Humanizer
        if Settings.Humanizer.Enabled then
            task.wait(math.random(Settings.Humanizer.MinDelay, Settings.Humanizer.MaxDelay))
        end

        -- Executa o passo atual do combo
        local currentKey = Settings.ComboSequence[Combo.CurrentStep]
        if executeInput(currentKey) then
            Combo.CurrentStep = Combo.CurrentStep + 1
            if Combo.CurrentStep > #Settings.ComboSequence then
                Combo.CurrentStep = 1
            end
            Combo.LastExecuted = now
        end
    end

    -- Keybind para Ativar/Desativar
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode[Settings.ToggleKey:upper()] then
            Combo.Active = not Combo.Active
            if Settings.Notifications then
                print("[GAROU COMBO] " .. (Combo.Active and "ATIVADO" or "DESATIVADO"))
            end
        end
    end)

    -- Loop Principal
    RunService.Heartbeat:Connect(function()
        pcall(executeCombo)
    end)

    -- Notificação Inicial
    if Settings.Notifications then
        print("[GAROU COMBO HUB] Carregado com sucesso! Pressione " .. Settings.ToggleKey:upper() .. " para ativar")
    end
end
