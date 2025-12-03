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
    -- first num cant be last entry cause second entry needs to be behind
    for index = 1, #tbl - 1 do
        if first_num < tbl[index] then
            first_num = tbl[index]
            first_num_index = index
        end
    end

    local second_num = 0
    -- get second num | we start searching BEHIND the first num
    for index = first_num_index + 1, #tbl do
        if second_num < tbl[index] then
            second_num = tbl[index]
        end
    end

    -- add values as strings
    local line_value = tostring(first_num) .. tostring(second_num)
    dprint(line_value)

    password = password + tonumber(line_value)
end

print("The 'Password' is \"" .. password .. "\"")

print("\nEnd of Programm")

local end_time = os.time()
print("Programm took " .. os.difftime(end_time, start_time) .. " seconds to execute")