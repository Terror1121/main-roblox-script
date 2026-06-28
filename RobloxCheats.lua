-- 1. Подключаем Venyx
local Venyx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source.lua"))()

-- 2. Создаём UI и сразу получаем объект вкладки
local venyx = Venyx.new("Моё меню")
local mainTab = venyx:AddPage("Основное")
local settingsSection = mainTab:AddSection("Настройки")

-- 3. Кнопка
settingsSection:CreateButton({
    Name = "Привет!",
    Callback = function()
        print("Кнопка нажата!")
    end
})

-- 4. Ползунок
settingsSection:CreateSlider({
    Name = "Громкость",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(Value)
        print("Громкость установлена на:", Value)
    end
})

-- 5. Управление клавишей K
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        venyx:Toggle()
    end
end)

print("✅ Меню загружено! Нажми K.")
