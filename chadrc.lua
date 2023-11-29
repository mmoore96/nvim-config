---@type ChadrcConfig 
 local M = {}
 M.ui = {
  theme = 'catppuccin',
  transparency = true,
 nvdash = {
  load_on_startup = false,
  header = {
    "                                                                        ",
    "                                                          OOO           ",
    "                                                         OO OO    OOO   ",
    " PPP                                                      000    00 00  ",
    " P PP             T                T   I                          OOO   ",
    " P PP RRR   OO  TTTTT  EE    CCC TTTTT   VV  VV  EE      ** **          ",
    " PPP  R  R O  O   T   E  E  C      T   I V    V E  E     ** **   ** **  ",
    " P    R    O  O   T   EEEE C       T   I  V  V  EEEE    **   ** **  **  ",
    " P    R    O  O   T   E     C      T   I   VV   E      **     ***    ** ",
    " P    R     OO    T   EEEE   CCC   T   I   VV   EEEE  ***    ****  ***  ",
    "                                                            ** ** ***   ",
    "                                                            ** **       ",
    "                                                                        ",
  },
},
}
 M.plugins = "custom.plugins"
 M.mappings = require "custom.mappings"
 return M
