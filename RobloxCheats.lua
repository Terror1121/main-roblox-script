-- 1. Подключаем Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. Создаём окно
local Window = Rayfield:CreateWindow({
    Name = "Моё первое меню",
    LoadingTitle = "Rayfield UI",
    LoadingSubtitle = "by namesick",
    ToggleUIKeybind = Enum.KeyCode.K, -- Клавиша K для скрытия
})

-- 3. Создаём вкладку "Основное"
local Tab = Window:CreateTab("Основное", 0)

-- 4. Создаём секцию "Настройки" (ВНЕШНЯЯ)
local Section = Tab:CreateSection("Настройки")

-- 5. СОЗДАЁМ КНОПКУ (ОНА БУДЕТ ВНУТРИ СЕКЦИИ)
Section:CreateButton({
    Name = "Привет!",
    Callback = function()
        print("Кнопка нажата!")
    end
})

-- 6. СОЗДАЁМ ПОЛЗУНОК (СЛАЙДЕР) (ТОЖЕ ВНУТРИ СЕКЦИИ)
Section:CreateSlider({
    Name = "Громкость",
    Min = 0,
    Max = 100,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "%",
    Callback = function(value)
        print("Громкость установлена на:", value)
    end
})

print("✅ Меню загружено! Нажми K для открытия/закрытия.")
