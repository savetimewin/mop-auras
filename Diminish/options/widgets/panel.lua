local _, NS = ...
local Widgets = NS.Widgets

local WINDOW_NAME = "DiminishOptionsWindow"
local NAV_WIDTH = 150
local MIN_WIDTH = 900
local MIN_HEIGHT = 620
local DEFAULT_WIDTH = 1040
local DEFAULT_HEIGHT = 720

local function RefreshOnShow(self)
    if self.refresh then
        self.refresh(self)
    end
end

local function InitializePanel(self)
    if self.initialized then return end

    if self.Setup then
        self:Setup()
        self.Setup = nil
    end

    if self.callbacks then
        for i = 1, #self.callbacks do
            local entry = self.callbacks[i]
            local panel = CreateFrame("Frame", nil, self)
            panel.name = entry.name
            panel.parent = self.name
            panel.frames = {}
            panel:Hide()

            self.pages[panel.name] = panel
            self.pageOrder[#self.pageOrder + 1] = panel.name

            entry.callback(panel)
            panel:SetScript("OnShow", RefreshOnShow)
        end
        self.callbacks = nil
    end

    local unitOrder = {
        player = 1,
        target = 2,
        focus = 3,
        arena = 4,
        party = 5,
        nameplate = 6,
    }
    table.sort(self.pageOrder, function(a, b)
        local pageA = self.pages[a]
        local pageB = self.pages[b]
        local orderA = pageA and unitOrder[pageA.unitID] or 100
        local orderB = pageB and unitOrder[pageB.unitID] or 100
        if orderA == orderB then
            return tostring(a) < tostring(b)
        end
        return orderA < orderB
    end)

    self.initialized = true
end

local function CreateChildPanel(self, name, callback)
    if not self.callbacks then
        self.callbacks = {}
    end

    self.callbacks[#self.callbacks + 1] = {
        name = name,
        callback = callback,
    }
end

local function SaveWindowState(window)
    if not DiminishDB then return end

    DiminishDB.optionsWindow = DiminishDB.optionsWindow or {}
    local db = DiminishDB.optionsWindow

    local point, _, relativePoint, x, y = window:GetPoint(1)
    if point then
        db.point = point
        db.relativePoint = relativePoint
        db.x = x
        db.y = y
    end

    db.width = window:GetWidth()
    db.height = window:GetHeight()
end

local function RestoreWindowState(window)
    local db = DiminishDB and DiminishDB.optionsWindow
    if not db then
        window:SetSize(DEFAULT_WIDTH, DEFAULT_HEIGHT)
        window:SetPoint("CENTER")
        return
    end

    local width = tonumber(db.width) or DEFAULT_WIDTH
    local height = tonumber(db.height) or DEFAULT_HEIGHT
    width = max(MIN_WIDTH, width)
    height = max(MIN_HEIGHT, height)
    window:SetSize(width, height)

    window:ClearAllPoints()
    if db.point then
        window:SetPoint(db.point, UIParent, db.relativePoint or db.point, tonumber(db.x) or 0, tonumber(db.y) or 0)
    else
        window:SetPoint("CENTER")
    end
end

local function CreateStandaloneWindow(panel)
    if panel.window then return panel.window end

    local template = _G.BackdropTemplateMixin and "BackdropTemplate" or nil
    local window = CreateFrame("Frame", WINDOW_NAME, UIParent, template)
    panel.window = window

    window:SetFrameStrata("DIALOG")
    window:SetClampedToScreen(true)
    window:SetMovable(true)
    window:SetResizable(true)
    if window.SetResizeBounds then
        window:SetResizeBounds(MIN_WIDTH, MIN_HEIGHT)
    elseif window.SetMinResize then
        window:SetMinResize(MIN_WIDTH, MIN_HEIGHT)
    end

    if window.SetBackdrop then
        window:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true,
            tileSize = 32,
            edgeSize = 32,
            insets = { left = 11, right = 12, top = 12, bottom = 11 },
        })
    end

    RestoreWindowState(window)
    window:Hide()

    local titleBar = CreateFrame("Frame", nil, window)
    titleBar:SetPoint("TOPLEFT", 12, -10)
    titleBar:SetPoint("TOPRIGHT", -38, -10)
    titleBar:SetHeight(30)
    titleBar:EnableMouse(true)
    titleBar:RegisterForDrag("LeftButton")
    titleBar:SetScript("OnDragStart", function()
        window:StartMoving()
    end)
    titleBar:SetScript("OnDragStop", function()
        window:StopMovingOrSizing()
        SaveWindowState(window)
    end)

    local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", 8, 0)
    title:SetText("Diminish")

    local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -6, -6)

    local nav = CreateFrame("Frame", nil, window, template)
    nav:SetPoint("TOPLEFT", 16, -48)
    nav:SetPoint("BOTTOMLEFT", 16, 18)
    nav:SetWidth(NAV_WIDTH)
    if nav.SetBackdrop then
        nav:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 },
        })
        nav:SetBackdropColor(0.03, 0.03, 0.03, 0.75)
        nav:SetBackdropBorderColor(0.45, 0.45, 0.45, 1)
    end
    window.nav = nav

    local content = CreateFrame("Frame", nil, window)
    content:SetPoint("TOPLEFT", nav, "TOPRIGHT", 10, 0)
    content:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", -18, 18)
    window.content = content

    local resize = CreateFrame("Button", nil, window)
    resize:SetSize(24, 24)
    resize:SetPoint("BOTTOMRIGHT", -5, 5)
    resize:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resize:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    resize:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    resize:SetScript("OnMouseDown", function(_, button)
        if button == "LeftButton" then
            window:StartSizing("BOTTOMRIGHT")
        end
    end)
    resize:SetScript("OnMouseUp", function()
        window:StopMovingOrSizing()
        SaveWindowState(window)
    end)

    window:SetScript("OnSizeChanged", function()
        if window:IsShown() then
            SaveWindowState(window)
        end
    end)

    window:SetScript("OnHide", function()
        SaveWindowState(window)
    end)

    if UISpecialFrames then
        local found
        for i = 1, #UISpecialFrames do
            if UISpecialFrames[i] == WINDOW_NAME then
                found = true
                break
            end
        end
        if not found then
            UISpecialFrames[#UISpecialFrames + 1] = WINDOW_NAME
        end
    end

    return window
end

local function SetNavSelected(button, selected)
    if button.LockHighlight and button.UnlockHighlight then
        if selected then
            button:LockHighlight()
        else
            button:UnlockHighlight()
        end
    end

    if button.text then
        button.text:SetTextColor(selected and 1 or 0.9, selected and 0.82 or 0.82, selected and 0 or 0.82)
    end
end

local function UpdateNavigationSelection(buttons, pageName)
    for name, button in pairs(buttons or {}) do
        SetNavSelected(button, name == pageName)
    end
end

local function AddNavigationButton(panel, nav, buttons, content, pageName, label, index)
    local button = CreateFrame("Button", nil, nav, "UIPanelButtonTemplate")
    button:SetHeight(28)
    button:SetPoint("TOPLEFT", 8, -8 - ((index - 1) * 31))
    button:SetPoint("TOPRIGHT", -8, -8 - ((index - 1) * 31))
    button:SetText(label)
    button.pageName = pageName
    button.text = button:GetFontString()
    button:SetScript("OnClick", function(self)
        panel:ShowPage(self.pageName, content)
    end)
    buttons[pageName] = button
end

local function BuildNavigation(panel)
    if panel.navigationBuilt then return end

    local window = CreateStandaloneWindow(panel)
    panel.navButtons = {}

    AddNavigationButton(panel, window.nav, panel.navButtons, window.content, panel.name, GENERAL or "General", 1)
    for i = 1, #panel.pageOrder do
        local pageName = panel.pageOrder[i]
        AddNavigationButton(panel, window.nav, panel.navButtons, window.content, pageName, pageName, i + 1)
    end

    panel.navigationBuilt = true
end

local function BuildSettingsNavigation(panel)
    if panel.settingsNavigationBuilt or not panel.settingsHost then return end

    local host = panel.settingsHost
    panel.settingsNavButtons = {}

    AddNavigationButton(panel, host.nav, panel.settingsNavButtons, host.content, panel.name, GENERAL or "General", 1)
    for i = 1, #panel.pageOrder do
        local pageName = panel.pageOrder[i]
        AddNavigationButton(panel, host.nav, panel.settingsNavButtons, host.content, pageName, pageName, i + 1)
    end

    panel.settingsNavigationBuilt = true
end

local function PopulateSettingsHost(panel)
    if not panel.settingsHost or not next(DIMINISH_NS.db or {}) then
        return
    end

    panel:EnsureInitialized()
    BuildSettingsNavigation(panel)
    panel:ShowPage(panel.currentPageName or panel.name, panel.settingsHost.content)
end

function Widgets:CreateMainPanel(name)
    self.ADDON_NAME = name

    local panel = CreateFrame("Frame", nil, UIParent)
    panel.name = "Diminish"
    panel.frames = {}
    panel.pages = {}
    panel.pageOrder = {}
    panel.CreateChildPanel = CreateChildPanel
    panel:Hide()

    function panel:EnsureInitialized()
        InitializePanel(self)
        BuildNavigation(self)
    end

    function panel:ShowPage(pageName, content)
        self:EnsureInitialized()

        local targetContent = content or self.window.content
        local page = pageName == self.name and self or self.pages[pageName]
        if not page then
            page = self
            pageName = self.name
        end

        if self.currentPage and self.currentPage ~= page then
            self.currentPage:Hide()
            self.currentPage:ClearAllPoints()
        end

        if page:GetParent() ~= targetContent then
            page:SetParent(targetContent)
        end
        page:ClearAllPoints()
        page:SetAllPoints(targetContent)
        page:Show()
        RefreshOnShow(page)

        self.currentPage = page
        self.currentPageName = pageName

        UpdateNavigationSelection(self.navButtons, pageName)
        UpdateNavigationSelection(self.settingsNavButtons, pageName)
    end

    function panel:OpenStandalone(pageName)
        self:EnsureInitialized()
        RestoreWindowState(self.window)
        self.window:Show()
        self.window:Raise()
        self:ShowPage(pageName or self.currentPageName or self.name, self.window.content)
    end

    function panel:ToggleStandalone(pageName)
        self:EnsureInitialized()
        if self.window:IsShown() then
            self.window:Hide()
        else
            self:OpenStandalone(pageName)
        end
    end

    -- Register the real Diminish configuration UI directly in Blizzard's
    -- AddOns settings while keeping /dim as the standalone-window entry point.
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        local template = _G.BackdropTemplateMixin and "BackdropTemplate" or nil
        local settingsHost = CreateFrame("Frame", nil, UIParent)
        settingsHost.name = "Diminish"
        panel.settingsHost = settingsHost

        local nav = CreateFrame("Frame", nil, settingsHost, template)
        nav:SetPoint("TOPLEFT", 8, -8)
        nav:SetPoint("BOTTOMLEFT", 8, 8)
        nav:SetWidth(NAV_WIDTH)
        if nav.SetBackdrop then
            nav:SetBackdrop({
                bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                tile = true,
                tileSize = 16,
                edgeSize = 12,
                insets = { left = 3, right = 3, top = 3, bottom = 3 },
            })
            nav:SetBackdropColor(0.03, 0.03, 0.03, 0.55)
            nav:SetBackdropBorderColor(0.45, 0.45, 0.45, 1)
        end
        settingsHost.nav = nav

        local content = CreateFrame("Frame", nil, settingsHost)
        content:SetPoint("TOPLEFT", nav, "TOPRIGHT", 10, 0)
        content:SetPoint("BOTTOMRIGHT", settingsHost, "BOTTOMRIGHT", -8, 8)
        settingsHost.content = content

        settingsHost:SetScript("OnShow", function()
            if panel.window and panel.window:IsShown() then
                panel.window:Hide()
            end

            PopulateSettingsHost(panel)
        end)

        settingsHost:SetScript("OnHide", function()
            if panel.currentPage and panel.currentPage:GetParent() == settingsHost.content then
                panel.currentPage:Hide()
            end
        end)

        local category = Settings.RegisterCanvasLayoutCategory(settingsHost, settingsHost.name)
        category.ID = category.ID or settingsHost.name
        Settings.RegisterAddOnCategory(category)
        panel.settingsCategory = category

        -- Blizzard's Settings canvas can display this registered frame without
        -- running its OnShow script. Pre-build the embedded options once the
        -- Diminish DB is ready so AddOns > Diminish is never an empty shell.
        local initFrame = CreateFrame("Frame")
        if IsLoggedIn() and next(DIMINISH_NS.db or {}) then
            C_Timer.After(0, function()
                PopulateSettingsHost(panel)
            end)
        else
            initFrame:RegisterEvent("PLAYER_LOGIN")
            initFrame:SetScript("OnEvent", function(self)
                self:UnregisterEvent("PLAYER_LOGIN")
                C_Timer.After(0, function()
                    PopulateSettingsHost(panel)
                end)
            end)
        end
    end

    SLASH_DIMINISH1 = "/diminish"
    SLASH_DIMINISH2 = "/dim"
    SlashCmdList.DIMINISH = function()
        panel:ToggleStandalone()
    end

    return panel
end
