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
local TabVisuals = Window:CreateTab("Визуал", "scan-eye")
local TabPr = Window:CreateTab("Прочее", "wrench")

-- ============================================
-- СЕКЦИЯ: ИНФОРМАЦИЯ
-- ============================================
local SectionInfo = TabInf:CreateSection("О чите")

local InfoParagraph = TabInf:CreateParagraph({
    Title = "Информация",
    Content = "Сделано разработчиком namesick\nВерсия alfa-001-patch-049",
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
-- СЕКЦИЯ: ВИЗУАЛ
-- ============================================
local espEnabled = false
local espConnections = {}
local espObjects = {}
local espGui = nil

local espSettings = {
    showName = false,
    showSkeleton = false,
    showHealth = false,
    showChams = false,
    showTracers = false,
    nameColor = Color3.fromRGB(255, 255, 255),
    skeletonColor = Color3.fromRGB(0, 255, 255),
    healthColor = Color3.fromRGB(0, 255, 0),
    chamsColor = Color3.fromRGB(255, 0, 0),
    tracerColor = Color3.fromRGB(0, 255, 0),
    nameSize = 14,
    chamsTransparency = 0.3,
    tracerThickness = 1,
}

-- Только основные части тела для Chams (минимум, чтобы не было белых блоков)
local CHAMS_PARTS = {
    "Head",
    "UpperTorso", 
    "LowerTorso",
    "HumanoidRootPart"
}

-- Храним оригинальные свойства частей для Chams
local originalProperties = {}
-- Храним подключения для мониторинга персонажей
local charConnections = {}

-- ============================================
-- CHAMS ФУНКЦИИ (исправленные - только torso и голова)
-- ============================================

local function saveOriginalProperties(part)
    if not originalProperties[part] then
        originalProperties[part] = {
            Material = part.Material,
            Color = part.Color,
            Transparency = part.Transparency,
        }
    end
end

local function applyChamsToPart(part, state)
    if not part or not part:IsA("BasePart") then return end
    
    -- Проверяем, является ли часть основной частью тела
    local isBodyPart = false
    for _, name in ipairs(CHAMS_PARTS) do
        if part.Name == name then
            isBodyPart = true
            break
        end
    end
    
    if not isBodyPart then return end
    
    if state then
        saveOriginalProperties(part)
        part.Material = Enum.Material.Neon
        part.Color = espSettings.chamsColor
        part.Transparency = espSettings.chamsTransparency
    else
        if originalProperties[part] then
            part.Material = originalProperties[part].Material
            part.Color = originalProperties[part].Color
            part.Transparency = originalProperties[part].Transparency
            originalProperties[part] = nil
        end
    end
end

local function applyChamsToCharacter(char, state)
    if not char then return end
    
    -- Применяем только к основным частям тела
    for _, partName in ipairs(CHAMS_PARTS) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            applyChamsToPart(part, state)
        end
    end
end

local function updateAllChams()
    if espEnabled and espSettings.showChams then
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= player then
                local char = targetPlayer.Character
                if char then
                    applyChamsToCharacter(char, true)
                end
            end
        end
    end
end

local function clearAllChams()
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            local char = targetPlayer.Character
            if char then
                applyChamsToCharacter(char, false)
            end
        end
    end
    originalProperties = {}
end

-- ============================================
-- TRACERS ФУНКЦИИ
-- ============================================

local tracerObjects = {}
local tracerConnection = nil

local function createTracers()
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and not tracerObjects[targetPlayer] then
            local tracer = Drawing.new("Line")
            tracer.Visible = false
            tracer.Color = espSettings.tracerColor
            tracer.Thickness = espSettings.tracerThickness
            tracer.Transparency = 1
            tracerObjects[targetPlayer] = tracer
        end
    end
end

local function removeTracers()
    for _, tracer in pairs(tracerObjects) do
        tracer:Remove()
    end
    tracerObjects = {}
end

local function updateTracers()
    if not espEnabled or not espSettings.showTracers then
        for _, tracer in pairs(tracerObjects) do
            tracer.Visible = false
        end
        return
    end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local viewportSize = camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y)
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            local tracer = tracerObjects[targetPlayer]
            if tracer then
                local char = targetPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local rootPart = char.HumanoidRootPart
                    local pos, onScreen = camera:WorldToScreenPoint(rootPart.Position)
                    
                    tracer.Visible = true
                    tracer.From = Vector2.new(center.X, center.Y)
                    
                    if onScreen then
                        tracer.To = Vector2.new(pos.X, pos.Y)
                    else
                        local direction = (rootPart.Position - camera.CFrame.Position).Unit
                        local rightVector = camera.CFrame.RightVector
                        local upVector = camera.CFrame.UpVector
                        
                        local screenDir = Vector2.new(
                            direction:Dot(rightVector),
                            direction:Dot(upVector)
                        )
                        
                        if screenDir.Magnitude > 0 then
                            screenDir = screenDir.Unit
                            local aspectRatio = viewportSize.X / viewportSize.Y
                            local edgeX, edgeY
                            
                            local angle = math.atan2(screenDir.Y, screenDir.X)
                            local absAngle = math.abs(angle)
                            
                            if absAngle <= math.atan(1/aspectRatio) then
                                edgeX = math.sign(screenDir.X) * viewportSize.X / 2
                                edgeY = math.tan(angle) * edgeX
                            else
                                edgeY = math.sign(screenDir.Y) * viewportSize.Y / 2
                                edgeX = edgeY / math.tan(angle)
                            end
                            
                            tracer.To = Vector2.new(
                                viewportSize.X / 2 + edgeX,
                                viewportSize.Y / 2 + edgeY
                            )
                        else
                            tracer.To = center
                        end
                    end
                else
                    tracer.Visible = false
                end
            end
        end
    end
end

local function toggleTracers(state)
    if state then
        createTracers()
        if tracerConnection then tracerConnection:Disconnect() end
        tracerConnection = runService.RenderStepped:Connect(updateTracers)
    else
        removeTracers()
        if tracerConnection then
            tracerConnection:Disconnect()
            tracerConnection = nil
        end
    end
end

-- ============================================
-- ESP ФУНКЦИИ
-- ============================================

local function getPart(char, partName)
    if not char or not partName then return nil end
    
    local part = char:FindFirstChild(partName)
    if part then return part end
    
    if partName == "UpperTorso" or partName == "LowerTorso" then
        return char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    elseif partName == "LeftUpperArm" or partName == "LeftLowerArm" or partName == "LeftHand" then
        return char:FindFirstChild("Left Arm")
    elseif partName == "RightUpperArm" or partName == "RightLowerArm" or partName == "RightHand" then
        return char:FindFirstChild("Right Arm")
    elseif partName == "LeftUpperLeg" or partName == "LeftLowerLeg" or partName == "LeftFoot" then
        return char:FindFirstChild("Left Leg")
    elseif partName == "RightUpperLeg" or partName == "RightLowerLeg" or partName == "RightFoot" then
        return char:FindFirstChild("Right Leg")
    elseif partName == "Head" then
        return char:FindFirstChild("Head")
    end
    
    return nil
end

local SKELETON_CONNECTIONS = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"},
}

