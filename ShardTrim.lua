local ADDON_PREFIX = "|cff55ff55[ShardTrim]|r"
local SOUL_SHARD_ID = 6265
local DEFAULT_KEEP_COUNT = 4

-- Saved variables
ShardTrimDB = ShardTrimDB or {}
ShardTrimDB.keepCount = ShardTrimDB.keepCount or DEFAULT_KEEP_COUNT

local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(ADDON_PREFIX .. " " .. msg)
end

local function ShowHelp()
    Print("Usage:")
    Print("  /shardtrim           - Trim all excess Soul Shards to the saved amount")
    Print("  /shardtrim <number>  - Set how many Soul Shards to keep")
    Print("  /shardtrim reset     - Reset to default (" .. DEFAULT_KEEP_COUNT .. ")")
    Print("  /shardtrim help      - Show this help")
    Print("  /st                  - Alias for /shardtrim")
end

-- Recursive function to delete shards safely with retry if cursor isn't ready
local function DeleteShards(shards, index, KEEP_COUNT)
    if index > #shards or index <= KEEP_COUNT then
        Print("Trimming complete.")
        return
    end

    local bag, slot = shards[index][1], shards[index][2]

    -- Clear cursor before picking up
    if CursorHasItem() then
        ClearCursor()
    end

    -- Try to pick up the shard
    C_Container.PickupContainerItem(bag, slot)

    if CursorHasItem() then
        -- Delete it if successfully on cursor
        DeleteCursorItem()
        -- Delay before moving to the next shard
        C_Timer.After(0.08, function()
            DeleteShards(shards, index + 1, KEEP_COUNT)
        end)
    else
        -- Retry same shard after a short delay
        C_Timer.After(0.05, function()
            DeleteShards(shards, index, KEEP_COUNT)
        end)
    end
end

local function ShardTrim(msg)
    if not C_Container or not C_Container.GetContainerNumSlots then
        Print("|cffff5555Container API not available.|r")
        return
    end

    if InCombatLockdown() then
        Print("|cffffff00Cannot delete Soul Shards while in combat.|r")
        return
    end

    msg = msg and msg:lower():gsub("^%s*(.-)%s*$", "%1") or ""

    -- Help
    if msg == "help" then
        ShowHelp()
        return
    end

    -- Reset
    if msg == "reset" then
        ShardTrimDB.keepCount = DEFAULT_KEEP_COUNT
        Print("Shard limit reset to " .. DEFAULT_KEEP_COUNT .. ".")
        return
    end

    -- Set new keep count
    if msg ~= "" then
        local newCount = tonumber(msg)
        if not newCount or newCount < 0 then
            Print("|cffff5555Invalid shard count.|r")
            return
        end

        ShardTrimDB.keepCount = math.floor(newCount)
        Print("Will keep " .. ShardTrimDB.keepCount .. " Soul Shard(s).")
        return
    end

    local KEEP_COUNT = ShardTrimDB.keepCount
    local shards = {}

    -- Scan bags
    for bag = 0, 4 do
        local slots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, slots do
            if C_Container.GetContainerItemID(bag, slot) == SOUL_SHARD_ID then
                shards[#shards + 1] = { bag, slot }
            end
        end
    end

    local totalShards = #shards
    local extras = totalShards - KEEP_COUNT

    if extras <= 0 then
        Print("No Soul Shards need trimming.")
        return
    end

    Print("Trimming " .. extras .. " extra Soul Shard(s)...")
    DeleteShards(shards, KEEP_COUNT + 1, KEEP_COUNT)
end

-- Slash commands
SLASH_SHARDTRIM1 = "/shardtrim"
SLASH_SHARDTRIM2 = "/st"
SlashCmdList.SHARDTRIM = ShardTrim