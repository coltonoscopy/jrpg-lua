return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 8,
  height = 7,
  tilewidth = 32,
  tileheight = 32,
  properties = {},
  tilesets = {
    {
      name = "atlas",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "../tilemap-12-solution/atlas.png",
      imagewidth = 512,
      imageheight = 512,
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
      width = 8,
      height = 7,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 5, 7, 1, 1, 1,
        1, 1, 1, 5, 7, 1, 2, 3,
        1, 1, 1, 5, 7, 1, 5, 6,
        1, 1, 1, 5, 7, 1, 5, 6,
        1, 1, 2, 11, 7, 1, 5, 6,
        1, 1, 5, 6, 7, 1, 8, 9,
        1, 1, 5, 6, 7, 1, 1, 1
      }
    }
  }
}
