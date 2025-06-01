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
local settings = require("scripts.ErnSunderRandomizer.settings")
local storage = require("openmw.storage")
local swapTable = require("scripts.ErnSunderRandomizer.swaptable")

if require("openmw.core").API_REVISION < 62 then
    error("OpenMW 0.49 or newer is required!")
end

-- Init settings first to init storage which is used everywhere.
settings.initSettings()

-- stepTable holds step info. This is filled once Dagoth Vemyn is activated.
local stepTable = storage.globalSection(S.MOD_NAME .. "StepTable")
stepTable:setLifeTime(storage.LIFE_TIME.Temporary)

local function saveState()
    return stepTable:asTable()
end

local function loadState(saved)
    stepTable:reset(saved)
end

return {
    engineHandlers = {
        onSave = saveState,
        onLoad = loadState
    }
}
