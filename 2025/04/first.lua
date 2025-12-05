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

local password = 0

local content_tbl = ParseFileToTable()
if not content_tbl then error("content_tbl is nil - Error parsing file") end

for index_row, row in ipairs(content_tbl) do
    for index_column, column in ipairs(row) do
        if column == "@" then
            dprint("Checking for: (" .. index_row .. "," .. index_column .. ")")

            -- Start at -1 because we are counting the paper roll we are checking too
            local surrounding_paper_rolls = -1
            -- check all 8 surrounding spots
            for i = 1, 3 do
                local y = index_column - 2 + i
                dprint("y = " .. y)
                dprint(y > 0, y <= #row, y > 0 and y <= #row)
                if y > 0 and y <= #row then
                    for j = 1, 3 do
                        local x = index_row - 2 + j
                        dprint("x = " .. x)
                        dprint(x > 0, x < #content_tbl, x > 0 and x <= #content_tbl)
                        if x > 0 and x <= #content_tbl then
                            -- (x,y)
                            -- (1,1) | (2,1) | (3,1)
                            -- (1,2) | (2,2) | (3,2)
                            -- (1,3) | (2,3) | (3,3)

                            local value = content_tbl[x][y]
                            dprint("Checked square : (" .. x .. "," .. y .. ")" .. " is " .. value)

                            if value == "@" then
                                surrounding_paper_rolls = surrounding_paper_rolls + 1
                            end
                        end
                    end
                    dprint(column)
                end
            end
            dprint(column)
            dprint(surrounding_paper_rolls)

            if surrounding_paper_rolls < 4 then
                password = password + 1
            end
        end
    end
end

print("The 'Password' is \"" .. string.format("%.f", password) .. "\"")

print("\nEnd of Programm")

local end_time = os.time()
print("Programm took " .. os.difftime(end_time, start_time) .. " seconds to execute")