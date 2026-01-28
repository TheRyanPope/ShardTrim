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
    Print("  /shardtrim           - Trim Soul Shards to the saved amount")
    Print("  /shardtrim <number>  - Set how many Soul Shards to keep")
    Print("  /shardtrim reset     - Reset to default (" .. DEFAULT_KEEP_COUNT .. ")")
    Print("  /shardtrim help      - Show this help")
end

local function TrimShards(msg)
    if not C_Container or not C_Container.GetContainerNumSlots then
        Print("|cffff5555Container API not available.|r")
        return
    end

    if InCombatLockdown() then
        Print("|cffffff00Cannot delete Soul Shards while in combat.|r")
        return
    end

    msg = msg and msg:lower():trim() or ""

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

    local deleted, failed = 0, 0

    -- Delete extras
    for i = KEEP_COUNT + 1, #shards do
        local bag, slot = shards[i][1], shards[i][2]

        C_Container.PickupContainerItem(bag, slot)

        if CursorHasItem() then
            DeleteCursorItem()
            deleted = deleted + 1
        else
            failed = failed + 1
            Print("|cffff5555Delete failed|r (bag " .. bag .. ", slot " .. slot .. ")")
        end

        ClearCursor()
    end

    if deleted > 0 then
        Print("Deleted " .. deleted .. " extra Soul Shard(s).")
    else
        Print("No Soul Shards needed trimming.")
    end

    if failed > 0 then
        Print("|cffffff00" .. failed .. " Soul Shard(s) could not be deleted — try again.|r")
    end
end

SLASH_SHARDTRIM1 = "/shardtrim"
SLASH_SHARDTRIM2 = "/st"
SlashCmdList.SHARDTRIM = TrimShards
