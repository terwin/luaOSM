osm = require'osm'

types = {}
roles = {}

callbacks = {
  node = function(atts, tags)
  end,
  way = function(atts, tags, nodes)
  end,
  relation = function(atts, tags, members)
    for _,mem in ipairs(members) do
      if types[mem.type] then
        types[mem.type] = types[mem.type] + 1
      else
        types[mem.type] = 1
      end
      if roles[mem.role] then
        roles[mem.role] = roles[mem.role] + 1
      else
        roles[mem.role] = 1
      end
    end
  end,
}

p = osm.new(callbacks)

for l in io.lines('data.osm') do
  p:parse(l..'\n')
end
p:parse()
p:close()

print('types:')
osm.print_counts(types, 2)
print('roles:')
osm.print_counts(roles, 2)

