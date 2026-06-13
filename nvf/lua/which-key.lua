local wk = require("which-key")

wk.register({
  c = { name = "[C]ode" },
  d = { name = "[D]ocument" },
  r = { name = "[R]ename" },
  s = { name = "[S]earch" },
  w = { name = "[W]orkspace" },
  t = { name = "[T]oggle" },
  g = {
    name = "[G]it",
    h = { name = "Git [H]unk" },
  },
}, { prefix = "<leader>" })
