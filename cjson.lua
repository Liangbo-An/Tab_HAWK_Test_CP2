-- Simple Lua JSON Library
local M = {}

-- Encode function: Converts Lua data into a JSON string
--value = {0xAAAAAAAA,0x55555555,0x000000ff,0x00000000}
function M.encode(value)
    local t = type(value)
    if t == "number" then
        return tostring(value)  -- Convert number to string
    elseif t == "string" then
        return string.format("%q", value)  -- Automatically escape strings
    elseif t == "boolean" then
        return value and "true" or "false"  -- Convert boolean to "true" or "false"
    elseif t == "table" then
        local result = {}
        local is_array = true
        for k, v in pairs(value) do
            if type(k) ~= "number" then
                is_array = false  -- If the key is not a number, it's not an array
                break
            end
        end

        if is_array then
            -- Handle array format
            for _, v in ipairs(value) do
                table.insert(result, M.encode(v))
            end
            return "[" .. table.concat(result, ",") .. "]"
        else
            -- Handle object format
            for k, v in pairs(value) do
                table.insert(result, string.format("%q:%s", k, M.encode(v)))
            end
            return "{" .. table.concat(result, ",") .. "}"
        end
    elseif t == "nil" then
        return "null"  -- Represent nil as "null"
    else
        error("Unsupported type: " .. t)
    end
end

-- Decode function: Parses JSON string and converts it back into Lua data
function M.decode(str)
    local pos = 1
    local function parse_value()
        local c = str:sub(pos, pos)
        if c == "{" then
            -- Parse object
            pos = pos + 1
            local result = {}
            while true do
                -- Skip whitespace characters
                while str:sub(pos, pos) == " " or str:sub(pos, pos) == "\t" or str:sub(pos, pos) == "\n" or str:sub(pos, pos) == "\r" do
                    pos = pos + 1
                end

                if str:sub(pos, pos) == "}" then
                    pos = pos + 1
                    break
                end

                local key = parse_value()
                while str:sub(pos, pos) == " " or str:sub(pos, pos) == "\t" do
                    pos = pos + 1
                end

                if str:sub(pos, pos) ~= ":" then
                    error("Expected ':' after key in object")
                end
                pos = pos + 1

                local value = parse_value()
                result[key] = value

                -- Skip whitespace characters
                while str:sub(pos, pos) == " " or str:sub(pos, pos) == "\t" do
                    pos = pos + 1
                end

                if str:sub(pos, pos) == "," then
                    pos = pos + 1
                elseif str:sub(pos, pos) == "}" then
                    pos = pos + 1
                    break
                else
                    error("Expected ',' or '}' in object")
                end
            end
            return result
        elseif c == "[" then
            -- Parse array
            pos = pos + 1
            local result = {}
            while true do
                -- Skip whitespace characters
                while str:sub(pos, pos) == " " or str:sub(pos, pos) == "\t" or str:sub(pos, pos) == "\n" or str:sub(pos, pos) == "\r" do
                    pos = pos + 1
                end

                if str:sub(pos, pos) == "]" then
                    pos = pos + 1
                    break
                end

                local value = parse_value()
                table.insert(result, value)

                -- Skip whitespace characters
                while str:sub(pos, pos) == " " or str:sub(pos, pos) == "\t" do
                    pos = pos + 1
                end

                if str:sub(pos, pos) == "," then
                    pos = pos + 1
                elseif str:sub(pos, pos) == "]" then
                    pos = pos + 1
                    break
                else
                    error("Expected ',' or ']' in array")
                end
            end
            return result
        elseif c == "\"" then
            -- Parse string
            pos = pos + 1
            local start_pos = pos
            while true do
                local c = str:sub(pos, pos)
                if c == "\"" then
                    local result = str:sub(start_pos, pos - 1)
                    pos = pos + 1
                    return result
                elseif c == "\\" then
                    -- Skip escape characters
                    pos = pos + 2
                else
                    pos = pos + 1
                end
            end
        elseif c == "t" and str:sub(pos, pos + 3) == "true" then
            pos = pos + 4
            return true
        elseif c == "f" and str:sub(pos, pos + 4) == "false" then
            pos = pos + 5
            return false
        elseif c == "n" and str:sub(pos, pos + 3) == "null" then
            pos = pos + 4
            return nil
        elseif c == "-" or c:match("[0-9]") then
            -- Parse number
            local start_pos = pos
            while true do
                local c = str:sub(pos, pos)
                if not c:match("[0-9%.eE+-]") then
                    break
                end
                pos = pos + 1
            end
            return tonumber(str:sub(start_pos, pos - 1))
        else
            error("Unexpected character: " .. c)
        end
    end

    -- Start parsing
    return parse_value()
end

return M
