-- Visual overview of all AeroSpace workspaces with window snapshots.

local M = {}

M.config = {
    hotkey = { mod = { "ctrl", "alt" }, key = "m" },
    bgColor = { red = 0.05, green = 0.05, blue = 0.08, alpha = 0.92 },
    cellBg = { red = 0.18, green = 0.18, blue = 0.2, alpha = 1.0 },
    cellBgFocused = { red = 0.15, green = 0.22, blue = 0.35, alpha = 1.0 },
    cellBorder = { red = 0.3, green = 0.3, blue = 0.35, alpha = 1.0 },
    cellBorderFocused = { red = 0.4, green = 0.55, blue = 0.9, alpha = 1.0 },
    cellBorderSelected = { red = 1.0, green = 1.0, blue = 1.0, alpha = 1.0 },
    labelColor = { white = 1, alpha = 0.9 },
    labelFont = { name = ".AppleSystemUIFont", size = 14 },
    screenMargin = 60,
    cellGap = 20,
    cellPadding = 10,
    labelHeight = 24,
    windowGap = 6,
    cornerRadius = 10,
    maxColumns = 5,
}

local canvas = nil
local navHotkeys = {}
local AEROSPACE_PATH = "/opt/homebrew/bin/aerospace"
local triggerHotkey = nil
local cellMap = {}
local selectedIndex = 1
local gridCols = 1

local function gatherWorkspaces()
    local focusedWs = hs.execute(AEROSPACE_PATH .. " list-workspaces --focused"):gsub("%s+$", "")
    local raw = hs.execute(
        AEROSPACE_PATH .. " list-windows --all --format '%{workspace}|%{window-id}|%{app-name}'"
    )

    local byWs = {}
    local order = {}
    local seen = {}

    for line in raw:gmatch("[^\r\n]+") do
        local ws, idStr, app = line:match("^(.+)|(%d+)|(.+)$")
        if ws and idStr then
            if not seen[ws] then
                seen[ws] = true
                table.insert(order, ws)
                byWs[ws] = { name = ws, windows = {}, isFocused = (ws == focusedWs) }
            end
            local id = tonumber(idStr)
            local win = hs.window.get(id)
            if win then
                local snap = win:snapshot()
                if snap then
                    local size = snap:size()
                    local scale = 0.25
                    snap:size({
                        w = math.floor(size.w * scale),
                        h = math.floor(size.h * scale),
                    })
                    local thumb = snap
                    table.insert(byWs[ws].windows, {
                        id = id,
                        app = app,
                        snapshot = thumb,
                    })
                end
            end
        end
    end

    table.sort(order, function(a, b)
        local na, nb = tonumber(a), tonumber(b)
        if na and nb then return na < nb end
        if na then return true end
        if nb then return false end
        return a < b
    end)

    local result = {}
    for _, ws in ipairs(order) do
        if #byWs[ws].windows > 0 or byWs[ws].isFocused then
            table.insert(result, byWs[ws])
        end
    end
    return result
end

local function chooseGrid(count, w, h)
    local bestCols, bestRows, bestScore = 1, count, math.huge
    local aspect = w / h

    for rows = 1, count do
        local cols = math.ceil(count / rows)
        local cellAspect = (w / cols) / (h / rows)
        local score = math.abs(math.log(cellAspect / aspect)) + (rows * cols - count) * 0.3
        if score < bestScore then
            bestCols, bestRows, bestScore = cols, rows, score
        end
    end

    return bestCols, bestRows
end

local function getCellBorderColor(cell, isSelected)
    if isSelected then
        return M.config.cellBorderSelected
    elseif cell.isFocused then
        return M.config.cellBorderFocused
    else
        return M.config.cellBorder
    end
end

local function getCellBorderWidth(cell, isSelected)
    if isSelected then return 3
    elseif cell.isFocused then return 2
    else return 1
    end
end

