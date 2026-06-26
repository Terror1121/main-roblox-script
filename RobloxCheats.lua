local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()

local Window = Library:CreateWindow({
    Title = 'Моё меню',
    Center = true,
    AutoShow = true,
})

local MainTab = Window:AddTab('Основное')
local Group = MainTab:AddLeftGroupbox('Настройки')

Group:AddButton({
    Name = 'Привет!',
    Func = function()
        print('Кнопка нажата!')
    end
})

Group:AddSlider({
    Name = 'Громкость',
    Min = 0,
    Max = 100,
    Default = 50,
    Func = function(Value)
        print('Громкость:', Value)
    end
})

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        Library:ToggleUI()
    end
end)

print('✅ Меню загружено! Нажми K.')
