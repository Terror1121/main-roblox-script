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

-- 3. Создаем вкладки
local TabInf = Window:CreateTab("Информация", "info")
local Tab = Window:CreateTab("Игрок", "user-round")
local TabESP = Window:CreateTab("ESP", "scan-eye")
local TabPr = Window:CreateTab("Прочее", "wrench")

-- ============================================
-- СЕКЦИЯ: ИНФОРМАЦИЯ
-- ============================================
local SectionInfo = TabInf:CreateSection("О чите")

local InfoParagraph = TabInf:CreateParagraph({
    Title = "Информация",
    Content = "Сделано разработчиком namesick\nВерсия alfa-001-patch003",
})

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- ============================================
-- СЕКЦИЯ: НАСТРОЙКИ СКОРОСТИ
-- ============================================
local SectionSpeed = Tab:CreateSection("Настройки скорости")

local SPEED = 50
local useKey = true
local isActive = false
local heartbeatConnection = nil

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

local SpeedToggle = Tab:CreateToggle({
    Name = "Активировать спидхак",
    CurrentValue = false,
    Flag = "SpeedHackToggle",
    Info = "Включает физический спидхак\nРаботает через Velocity, обходит серверные проверки",
    Callback = function(Value)
        toggleSpeed(Value)
    end,
})

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

local flying = false
local flySpeed = 200
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil

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

local FlyKeybind = Tab:CreateKeybind({
    Name = "Клавиша для полета",
    CurrentKeybind = "X",
    Flag = "FlyKeybind",
    Info = "Нажми на поле и нажми клавишу, чтобы назначить её",
    Callback = function(Keybind, KeybindObject)
        print("✅ Клавиша полета изменена на:", Keybind)
    end,
})

-- ============================================
-- СЕКЦИЯ: НАСТРОЙКИ NOCLIP
-- ============================================
local SectionNoclip = Tab:CreateSection("Настройки Noclip")

local noclipEnabled = false
local noclipConnection = nil

local function enableNoclip()
    if noclipEnabled then return end
    noclipEnabled = true
    print("✅ Noclip ВКЛЮЧЕН")
end

local function disableNoclip()
    if not noclipEnabled then return end
    noclipEnabled = false
    print("❌ Noclip ВЫКЛЮЧЕН")
end

local function toggleNoclip()
    if noclipEnabled then
        disableNoclip()
    else
        enableNoclip()
    end
end

