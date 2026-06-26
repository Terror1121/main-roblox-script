-- 1. Подключаем Amethyst UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/J0se-j/My-Lua-Library/refs/heads/main/Booting-the-library.lua"))()

-- 2. Создаём окно
local Window = Library:CreateWindow({
    Name = "Моё первое меню",
    LoadingTitle = "Amethyst UI",          -- Заголовок при загрузке
    LoadingSubtitle = "by namesick",         -- Подзаголовок
    ToggleUIKeybind = Enum.KeyCode.K,      -- Клавиша для показа/скрытия (K)
})

-- 3. Создаём вкладку
local Tab = Window:CreateTab("Основное")

-- 4. Создаём секцию внутри вкладки
local Section = Tab:CreateSection("Настройки")

-- 5. Добавляем кнопку
Section:CreateButton({
    Name = "Привет!",
    Callback = function()
        print("Кнопка нажата!")
    end
})

-- 6. Добавляем ползунок (слайдер)
Section:CreateSlider({
    Name = "Громкость",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Громкость установлена на:", value)
    end
})
