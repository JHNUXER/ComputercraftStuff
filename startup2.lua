local c = function() term.clear() term.setCursorPos(1,1) end

local function fileBrowser()
	local index = 1
	local dfs = {}
	local dirs = {}
	local files = {}
	local finalList = {}
	
	local function resolve(p)
		return "/"..shell.dir().."/"..p
	end
	local function isDir(p)
		return fs.isDir(resolve(p))
	end
	local function indexOf(p)
		for i = 1,#finalList do
			if finalList[i] == p then return i end
		end
	end
	local function textify(text)
		local k = text
		if isDir(text) then k = "[ "..text.." ]" else k = "- "..text.." -" end
		if indexOf(text) == index then k = "> "..k else k = "  "..k end
		return k
	end
	local function draw()
		c()
		for i = 1,#finalList do
			print(textify(finalList[i]))
		end
	end
	local function moveIndexUp()
		if index > 1 then
			index = index - 1
		else
			index = #finalList
		end
	end
	local function moveIndexDown()
		if index < #finalList then
			index = index + 1
		else
			index = 1
		end
	end
	local function exec()
		if not isDir(finalList[index]) then shell.run("edit "..resolve(finalList[index])) else shell.setDir(resolve(finalList[index])) end
	end
	local keyFunctions = {
		["up"] = moveIndexUp,
		["down"] = moveIndexDown,
		["left"] = function() shell.setDir(fs.getDir(shell.dir())) end,
		["right"] = function() return nil end,
		["enter"] = exec,
		["tab"] = function() return nil end
	}
	local function grabFiles()
		dfs = fs.list(shell.dir())
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
	local function getKeyPress()
		local _,k,_ = os.pullEvent("key")
		local key = keys.getName(k)
		keyFunctions[key]()
	end
	while true do
		clearFiles()
		grabFiles()
		draw()
		getKeyPress()
		sleep(0.1)
	end
end

fileBrowser()
