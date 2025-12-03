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

local function ReadNumbers(line)
    local first_num = string.sub(line, 1, 5)
    local second_num = string.sub(line, 8)

    return first_num, second_num
end

local tbl_left = {}
local tbl_right = {}

local function GetLineContent()
    for line_content in io.lines("input.txt") do
        if
            not line_content
            or type(line_content) ~= "string"
            or line_content == ""
        then
            return error("Error parsing file" .. line_content)
        end

        local first_num, second_num = ReadNumbers(line_content)
        dprint(first_num, second_num)

        table.insert(tbl_left, first_num)
        table.insert(tbl_right, second_num)
    end
end

GetLineContent()

for index_l = 1, #tbl_left do
    for index_r = 1, #tbl_right do
        --print(tbl_left[index_l], tbl_right[index_r], tonumber(tbl_left[index_l]) == tonumber(tbl_right[index_r]))
        if tonumber(tbl_left[index_l]) == tonumber(tbl_right[index_r]) then
            password = password + tbl_right[index_r]
        end
    end
end

print("The 'Password' is \"" .. password .. "\"")

local end_time = os.time()
print("\nProgramm took " .. os.difftime(end_time, start_time) .. " seconds to execute")

print("\nEnd of Programm")