local function updateSelection(oldIndex, newIndex)
    if not canvas or oldIndex == newIndex then return end
    if oldIndex >= 1 and oldIndex <= #cellMap then
        local old = cellMap[oldIndex]
        canvas[old.elementIndex].strokeColor = getCellBorderColor(old, false)
        canvas[old.elementIndex].strokeWidth = getCellBorderWidth(old, false)
    end
    if newIndex >= 1 and newIndex <= #cellMap then
        local new = cellMap[newIndex]
        canvas[new.elementIndex].strokeColor = getCellBorderColor(new, true)
        canvas[new.elementIndex].strokeWidth = getCellBorderWidth(new, true)
    end
    selectedIndex = newIndex
end

local function navigate(direction)
    if #cellMap == 0 then return end
    local count = #cellMap
    local col = (selectedIndex - 1) % gridCols
    local row = math.floor((selectedIndex - 1) / gridCols)

    if direction == "h" then
        col = col - 1
        if col < 0 then col = gridCols - 1 end
    elseif direction == "l" then
        col = col + 1
        if col >= gridCols then col = 0 end
    elseif direction == "k" then
        row = row - 1
    elseif direction == "j" then
        row = row + 1
    end

    local newIndex = row * gridCols + col + 1
    if newIndex >= 1 and newIndex <= count then
        updateSelection(selectedIndex, newIndex)
    end
end

local function switchWorkspace(ws)
    local task = hs.task.new(AEROSPACE_PATH, function() end, { "workspace", ws })
    if task then task:start() end
end

local function confirmSelection()
    if selectedIndex >= 1 and selectedIndex <= #cellMap then
        local ws = cellMap[selectedIndex].workspace
        M.hide()
        switchWorkspace(ws)
    end
end

local function buildElements(workspaces)
    local screen = hs.screen.mainScreen()
    local screenFrame = screen:frame()
    local cfg = M.config

    local count = #workspaces
    local cols, rows = chooseGrid(count, screenFrame.w, screenFrame.h)
    if cols > cfg.maxColumns then
        cols = cfg.maxColumns
        rows = math.ceil(count / cols)
    end
    gridCols = cols

    local usableW = screenFrame.w - cfg.screenMargin * 2
    local usableH = screenFrame.h - cfg.screenMargin * 2
    local cellW = math.floor((usableW - cfg.cellGap * (cols - 1)) / cols)
    local cellH = math.floor((usableH - cfg.cellGap * (rows - 1)) / rows)

    local elements = {}
    cellMap = {}

    table.insert(elements, {
        type = "rectangle",
        frame = { x = 0, y = 0, w = screenFrame.w, h = screenFrame.h },
        fillColor = cfg.bgColor,
        action = "fill",
    })

    local focusedCellIndex = 1
    local idx = 1
    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            if idx > count then break end
            local ws = workspaces[idx]

            local cx = cfg.screenMargin + col * (cellW + cfg.cellGap)
            local cy = cfg.screenMargin + row * (cellH + cfg.cellGap)

            if ws.isFocused then
                focusedCellIndex = idx
            end

            local isSelected = (idx == focusedCellIndex and ws.isFocused)

            table.insert(elements, {
                type = "rectangle",
                frame = { x = cx, y = cy, w = cellW, h = cellH },
                fillColor = ws.isFocused and cfg.cellBgFocused or cfg.cellBg,
                strokeColor = getCellBorderColor({ isFocused = ws.isFocused }, isSelected),
                strokeWidth = getCellBorderWidth({ isFocused = ws.isFocused }, isSelected),
                roundedRectRadii = { xRadius = cfg.cornerRadius, yRadius = cfg.cornerRadius },
                action = "strokeAndFill",
            })
            local cellElementIndex = #elements

            table.insert(elements, {
                type = "text",
                frame = {
                    x = cx + cfg.cellPadding,
                    y = cy + 4,
                    w = cellW - cfg.cellPadding * 2,
                    h = cfg.labelHeight,
                },
                text = hs.styledtext.new(ws.name, {
                    font = cfg.labelFont,
                    color = cfg.labelColor,
                    paragraphStyle = { alignment = "left" },
                }),
            })

            local thumbX = cx + cfg.cellPadding
            local thumbY = cy + cfg.labelHeight + cfg.cellPadding
            local thumbAreaW = cellW - cfg.cellPadding * 2
            local thumbAreaH = cellH - cfg.labelHeight - cfg.cellPadding * 2

            local winCount = #ws.windows
            if winCount > 0 and thumbAreaW > 0 and thumbAreaH > 0 then
                local wCols, wRows = chooseGrid(winCount, thumbAreaW, thumbAreaH)
                local winW = math.floor((thumbAreaW - cfg.windowGap * (wCols - 1)) / wCols)
                local winH = math.floor((thumbAreaH - cfg.windowGap * (wRows - 1)) / wRows)

                local wi = 1
                for wr = 0, wRows - 1 do
                    for wc = 0, wCols - 1 do
                        if wi > winCount then break end
                        local wx = thumbX + wc * (winW + cfg.windowGap)
                        local wy = thumbY + wr * (winH + cfg.windowGap)

                        table.insert(elements, {
                            type = "rectangle",
                            frame = { x = wx, y = wy, w = winW, h = winH },
                            fillColor = { red = 0.1, green = 0.1, blue = 0.1, alpha = 1 },
                            roundedRectRadii = { xRadius = 4, yRadius = 4 },
                            action = "fill",
                        })

                        table.insert(elements, {
                            type = "image",
                            frame = { x = wx, y = wy, w = winW, h = winH },
                            image = ws.windows[wi].snapshot,
                            imageScaling = "scaleProportionally",
                            imageAlignment = "center",
                        })
                        wi = wi + 1
                    end
                end
            end

            table.insert(cellMap, {
                x = cx,
                y = cy,
                w = cellW,
                h = cellH,
                workspace = ws.name,
                isFocused = ws.isFocused,
                elementIndex = cellElementIndex,
            })

            idx = idx + 1
        end
    end

    selectedIndex = focusedCellIndex

    return elements, screenFrame
