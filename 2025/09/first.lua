print("Running...\n")

local start_time = os.time()

local debugmode = false

---print only in debug mode
---@param ... unknown
local function dprint(...)
    if not debugmode then return end
    print(...)
end

local function ParseFileToTable()
    local full_table = {}
    for line_content in io.lines("input.txt") do
        if
            not line_content
            or type(line_content) ~= "string"
            or line_content == ""
        then
            return error("Error parsing file" .. line_content)
        end


        local part_one, part_two
        local pos = string.find(line_content, ",")

        if not pos then
            error("Seperating ',' is Missing")
        end

        part_one = tonumber(string.sub(line_content, 1, pos - 1))
        part_two = tonumber(string.sub(line_content, pos + 1))
        dprint(part_one, part_two)
        table.insert(full_table, {part_one, part_two})
    end

    return full_table
end


-- Check
local file, err = io.open("input.txt", "r")
if err then error(err) end
if not file then return end
file:close()

local password = 0

local tbl = ParseFileToTable()
if not tbl then error("Error parsing table") end

for row, row_value in ipairs(tbl) do
    local x, y = row_value[1], row_value[2]

    for crow, crow_value in ipairs(tbl) do
        local cx, cy = crow_value[1], crow_value[2]
        local square_size = (math.max(cx, x) - math.min(cx, x) + 1) * (math.max(cy, y) - math.min(cy, y) + 1)
    
        if square_size > password then
            password = square_size
        end
    end
end

print("The 'Password' is \"" .. string.format("%.f", password) .. "\"")

print("\nEnd of Programm")

local end_time = os.time()
print("Programm took " .. os.difftime(end_time, start_time) .. " seconds to execute")