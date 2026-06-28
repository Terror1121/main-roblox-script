local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))() -- 1. Загружаем библиотеку

-- 2. Создаем главное окно
local Window = Rayfield:CreateWindow({
    Name = "Main Script",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by namesick",
    ScriptID = "sid_eo08v93jcdta",
    -- Клавиша для открытия/закрытия меню
    ToggleUIKeybind = Enum.KeyCode.G,
    
})

-- 3. Создаем вкладку
local Tab = Window:CreateTab("Основное", 4483362458) -- Второй аргумент — иконка

-- 4. Создаем секцию внутри вкладки
local Section = Tab:CreateSection("Настройки")


local Button = Tab:CreateButton({
   Name = "Кнопка",
   Callback = function()
 -- The function that takes place when the button is pressed
            print("Кнопка нажата!")
   end,
})


