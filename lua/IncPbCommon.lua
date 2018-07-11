require "UserSoulInfo_pb"
require "UserSkillInfo_pb"
require "SkillBookInfo_pb"
require "UserEquipInfo_pb"
require "UserDiscipleInfo_pb"
require "UserToolInfo_pb"
require "UserEquipInfo_pb"
require "UserBattleArray_pb"
require "UserBattle_pb"
require "AdventureInfo_pb"

DropManager = {}

function getRewardInfo(msg)
    if msg~=nil then
        local contentTable=getResTable(msg)
        if contentTable~=nil then
            local contentStr=""
            local j=1
            for i=1,table.maxn(contentTable) do
                local info=ResManager:getInstance():getResInfoByTypeAndId(contentTable[i].type,contentTable[i].itemId,contentTable[i].count)
                if j~=1 then
                    contentStr=contentStr..","
                end
                contentStr=contentStr..info.name.."x"..info.count
                j=j+1
            end
            return contentStr
        end
        return msg
    else
        return msg
    end
end

function autoReturn(s, width)
    local les = string.len(s)
    local ret = ""
    local count = 0
    for i=1,les do
        local v = string.byte(s,i)
        if bit:band(v,128)==0 then
            count = count + 0.5
            if(count>width)then
                ret = ret .. "\n"
                count = 0
            end
        end
        if bit:band(v,128)~=0 and bit:band(v,64)~=0 then
            count = count + 1
            if(count>width)then
                ret = ret .. "\n"
                count = 0
            end
        end
        ret = ret .. string.char(v)
    end
    return ret
end

function Split(str, delim, maxNb)
    if string.find(str, delim) == nil then
        return {str}
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

function getResTable(str)
    local  _tableItem=Split(str,",")
    local _tableRes={}
    if _tableItem==str then
       local _resItem=Split(str,":")
       if _resItem==str then
           _resItem=nil
       else
           _tableRes[1]={}
            if table.maxn(_resItem)==3 then
                _tableRes[1].type=_resItem[1]
                _tableRes[1].itemId=_resItem[2]
                _tableRes[1].count=_resItem[3]
            else
                _tableRes[1]=nil
            end
       end
    else
        for i=1, table.maxn(_tableItem) do
            _tableRes[i]={}
            local _resItem=Split(_tableItem[i],":")
            if _resItem==str then
                _tableRes[i]=nil
            else
                if table.maxn(_resItem)==3 then
                    _tableRes[i].type=_resItem[1]
                    _tableRes[i].itemId=_resItem[2]
                    _tableRes[i].count=_resItem[3]
                else
                    _tableRes[i]=nil
                end
            end
        end
    end
    return _tableRes
end

function getToolsCount(itemId)
    local _toolsInfo=ServerDateManager:getInstance():getUserToolInfoByItemId(itemId)
    local _count=0
    if _toolsInfo~=nil then
        _count=_toolsInfo.count
    end
    return _count
end

function DropManager.updateToolCount(itemId, count)
	local userToolInfo = ServerDateManager:getInstance():getUserToolInfoByItemId(itemId)
	if userToolInfo ~= nil then
		userToolInfo.count = count
	end
end

function DropManager.gotEquipment(info)
    local userEquipInfo = ServerDateManager:getInstance():getAndCreatUserEquipInfo(info.id)
	userEquipInfo.itemid		= info.itemid
	userEquipInfo.level		    = info.level
	userEquipInfo.refinexp		= info.refinexp
	userEquipInfo.refinelevel	= info.refinelevel
    userEquipInfo.buffvalue     = info.buffvalue
	
	for index, propInfo in ipairs(info.pInfo) do
		if propInfo.type ~= nil then
			userEquipInfo:setPropertyInfoByKey(propInfo.type, propInfo.num)
		end
	end
	for pos, stoneInfo in ipairs(info.stoneInfo) do
		if stoneInfo ~= nil then
			userEquipInfo:setStoneInfoByPosition(pos, stoneInfo)
		end
	end
end