runService.RenderStepped:Connect(function()
    if not noclipEnabled then return end
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

local NoclipToggle = Tab:CreateToggle({
    Name = "Активировать Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Info = "Включает режим прохода сквозь стены",
    Callback = function(Value)
        if Value then
            enableNoclip()
        else
            disableNoclip()
        end
    end,
})

local NoclipKeybind = Tab:CreateKeybind({
    Name = "Клавиша для Noclip",
    CurrentKeybind = "V",
    Flag = "NoclipKeybind",
    Info = "Нажми на поле и нажми клавишу, чтобы назначить её",
    Callback = function(Keybind, KeybindObject)
        print("✅ Клавиша Noclip изменена на:", Keybind)
    end,
})

-- ============================================
-- СЕКЦИЯ: БЕСКОНЕЧНЫЙ ПРЫЖОК
-- ============================================
local SectionJump = Tab:CreateSection("Бесконечный прыжок")

local jumpEnabled = false
local jumpConnection = nil

local function enableJump()
    if jumpEnabled then return end
    jumpEnabled = true
    
    jumpConnection = runService.RenderStepped:Connect(function()
        if not jumpEnabled then return end
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        if userInput:IsKeyDown(Enum.KeyCode.Space) then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
    
    print("✅ Бесконечный прыжок ВКЛЮЧЕН")
end

local function disableJump()
    if not jumpEnabled then return end
    jumpEnabled = false
    
    if jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
    
    print("❌ Бесконечный прыжок ВЫКЛЮЧЕН")
end

local JumpToggle = Tab:CreateToggle({
    Name = "Активировать бесконечный прыжок",
    CurrentValue = false,
    Flag = "JumpToggle",
    Info = "Позволяет прыгать бесконечно\n(зажми пробел)",
    Callback = function(Value)
        if Value then
            enableJump()
        else
            disableJump()
        end
    end,
})

-- ============================================
-- СЕКЦИЯ: ESP (РАБОЧАЯ ВЕРСИЯ)
-- ============================================
local espEnabled = false
local espConnections = {}
local espObjects = {}

local espSettings = {
    showName = true,
    showBox = true,
    showHealth = true,
    nameColor = Color3.fromRGB(255, 255, 255),
    boxColor = Color3.fromRGB(0, 255, 255),
    healthColor = Color3.fromRGB(0, 255, 0),
    nameSize = 20,
    healthSize = 3,
}

local function removeESP(targetPlayer)
    local espData = espObjects[targetPlayer]
    if espData then
        if espData.nameBillboard then espData.nameBillboard:Destroy() end
        if espData.boxBillboard then espData.boxBillboard:Destroy() end
        if espData.healthBillboard then espData.healthBillboard:Destroy() end
        espObjects[targetPlayer] = nil
    end
end

local function clearAllESP()
    for _, connection in ipairs(espConnections) do
        connection:Disconnect()
    end
    espConnections = {}
    for targetPlayer, _ in pairs(espObjects) do
        removeESP(targetPlayer)
    end
    espObjects = {}
end

local function createESP(targetPlayer)
    if targetPlayer == player then return end
    
    local char = targetPlayer.Character
    if not char then return end
    
    local head = char:FindFirstChild("Head")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local espData = {}
    
    -- ИМЯ
    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Size = UDim2.new(0, 200, 0, 30)
    nameBillboard.Adornee = head or rootPart
    nameBillboard.StudsOffset = Vector3.new(0, (head and 3.5 or 1.5), 0)
    nameBillboard.AlwaysOnTop = true
    nameBillboard.ResetOnSpawn = false
    nameBillboard.Parent = char
    nameBillboard.Enabled = espEnabled and espSettings.showName
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = targetPlayer.Name
    nameLabel.TextColor3 = espSettings.nameColor
    nameLabel.TextSize = espSettings.nameSize
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = nameBillboard
    espData.nameLabel = nameLabel
    espData.nameBillboard = nameBillboard
    
    -- БОКС (2D рамка)
    local boxBillboard = Instance.new("BillboardGui")
    boxBillboard.Size = UDim2.new(0, 3, 0, 5)
    boxBillboard.Adornee = rootPart
    boxBillboard.StudsOffset = Vector3.new(0, 0, 0)
    boxBillboard.AlwaysOnTop = true
    boxBillboard.ResetOnSpawn = false
    boxBillboard.Parent = char
    boxBillboard.Enabled = espEnabled and espSettings.showBox
    
    local boxFrame = Instance.new("Frame")
    boxFrame.Size = UDim2.new(1, 0, 1, 0)
    boxFrame.BackgroundTransparency = 1
    boxFrame.BorderSizePixel = 2
    boxFrame.BorderColor3 = espSettings.boxColor
    boxFrame.Parent = boxBillboard
    espData.boxFrame = boxFrame
    espData.boxBillboard = boxBillboard
    
    -- ЗДОРОВЬЕ
    local healthBillboard = Instance.new("BillboardGui")
    healthBillboard.Size = UDim2.new(0, 3, 0, 0.3)
    healthBillboard.Adornee = head or rootPart
    healthBillboard.StudsOffset = Vector3.new(0, (head and 2.5 or 0.5), 0)
    healthBillboard.AlwaysOnTop = true
    healthBillboard.ResetOnSpawn = false
    healthBillboard.Parent = char
    healthBillboard.Enabled = espEnabled and espSettings.showHealth
    
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(1, 0, 1, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthBg.BackgroundTransparency = 0.4
    healthBg.BorderSizePixel = 0
    healthBg.Parent = healthBillboard
    
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = espSettings.healthColor
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBg
    espData.healthBar = healthBar
    espData.healthBg = healthBg
    espData.healthBillboard = healthBillboard
    
    espObjects[targetPlayer] = espData
    
    -- ОБНОВЛЕНИЕ ЗДОРОВЬЯ
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local healthConnection = runService.RenderStepped:Connect(function()
            if not espEnabled or not espSettings.showHealth then
                if healthBillboard then healthBillboard.Enabled = false end
                return
            end
            if healthBillboard then healthBillboard.Enabled = true end
            if humanoid and healthBar then
                local health = humanoid.Health
                local maxHealth = humanoid.MaxHealth
                local percent = math.clamp(health / maxHealth, 0, 1)
                healthBar.Size = UDim2.new(percent, 0, 1, 0)
                healthBar.BackgroundColor3 = espSettings.healthColor
                healthBillboard.Size = UDim2.new(0, espSettings.healthSize * 3, 0, espSettings.healthSize * 0.3)
            end
        end)
        table.insert(espConnections, healthConnection)
    end
    
    return espData
end

local function refreshAllESP()
    clearAllESP()
    if espEnabled then
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= player then
                createESP(targetPlayer)
            end
        end
    end
end

local function toggleESP(state)
    espEnabled = state
    if state then
        refreshAllESP()
    else
        clearAllESP()
    end
end

local function updateESPSettings()
    for _, espData in pairs(espObjects) do
        if espData.nameLabel then
            espData.nameLabel.TextColor3 = espSettings.nameColor
            espData.nameLabel.TextSize = espSettings.nameSize
            if espData.nameBillboard then
                espData.nameBillboard.Enabled = espEnabled and espSettings.showName
            end
        end
        if espData.boxFrame then
            espData.boxFrame.BorderColor3 = espSettings.boxColor
            if espData.boxBillboard then
                espData.boxBillboard.Enabled = espEnabled and espSettings.showBox
            end
        end
        if espData.healthBar then
            espData.healthBar.BackgroundColor3 = espSettings.healthColor
            if espData.healthBillboard then
                espData.healthBillboard.Enabled = espEnabled and espSettings.showHealth
                espData.healthBillboard.Size = UDim2.new(0, espSettings.healthSize * 3, 0, espSettings.healthSize * 0.3)
            end
        end
    end
end

-- ============================================
-- ИНТЕРФЕЙС ESP В МЕНЮ
-- ============================================

local SectionESP = TabESP:CreateSection("Настройки ESP")

local ESPToggle = TabESP:CreateToggle({
    Name = "Включить ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Info = "Включает/выключает ESP\nПоказывает имена, боксы и здоровье всех игроков",
    Callback = function(Value)
        toggleESP(Value)
    end,
})

local NameColorPicker = TabESP:CreateColorPicker({
    Name = "Цвет ника",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ESPNameColor",
    Info = "Выбери цвет для имени игрока",
    Callback = function(Color)
        espSettings.nameColor = Color
        updateESPSettings()
    end,
})

local BoxColorPicker = TabESP:CreateColorPicker({
    Name = "Цвет бокса",
    Color = Color3.fromRGB(0, 255, 255),
    Flag = "ESPBoxColor",
    Info = "Выбери цвет для рамки вокруг игрока",
    Callback = function(Color)
        espSettings.boxColor = Color
        updateESPSettings()
    end,
})

local HealthColorPicker = TabESP:CreateColorPicker({
    Name = "Цвет здоровья",
    Color = Color3.fromRGB(0, 255, 0),
    Flag = "ESPHealthColor",
    Info = "Выбери цвет для полоски здоровья",
    Callback = function(Color)
        espSettings.healthColor = Color
        updateESPSettings()
    end,
})

local NameToggle = TabESP:CreateToggle({
    Name = "Показывать имена",
    CurrentValue = true,
    Flag = "ESPNameToggle",
    Info = "Показывает имя игрока над головой",
    Callback = function(Value)
        espSettings.showName = Value
        updateESPSettings()
    end,
})

local BoxToggle = TabESP:CreateToggle({
    Name = "Показывать бокс",
    CurrentValue = true,
    Flag = "ESPBoxToggle",
    Info = "Показывает рамку вокруг игрока",
    Callback = function(Value)
        espSettings.showBox = Value
        updateESPSettings()
    end,
})

local HealthToggle = TabESP:CreateToggle({
    Name = "Показывать здоровье",
    CurrentValue = true,
    Flag = "ESPHealthToggle",
    Info = "Показывает полоску здоровья над игроком",
    Callback = function(Value)
        espSettings.showHealth = Value
        updateESPSettings()
    end,
})

local NameSizeSlider = TabESP:CreateSlider({
    Name = "Размер ника",
    Range = {10, 40},
    Increment = 1,
    Suffix = "",
    CurrentValue = 20,
    Flag = "ESPNameSize",
    Info = "Регулирует размер имени",
    Callback = function(Value)
        espSettings.nameSize = Value
        updateESPSettings()
    end,
})

local HealthSizeSlider = TabESP:CreateSlider({
    Name = "Размер здоровья",
    Range = {1, 5},
    Increment = 0.5,
    Suffix = "",
    CurrentValue = 3,
    Flag = "ESPHealthSize",
    Info = "Регулирует размер полоски здоровья",
    Callback = function(Value)
        espSettings.healthSize = Value
        updateESPSettings()
    end,
})

Players.PlayerAdded:Connect(function(targetPlayer)
    if espEnabled then
        createESP(targetPlayer)
    end
end)

Players.PlayerRemoving:Connect(function(targetPlayer)
    removeESP(targetPlayer)
end)

local function onCharacterAdded()
    if espEnabled then
        task.wait(0.3)
        refreshAllESP()
    end
end

player.CharacterAdded:Connect(onCharacterAdded)

for _, targetPlayer in ipairs(Players:GetPlayers()) do
    targetPlayer.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(0.3)
            removeESP(targetPlayer)
            createESP(targetPlayer)
        end
    end)
end

-- ============================================
-- ТЕСТОВАЯ КНОПКА
-- ============================================
local TButton = TabPr:CreateButton({
    Name = "Тестовая кнопка",
    Callback = function()
        print("РАБОТАЕТ!!!!!!!!!!!!!!")
    end,
})

local DestroyButton = TabPr:CreateButton({
    Name = "Уничтожить меню",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- ============================================
-- ОБРАБОТЧИКИ КЛАВИШ
-- ============================================

userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode.Name == FlyKeybind.CurrentKeybind then
        toggleFly()
        FlyToggle:Set(flying)
        print("🔑 Клавиша полета нажата, flying:", flying)
    end
end)

userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode.Name == NoclipKeybind.CurrentKeybind then
        toggleNoclip()
        NoclipToggle:Set(noclipEnabled)
        print("🔑 Клавиша Noclip нажата, noclipEnabled:", noclipEnabled)
    end
end)

-- ============================================
-- ВОССТАНОВЛЕНИЕ ПРИ РЕСПАВНЕ
-- ============================================
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flying then
        enableFly()
        FlyToggle:Set(true)
    end
    if noclipEnabled then
        disableNoclip()
        task.wait(0.1)
        enableNoclip()
        NoclipToggle:Set(true)
    end
    if jumpEnabled then
        disableJump()
        task.wait(0.1)
        enableJump()
        JumpToggle:Set(true)
    end
end)

-- ============================================
-- ВЫВОД В КОНСОЛЬ
-- ============================================
print("✅ Меню загружено! Нажми G для открытия.")
print("⚙️ Настрой скорость через ползунок, включи спидхак переключателем.")
print("🪁 Полет: включи через переключатель или нажми " .. FlyKeybind.CurrentKeybind)
print("🧱 Noclip: включи через переключатель или нажми " .. NoclipKeybind.CurrentKeybind)
print("🦘 Бесконечный прыжок: включи через переключатель")
print("👁️ ESP: включи через переключатель во вкладке ESP")