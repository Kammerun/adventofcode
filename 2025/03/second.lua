print("Running...\n")

local start_time = os.time()

local debugmode = false

---print only in debug mode
---@param ... unknown
local function dprint(...)
    if not debugmode then return end
    print(...)
end


-- Check
local file, err = io.open("input.txt", "r")
if err then error(err) end
if not file then return end
file:close()

local password = 0

for line_content in io.lines("input.txt") do
    if
        not line_content
        or type(line_content) ~= "string"
        or line_content == ""
    then
        return error("Error parsing file" .. line_content)
    end

    -- https://stackoverflow.com/questions/20423406/lua-convert-string-to-table
    local tbl= {}
    line_content:gsub(".", function(c) table.insert(tbl, tonumber(c)) end)

    local first_num = 0
    local first_num_index = 1
    -- first num cant be one of the last 12 entrys cause other entrys need to be behind
    for index = 1, #tbl - 12 do
        if first_num < tbl[index] then
            first_num = tbl[index]
            first_num_index = index
        end
    end

    dprint("Die Erste Nummer ist : " .. first_num .. " an der Stelle " .. first_num_index)

    local rest_value = ""

    local last_num_index = first_num_index
    local remaining_nums = 11
    for times = 1, remaining_nums do
        dprint("Table ist " .. #tbl .. " long", "Remaining Numbers to get are " .. remaining_nums)
        dprint("Suche die " .. times + 1 .. ". Nummer, Range: " .. last_num_index + 1 .. " - " .. #tbl - (remaining_nums - 1))

        local next_num = 0
        for index = last_num_index + 1, #tbl - (remaining_nums - 1) do
            if next_num < tbl[index] then
                next_num = tbl[index]
                last_num_index = index
            end
        end

        remaining_nums = remaining_nums - 1
        dprint("Die " .. times + 1 .. ". Nummer ist: " .. next_num .. " an der Stelle: " .. last_num_index)

        rest_value = tostring(rest_value) .. tostring(next_num)
    end

    -- add values as strings
    local line_value = tostring(first_num) .. tostring(rest_value)
    dprint(line_value)

    password = password + tonumber(line_value)
end

print("The 'Password' is \"" .. string.format("%.f", password) .. "\"")

print("\nEnd of Programm")

local end_time = os.time()
print("Programm took " .. os.difftime(end_time, start_time) .. " seconds to execute")