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

-- Параграф с информацией
local InfoParagraph = TabInf:CreateParagraph({
    Title = "Информация",
    Content = "Сделано разработчиком namesick\nВерсия alfa-001-upd006",
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
-- СЕКЦИЯ: ESP (ИСПРАВЛЕННАЯ ВЕРСИЯ)
-- ============================================
local espEnabled = false
local espConnections = {}
local espObjects = {}

-- Настройки ESP по умолчанию
local espSettings = {
    showName = true,
    showBox = true,
    showLine = true,
    color = Color3.fromRGB(255, 0, 0),
}

-- Создание ESP для игрока
local function createESP(targetPlayer)
    if targetPlayer == player then return end
    
    local char = targetPlayer.Character
    if not char then return end
    
    local head = char:FindFirstChild("Head")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local attachPart = head or rootPart
    if not attachPart then return end
    
    local espData = {}
    
    -- BillboardGui для ника
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 30)
    billboard.Adornee = attachPart
    billboard.StudsOffset = Vector3.new(0, (head and 2.5 or 0), 0)
    billboard.AlwaysOnTop = true
    billboard.ResetOnSpawn = false
    billboard.Parent = char
    billboard.Enabled = espEnabled and espSettings.showName
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = targetPlayer.Name
    nameLabel.TextColor3 = espSettings.color
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    espData.nameLabel = nameLabel
    
    -- SelectionBox для бокса (без Size)
    local box = Instance.new("SelectionBox")
    box.Color3 = espSettings.color
    box.Transparency = 0.5
    box.LineThickness = 0.1
    box.Adornee = rootPart or attachPart
    box.Parent = char
    box.Visible = espEnabled and espSettings.showBox
    espData.box = box
    
    -- Линия-трейсер
    local espGui = game.CoreGui:FindFirstChild("ESPGui")
    if not espGui then
        espGui = Instance.new("ScreenGui")
        espGui.Name = "ESPGui"
        espGui.Parent = game.CoreGui
        espGui.ResetOnSpawn = false
    end
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 2, 0, 0)
    line.BackgroundColor3 = espSettings.color
    line.BorderSizePixel = 0
    line.Parent = espGui
    line.Visible = espEnabled and espSettings.showLine
    espData.line = line
    
    espObjects[targetPlayer] = espData
    
    -- Обновление позиции линии
    local connection = runService.RenderStepped:Connect(function()
        if not espEnabled then return end
        if espSettings.showLine and espData.line and rootPart then
            local rootPos = rootPart.Position
            local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(rootPos)
            if onScreen then
                local centerX = workspace.CurrentCamera.ViewportSize.X / 2
                local centerY = workspace.CurrentCamera.ViewportSize.Y / 2
                local diffX = screenPos.X - centerX
                local diffY = screenPos.Y - centerY
                local distance = math.sqrt(diffX^2 + diffY^2)
                if distance > 0 then
                    espData.line.Size = UDim2.new(0, distance, 0, 2)
                    espData.line.Position = UDim2.new(0, centerX + diffX / 2, 0, centerY + diffY / 2)
                    espData.line.Rotation = math.deg(math.atan2(diffY, diffX))
                    espData.line.Visible = true
                else
                    espData.line.Visible = false
                end
            else
                espData.line.Visible = false
            end
        end
    end)
    
    table.insert(espConnections, connection)
    return espData
end

-- Удаление ESP для игрока
local function removeESP(targetPlayer)
    local espData = espObjects[targetPlayer]
    if espData then
        if espData.nameLabel then 
            local billboard = espData.nameLabel.Parent
            if billboard then billboard:Destroy() end
        end
        if espData.box then espData.box:Destroy() end
        if espData.line then espData.line:Destroy() end
        espObjects[targetPlayer] = nil
    end
end

-- Очистка всех ESP
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

-- Включение/выключение ESP
local function toggleESP(state)
    espEnabled = state
    if state then
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= player then
                createESP(targetPlayer)
            end
        end
    else
        clearAllESP()
    end
end

-- Обновление цвета всех ESP
local function updateESPColor(color)
    espSettings.color = color
    for _, espData in pairs(espObjects) do
        if espData.nameLabel then
            espData.nameLabel.TextColor3 = color
        end
        if espData.box then
            espData.box.Color3 = color
        end
        if espData.line then
            espData.line.BackgroundColor3 = color
        end
    end
end

-- Обновление видимости элементов
local function updateESPVisibility()
    for _, espData in pairs(espObjects) do
        if espData.nameLabel then
            local billboard = espData.nameLabel.Parent
            if billboard then
                billboard.Enabled = espEnabled and espSettings.showName
            end
        end
        if espData.box then
            espData.box.Visible = espEnabled and espSettings.showBox
        end
        if espData.line then
            espData.line.Visible = espEnabled and espSettings.showLine
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
    Info = "Включает/выключает ESP\nПоказывает имена, боксы и линии всех игроков",
    Callback = function(Value)
        toggleESP(Value)
    end,
})

local ESPColorPicker = TabESP:CreateColorPicker({
    Name = "Цвет ESP",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "ESPColor",
    Info = "Выбери цвет для ника, бокса и линий",
    Callback = function(Color)
        updateESPColor(Color)
    end,
})

local NameToggle = TabESP:CreateToggle({
    Name = "Показывать имена",
    CurrentValue = true,
    Flag = "ESPNameToggle",
    Info = "Показывает имя игрока над головой",
    Callback = function(Value)
        espSettings.showName = Value
        updateESPVisibility()
    end,
})

local BoxToggle = TabESP:CreateToggle({
    Name = "Показывать бокс",
    CurrentValue = true,
    Flag = "ESPBoxToggle",
    Info = "Показывает рамку вокруг игрока",
    Callback = function(Value)
        espSettings.showBox = Value
        updateESPVisibility()
    end,
})

local LineToggle = TabESP:CreateToggle({
    Name = "Показывать линии",
    CurrentValue = true,
    Flag = "ESPLineToggle",
    Info = "Показывает линию от центра экрана до игрока (трейсер)",
    Callback = function(Value)
        espSettings.showLine = Value
        updateESPVisibility()
    end,
})

-- Обработчики появления/ухода игроков
Players.PlayerAdded:Connect(function(targetPlayer)
    if espEnabled then
        createESP(targetPlayer)
    end
end)

Players.PlayerRemoving:Connect(function(targetPlayer)
    removeESP(targetPlayer)
end)

player.CharacterAdded:Connect(function()
    if espEnabled then
        task.wait(0.5)
        clearAllESP()
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= player then
                createESP(targetPlayer)
            end
        end
    end
end)

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

-- Полёт
userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode.Name == FlyKeybind.CurrentKeybind then
        toggleFly()
        FlyToggle:Set(flying)
        print("🔑 Клавиша полета нажата, flying:", flying)
    end
end)

-- Noclip
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