--[[
ErnSunderRandomizer for OpenMW.
Copyright (C) 2025 Erin Pentecost

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

local core = require("openmw.core")
local storage = require("openmw.storage")
local types = require("openmw.types")


local stepTable = storage.globalSection(S.MOD_NAME .. "StepTable")
stepTable:setLifeTime(storage.LIFE_TIME.Temporary)


local function hideItemOnce(actor, itemRecordID)
    -- don't repeat work.
    if stepTable:get("huntActive_" .. itemRecordID) ~= true then
        return
    end

    -- does actor even have the item?
    item = types.Actor.inventory(actor):find(itemRecordID)
    if item == nil then
        recordName = types.NPC.record(self).id
        error("actor " .. recordName .. " doesn't have " .. itemRecordID)
        return
    end

    -- send event
    core.sendGlobalEvent("LMhideItem", {
        actor = actor,
        itemRecordID = itemRecordID,
    })
    -- mark as done
    stepTable:set("huntActive_" .. itemRecordID, true)
end

return {
    hideItemOnce = hideItemOnce,
}