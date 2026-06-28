-- 1. Загружаем библиотеку
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. Создаем главное окно
local Window = Rayfield:CreateWindow({
    Name = "Моё крутое меню",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by YourName",
    -- Клавиша для открытия/закрытия меню
    ToggleUIKeybind = Enum.KeyCode.K,
})

-- 3. Создаем вкладку
local Tab = Window:CreateTab("Основное", 4483362458) -- Второй аргумент — иконка

-- 4. Создаем секцию внутри вкладки
local Section = Tab:CreateSection("Настройки")

-- 5. Добавляем кнопку
--Section:CreateButton({
    --Name = "Привет!",
    --Callback = function()
       -- print("Кнопка нажата!")
   -- end
--})

local Button = Tab:CreateButton({
   Name = "Привет!",
   Callback = function()
 -- The function that takes place when the button is pressed
            print("Кнопка нажата!")
   end,
})

local Button2 = Section:CreateButton({
   Name = "Привет!",
   Callback = function()
 -- The function that takes place when the button is pressed
            print("2Кнопка нажата!")
   end,
})


-- 6. Добавляем ползунок
--Section:CreateSlider({
    --Name = "Громкость",
    --Range = {0, 100},
   --Increment = 1,
    --CurrentValue = 50,
    --Callback = function(Value)
        --print("Громкость установлена на:", Value)
    --end
--})
