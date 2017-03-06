function CreateMap1()

return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 14,
  height = 14,
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
    },
    {
      name = "collision_graphic",
      firstgid = 133,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "graphics/collision_graphic.png",
      imagewidth = 32,
      imageheight = 32,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "tilelayer",
      x = 0,
      y = 0,
      width = 14,
      height = 14,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 1, 2, 3, 4, 2, 2, 3, 4, 5, 6, 10, 11, 0,
        0, 57, 13, 14, 15, 13, 13, 14, 15, 16, 17, 21, 57, 0,
        0, 72, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 72, 0,
        0, 72, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 72, 0,
        0, 72, 73, 73, 73, 1, 48, 48, 11, 73, 73, 73, 72, 0,
        0, 72, 73, 73, 73, 23, 29, 29, 33, 73, 73, 73, 72, 0,
        0, 72, 73, 73, 73, 45, 48, 48, 55, 73, 73, 73, 72, 0,
        0, 72, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 72, 0,
        0, 72, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 72, 0,
        0, 72, 72, 73, 73, 73, 73, 73, 73, 73, 73, 73, 72, 0,
        0, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 0,
        0, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 63, 66, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "decoration",
      x = 0,
      y = 0,
      width = 14,
      height = 14,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 30, 0, 0, 30, 0, 0, 30, 0, 0, 0, 0, 0,
        0, 0, 41, 0, 0, 41, 0, 0, 41, 0, 115, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 126, 0, 0, 0,
        0, 0, 74, 77, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 85, 88, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 85, 88, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 85, 99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 85, 99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 107, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "collision",
      x = 0,
      y = 0,
      width = 14,
      height = 14,
      visible = true,
      opacity = 0.49,
      properties = {},
      encoding = "lua",
      data = {
        133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133,
        133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133,
        133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 0, 133, 133,
        133, 0, 0, 0, 0, 0, 0, 0, 0, 0, 133, 0, 0, 133,
        133, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 133,
        133, 0, 0, 0, 0, 133, 133, 133, 133, 0, 0, 0, 0, 133,
        133, 0, 0, 0, 0, 133, 0, 0, 133, 0, 0, 0, 0, 133,
        133, 0, 0, 0, 0, 133, 133, 133, 133, 0, 0, 0, 0, 133,
        133, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 133,
        133, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 133,
        133, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 133,
        133, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 133,
        133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 0, 133, 133, 133,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "tilelayer",
      x = 0,
      y = 0,
      width = 14,
      height = 14,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0,
        0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0,
        0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0,
        0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0,
        0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0,
        0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0,
        0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0,
        0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0,
        0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0,
        0, 45, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 55, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "decoration",
      x = 0,
      y = 0,
      width = 14,
      height = 14,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 31, 0, 0, 0, 0, 0, 31, 0, 0, 0, 0, 0,
        0, 0, 42, 0, 0, 0, 0, 0, 42, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "collision",
      x = 0,
      y = 0,
      width = 14,
      height = 14,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
end
