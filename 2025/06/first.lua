print("Running...\n")

local start_time = os.time()

local debugmode = false

---print only in debug mode
---@param ... unknown
local function dprint(...)
    if not debugmode then return end
    print(...)
end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/string.lua#L58-L76
local pattern_escape_replacements = {
	["("] = "%(",
	[")"] = "%)",
	["."] = "%.",
	["%"] = "%%",
	["+"] = "%+",
	["-"] = "%-",
	["*"] = "%*",
	["?"] = "%?",
	["["] = "%[",
	["]"] = "%]",
	["^"] = "%^",
	["$"] = "%$",
	["\0"] = "%z"
}

function string.PatternSafe( str )
	return ( string.gsub( str, ".", pattern_escape_replacements ) )
end

-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/string.lua#L258-L261
function string.Trim( s, char )
	if ( char ) then char = string.PatternSafe( char ) else char = "%s" end
	return string.match( s, "^" .. char .. "*(.-)" .. char .. "*$" ) or s
end

local function ParseFileToTable()
    local full_table = {}

    local row = 1
    for line_content in io.lines("input.txt") do
        if
            not line_content
            or type(line_content) ~= "string"
            or line_content == ""
        then
            return error("Error parsing file" .. line_content)
        end

        local line_tbl = {}
        while true do
            local pos = string.find(line_content, " ")
            if not pos then
                -- add last element
                local num = string.Trim(string.sub(line_content, 1))
                    if num ~= "+" and num ~= "*" then
                        num = tonumber(num)
                    end
                    table.insert(line_tbl, num)
                break
            end

            local num = string.Trim(string.sub(line_content, 1, pos - 1))
            line_content = string.sub(line_content, pos + 1)

            if num ~= "" then
                if num ~= "+" and num ~= "*" then
                    num = tonumber(num)
                end
                table.insert(line_tbl, num)
            end
        end

        table.insert(full_table, line_tbl)

        row = row + 1
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
if not tbl then return end

for k,v in pairs(tbl) do
    print(k, v[1], v[2], v[3], v[4])
    print()
end

for column = 1, #tbl[1] do
    local column_value = tbl[1][column]

    for row = 2, #tbl - 1 do
        local operation = tbl[#tbl][column]

        if operation == "+" then
            column_value = column_value + tbl[row][column]
        else
            column_value = column_value * tbl[row][column]
        end
    end

    print("The " .. column .. ". Column has a Value of: " .. column_value)
    password = password + column_value
end

print("The 'Password' is \"" .. string.format("%.f", password) .. "\"")

print("\nEnd of Programm")

local end_time = os.time()
print("Programm took " .. os.difftime(end_time, start_time) .. " seconds to execute")