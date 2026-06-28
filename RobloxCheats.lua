-- 1. Подключаем Neverlose (альтернативная ссылка)
local Neverlose_Main = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kokoro-San/Neverlose-UI/main/Source.lua"))()

-- 2. Создаём окно
local win = Neverlose_Main:Window({
    Title = "Моё меню",
    CFG = "Neverlose",
    Key = Enum.KeyCode.H,
    External = {
        KeySystem = false,
    }
})

-- 3. Вкладка
local MainTab = win:Tab({
    Name = "Основное",
    Callback = function() end
})

-- 4. Кнопка
MainTab:Button({
    Name = "Привет!",
    Callback = function()
        print("Кнопка нажата!")
    end
})

-- 5. Ползунок
MainTab:Slider({
    Name = "Громкость",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(Value)
        print("Громкость установлена на:", Value)
    end
})


print("✅ Меню загружено! Нажми H или K.")
