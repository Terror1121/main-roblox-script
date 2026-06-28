-- 1. Загружаем библиотеку
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. Создаем главное окно
local Window = Rayfield:CreateWindow({
    Name = "Main Script",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by namesick",
    ScriptID = "sid_eo08v93jcdta",
    ToggleUIKeybind = Enum.KeyCode.G,
})

-- 3. Создаем вкладку
local Tab = Window:CreateTab("Основное", "user-round")

-- 4. Создаем секцию
local Section = Tab:CreateSection("Настройки скорости")

-- ============================================
-- ПЕРЕМЕННЫЕ ДЛЯ СПИДХАКА
-- ============================================
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

local SPEED = 50  -- Значение по умолчанию
local useKey = true -- true = на Shift, false = всегда
local isActive = false
local heartbeatConnection = nil

-- ============================================
-- ЛОГИКА СПИДХАКА (использует SPEED из переменной)
-- ============================================
local function applyPhysicsSpeed(char)
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local moveDirection = humanoid.MoveDirection
    if moveDirection.Magnitude < 0.1 then 
        return 
    end
    
    local currentVel = root.Velocity
    local forwardVel = currentVel.Magnitude
    
    if forwardVel < SPEED then  -- Используем SPEED из переменной
        local newVel = moveDirection * SPEED
        newVel = Vector3.new(newVel.X, currentVel.Y, newVel.Z)
        root.Velocity = newVel
    end
end

-- Функция включения/выключения
local function toggleSpeed(state)
    if state then
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end
        
        heartbeatConnection = runService.Heartbeat:Connect(function()
            local char = player.Character
            if not char then return end
            
            if useKey then
                if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
                    applyPhysicsSpeed(char)
                    isActive = true
                else
                    if isActive then
                        isActive = false
                    end
                end
            else
                applyPhysicsSpeed(char)
            end
        end)
        print("✅ Спидхак ВКЛЮЧЕН, скорость:", SPEED)
    else
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end
        print("❌ Спидхак ВЫКЛЮЧЕН")
        
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end

-- ============================================
-- ПОЛЗУНОК ДЛЯ РЕГУЛИРОВКИ СКОРОСТИ
-- ============================================
local SpeedSlider = Tab:CreateSlider({
    Name = "Скорость бега",
    Range = {16, 500},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "SpeedValue",
    Info = "Установи скорость бега от 16 до 200\n\nДля активации включи переключатель ниже",
    Callback = function(Value)
        SPEED = Value  -- Обновляем глобальную переменную скорости
        print("Скорость изменена на:", SPEED)
    end,
})

-- ============================================
-- ПЕРЕКЛЮЧАТЕЛЬ ДЛЯ АКТИВАЦИИ СПИДХАКА
-- ============================================
local SpeedToggle = Tab:CreateToggle({
    Name = "Активировать спидхак",
    CurrentValue = false,
    Flag = "SpeedHackToggle",
    Info = "Включает/выключает физический спидхак\n\n🚀 Особенности:\n• Работает через физику, обходит серверные проверки\n• Можно регулировать скорость через ползунок выше\n• Скорость применяется при зажатом Shift (если включен режим Shift)",
    Callback = function(Value)
        toggleSpeed(Value)
    end,
})

-- ============================================
-- ДОПОЛНИТЕЛЬНО: ВЫБОР РЕЖИМА (Shift или всегда)
-- ============================================
local ModeToggle = Tab:CreateToggle({
    Name = "Режим 'Всегда' (отключи, чтобы работало только на Shift)",
    CurrentValue = false,
    Flag = "AlwaysModeSpeedHack",
    Info = "Вкл: скорость работает всегда\nВыкл: скорость работает только при зажатом Shift",
    Callback = function(Value)
        useKey = not Value  -- Если включено, useKey = false (работает всегда)
        print("Режим изменен:", Value and "Всегда" or "Только Shift")
    end,
})

local TButton = Tab:CreateButton({
    Name = "Тест кнопка",
    Callback = function ()
        print("РАБОТАЕТ!!!!!!!!!!!!!!") 
    end,
})

-- йооу

print("✅ Меню загружено! Нажми G для открытия.")
print("⚙️ Настрой скорость через ползунок, включи спидхак переключателем.")
