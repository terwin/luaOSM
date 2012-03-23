package = "LuaOSM"
version = "1.0-1"

source = {
  url = "https://terwin@github.com/terwin/luaOSM.git" 
}

description = {
  summary = "OSM (OpenStreetMap) database parsing",
  detailed = [[
    LuaOSM is a simple wrapper around LuaExpat to facilitate parsing of 
    OpenStreetMap XML files.
  ]]
}

dependencies = {
  "lua >= 5.1",
  "luaexpat >= 1.2.0"
}

build = {
  type = "builtin",
  modules = {
    osm = "src/osm.lua"
  },
  copy_directories = {"examples"}
}
