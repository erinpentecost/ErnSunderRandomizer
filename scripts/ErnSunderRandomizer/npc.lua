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
local self = require("openmw.self")
local storage = require("openmw.storage")
local types = require("openmw.types")
local swapTable = require("scripts.ErnSunderRandomizer.swaptable")

local stepTable = storage.globalSection(S.MOD_NAME .. "StepTable")

if require("openmw.core").API_REVISION < 62 then
    error("OpenMW 0.49 or newer is required!")
end


local function onActive()
    id = self.id
    if id == false then
        S.debugPrint("npc doesn't have an id???")
        return
    end

    -- filters so things don't get out of hand
    if self.type ~= types.NPC then
        S.debugPrint("npc script not applied on an NPC")
        return
    end

    if types.NPC.objectIsInstance(self) == false then
        S.debugPrint("not an instance!")
        return
    end

    record = types.NPC.record(self)
    if record == nil then
        S.debugPrint("npc " .. id .. " has no record?")
        return
    end


    -- todo:
    -- if npc is in the chain (not termination though):
    -- * add note
    -- * mark as done, so we don't re-add note
    -- if npc is end of chain:
    -- * add sunder if they don't have one
    -- * mark as done, so we don't re-add sunder
    if swapMarker:get(id, true) then
        S.debugPrint("npc " .. id .. " already handled")
        return
    end
end

return {
    engineHandlers = {
        onActive = onActive
    }
}