function DropManager.gotTool(info)
    local userToolInfo = ServerDateManager:getInstance():getAndCreatToolInfo(info.id)
	userToolInfo.itemid	= info.itemid
	userToolInfo.count	= info.count
	ServerDateManager:getInstance():creatUserToolKeyMapByToolItem(userToolInfo)
end

function DropManager.gotSkill(info)
    local skillInfo = ServerDateManager:getInstance():getAndCreatSkillInfo(info.id)
	skillInfo.itemid		= info.itemid
	skillInfo.level		    = info.level
	skillInfo.quantity		= info.quantity
	skillInfo.consume		= info.consume
	if info.isborn ~= 0 then
	    skillInfo.isBornSkill	= true
	else
	    skillInfo.isBornSkill	= false
	end
end

function DropManager.gotSoul(info)
    local soulInfo = ServerDateManager:getInstance():getAndCreatSoulInfo(info.id)
	soulInfo.itemid	= info.itemid
	soulInfo.count	= info.count
end

function DropManager.gotDisciple(info)
    local userDiscipleInfo = ServerDateManager:getInstance():getAndCreatDiscipleInfo(info.id)
	userDiscipleInfo.itemid		= info.itemid
	userDiscipleInfo.level		= info.level
	userDiscipleInfo.exp		= info.exp
	userDiscipleInfo.health		= info.health
	userDiscipleInfo.attack		= info.attack
	userDiscipleInfo.defence	= info.defence
	userDiscipleInfo.rp			= info.rp
	userDiscipleInfo.upgradelevel	= info.upgradelevel
	userDiscipleInfo.potentiality	= info.potentiality
	userDiscipleInfo.skill1		= info.skill1
	userDiscipleInfo.battleid		= info.battleid
	userDiscipleInfo.preLevel      = info.level
end

