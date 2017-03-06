function CreateMap1()
return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 12,
  height = 12,
  tilewidth = 16,
  tileheight = 16,
  properties = {},
  tilesets = {
    {
      name = "rpg_indoor",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "graphics/rpg_indoor.png",
      imagewidth = 176,
      imageheight = 192,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 12,
      height = 12,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        1, 2, 3, 4, 2, 2, 3, 4, 5, 6, 10, 11,
        12, 13, 14, 15, 13, 13, 14, 15, 16, 17, 21, 22,
        94, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 70,
        94, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 81,
        94, 73, 73, 73, 1, 48, 48, 11, 73, 73, 73, 70,
        94, 73, 73, 73, 23, 29, 29, 33, 73, 73, 73, 70,
        94, 73, 73, 73, 45, 48, 48, 55, 73, 73, 73, 70,
        94, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 70,
        94, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 70,
        94, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 70,
        45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 52, 55,
        56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 63, 66
      }
    }
  }
}
end
