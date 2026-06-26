-- 1. Подключаем Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. Создаём окно (аналог твоего)
local Window = Rayfield:CreateWindow({
    Name = "Моё первое меню",
    LoadingTitle = "Rayfield UI",
    LoadingSubtitle = "by namesick",
    ToggleUIKeybind = Enum.KeyCode.K, -- 👈 КЛАВИША K РАБОТАЕТ!
})

-- 3. Создаём вкладку "Основное"
local Tab = Window:CreateTab("Основное", 0) -- 0 = иконка (можно убрать)

-- 4. Создаём секцию "Настройки"
local Section = Tab:CreateSection("Настройки")

-- 5. Кнопка "Привет!" (полный аналог твоей)
Section:CreateButton({
    Name = "Привет!",
    Callback = function()
        print("Кнопка нажата!")
    end
})

-- 6. Ползунок "Громкость" (полный аналог твоего)
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
