local ADDON_PREFIX = "|cff55ff55[ShardTrim]|r"
local SOUL_SHARD_ID = 6265
local DEFAULT_KEEP_COUNT = 4

ShardTrimDB = ShardTrimDB or {}
ShardTrimDB.keepCount = ShardTrimDB.keepCount or DEFAULT_KEEP_COUNT

local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(ADDON_PREFIX .. " " .. msg)
end

local function ShowHelp()
    Print("Usage:")
    Print("  /shardtrim           - Trim ONE excess Soul Shard")
    Print("  /shardtrim <number>  - Set how many Soul Shards to keep")
    Print("  /shardtrim reset     - Reset to default (" .. DEFAULT_KEEP_COUNT .. ")")
    Print("  /st                  - Alias for /shardtrim")
end

local function GetSoulShards()
    local shards = {}

    for bag = 0, 4 do
        local slots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, slots do
            if C_Container.GetContainerItemID(bag, slot) == SOUL_SHARD_ID then
                shards[#shards + 1] = { bag, slot }
            end
        end
    end

    return shards
end

local function DeleteShard()
    if InCombatLockdown() then
        Print("|cffffff00Cannot delete Soul Shards while in combat.|r")
        return
    end

    if CursorHasItem() then
        ClearCursor()
        return
    end

    local KEEP_COUNT = ShardTrimDB.keepCount
    local shards = GetSoulShards()
    local total = #shards
    local excess = total - KEEP_COUNT

    if excess <= 0 then
        return
    end

    local bag, slot = shards[KEEP_COUNT + 1][1], shards[KEEP_COUNT + 1][2]

    C_Container.PickupContainerItem(bag, slot)

    if CursorHasItem() then
        DeleteCursorItem()
    end
end

local function ShardTrim(msg)
    msg = msg and msg:lower():gsub("^%s*(.-)%s*$", "%1") or ""

    if msg == "help" then
        ShowHelp()
        return
    end

    if msg == "reset" then
        ShardTrimDB.keepCount = DEFAULT_KEEP_COUNT
        Print("Shard limit reset to " .. DEFAULT_KEEP_COUNT .. ".")
        return
    end

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

    DeleteShard()
end

SLASH_SHARDTRIM1 = "/shardtrim"
SLASH_SHARDTRIM2 = "/st"
SlashCmdList.SHARDTRIM = ShardTrim