local function createESPGui()
    if espGui then return end
    espGui = Instance.new("ScreenGui")
    espGui.Name = "VisualsGui"
    espGui.Parent = player.PlayerGui
    espGui.ResetOnSpawn = false
    espGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    espGui.DisplayOrder = 0
end

local function removeESP(targetPlayer)
    local espData = espObjects[targetPlayer]
    if espData then
        if espData.nameLabel then espData.nameLabel:Destroy() end
        if espData.lines then
            for _, lineData in ipairs(espData.lines) do
                if lineData and lineData.frame then
                    lineData.frame:Destroy()
                end
            end
            espData.lines = nil
        end
        if espData.healthBg then espData.healthBg:Destroy() end
        if espData.healthBar then espData.healthBar:Destroy() end
        espObjects[targetPlayer] = nil
    end
    if tracerObjects[targetPlayer] then
        tracerObjects[targetPlayer]:Remove()
        tracerObjects[targetPlayer] = nil
    end
    if charConnections[targetPlayer] then
        for _, conn in ipairs(charConnections[targetPlayer]) do
            conn:Disconnect()
        end
        charConnections[targetPlayer] = nil
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
    if espGui then
        espGui:Destroy()
        espGui = nil
    end
    removeTracers()
    if tracerConnection then
        tracerConnection:Disconnect()
        tracerConnection = nil
    end
    clearAllChams()
end

