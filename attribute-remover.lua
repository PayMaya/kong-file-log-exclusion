local attribute_remover = {}

-- from: https://gist.github.com/tylerneylon/81333721109155b2d244
local function deep_copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end

  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do
    res[deep_copy(k, s)] = deep_copy(v, s)
  end
  return res
end

local function delete_attribute(source, attribute)
  local table = source
  local iterator = attribute:gmatch("([^.%s]+)")
  for k in iterator do  
    if type(table[k]) ~= "table" then
      attribute = k
      break
    end
    table = table[k]
  end 
  if not iterator() then
    table[attribute] = nil
  end
end

function attribute_remover.delete_attributes(source, attributes)
  source = deep_copy(source)
  for index, attribute in ipairs(attributes) do
    delete_attribute(source, attribute)
  end
  return source
end

return attribute_remover
