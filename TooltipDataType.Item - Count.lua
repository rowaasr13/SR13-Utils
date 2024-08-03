local GetItemCount = C_Item.GetItemCount

local str_pieces = {}
local function TooltipAddCount(tooltip, data)
    -- _G.DEVTOOL_DEBUG = _G.DEVTOOL_DEBUG or {}
    -- _G.DEVTOOL_DEBUG.ItemTooltip_data = data

    local item_id = data.id
    if not item_id then return end

    -- count = C_Item.GetItemCount(itemInfo [, includeBank, includeUses, includeReagentBank, includeAccountBank])
    local bag_bank_account =                          GetItemCount(item_id, true, false, true, true)
    local bag_bank         = bag_bank_account > 0 and GetItemCount(item_id, true, false, true, false) or 0
    local bag              = bag_bank > 0         and GetItemCount(item_id, false, false, false, false) or 0

    local only_account = bag_bank_account - bag_bank
    local only_bank = bag_bank - bag

    wipe(str_pieces)
    local idx = 0

    if bag > 0          then idx = idx + 1 str_pieces[idx] = "Bag: " .. bag end
    if only_bank > 0    then idx = idx + 1 str_pieces[idx] = "Bank: " .. only_bank end
    if only_account > 0 then idx = idx + 1 str_pieces[idx] = "Account: " .. only_account end
    if idx == 0 or idx > 1 then idx = idx + 1 str_pieces[idx] = "Total: " .. bag_bank_account end

    tooltip:AddLine(table.concat(str_pieces, ' '), 0, 1, 1)
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, TooltipAddCount)
