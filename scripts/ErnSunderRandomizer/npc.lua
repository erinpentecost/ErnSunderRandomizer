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
local self = require("openmw.self")
local types = require("openmw.types")
local common = require("scripts.ErnSunderRandomizer.common")
local settings = require("scripts.ErnSunderRandomizer.settings")

if require("openmw.core").API_REVISION < 62 then
    error("OpenMW 0.49 or newer is required!")
end

local function onActive()
    id = self.id
    if id == false then
        settings.debugPrint("npc doesn't have an id???")
        return
    end

    -- filters so things don't get out of hand
    if self.type ~= types.NPC then
        settings.debugPrint("npc script not applied on an NPC")
        return
    end

    if types.NPC.objectIsInstance(self) == false then
        settings.debugPrint("not an instance!")
        return
    end

    record = types.NPC.record(self)
    if record == nil then
        settings.debugPrint("npc " .. id .. " has no record?")
        return
    end

    if string.lower(record.id) == "dagoth vemyn" then
        common.hideItemOnce(self, "sunder")
    end

end

return {
    engineHandlers = {
        onActive = onActive
    }
}
