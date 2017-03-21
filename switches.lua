local switches = {
  {
    name = "Reactor",
    id = "reac-alpha",
    state = false,
  }
}

local switch_functions = {
  ["reac-alpha"] = function() return nil end
}

local function getSwitch(sId)
  for i = 1,#switches do
    if switches[i].id == sId then return switches[i] end
  end
end

local function toggle()
end
