print("Running...\n")

local start_time = os.time()

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
---@param id any -- 
---@return boolean
local function CheckID(id)
    dprint("checking id: " .. id)
    local bvalid
    local part_one, part_two
    local length = string.len(id)
    local half_len = length / 2
    if length % 2 ~= 0 then
        bvalid = true
    else
        part_one = tonumber(string.sub(id, 1, half_len))
        part_two = tonumber(string.sub(id, half_len + 1))

        bvalid = part_one ~= part_two
    end

    for part_len = 1, length do
        if bvalid == false then break end

        if length % part_len == 0 and length ~= part_len then
            local parts = length
            local first_part = string.sub(id, 1, part_len)

            dprint(parts)

            local all_same = true
            local second_part
            for j = 2, parts + 1 do

                local first_num = (j - 1) * part_len + 1
                local second_num = j * part_len

                if first_num > length or second_num > length then break end

                dprint("FIRST NUM = " .. first_num .. " SECOND NUM = " .. second_num)
                second_part = string.sub(id, first_num, second_num)
                dprint("1:: " .. first_part .. " 2:: " .. second_part .. " Bool:: " .. tostring(first_part == second_part))
                if first_part ~= second_part then
                    all_same = false
                end
            end

            -- if all of them are the same then the id has repeatable patterns and is invalid
            bvalid = not all_same
        end
    end

    dprint("ID is " .. tostring(bvalid))
    return bvalid
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