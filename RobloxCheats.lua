local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))() -- 1. Загружаем библиотеку

-- 2. Создаем главное окно
local Window = Rayfield:CreateWindow({
    Name = "Моё крутое меню",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by YourName",
    ScriptID = "sid_eo08v93jcdta",
    -- Клавиша для открытия/закрытия меню
    ToggleUIKeybind = Enum.KeyCode.K,
    
})

-- 3. Создаем вкладку
local Tab = Window:CreateTab("Основное", 4483362458) -- Второй аргумент — иконка

-- 4. Создаем секцию внутри вкладки
local Section = Tab:CreateSection("Настройки")


local Button = Tab:CreateButton({
   Name = "Привет!",
   Callback = function()
 -- The function that takes place when the button is pressed
            print("Кнопка нажата!")
   end,
})