end

local function bindNavKeys()
    local keys = {
        { {}, "h", function() navigate("h") end },
        { {}, "j", function() navigate("j") end },
        { {}, "k", function() navigate("k") end },
        { {}, "l", function() navigate("l") end },
        { {}, "left", function() navigate("h") end },
        { {}, "down", function() navigate("j") end },
        { {}, "up", function() navigate("k") end },
        { {}, "right", function() navigate("l") end },
        { {}, "return", confirmSelection },
        { {}, "escape", function() M.hide() end },
    }
    for _, k in ipairs(keys) do
        local hk = hs.hotkey.bind(k[1], k[2], k[3], nil, k[3])
        table.insert(navHotkeys, hk)
    end
end

local function unbindNavKeys()
    for _, hk in ipairs(navHotkeys) do
        hk:delete()
    end
    navHotkeys = {}
end

function M.show()
    if canvas then return end

    local workspaces = gatherWorkspaces()
    if #workspaces == 0 then return end

    local elements, screenFrame = buildElements(workspaces)

    canvas = hs.canvas.new(screenFrame)
    for _, el in ipairs(elements) do
        canvas:appendElements(el)
    end

    canvas:level(hs.canvas.windowLevels.overlay)
    canvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
    canvas:clickActivating(false)

    canvas:mouseCallback(function(_, msg, _, x, y)
        if msg == "mouseUp" then
            for i, cell in ipairs(cellMap) do
                if x >= cell.x and x <= cell.x + cell.w
                    and y >= cell.y and y <= cell.y + cell.h then
                    updateSelection(selectedIndex, i)
                    confirmSelection()
                    return
                end
            end
            M.hide()
        end
    end)

    canvas:show()
    bindNavKeys()
end

function M.hide()
    if not canvas then return end

    unbindNavKeys()
    canvas:delete()
    canvas = nil
    cellMap = {}
    selectedIndex = 1
end

function M.toggle()
    if canvas then
        M.hide()
    else
        M.show()
    end
end

function M.init(config)
    if config then
        for k, v in pairs(config) do
            M.config[k] = v
        end
    end

    if M.config.hotkey then
        triggerHotkey = hs.hotkey.bind(
            M.config.hotkey.mod,
            M.config.hotkey.key,
            function() M.toggle() end
        )
    end

    return M
end

return M
