local _, NS = ...
local Widgets = NS.Widgets

local count = 0

local function FormatValue(value)
    if value == nil then return "" end
    if value == math.floor(value) then
        return tostring(math.floor(value))
    end
    return tostring(value)
end

local function RestoreEditValue(editbox)
    local slider = editbox.slider
    local value = slider.lastValidValue
    if value == nil then
        value = slider:GetValue()
    end
    editbox:SetText(FormatValue(value))
end

local function IsValidInput(slider, value)
    if not value or value ~= value or value == math.huge or value == -math.huge then
        return false
    end

    local minValue, maxValue = slider:GetMinMaxValues()
    if value < minValue or value > maxValue then
        return false
    end

    local step = slider.valueStep or 1
    if step > 0 then
        local steps = (value - minValue) / step
        local nearest = math.floor(steps + 0.5)
        if math.abs(steps - nearest) > 0.000001 then
            return false
        end
    end

    return true
end

local function OnEditEnterPressed(editbox)
    local slider = editbox.slider
    local value = tonumber(editbox:GetText())

    if not IsValidInput(slider, value) then
        RestoreEditValue(editbox)
        editbox:ClearFocus()
        return
    end

    slider:SetValue(value)
    slider.lastValidValue = value
    editbox:SetText(FormatValue(slider:GetValue()))
    editbox:ClearFocus()
end

local function OnEditEscapePressed(editbox)
    RestoreEditValue(editbox)
    editbox:ClearFocus()
end

local function OnEditFocusLost(editbox)
    RestoreEditValue(editbox)
end

local function OnEditFocusGained(editbox)
    editbox:HighlightText()
end

local function OnValueChanged(self, value)
    local val = ceil(value)
    self.lastValidValue = val

    if self.valueEditBox then
        self.valueEditBox:SetText(FormatValue(val))
    end

    if self.callbackFunc and self.hasRefreshed then
        self.callbackFunc(self, val)
    end
    self.hasRefreshed = true -- only run callback after panel.refresh() has been triggered once after startup
end

local SliderBackdrop  = {
    bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
    edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
    tile = true, tileSize = 8, edgeSize = 8,
    insets = { left = 3, right = 3, top = 6, bottom = 6 }
}

function Widgets:CreateSlider(parent, text, tooltipText, minValue, maxValue, valueStep, func)
    local name = format("%sSlider%d", self.ADDON_NAME, count)

    local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate, BackdropTemplate")
    slider:SetSize(180, 15)
    slider:SetMinMaxValues(minValue or 1, maxValue or 100)
    slider:SetValueStep(valueStep or 1)
    slider.valueStep = valueStep or 1
    slider:SetOrientation("HORIZONTAL")
    slider:SetBackdrop(SliderBackdrop)
    slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")

    local label = _G[name .. "Text"]
    label:SetFontObject("GameFontNormalLeft")
    label:ClearAllPoints()
    label:SetPoint("BOTTOMLEFT", slider, "TOPLEFT", 0, 3)
    label:SetText(text)
    slider.labelText = label

    -- Replace the template's read-only High label with a borderless EditBox.
    -- It occupies the same location, so the value still looks like the normal
    -- slider number but can be clicked and typed directly.
    local templateValue = _G[name .. "High"]
    templateValue:Hide()

    local value = CreateFrame("EditBox", nil, slider)
    value:SetSize(55, 18)
    value:SetPoint("BOTTOMRIGHT", slider, "TOPRIGHT", 0, 1)
    value:SetAutoFocus(false)
    value:EnableMouse(true)
    value:SetMaxLetters(12)
    value:SetJustifyH("RIGHT")
    value:SetFontObject("GameFontHighlightSmall")
    value:SetTextInsets(0, 0, 0, 0)
    value.slider = slider
    value:SetScript("OnEnterPressed", OnEditEnterPressed)
    value:SetScript("OnEscapePressed", OnEditEscapePressed)
    value:SetScript("OnEditFocusLost", OnEditFocusLost)
    value:SetScript("OnEditFocusGained", OnEditFocusGained)
    slider.valueText = value
    slider.valueEditBox = value

    slider.tooltipText = tooltipText
    slider:SetScript("OnEnter", Widgets.OnEnter)
    slider:SetScript("OnLeave", GameTooltip_Hide)
    slider.callbackFunc = func
    slider:SetScript("OnValueChanged", OnValueChanged)
    _G[name .. "Low"]:SetText("")

    count = count + 1

    return slider
end
