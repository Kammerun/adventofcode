print("Running...\n")

-- Check
local file, err = io.open("input.txt", "r")
if err then error(err) end
if not file then return end
file:close()

local rotation = 50
local password = 0

for line_content in io.lines("input.txt") do
    if
        not line_content
        or type(line_content) ~= "string"
        or line_content == ""
    then
        return error("Error parsing file" .. line_content)
    end

    local direction = string.sub(line_content, 1, 1)
    local degrees = string.sub(line_content, 2)

    if direction == "R" then
        rotation = rotation + degrees
    elseif direction == "L" then
        rotation = rotation - degrees
    end

    if rotation % 100 == 0 then
        password = password + 1
    end
end

print("The Clock is at a Rotation of " .. rotation .. " degrees")
print("The 'Password' is \"" .. password .. "\"")

print("\nEnd of Programm")