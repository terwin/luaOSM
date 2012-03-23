local lxp = require'lxp'

local M = {}

local stack = setmetatable({},{
  __call = function()
    return setmetatable({},{__index = {
      push = function(s,v) 
        s[#s+1] = v 
        return v
      end,
      pop = function(s) 
        local res = s[#s]
        s[#s] = nil 
        return res
      end,
      top = function(s) 
        return s[#s]
      end,
      print = function(s)
        for i = #s,1,-1 do
          print(s[i])
        end
      end
    }})
  end
})

local clear = function(t)
  for k,_ in pairs(t) do
    t[k] = nil
  end
end

local function hiho(cb)
  local s = stack()
  local tags, nodes, members = {}, {}, {}
  local att_save = {}
  return {
    StartElement = function(p, name, atts)
      local parent = s:top()
      s:push(name)

      if parent == 'osm' then
        clear(tags)
        clear(nodes)
        clear(members)
        att_save[1] = atts
      elseif parent == 'node' or parent == 'way' or parent == 'relation' then
        if name == 'tag' then
          tags[atts.k] = atts.v
        elseif name == 'nd' then
          nodes[#nodes+1] = atts.ref
        elseif name == 'member' then
          members[#members+1] = atts
        end
      end
    end,
    EndElement = function(p, name)
      s:pop()
      if name == 'node' then
        cb.node(att_save[1], tags)
      elseif name == 'way' then
        cb.way(att_save[1], tags, nodes)
      elseif name ==  'relation' then
        cb.relation(att_save[1], tags, members)
      end
    end
  }
end

function M.new(cb)
  if type(cb) ~= 'table' then error("Must provide callback table", 2) end
  if type(cb.node) ~= 'function' then error("Must provide node callback function", 2) end
  if type(cb.way) ~= 'function' then error("Must provide way callback function", 2) end
  if type(cb.relation) ~= 'function' then error("Must provide relation callback function", 2) end
  return lxp.new(hiho(cb))
end

function M.print_counts(counts, indent)
  local indent = indent or 0
  local list = {}
  local maxlen = 5

  for k,v in pairs(counts) do
    list[#list + 1] = k
    maxlen = math.max(maxlen, k:len())
  end

  table.sort(list, function(a, b) return counts[a] > counts[b] end)

  local total = 0

  for i,v in ipairs(list) do
    print(string.format(string.rep(' ',indent)..'%-'..(maxlen)..'s: %d', v, counts[v]))
    total = total + counts[v]
  end
  print(string.format(string.rep(' ',indent)..'%-'..(maxlen)..'s: %d', 'total', total))
end

debug.traceback = nil

return M