function DropManager.gotSkillBook(info)
    if ServerDateManager:getInstance():getAdventureItemInfoMapTotalNum()==0 then
		--[[
        local msg = AdventureInfo_pb.OPAdventureInfo()
        msg.version = 1
        local pb_data = msg:SerializeToString()
        container:sendPakcet(105,pb_data,#pb_data,true)
        --]]
    else 
        if info.partId ==0 then
			ServerDateManager:getInstance():addSkillBookPieceChanceBySkillId(info.skilld,info.count)
		else
			ServerDateManager:getInstance():addSkillBookPartBySkillIdAndPartId(info.skillId,info.partId,info.count)
		end
    end
end

function DropManager.addSoul(info)
	local soulInfo = ServerDateManager:getInstance():getAndCreatSoulInfo(info.id)
	soulInfo.itemid	= info.itemid
	if soulInfo.count ~= nil then
		soulInfo.count	= soulInfo.count + info.count
	else
		soulInfo.count = info.count
	end
end

function DropManager.gotRewards(rewardMsg)
	if rewardMsg.discipleInfo ~= nil then
		for _, info in ipairs(rewardMsg.discipleInfo) do
			DropManager.gotDisciple(info)
		end
	end
	if rewardMsg.soulInfo ~= nil then
		for _, info in ipairs(rewardMsg.soulInfo) do
			DropManager.gotSoul(info)
		end
	end
	if rewardMsg.toolInfo ~= nil then
		for _, info in ipairs(rewardMsg.toolInfo) do
			DropManager.gotTool(info)
		end
	end
	if rewardMsg.equipInfo ~= nil then
		for _, info in ipairs(rewardMsg.equipInfo) do
			DropManager.gotEquipment(info)
		end
	end
	if rewardMsg.skillInfo ~= nil then
		for _, info in ipairs(rewardMsg.skillInfo) do
			DropManager.gotSkill(info)
		end
	end
	if rewardMsg.silverCoins ~= nil then
		ScriptMathToLua:modifySilverCoins(rewardMsg.silverCoins)
	end
	if rewardMsg.goldCoins ~= nil then
		ServerDateManager:getInstance():getUserBasicInfo().goldcoins = tonumber(rewardMsg.goldCoins)
	end
end

UserDiscipleManager = {}

function UserDiscipleManager.getAllUserDisciple()
	local list = {}

	local indexMax = ServerDateManager:getInstance():getDiscipleInfoTotalNum() - 1
	for index = 0, indexMax do
		table.insert(list, ServerDateManager:getInstance():getUserDiscipleInfoByIndex(index))
	end
	return list
end

UserSoulManager = {}

function UserSoulManager.getAllUserSoul()
	local list = {}

	local indexMax = ServerDateManager:getInstance():getSoulInfoTotalNum() - 1
	for index = 0, indexMax do
		table.insert(list, ServerDateManager:getInstance():getUserSoulInfoByIndex(index))
	end
	return list
end

function UserSoulManager.getUserSoulInfoByItemID(itemId)
	for _, userSoul in ipairs(UserSoulManager.getAllUserSoul()) do
		if itemId == userSoul.itemid then
			return userSoul
		end
	end
	return nil
end

common = {}

function common:setStringForLabel(container, strMap)
	for name, str in pairs(strMap) do
		local node = container:getVarLabelBMFont(name)
		if node then
			node:setString(tostring(str))
		else
			CCLuaLog("noSuchLabelBMFont====>" .. name)
		end
	end
end

function common:getSettingVar(varName)
	local setting, name = VaribleManager:getInstance():getSetting(varName)
	return setting
end


function common:getColorFromSetting(varName)
	--parseColor3B returns multi value
	local color3B = StringConverter:parseColor3B(self:getSettingVar(varName))
	return color3B
end

function common:setBlackBoardVariable(key, val)
	key = tostring(key)
	if BlackBoard:getInstance():hasVarible(key) then
		BlackBoard:getInstance():setVarible(key, val)
	else
		BlackBoard:getInstance():addVarible(key, val)
	end
end

function common:second2DateString(second)
	local hms = Split(GameMaths:formatSecondsToTime(second), ":")
	local dateStr = ""

	local h = tonumber(hms[1])
	if h > 0 then
		if h >= 24 then
			local d = math.floor(h / 24)
			dateStr = d .. Language:getInstance():getString("@Days")
		end
		dateStr = dateStr .. (h % 24) .. Language:getInstance():getString("@Hour")
	end

	local m = tonumber(hms[2])
	if h > 0 or m > 0 then
		dateStr = dateStr .. m .. Language:getInstance():getString("@Minute")
	end

	local s = tonumber(hms[3])
	dateStr = dateStr .. s .. Language:getInstance():getString("@Second")

	return dateStr
end

function common:showGiftPackage(itemId)
	local item = ToolTableManager:getInstance():getToolItemByID(itemId)
	if self:trim(item.includeStr) == "" then return end
	local gifts = Split(item.includeStr, ",")

	GoodsViewPage.mViewGoodsListInfo = {}
	for index, giftStr in ipairs(gifts) do
		local giftInfo = Split(giftStr, ":")
		self:table_map(giftInfo, tonumber)
		local gift = ResManager:getInstance():getResInfoByTypeAndId(giftInfo[1], giftInfo[2], giftInfo[3])
		GoodsViewPage.mViewGoodsListInfo[index] = {
			type = ResManager:getInstance():getResMainType(gift.type),
			name = gift.name,
			icon = gift.icon,
			count = gift.count,
			quality = gift.quality
		}
	end

	GoodsViewPage.mTitle="@PackPreviewTitleView"
	GoodsViewPage.mMsgContent="@PackPreviewMsgView"

	MainFrame:getInstance():pushPage("GoodsShowListPage")
end

function common:table_combine(keys, values)
	local tb = {}
	for index, key in ipairs(keys) do
		tb[key] = values[index]
	end
	return tb
end

function common:table_merge(...)
	local tb = {}
	for i = 1, select("#", ...) do
		table.foreach(select(i, ...), function(k, v)
			tb[k] = v
		end)
	end
	return tb
end

function common:table_map(tb, func)
	table.foreach(tb, function(k, v) tb[k] = func(v) end)
end

function common:trim(s)
	return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

UserDataManager = {}

function UserDataManager.getUserDataByTypeAndItemId(type, itemId)
	local resType = ResManager:getInstance():getResMainType(type)

	if resType == SOUL_TYPE then
		return UserSoulManager.getUserSoulInfoByItemID(itemId)
	elseif resType == TOOLS_TYPE then
		return ServerDateManager:getInstance():getUserToolInfoByItemId(itemId)
	end
end

AdventureManager = {}

function AdventureManager.getAdventureItemByType(adventureType)
	local totalNum = ServerDateManager:getInstance():getAdventureItemInfoMapTotalNum()
	for i = 0, totalNum-1 do
		local adventureItemInfo = ServerDateManager:getInstance():getAdventureItemInfoByIndex(i)
		local adventureItem = AdventureTableManager:getInstance():getAdventureItemByID(adventureItemInfo.adventureId)
		if adventureItem.adventureType == adventureType then
			return adventureItem
		end
	end
	return nil
end

function AdventureManager.getCurrentAdventureId()
	--todo: need to change c++ code
	local currType = BlackBoard:getInstance().ToAdventruePageType
	local adventureItem = AdventureManager.getAdventureItemByType(currType)
	return adventureItem and adventureItem.itemID or 0 
end

function jumpPage(pagename,id,type)
    local canJump = true
    if pagename == "AdventurePage" then
        canJump = false
        local num = ServerDateManager:getInstance():getAdventureItemInfoMapTotalNum()
        for i=0,num-1 do
            local item = ServerDateManager:getInstance():getAdventureItemInfoByIndex(i)
            item = AdventureTableManager:getInstance():getAdventureItemByID(item.adventureId)
            if item.adventureType == id then 
                canJump = true
                break
            end
        end
        if canJump then
            BlackBoard:getInstance().ToAdventruePageType = id
        end
    elseif pagename == "DisciplePage" then
        BlackBoard:getInstance().DisciplePageTab = id
    elseif pagename == "ArenaPage" then
        if ServerDateManager:getInstance():getUserBasicInfo().level < 5 then
            canJump = false
        else
            if BlackBoard:getInstance():hasVarible("ArenaPageTab") then
                BlackBoard:getInstance():setVarible("ArenaPageTab",id)
            else
                BlackBoard:getInstance():addVarible("ArenaPageTab",id)
            end
        end
    elseif pagename == "BuyPropsPage" then
        if BlackBoard:getInstance():hasVarible("BuyPropsPageTab") then
            BlackBoard:getInstance():setVarible("BuyPropsPageTab",id)
        else
            BlackBoard:getInstance():addVarible("BuyPropsPageTab",id)
        end
    elseif pagename == "EquipPage" then
        if BlackBoard:getInstance():hasVarible("SellEquip") then
            BlackBoard:getInstance():setVarible("SellEquip",id)
        else
            BlackBoard:getInstance():addVarible("SellEquip",id)
        end
    elseif pagename == "PackagePage" then
        if BlackBoard:getInstance():hasVarible("PackagePageTab") then
            BlackBoard:getInstance():setVarible("PackagePageTab",id)
        else
            BlackBoard:getInstance():addVarible("PackagePageTab",id)
        end
    elseif pagename == "TeamPage" then
        BlackBoard:getInstance().TeamShowIndex = id
    elseif pagename == "TaskSystemPage" then
        local gamemsg = MsgMainFramePopPage:new()
        gamemsg.pageName = "popAllPage"
        MessageManager:getInstance():sendMessageForScript(gamemsg)
        if BlackBoard:getInstance():hasVarible("TaskSystemPageTab") then
            BlackBoard:getInstance():setVarible("TaskSystemPageTab",id)
        else
            BlackBoard:getInstance():addVarible("TaskSystemPageTab",id)
        end
    end
    
    if not canJump then
        MessageBoxPage:Msg_Box("@CannotJumpPage")
        return
    end
    
    if type == 0 then
        local gamemsg = MsgMainFrameChangePage:new()
        gamemsg.pageName = pagename
        gamemsg.needPopAllPage = true
        MessageManager:getInstance():sendMessageForScript(gamemsg)
    elseif type == 1 then
        local gamemsg = MsgMainFramePushPage:new()
        gamemsg.pageName = pagename
        MessageManager:getInstance():sendMessageForScript(gamemsg)
    end
end
