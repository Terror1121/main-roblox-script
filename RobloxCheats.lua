-- Подключаем LinoriaLib
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- Создаем окно
local Window = Library:CreateWindow({
    Title = 'Моё меню',
    Center = true,
    AutoShow = true,
})

-- Создаем вкладку
local MainTab = Window:AddTab('Основное')

-- Создаем группу внутри вкладки
local Group = MainTab:AddLeftGroupbox('Настройки')

-- ДОБАВЛЯЕМ КНОПКУ
Group:AddButton({
    Name = 'Привет!',
    Callback = function()
        print('Кнопка нажата!')  -- Сообщение появится в консоли экзекутора
    end
})

-- ДОБАВЛЯЕМ ПОЛЗУНОК
Group:AddSlider({
    Name = 'Громкость',
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(Value)
        print('Громкость установлена на:', Value)
    end
})

-- Клавиша для открытия/закрытия меню (по умолчанию RightShift)
-- Если хочешь K, нужно будет добавить отдельную обработку
print('✅ Меню загружено! Нажми RightShift для открытия/закрытия.')
