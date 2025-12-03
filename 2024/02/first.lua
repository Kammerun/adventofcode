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

-- dir (bool). increasing = true, decreasing = false 
local dir
for line_content in io.lines("input.txt") do
    local save = true

    dprint("Checking line \"" .. line_content .. "\"")

    if
        not line_content
        or type(line_content) ~= "string"
        or line_content == ""
    then
        return error("Error parsing file" .. line_content)
    end

    -- https://stackoverflow.com/questions/20423406/lua-convert-string-to-table
    local tbl = {}
    while true do
        local next_space = string.find(line_content, " ")
        if not next_space then
            table.insert(tbl, tonumber(line_content))
            break
        end

        local num = tonumber(string.sub(line_content, 1, next_space - 1))
        table.insert(tbl, num)
        line_content = string.sub(line_content, next_space + 1)
    end

    for i = 1, #tbl - 1 do
        local left_num = tbl[i]
        local right_num = tbl[i + 1]

        dprint(left_num, right_num)

        if left_num == right_num then
            dprint("The " .. i .. ". Element: " .. left_num .. " and the next Element are the same: " .. right_num)
            save = false
            break
        end

        -- set dir
        if i == 1 then
            dir = left_num < right_num
        end

        if dir ~= (left_num < right_num) then
            save = false
            break
        end

        if (math.max(left_num, right_num) - math.min(left_num, right_num)) > 3 then
            save = false
            break
        end
    end

    if save then
        password = password + 1
    end
end

print("The 'Password' is \"" .. string.format("%.f", password) .. "\"")

print("\nEnd of Programm")

local end_time = os.time()
print("Programm took " .. os.difftime(end_time, start_time) .. " seconds to execute")