require "IncPbCommon"

TableManagerForLua={}
TableManagerForLua.ToolsList={}
TableManagerForLua.euipmentFragmentList={}

local function load_ToolsTable()
	if TableManagerForLua.ToolsList == nil or table.maxn(TableManagerForLua.ToolsList)<=0 then
        TableManagerForLua.ToolsList={}
        local tabel = TableReaderManager:getInstance():getTableReader("Tools.txt")
        local count = tabel:getLineCount()-1;
        for i = 1,count do
            local index = i
            if index then
                TableManagerForLua.ToolsList[index] = {}
                TableManagerForLua.ToolsList[index].itemID=tonumber(tabel:getData(i,0))
                TableManagerForLua.ToolsList[index].name=tabel:getData(i,1)
                TableManagerForLua.ToolsList[index].describe=tabel:getData(i,2)
                TableManagerForLua.ToolsList[index].price=tonumber(tabel:getData(i,3))
                TableManagerForLua.ToolsList[index].priceType=tonumber(tabel:getData(i,4))
                TableManagerForLua.ToolsList[index].operationType=tonumber(tabel:getData(i,5))
                TableManagerForLua.ToolsList[index].jumpPage=tabel:getData(i,6)
                TableManagerForLua.ToolsList[index].buttonString=tabel:getData(i,7)
                TableManagerForLua.ToolsList[index].iconPic=tabel:getData(i,8)
                TableManagerForLua.ToolsList[index].bodyPic=tabel:getData(i,9)
                TableManagerForLua.ToolsList[index].namePic="none"
                TableManagerForLua.ToolsList[index].originPrice=tonumber(tabel:getData(i,10))
                TableManagerForLua.ToolsList[index].pageID=tonumber(tabel:getData(i,11))
                TableManagerForLua.ToolsList[index].buyCountLimit=tonumber(tabel:getData(i,12))
                TableManagerForLua.ToolsList[index].includeStr=tabel:getData(i,13)
                TableManagerForLua.ToolsList[index].includeOther=tabel:getData(i,13)
                TableManagerForLua.ToolsList[index].isStone=tonumber(tabel:getData(i,14))
                TableManagerForLua.ToolsList[index].showInBag=tonumber(tabel:getData(i,15))
            end
        end
	end
end
load_ToolsTable()

local function load_equipmentFragment()
    if TableManagerForLua.equipmentFragmentList == nil or table.maxn(TableManagerForLua.equipmentFragmentList)<=0 then
        TableManagerForLua.equipmentFragmentList={}
        local tabel = TableReaderManager:getInstance():getTableReader("equipmentFragment.txt")
        local count = tabel:getLineCount()-1;
        for i = 1,count do
            local index = tonumber(tabel:getData(i,0))
            if index then
                TableManagerForLua.equipmentFragmentList[index] = {}
                TableManagerForLua.equipmentFragmentList[index].itemID=tonumber(tabel:getData(i,0))
                TableManagerForLua.equipmentFragmentList[index].pieceTarget=tabel:getData(i,1)
                TableManagerForLua.equipmentFragmentList[index].pieceConsume=tabel:getData(i,2)
                TableManagerForLua.equipmentFragmentList[index].pieceRate=tabel:getData(i,3)
            end
        end
    end
end
load_equipmentFragment()


ConfigManager = {
	configs = {}
}

function ConfigManager.loadCfg(fileName, attrMap, indexPos)
	local tableCfg = TableReaderManager:getInstance():getTableReader(fileName)
	local count = tableCfg:getLineCount() - 1
	local Cfg = {}
	for i = 1, count do
		local index = indexPos ~= nil and tonumber(tableCfg:getData(i, indexPos)) or i
		if index then
			Cfg[index] = {}
			for attr, pos in pairs(attrMap) do
				Cfg[index][attr] = tableCfg:getData(i, pos)
			end
		end
	end
	return Cfg
end

function ConfigManager.getWishingTreeCfg()
	if ConfigManager.configs["WishingTree"] == nil then
		local fileName = "WishingTreeList.txt"
		local tableCfg = TableReaderManager:getInstance():getTableReader(fileName)
		local count = tableCfg:getLineCount() - 1
		local Cfg = {}
		for i = 1, count do
			local index = tonumber(tableCfg:getData(i, 0))
			if index then
				Cfg[index] = {
					from = index,
					options = {},
					isOpen = tonumber(tableCfg:getData(i, 5))
				}
				for j = 1, 4 do
					local optionData = Split(tableCfg:getData(i, j), ':', 3)
					local option = {
						type = tonumber(optionData[1]),
						id = tonumber(optionData[2]),
						count = tonumber(optionData[3])
					}
					table.insert(Cfg[index]["options"], option)
				end
				Cfg[index]["to"] = Cfg[index]["options"][4]["id"]
			end
		end
		ConfigManager.configs["WishingTree"] = Cfg
	end

	return ConfigManager.configs["WishingTree"]
