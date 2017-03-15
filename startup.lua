local index = 1

local dfs = {}
local dirs = {}
local files = {}
local finalList = {}

local shifted = false

local function path(p)
	return "/"..shell.dir().."/"..p
end

local function cd(d)
	if d == ".." then shell.setDir(fs.getDir(shell.dir())) else shell.setDir(path(d)) end
	return shell.dir()
end

local function draw()
	for i = 1,#finalList do
	  local text = finalList[i]
	  if i == index then text = "> "..text else text = "  "..text end
	end
end

local function getKeyPress() local _,k,h = os.pullEvent("key") local key = keys.getName(k) if key == "shift" then shifted = true break else return key end
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
	local pt = path(r())
	fs.open(pt,"w").close()
	shell.run("edit "..pt)
end
local function newDirectory()
	c()
	p("New Directory: ")
	fs.makeDir(path(r()))
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
local function delete(f) fs.delete(path(f)) end
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
end
