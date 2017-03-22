local Menu = {}
function Menu:new(sId)
	o = {}
	setmetatable(o,self)
	self.id = sId
	self.index = 1
	self.options = {}
	self.addOption = function(opt)
		table.insert(self,opt)
	end
	return o
end

local menus = {
	Menu:new("mainmenu"),
	Menu:new("files")
}

local function fileBrowser()
	local index = 1
	local dfs = {}
	local dirs = {}
	local files = {}
	local finalList = {}
	
	local function resolve(p)
		return "/"..shell.dir.."/"..p
	end
	local function indexOf(p)
		for i = 1,#dfs do
			if finalList[i] == p then return i end
		end
	end
	local function textify(text)
		local k = text
		if isDir(text) then k = "[ "..text.." ]" else k = "- "..text.." -" end
		if indexOf(p) == index then k = "> "..k else k = "  "..k end
	end
	local function draw()
		term.clear()
		term.setCursorPos(1,1)
		for i = 1,#dfs do
			local text = textify(finalList[i])
			print(text)
		end
	end
	local keyFunctions = {
		["up"] = moveIndexUp,
		["down"] = moveIndexDown,
		["left"] = function() shell.setDir(fs.getDir(shell.dir())) end
		["right"] = function() shell.run("")
	}
	local function waitForKeyPress()
		local key = getKeyPress()
		
	end
	while true do
	end
end
