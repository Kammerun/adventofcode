print("Running...\n")

local start_time = os.time()

local debugmode = false

---print only in debug mode
---@param ... unknown
local function dprint(...)
    if not debugmode then return end
    print(...)
end

local function ParseFileToTables()
    local ranges = {}
    local ingredient_ids = {}

    local get_ranges = true

    for line_content in io.lines("input.txt") do
        if
            not line_content
            or type(line_content) ~= "string"
        then
            return error("Error parsing file" .. line_content)
        end

        if line_content == "" then
            get_ranges = false
        end

        if get_ranges then
            local part_one, part_two
            local pos = string.find(line_content, "-")

            if not pos then
                error("Seperating '-' is Missing")
            end

            part_one = tonumber(string.sub(line_content, 1, pos - 1))
            part_two = tonumber(string.sub(line_content, pos + 1))
            table.insert(ranges, {part_one, part_two})
        else
            if line_content ~= "" then
                table.insert(ingredient_ids, tonumber(line_content))
            end
        end
    end

    return ranges, ingredient_ids
end

-- Check
local file, err = io.open("input.txt", "r")
if err then error(err) end
if not file then return end
file:close()

local ranges, ingredient_ids = ParseFileToTables()
if not (ranges and ingredient_ids) then return end

for _, v in ipairs(ranges) do
    dprint(v[1], v[2])
end

for _, v in ipairs(ingredient_ids) do
    dprint(v)
end

local password = 0
for _, id in ipairs(ingredient_ids) do
    dprint("Checking Number: " .. id)
    -- check for each ingredient id if it is in any given range
    for _, range_pair in ipairs(ranges) do
        if id >= range_pair[1] and id <= range_pair[2] then
            dprint("Number " .. id .. " is safe!")
            password = password + 1
            break -- !!!
        end
    end
end

print("The 'Password' is \"" .. string.format("%.f", password) .. "\"")

print("\nEnd of Programm")

local end_time = os.time()
print("Programm took " .. os.difftime(end_time, start_time) .. " seconds to execute")