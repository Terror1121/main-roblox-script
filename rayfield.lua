-- .vscode/rayfield.lua
-- Этот файл нужен только для автодополнения и не влияет на работу скрипта.

---@class Rayfield
local Rayfield = {}

---@class RayfieldWindow
local Window = {}
---@param config table
---@return RayfieldWindow
function Rayfield:CreateWindow(config) end

---@class RayfieldTab
local Tab = {}
---@param name string
---@param icon string|number
---@return RayfieldTab
function Window:CreateTab(name, icon) end

---@class RayfieldSection
local Section = {}
---@param name string
---@return RayfieldSection
function Tab:CreateSection(name) end

---@class RayfieldButton
local Button = {}
---@param config table
---@return RayfieldButton
function Tab:CreateButton(config) end

---@class RayfieldSlider
local Slider = {}
---@param config table
---@return RayfieldSlider
function Tab:CreateSlider(config) end

---@class RayfieldToggle
local Toggle = {}
---@param config table
---@return RayfieldToggle
function Tab:CreateToggle(config) end

-- Добавь сюда другие методы, если они тебе нужны (CreateInput, CreateDropdown и т.д.)