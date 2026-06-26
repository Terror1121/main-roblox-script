-- 1. Подключаем Rayfield (актуальная версия)
-- Подключаем актуальную версию Rayfield (2025)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/source.lua'))()

-- 2. Создаём окно
local Window = Rayfield:CreateWindow({
    Name = "Моё первое меню",
    LoadingTitle = "Rayfield UI",
    LoadingSubtitle = "by namesick",
    ToggleUIKeybind = Enum.KeyCode.K,
})

-- 3. Создаём вкладку
local Tab = Window:CreateTab("Основное")

-- 4. Создаём секцию
local Section = Tab:CreateSection("Настройки")

-- 5. Кнопка (правильный синтаксис для новой версии)
Section:CreateButton({
    Name = "Привет!",
    Callback = function()
        print("Кнопка нажата!")
    end
})

-- 6. Ползунок (правильный синтаксис)
Section:CreateSlider({
    Name = "Громкость",
    Range = {0, 100}, -- В новой версии используется Range, а не Min/Max
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "%",
    Callback = function(value)
        print("Громкость установлена на:", value)
    end
})

print("✅ Меню загружено! Нажми K.")