local function setupCharacterMonitoring(char, targetPlayer)
    if not char then return end
    
    if not charConnections[targetPlayer] then
        charConnections[targetPlayer] = {}
    end
    
    for _, conn in ipairs(charConnections[targetPlayer]) do
        conn:Disconnect()
    end
    charConnections[targetPlayer] = {}
    
    local descendantAddedConnection = char.DescendantAdded:Connect(function(part)
        if espEnabled and espSettings.showChams and part:IsA("BasePart") then
            for _, name in ipairs(CHAMS_PARTS) do
                if part.Name == name then
                    applyChamsToPart(part, true)
                    break
                end
            end
        end
    end)
    
    local descendantRemovingConnection = char.DescendantRemoving:Connect(function(part)
        if part:IsA("BasePart") and originalProperties[part] then
            originalProperties[part] = nil
        end
    end)
    
    table.insert(charConnections[targetPlayer], descendantAddedConnection)
    table.insert(charConnections[targetPlayer], descendantRemovingConnection)
end

local function createESP(targetPlayer)
    if targetPlayer == player then return end
    if espObjects[targetPlayer] then return end
    
    createESPGui()
    
    local espData = {}
    local lines = {}
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 200, 0, 30)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = targetPlayer.Name
    nameLabel.TextColor3 = espSettings.nameColor
    nameLabel.TextSize = espSettings.nameSize
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Visible = false
    nameLabel.Parent = espGui
    espData.nameLabel = nameLabel
    
    for _, connection in ipairs(SKELETON_CONNECTIONS) do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, 1, 0, 3)
        line.BackgroundColor3 = espSettings.skeletonColor
        line.BackgroundTransparency = 0
        line.BorderSizePixel = 0
        line.Visible = false
        line.Parent = espGui
        table.insert(lines, {
            frame = line,
            part1 = connection[1],
            part2 = connection[2]
        })
    end
    espData.lines = lines
    
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(0, 80, 0, 10)
    healthBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthBg.BackgroundTransparency = 0.4
    healthBg.BorderSizePixel = 1
    healthBg.BorderColor3 = Color3.fromRGB(255, 255, 255)
    healthBg.Visible = false
    healthBg.Parent = espGui
    espData.healthBg = healthBg
    
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = espSettings.healthColor
    healthBar.BackgroundTransparency = 0
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBg
    espData.healthBar = healthBar
    
    espObjects[targetPlayer] = espData
    
    local char = targetPlayer.Character
    if char then
        if espSettings.showChams then
            applyChamsToCharacter(char, true)
        end
        setupCharacterMonitoring(char, targetPlayer)
    end
    
    targetPlayer.CharacterAdded:Connect(function(character)
        task.wait(0.1)
        if espEnabled and espSettings.showChams then
            applyChamsToCharacter(character, true)
        end
        setupCharacterMonitoring(character, targetPlayer)
    end)
    
    local connection = runService.RenderStepped:Connect(function()
        if not espEnabled then
            nameLabel.Visible = false
            for _, data in ipairs(lines) do
                data.frame.Visible = false
            end
            healthBg.Visible = false
            return
        end
        
        local char = targetPlayer.Character
        if not char then
            nameLabel.Visible = false
            for _, data in ipairs(lines) do
                data.frame.Visible = false
            end
            healthBg.Visible = false
            return
        end
        
        local camera = workspace.CurrentCamera
        if not camera then return end
        
        for _, data in ipairs(lines) do
            local part1 = getPart(char, data.part1)
            local part2 = getPart(char, data.part2)
            
            if part1 and part2 then
                local pos1, onScreen1 = camera:WorldToScreenPoint(part1.Position)
                local pos2, onScreen2 = camera:WorldToScreenPoint(part2.Position)
                
                if onScreen1 and onScreen2 then
                    local x1, y1 = pos1.X, pos1.Y
                    local x2, y2 = pos2.X, pos2.Y
                    
                    local dx = x2 - x1
                    local dy = y2 - y1
                    local distance = math.sqrt(dx*dx + dy*dy)
                    
                    if distance > 0 then
                        data.frame.Size = UDim2.new(0, distance, 0, 3)
                        data.frame.Position = UDim2.new(0, (x1 + x2) / 2 - distance/2, 0, (y1 + y2) / 2 - 1.5)
                        data.frame.Rotation = math.deg(math.atan2(dy, dx))
                        data.frame.Visible = espEnabled and espSettings.showSkeleton
                        data.frame.BackgroundColor3 = espSettings.skeletonColor
                        data.frame.BackgroundTransparency = 0
                    else
                        data.frame.Visible = false
                    end
                else
                    data.frame.Visible = false
                end
            else
                data.frame.Visible = false
            end
        end
        
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        local head = getPart(char, "Head")
        if rootPart then
            local headPos, headOnScreen = camera:WorldToScreenPoint((head and head.Position or rootPart.Position) + Vector3.new(0, 2.5, 0))
            if headOnScreen then
                nameLabel.Visible = espEnabled and espSettings.showName
                nameLabel.Position = UDim2.new(0, headPos.X - 100, 0, headPos.Y - 40)
                nameLabel.TextColor3 = espSettings.nameColor
                nameLabel.TextSize = espSettings.nameSize
            else
                nameLabel.Visible = false
            end
        else
            nameLabel.Visible = false
        end
        
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if espEnabled and espSettings.showHealth and humanoid and rootPart then
            local rootPos, rootOnScreen = camera:WorldToScreenPoint(rootPart.Position)
            if rootOnScreen then
                local health = humanoid.Health
                local maxHealth = humanoid.MaxHealth
                local percent = math.clamp(health / maxHealth, 0, 1)
                
                healthBg.Visible = true
                healthBg.Size = UDim2.new(0, 60, 0, 10)
                healthBg.Position = UDim2.new(0, rootPos.X - 30, 0, rootPos.Y + 20)
                healthBar.Size = UDim2.new(percent, 0, 1, 0)
                healthBar.BackgroundColor3 = espSettings.healthColor
            else
                healthBg.Visible = false
            end
        else
            healthBg.Visible = false
        end
    end)
    
    table.insert(espConnections, connection)
    
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
        if espSettings.showTracers then
            toggleTracers(true)
        end
        if espSettings.showChams then
            updateAllChams()
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

