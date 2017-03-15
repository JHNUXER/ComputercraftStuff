local index = 1

local dfs = {}
local dirs = {}
local files = {}
local finalList = {}

local shifted = false

local function iPath(p)
  return "/"..shell.dir().."/"..p
end

local function cd(d)
  if d == ".." then shell.setDir(fs.getDir(shell.dir())) else shell.setDir(iPath(d)) end
  return shell.dir()
end

local function isDir(text)
  return isDir(iPath(text))
end
local function textify(text)
  if isDir(text) then text = "[ "..text.." ]" else text = "- "..text.." -" end
  return text
end

local function grabFiles()
  dfs = fs.list("/"..shell.dir())
  for i = 1,#dfs do
    if isDir(dfs[i]) then table.insert(dirs,dfs[i]) else table.insert(files,dfs[i]) end
  end
  for i = 1,#dirs do
    table.insert(finalList,dirs[i])
  end
  for i = 1,#files do
    table.insert(finalList,files[i])
  end
end
local function clearFiles()
  dfs = {}
  dirs = {}
  files = {}
  finalList = {}
end

local function draw()
  c()
  for i = 1,#finalList do
    local text = textify(finalList[i])
    if i == index then text = "> "..text else text = "  "..text end
    print(text)
  end
end

local function getKeyPress()
  local _,k,_ = os.pullEvent("key")
  local key = keys.getName(k)
  if key == "shift" then shifted = true else return key end
end
local function moveIndex(k)
  if k == "up" then
    if index > 1 then
      index = index - 1
    else
      index = #finalList
    end
  elseif k == "down" then
    if index <#finalList then
      index = index + 1
    else
      index = 1
    end
  end
end
local function newFile()
  c()
  p("New File: ")
  local pt = iPath(r())
  fs.open(pt,"w").close()
  shell.run("edit "..pt)
end
local function newDirectory()
  c()
  p("New Directory: ")
  fs.makeDir(iPath(r()))
end
local function newStuff()
  local stop = false
  local indx = 1
  local mOptions = {"[ Directory ]","[ File ]"}
  while not stop do
    c()
    for i = 1,#mOptions do
      text = mOptions[i]
      if i == indx then text = "> "..text else text = "  "..text end
      pl(text)
    end
    local _,k,_ = os.pullEvent("key")
    local key = keys.getName(k)
    if key == "one" then
      newDirectory()
    elseif key == "two" then
      newFile()
    end
    stop = true
  end
end
local function delete(f) fs.delete(iPath(f)) end
local function waitForKeyPress()
  local key = getKeyPress()
  if key == "left" then
    cd("..")
  elseif key == "right" then
    cd(finalList[index])
  elseif (key == "up") or (key == "down") then moveIndex(key)
  elseif key == "n" then newStuff()
  elseif key == "delete" then delete(finalList[index])
  end
end

while true do
  c()
  clearFiles()
  grabFiles()
  draw()
  waitForKeyPress()
  sleep(0.1)
end
