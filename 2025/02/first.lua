print("Running...\n")

local debugmode = false

---print only in debug mode
---@param ... unknown
local function dprint(...)
    if not debugmode then return end
    print(...)
end


---Returns all IDs in a Table
---@param content string
---@return table
local function GetIDs(content)
    local tbl = {}

    while true do
    --[[ for _ = 1, 3, 1 do ]]
        local pos = string.find(content, ",")
        dprint(pos)

        if not pos then
            if content ~= "" then
                table.insert(tbl, content)
            end
            break
        end

        local current_id = string.sub(content, 1, pos - 1)
        content = string.sub(content, pos + 1)
        dprint(current_id)
        dprint(content .. "\n\n")

        table.insert(tbl, current_id)
    end

    return tbl
end

---Sepertaes the ids at the "-"
---@param full_id string
---@return integer
---@return integer
local function SeperateIDPair(full_id)
    local part_one, part_two

    local pos = string.find(full_id, "-")
    dprint(pos)

    if not pos then
        error("Seperating '-' is Missing")
    end

    part_one = tonumber(string.sub(full_id, 1, pos - 1))
    part_two = tonumber(string.sub(full_id, pos + 1))

    if not (part_one and part_two) then error("ID is invalid") end

    dprint(part_one)
    dprint(part_two .. "\n\n")

    return part_one, part_two
end

---Checks if supplied ID is valid or not
---@param id number
---@return boolean
local function CheckID(id)
    local part_one, part_two
    local lenght = string.len(id)
    if lenght % 2 ~= 0 then
        return true
    end
    local half_len = lenght / 2
    part_one = tonumber(string.sub(id, 1, half_len))
    part_two = tonumber(string.sub(id, half_len + 1))

    return part_one ~= part_two
end

local file, err = io.open("input.txt", "r")
if err then error(err) end
if not file then return end

local solution = 0

local content = file:read("*a")
local ids = GetIDs(content)

for _, id in pairs(ids) do
    dprint(id)

    local min, max = SeperateIDPair(id)
    dprint(min, max)

    for num = min, max, 1 do
        local valid_id = CheckID(num)

        if not valid_id then
            solution = solution + num
        end
    end
end



file:close()
print("The Sum of all invalid IDs is \"" .. solution .. "\"")
print("\nEnd of Programm")