end

function ConfigManager.getFullDiscipleList()
	if ConfigManager.configs["discipleList"] == nil then
		ConfigManager.configs["discipleList"] = ConfigManager.loadCfg("Disciples.txt", {id=0}, 0)
	end
	return ConfigManager.configs["discipleList"]
end

function ConfigManager.getWishTimesCfg()
	if ConfigManager.configs["wishingTreeTimes"] == nil then
		local attr2Pos = {
			vipLevel = 0,
			freeTimes = 1,
			totalTimes = 2
		}
		ConfigManager.configs["wishingTreeTimes"] = ConfigManager.loadCfg("WishingTreeVipData.txt", attr2Pos)
	end
	return ConfigManager.configs["wishingTreeTimes"]
end

function ConfigManager.getWishingTreeHelpInfo()
	if ConfigManager.configs["wishingTreeHelp"] == nil then
		local wishingHelpType = {
			COMMON = 1,
			TAROT = 2,
			REFER = 3
		}
		local fileName = "WishingTreeHelp.txt"
		local tableCfg = TableReaderManager:getInstance():getTableReader(fileName)
		local count = tableCfg:getLineCount() - 1
		local Cfg = {}
		for i = 1, count do
			local type = tonumber(tableCfg:getData(i, 0))
			if type then
				local title = tableCfg:getData(i, 1)
				local content = tableCfg:getData(i, 2)
				local pic = tableCfg:getData(i, 3)
				if type == wishingHelpType.REFER then
					table.foreach(ConfigManager.getWishingTreeCfg(), function(k, wishCfg)
						local wishFrom = DiscipleTableManager:getInstance():getDiscipleItemByID(wishCfg["from"])
						local wishTo = DiscipleTableManager:getInstance():getDiscipleItemByID(wishCfg["to"])
						local cfgItem = {
							type = type,
							title = title,
							content = content,
							pic = pic
						}
						cfgItem.content = string.gsub(content, "#1", wishFrom.name)
						cfgItem.content = string.gsub(cfgItem.content, "#2", wishTo.name)
						table.insert(Cfg, cfgItem)
					end)
				else
					if type == wishingHelpType.TAROT then
						pic = nil
					end
					local cfgItem = {
						type = type,
						title = title,
						content = content,
						pic = pic
					}
					table.insert(Cfg, cfgItem)
				end
			end
		end
		ConfigManager.configs["wishingTreeHelp"] = Cfg
	end
	return ConfigManager.configs["wishingTreeHelp"]
end

function ConfigManager.getExchanges()
	if ConfigManager.configs["exchanges"] == nil then
		local fileName = "Exchanges.txt"
		local tableCfg = TableReaderManager:getInstance():getTableReader(fileName)
		local count = tableCfg:getLineCount() - 1
		local Cfg = {}
		for i = 1, count do
			local index = tonumber(tableCfg:getData(i, 0))
			if index then
				Cfg[index] = {
					from = ConfigManager._getItemCfg(tableCfg:getData(i, 1)),
					add = {},
					to = {},
					rewardType = tonumber(tableCfg:getData(i, 4))
				}
				for k, str in ipairs(Split(tableCfg:getData(i, 2), ";")) do
					table.insert(Cfg[index]["add"], ConfigManager._getItemCfg(str))
				end
				for k, str in ipairs(Split(tableCfg:getData(i, 3), ";")) do
					table.insert(Cfg[index]["to"], ConfigManager._getItemCfg(str))
				end
			end
		end
		ConfigManager.configs["exchanges"] = Cfg
	end
	return ConfigManager.configs["exchanges"]
end

function ConfigManager._getItemCfg(itemStr)
	local cfgAttr = {"type", "id", "count"}
	local cfg = {}
	for index, val in ipairs(Split(itemStr, ":")) do
		cfg[cfgAttr[index]] = tonumber(val)
	end
	return cfg
end

function ConfigManager.getCallOfLufeiHelpInfo()
	if ConfigManager.configs["callOfLufeiHelp"] == nil then
		local attr2Pos = {
			title = 0,
			content = 1
		}
		ConfigManager.configs["callOfLufeiHelp"] = ConfigManager.loadCfg("CallOfLufeiHelp.txt", attr2Pos)
	end
	return ConfigManager.configs["callOfLufeiHelp"]
end
