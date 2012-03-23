osm = require'osm'

count = 0

types = {}
roles = {}

callbacks = {
  node = function(atts, tags)
  end,
  way = function(atts, tags, nodes)
    if tags.highway and valid_highways[tags.highway] then
      if tags.name then 
        count = count + 1 
        name = '"'..tags.name..'"'
      else
        name = '"<none>"'
        --print(tags.highway)
      end
      print(atts.id, tags.highway, name, nodes[1], nodes[#nodes])
    end
  end,
  relation = function(atts, tags, members)
  end,
}

p = osm.new(callbacks)

for l in io.lines('data.osm') do
  p:parse(l..'\n')
end
p:parse()
p:close()

