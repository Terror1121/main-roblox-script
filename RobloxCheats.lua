-- 1. Подключаем OrionLib
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/DenDenZZZ/Orion-UI-Library/refs/heads/main/source')))()

-- 2. Создаём окно
local Window = OrionLib:MakeWindow({
    Name = "Моё первое меню",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = true,
    IntroText = "Orion Loaded"
})

-- 3. Вкладка
local Tab = Window:MakeTab({
    Name = "Основное",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 4. Секция
local Section = Tab:AddSection({
    Name = "Настройки"
})

-- 5. КНОПКА С УВЕДОМЛЕНИЕМ (работает визуально)
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

-- 6. ПОЛЗУНОК
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

-- 8. Управление клавишей K
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        OrionLib:ToggleUi()
    end
end)

print("✅ Меню загружено! Нажми K.")
