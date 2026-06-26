-- 1. Подключаем библиотеку OrionLib
-- Используем актуальную ссылку [citation:1][citation:4][citation:7]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/DenDenZZZ/Orion-UI-Library/refs/heads/main/source')))()

-- 2. Создаём главное окно
local Window = OrionLib:MakeWindow({
    Name = "Моё первое меню",  -- Название окна
    HidePremium = false,       -- Показывать Premium статус
    SaveConfig = false,        -- Отключаем сохранение настроек для простоты
    IntroEnabled = true,       -- Показывать анимацию приветствия
    IntroText = "Orion Loaded" -- Текст в анимации
})

-- 3. Создаём вкладку
local Tab = Window:MakeTab({
    Name = "Основное",
    Icon = "rbxassetid://4483345998", -- Иконка рядом с названием
    PremiumOnly = false
})

-- 4. Создаём секцию внутри вкладки
local Section = Tab:AddSection({
    Name = "Настройки"
})

-- 5. Добавляем КНОПКУ
Section:AddButton({
    Name = "Привет!",
    Callback = function()
        print("Кнопка нажата!") -- Здесь будет твой код
    end
})

-- 6. Добавляем ПОЛЗУНОК (Слайдер)
Section:AddSlider({
    Name = "Громкость",
    Min = 0,
    Max = 100,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "%",
    Callback = function(Value)
        print("Громкость установлена на:", Value) -- Здесь будет твой код
    end    
})

-- 7. ОБЯЗАТЕЛЬНО инициализируем библиотеку в конце [citation:1][citation:4]
OrionLib:Init()

print("✅ Меню загружено! Нажми K для открытия/закрытия.")
