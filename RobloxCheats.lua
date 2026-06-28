-- 1. Подключаем Neverlose UI
local Neverlose_Main = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mana42138/Neverlose-UI/main/Source.lua"))()

-- 2. Создаём окно
local win = Neverlose_Main:Window({
    Title = "Моё меню",
    CFG = "Neverlose",
    Key = Enum.KeyCode.H,  -- Клавиша для открытия (H)
    External = {
        KeySystem = false,
    }
})

-- 3. Вкладка "Основное"
local MainTab = win:Tab({
    Name = "Основное",
    Callback = function() end
})

-- 4. КНОПКА
MainTab:Button({
    Name = "Привет!",
    Callback = function()
        print("Кнопка нажата!") -- Вывод в консоль экзекутора
    end
})

-- 5. ПОЛЗУНОК (Слайдер)
MainTab:Slider({
    Name = "Громкость",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(Value)
        print("Громкость установлена на:", Value)
    end
})

print("✅ Меню загружено! Нажми H для открытия/закрытия (или K).")
