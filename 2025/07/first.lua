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

        local line_tbl = {}
        for i = 1, #line_content do
            line_tbl[i] = line_content:sub(i, i)
        end
        table.insert(full_table, line_tbl)
    end

    return full_table
end

local function GetStartingPoint(tbl)
    -- Start at "S" (theres only one)
    local first_row = tbl[1]
    local start_pos
    for index, v in ipairs(first_row) do
        if v == "S" then
            start_pos = index
        end
    end

    if not start_pos then error("Couldn't find Starting Point 'S'") end
    return start_pos
end

local function MoveBeam()
end

-- Check
local file, err = io.open("input.txt", "r")
if err then error(err) end
if not file then return end
file:close()

local password = 0

-- get the full table
local tbl = ParseFileToTable()
if not tbl then error("Error Parsing Table") return end
local start_pos = GetStartingPoint(tbl)
print("Starting Point (S) at : '" .. start_pos .. "'")

-- row_value is the TABLE containing all the values of the row 
for row, row_value in ipairs(tbl) do
    -- if first row start the beam
    if row == 1 then
        -- Set the "." under the "S" to "|"
        tbl[2][start_pos] = "|"
        goto continue
    end


    -- column_value is the CHAR containing ONE value! 
    for column, char in ipairs(row_value) do
        io.write(char)

        -- Check for every char if it is a "|"
        -- then check the spot under the "|"
        -- if its a "." change it to "|"
        -- if its a "^" change the symbol "." on the right and left to "|"
        --         dont change the symbol "^"!

        local char_x, char_y = column, row
        if (char ~= "|" or char_y + 1 > #tbl) then goto next_char end

        local char_under = tbl[char_y + 1][char_x]
        if char_under == "." then
            tbl[char_y + 1][char_x] = "|"
        elseif char_under == "^" then
            -- the "^" got hit so password += 1
            password = password + 1

            -- if its a "." change it to "|"
            -- if its a "^" change the symbol "." on the right and left to "|"
            --         dont change the symbol "^"!

            -- check left symbol
            if char_x - 1 >= 1 then
                local char_under_left = tbl[char_y + 1][char_x - 1]
                --io.write("Char on the Left is:" .. char_under_left .. " ;")

                if char_under_left == "." then
                    tbl[char_y + 1][char_x - 1] = "|"
                end
            end

            if char_x + 1 <= #tbl[1] then
                local char_under_right = tbl[char_y + 1][char_x + 1]
                --io.write("Char on the Right is:" .. char_under_right .. " ;")

                if char_under_right == "." then
                    tbl[char_y + 1][char_x + 1] = "|"
                end
            end
        end

        ::next_char::
    end

    ::continue::
    io.write("\n")
end

print("The 'Password' is \"" .. string.format("%.f", password) .. "\"")

print("\nEnd of Programm")

local end_time = os.time()
print("Programm took " .. os.difftime(end_time, start_time) .. " seconds to execute")