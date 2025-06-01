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
local clue = require("scripts.ErnSunderRandomizer.clue")
local types = require("openmw.types")
local common = require("scripts.ErnSunderRandomizer.common")

if require("openmw.core").API_REVISION < 62 then
    error("OpenMW 0.49 or newer is required!")
end

common.initCommon()

-- Init settings first to init storage which is used everywhere.
settings.initSettings()

local function saveState()
    return common.stepTable:asTable()
end

local function loadState(saved)
    common.stepTable:reset(saved)
end

-- data.actor is the current posssessor
-- data.itemRecordID is the item to hide.
local function hideItem(data)
    settings.debugPrint("hideItem started")

    -- input validation
    actor = data.actor
    if actor == nil then
        error("hideItem handler passed in nil actor")
        return
    end
    itemRecordID = data.itemRecordID
    if itemRecordID == nil then
        error("hideItem handler passed in nil itemRecordID")
        return
    end

    -- find treasure
    dvInventory = types.Actor.inventory(actor)
    treasureInstance = dvInventory:find(itemRecordID)
    if treasureInstance == nil then
        error("possesor doesn't have " .. itemRecordID)
        return
    end

    -- build clue chain
    totalSteps = settings.stepCount()
    chain = clue.getChain(totalSteps)
    if chain == nil then
        error("failed to create chain")
        return
    end

    -- put actor at start of chain.
    table.insert(chain, 1, {
        cell=nil,
        npc=actor,
    })

    -- mark so we don't hide this again
    common.markAsHidden(actor, itemRecordID)

    for i, step in ipairs(chain) do
        if i == totalSteps then
            -- last in the chain. move item here.
            inventory = types.Actor.inventory(step.npc)
            treasureInstance:moveInto(inventory)
        else
            -- each npc should have a clue pointing to the next.
            nextStep = chain[i+1]
            noteRecord = clue.createClueRecord(i, nextStep.cell, nextStep.npc)
            noteInstance = world.createObject(noteRecord)
            noteInstance:moveInto(step.npc)
        end
    end
end

return {
    eventHandlers = {
        LMhideItem = hideItem
    },
    engineHandlers = {
        onSave = saveState,
        onLoad = loadState
    }
}