local function updateVisualsSettings()
    for _, espData in pairs(espObjects) do
        if espData.nameLabel then
            espData.nameLabel.TextColor3 = espSettings.nameColor
            espData.nameLabel.TextSize = espSettings.nameSize
        end
        if espData.lines then
            for _, data in ipairs(espData.lines) do
                data.frame.BackgroundColor3 = espSettings.skeletonColor
                data.frame.BackgroundTransparency = 0
                data.frame.Visible = espEnabled and espSettings.showSkeleton
            end
        end
        if espData.healthBar then
            espData.healthBar.BackgroundColor3 = espSettings.healthColor
            espData.healthBar.BackgroundTransparency = 0
        end
    end
    
    if espEnabled then
        if espSettings.showChams then
            updateAllChams()
        else
            clearAllChams()
        end
        
        if espSettings.showTracers then
            toggleTracers(true)
        else
            toggleTracers(false)
        end
    end
end

-- ============================================
-- ОБРАБОТЧИКИ ИГРОКОВ
-- ============================================

Players.PlayerAdded:Connect(function(targetPlayer)
    if espEnabled then
        task.wait(0.5)
        createESP(targetPlayer)
        if espSettings.showTracers then
            createTracers()
        end
    end
end)

Players.PlayerRemoving:Connect(function(targetPlayer)
    removeESP(targetPlayer)
    if tracerObjects[targetPlayer] then
        tracerObjects[targetPlayer]:Remove()
        tracerObjects[targetPlayer] = nil
    end
end)

