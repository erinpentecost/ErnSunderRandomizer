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
local world = require("openmw.world")
local types = require("openmw.types")
local settings = require("scripts.ErnSunderRandomizer.settings")
local cells = require("scripts.ErnSunderRandomizer.cells").cells
local core = require("openmw.core")
local localization = core.l10n(settings.MOD_NAME)

-- getCellName returns the name of the cell or nil, if the name can't be determined.
local function getCellName(cell)
    -- Don't know how to get localized cell names.
    location = localization(cell.name)
    if location == nil then
        if cell.gridX and cell.gridY then
            index = tostring(cell.gridX) .. ", " .. tostring(cell.gridY)
            location = localization(cells[location])
        end
    end
    if location == nil then
        location = localization(cell.region)
    end
    return location
end

local function filterCell(cell)
    return getCellName(cell) ~= nil
end

local function filterNPC(npc)
    -- Try to get named NPCs.
    rec = types.NPC.record(npc)
    preliminary = (string.lower(rec.class) ~= "guard") and
        (rec.isEssential ~= true) and
        (rec.isRespawning ~= true) and
        (types.Actor.isDead(npc) ~= true)
    if preliminary ~= true then
        return false
    end

    -- Filter Blades because we're trying to keep it lore friendly.
    for _, factionId in pairs(types.NPC.getFactions(npc)) do
        if (string.lower(factionId) == "blades") then
            return false
        end
    end

    return true
end

local function getRandomNPCinCell(cell)
    size = 0
    asList = {}
    for _, npc = ipairs(cell:getAll(types.NPC)) do
        if filterNPC(npc) then
            size = size + 1
            table.insert(asList, cell)
        end
    end

    if size == 0 then
        return nil
    end

    randIndex = math.random(1, size)
    return asList[randIndex]
end

-- getChain returns a list of {cell=cell,npc=npcInstance} of length steps.
-- Each step will have a unique cell.
local function getChain(steps)
    subset = {}
    size = 0
    for _, cell in ipairs(world.cells) do
        if filterCell(cell) then
            location = getCellName(cell)
            if location ~= nil then
                holder = getRandomNPCinCell(cell)
                if holder ~= nil then
                    size = size + 1
                    -- end of table is n+1, where n is length of table
                    randIndex = math.random(1, size)
                    table.insert(subset, randIndex, {cell=cell,npc=holder})
                end
            end
        end
    end

    -- subset is now a maximum-length, randomized chain
    settings.debugPrint("Found " .. size .. " potential steps in the chain.")

    if size < steps then
        error("want " .. steps .. " steps, but found only " .. size .. " valid steps.")
        return nil
    end

    -- return first "steps" elements in subset.
    output = {}
    count = 0
    for _, step in ipairs(subset) do
        table.insert(output, step)
        count = count + 1
        if count == steps then
            return output
        end
    end
end


local function createClueRecord(number, cell, npcInstance)
    cellName = getCellName(cell)
    npcName = types.NPC.record(npc).name
    record = {
        enchant = nil,
        enchantCapacity = 0,
        icon = "m\\Tx_note_02.tga"
        id = settings .. "_clue_" .. number,
        isScroll = false,
        model = "m\\Text_Note_02.nif",
        name = localization("clue_name", {number=number}),
        skill = nil,
        text = localization("clue_body", {npc=localization(npcName), location=location}),
    }

    world.createRecord(record)
    return id
end
