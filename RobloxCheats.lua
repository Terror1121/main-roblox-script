-- 1. Подключаем Venyx (встроенная библиотека)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/Venyx/v1.1.0/source.lua"))()

-- 2. Создаём окно
local Window = Library:CreateWindow({
    Name = "Моё первое меню",
    ToggleUIKeybind = Enum.KeyCode.K,
})

-- 3. Создаём вкладку
local Tab = Window:CreateTab("Основное")

-- 4. Создаём секцию
local Section = Tab:CreateSection("Настройки")

-- 5. Кнопка
Section:CreateButton({
    Name = "Привет!",
    Callback = function()
        print("Кнопка нажата!")
    end
})

-- 6. Ползунок
Section:CreateSlider({
    Name = "Громкость",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Громкость установлена на:", value)
    end
})

print("✅ Меню загружено! Нажми K.")
