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

-- 3. Создаем вкладку "Основное"
local Tab = Window:CreateTab("Основное", "user-round")

-- ============================================
-- СЕКЦИЯ: НАСТРОЙКИ СКОРОСТИ
-- ============================================
local SectionSpeed = Tab:CreateSection("Настройки скорости")

-- ПЕРЕМЕННЫЕ ДЛЯ СПИДХАКА
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

local SPEED = 50
local useKey = true
local isActive = false
local heartbeatConnection = nil

-- ЛОГИКА СПИДХАКА
local function applyPhysicsSpeed(char)
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local moveDirection = humanoid.MoveDirection
    if moveDirection.Magnitude < 0.1 then return end
    local currentVel = root.Velocity
    if currentVel.Magnitude < SPEED then
        local newVel = moveDirection * SPEED
        newVel = Vector3.new(newVel.X, currentVel.Y, newVel.Z)
        root.Velocity = newVel
    end
end

local function toggleSpeed(state)
    if state then
        if heartbeatConnection then heartbeatConnection:Disconnect() end
        heartbeatConnection = runService.Heartbeat:Connect(function()
            local char = player.Character
            if not char then return end
            if useKey then
                if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
                    applyPhysicsSpeed(char)
                    isActive = true
                else
                    isActive = false
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
            if humanoid then humanoid.WalkSpeed = 16 end
        end
    end
end

-- ПОЛЗУНОК СКОРОСТИ
local SpeedSlider = Tab:CreateSlider({
    Name = "Скорость бега",
    Range = {16, 500},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "SpeedValue",
    Info = "Установи скорость бега от 16 до 500",
    Callback = function(Value)
        SPEED = Value
        print("Скорость изменена на:", SPEED)
    end,
})

-- ПЕРЕКЛЮЧАТЕЛЬ СПИДХАКА
local SpeedToggle = Tab:CreateToggle({
    Name = "Активировать спидхак",
    CurrentValue = false,
    Flag = "SpeedHackToggle",
    Info = "Включает физический спидхак\nРаботает через Velocity, обходит серверные проверки",
    Callback = function(Value)
        toggleSpeed(Value)
    end,
})

-- РЕЖИМ "ВСЕГДА"
local ModeToggle = Tab:CreateToggle({
    Name = "Режим 'Всегда' (отключи для Shift)",
    CurrentValue = false,
    Flag = "AlwaysModeSpeedHack",
    Info = "Вкл: скорость всегда\nВыкл: только при Shift",
    Callback = function(Value)
        useKey = not Value
        print("Режим изменен:", Value and "Всегда" or "Только Shift")
    end,
})

-- ============================================
-- СЕКЦИЯ: НАСТРОЙКИ ПОЛЁТА
-- ============================================
local SectionFly = Tab:CreateSection("Настройки полёта")

-- ПЕРЕМЕННЫЕ ДЛЯ ПОЛЁТА
local flying = false
local flySpeed = 200
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil
local flyKeybind = Enum.KeyCode.X  -- Клавиша по умолчанию

-- ФУНКЦИИ ПОЛЁТА
local function enableFly()
    if flying then return end
    flying = true
    
    local char = player.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid then return end
    
    humanoid.PlatformStand = true
    humanoid.UseJumpPower = false
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    flyConnection = runService.RenderStepped:Connect(function()
        if not flying or not rootPart or not bodyVelocity then return end
        
        local camera = workspace.CurrentCamera
        if not camera then return end
        
        local moveDirection = Vector3.new(0, 0, 0)
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        local up = camera.CFrame.UpVector
        
        if userInput:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + forward end
        if userInput:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - forward end
        if userInput:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - right end
        if userInput:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + right end
        if userInput:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + up end
        if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - up end
        
        local currentSpeed = flySpeed
        if userInput:IsKeyDown(Enum.KeyCode.E) then currentSpeed = flySpeed * 2 end
        if userInput:IsKeyDown(Enum.KeyCode.Q) then currentSpeed = flySpeed * 0.3 end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * currentSpeed
        end
        bodyVelocity.Velocity = moveDirection
        bodyGyro.CFrame = camera.CFrame
    end)
    
    print("✅ Полет ВКЛЮЧЕН")
end

local function disableFly()
    if not flying then return end
    flying = false
    
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid.UseJumpPower = true
        end
    end
    
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    
    print("❌ Полет ВЫКЛЮЧЕН")
end

local function toggleFly()
    if flying then
        disableFly()
    else
        enableFly()
    end
end

-- ПЕРЕКЛЮЧАТЕЛЬ ПОЛЁТА
local FlyToggle = Tab:CreateToggle({
    Name = "Активировать полет",
    CurrentValue = false,
    Flag = "FlyToggle",
    Info = "Включает режим полёта\nУправление: WASD - движение, Пробел - вверх, Shift - вниз\nE - ускорение, Q - замедление",
    Callback = function(Value)
        if Value then
            enableFly()
        else
            disableFly()
        end
    end,
})

-- ПОЛЗУНОК СКОРОСТИ ПОЛЁТА
local FlySpeedSlider = Tab:CreateSlider({
    Name = "Скорость полета",
    Range = {50, 500},
    Increment = 10,
    Suffix = "",
    CurrentValue = 200,
    Flag = "FlySpeedSlider",
    Info = "Установи скорость полёта от 50 до 500",
    Callback = function(Value)
        flySpeed = Value
        print("Скорость полета изменена на:", flySpeed)
    end,
})

-- НАЗНАЧЕНИЕ КЛАВИШИ ДЛЯ ПОЛЁТА (КЕЙБИНД)
local FlyKeybind = Tab:CreateKeybind({
    Name = "Клавиша для полета",
    CurrentKeybind = "X",
    Flag = "FlyKeybind",
    Info = "Нажми на поле и нажми клавишу, чтобы назначить её для включения/выключения полёта",
    Callback = function(Key)
        flyKeybind = Key
        print("Клавиша полета изменена на:", Key.Name)
    end,
})

-- ============================================
-- ТЕСТОВАЯ КНОПКА
-- ============================================
local TButton = Tab:CreateButton({
    Name = "Тест кнопка",
    Callback = function()
        print("РАБОТАЕТ!!!!!!!!!!!!!!")
    end,
})

-- ============================================
-- ОБРАБОТЧИК КЛАВИШИ ДЛЯ ПОЛЁТА (работает с биндом)
-- ============================================
userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == flyKeybind then
        toggleFly()
        -- Синхронизируем Toggle с состоянием полёта
        FlyToggle:Set(flying)
    end
end)

-- ============================================
-- ВОССТАНОВЛЕНИЕ ПРИ РЕСПАВНЕ
-- ============================================
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flying then
        enableFly()
    end
end)

-- ============================================
-- ВЫВОД В КОНСОЛЬ
-- ============================================
print("✅ Меню загружено! Нажми G для открытия.")
print("⚙️ Настрой скорость через ползунок, включи спидхак переключателем.")
print("🪁 Полет: включи через переключатель или нажми " .. flyKeybind.Name)