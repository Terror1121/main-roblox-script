-- 1. Подключаем библиотеку OrionLib
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/DenDenZZZ/Orion-UI-Library/refs/heads/main/source')))()

-- 2. Создаём главное окно (убираем Intro, чтобы избежать ошибок с иконками)
local Window = OrionLib:MakeWindow({
    Name = "Моё первое меню",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = false,        -- Отключаем приветствие (чтобы не грузить иконки)
    IntroText = "Orion Loaded"
})

-- 3. Создаём вкладку
local Tab = Window:MakeTab({
    Name = "Основное",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 4. Создаём секцию
local Section = Tab:AddSection({
    Name = "Настройки"
})

-- 5. Кнопка с уведомлением
Section:AddButton({
    Name = "Привет!",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Уведомление",
            Content = "Кнопка нажата! 🎉",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- 6. Ползунок
Section:AddSlider({
    Name = "Громкость",
    Min = 0,
    Max = 100,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "%",
    Callback = function(Value)
        print("Громкость установлена на:", Value)
    end    
})

-- 7. Инициализация
OrionLib:Init()

-- 8. УПРАВЛЕНИЕ КЛАВИШЕЙ K (ИСПРАВЛЕННЫЙ МЕТОД)
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        -- Пробуем разные варианты названия метода
        if OrionLib.Toggle then
            OrionLib:Toggle()
        elseif OrionLib.ToggleUI then
            OrionLib:ToggleUI()
        elseif OrionLib.ToggleUi then
            OrionLib:ToggleUi()
        else
            -- Если ничего не работает — показываем/скрываем через GUI
            local gui = game.CoreGui:FindFirstChild("OrionGui")
            if gui then
                gui.Enabled = not gui.Enabled
            end
        end
    end
end)

print("✅ Меню загружено! Нажми K.")