player.CharacterAdded:Connect(function()
    if espEnabled then
        task.wait(0.5)
        refreshAllESP()
    end
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

for _, targetPlayer in ipairs(Players:GetPlayers()) do
    if targetPlayer ~= player then
        targetPlayer.CharacterAdded:Connect(function()
            if espEnabled then
                task.wait(0.3)
                removeESP(targetPlayer)
                createESP(targetPlayer)
            end
        end)
    end
end

-- ============================================
-- ИНТЕРФЕЙС ВИЗУАЛ В МЕНЮ
-- ============================================

local SectionVisuals = TabVisuals:CreateSection("Настройки ESP")

local ESPToggle = TabVisuals:CreateToggle({
    Name = "Включить ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Info = "Включает/выключает ESP\nПоказывает имена, скелет и здоровье всех игроков",
    Callback = function(Value)
        toggleESP(Value)
    end,
})

local NameColorPicker = TabVisuals:CreateColorPicker({
    Name = "Цвет ника",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "VisualNameColor",
    Info = "Выбери цвет для имени игрока",
    Callback = function(Color)
        espSettings.nameColor = Color
        updateVisualsSettings()
    end,
})

local SkeletonColorPicker = TabVisuals:CreateColorPicker({
    Name = "Цвет скелета",
    Color = Color3.fromRGB(0, 255, 255),
    Flag = "VisualSkeletonColor",
    Info = "Выбери цвет для скелета игрока",
    Callback = function(Color)
        espSettings.skeletonColor = Color
        updateVisualsSettings()
    end,
})

local HealthColorPicker = TabVisuals:CreateColorPicker({
    Name = "Цвет здоровья",
    Color = Color3.fromRGB(0, 255, 0),
    Flag = "VisualHealthColor",
    Info = "Выбери цвет для полоски здоровья",
    Callback = function(Color)
        espSettings.healthColor = Color
        updateVisualsSettings()
    end,
})

local NameToggle = TabVisuals:CreateToggle({
    Name = "Показывать имена",
    CurrentValue = false,
    Flag = "VisualNameToggle",
    Info = "Показывает имя игрока над головой",
    Callback = function(Value)
        espSettings.showName = Value
        updateVisualsSettings()
    end,
})

local SkeletonToggle = TabVisuals:CreateToggle({
    Name = "Показывать скелет",
    CurrentValue = false,
    Flag = "VisualSkeletonToggle",
    Info = "Показывает скелет игрока (контур)",
    Callback = function(Value)
        espSettings.showSkeleton = Value
        updateVisualsSettings()
    end,
})

local HealthToggle = TabVisuals:CreateToggle({
    Name = "Показывать здоровье",
    CurrentValue = false,
    Flag = "VisualHealthToggle",
    Info = "Показывает полоску здоровья над игроком",
    Callback = function(Value)
        espSettings.showHealth = Value
        updateVisualsSettings()
    end,
})

local NameSizeSlider = TabVisuals:CreateSlider({
    Name = "Размер ника",
    Range = {10, 40},
    Increment = 1,
    Suffix = "",
    CurrentValue = 14,
    Flag = "VisualNameSize",
    Info = "Регулирует размер имени",
    Callback = function(Value)
        espSettings.nameSize = Value
        updateVisualsSettings()
    end,
})

-- ============================================
-- CHAMS В СЕКЦИИ ESP (упрощенные - только торс и голова)
-- ============================================

local ChamsToggle = TabVisuals:CreateToggle({
    Name = "Chams (подсветка через стены)",
    CurrentValue = false,
    Flag = "ChamsToggle",
    Info = "Подсвечивает торс и голову игрока через стены",
    Callback = function(Value)
        espSettings.showChams = Value
        updateVisualsSettings()
    end,
})

local ChamsColorPicker = TabVisuals:CreateColorPicker({
    Name = "Цвет Chams",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "ChamsColor",
    Info = "Выбери цвет подсветки",
    Callback = function(Color)
        espSettings.chamsColor = Color
        updateVisualsSettings()
    end,
})

local ChamsTransparencySlider = TabVisuals:CreateSlider({
    Name = "Прозрачность Chams",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0.3,
    Flag = "ChamsTransparency",
    Info = "Регулирует прозрачность подсветки",
    Callback = function(Value)
        espSettings.chamsTransparency = Value
        updateVisualsSettings()
    end,
})

-- ============================================
-- TRACERS В СЕКЦИИ ESP
-- ============================================

local TracersToggle = TabVisuals:CreateToggle({
    Name = "Tracers (линии к игрокам)",
    CurrentValue = false,
    Flag = "TracersToggle",
    Info = "Рисует линии от тебя к игрокам\nПоказывает даже если игрок за экраном",
    Callback = function(Value)
        espSettings.showTracers = Value
        updateVisualsSettings()
    end,
})

local TracersColorPicker = TabVisuals:CreateColorPicker({
    Name = "Цвет Tracers",
    Color = Color3.fromRGB(0, 255, 0),
    Flag = "TracersColor",
    Info = "Выбери цвет линий",
    Callback = function(Color)
        espSettings.tracerColor = Color
        for _, tracer in pairs(tracerObjects) do
            tracer.Color = Color
        end
    end,
})

local TracersThicknessSlider = TabVisuals:CreateSlider({
    Name = "Толщина Tracers",
    Range = {1, 5},
    Increment = 1,
    Suffix = "",
    CurrentValue = 1,
    Flag = "TracersThickness",
    Info = "Регулирует толщину линий",
    Callback = function(Value)
        espSettings.tracerThickness = Value
        for _, tracer in pairs(tracerObjects) do
            tracer.Thickness = Value
        end
    end,
})

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
-- ВЫВОД В КОНСОЛЬ
-- ============================================
print("✅ Меню загружено! Нажми G для открытия.")
print("⚙️ Настрой скорость через ползунок, включи спидхак переключателем.")
print("🪁 Полет: включи через переключатель или нажми " .. FlyKeybind.CurrentKeybind)
print("🧱 Noclip: включи через переключатель или нажми " .. NoclipKeybind.CurrentKeybind)
print("🦘 Бесконечный прыжок: включи через переключатель")
print("👁️ Визуал: включи через переключатель во вкладке Визуал")