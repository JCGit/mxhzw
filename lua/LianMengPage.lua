require "OP_League_pb"
require "LianMeng"
require "lianmenghuizhang"
require "bit"

local LianMengPage = {}

function luaCreat_LianMengPage(container)
    CCLuaLog("OnCreat_LianMengPage")
    container:registerFunctionHandler(LianMengPage.onFunction)
end


function LianMengPage.onFunction(eventName,container)
    if eventName == "luaInit" then
        LianMengPage.onInit(container)
    elseif eventName == "luaEnter" then
        LianMengPage.onEnter(container)
    elseif eventName == "luaExit" then
        LianMengPage.onExit(container)
    elseif eventName == "luaExecute" then
        LianMengPage.onExecute(container)
    elseif eventName == "luaLoad" then
        LianMengPage.onLoad(container)
    elseif eventName == "luaUnLoad" then
        LianMengPage.onUnLoad(container)
	elseif eventName == "luaGameMessage" then
		LianMengPage.onGameMessage(container)
	elseif eventName == "luaReceivePacket" then
		LianMengPage.onReceivePacket(container)
	elseif eventName == "onLMBadgePage" then
		 LianMengPage.onLMBadge(container)
	elseif eventName == "onLMApply" then
	    LianMengPage.onLMApply(container)
	elseif eventName == "onLMRank" then
	    LianMengPage.onLMRank(container)
	elseif eventName == "onLMMember" then
	    LianMengPage.onLMMember(container)
	elseif eventName == "onLMBattle" then
	    LianMengPage.onLMBattle(container)
--	    MessageBoxPage:Msg_Box("@MAINPAGE_COMINGSOON")
	elseif eventName == "onTotem" then
		 LianMengPage.onLMTotem(container)
	elseif eventName == "onLMBuilding" then
	    LianMengPage.onLMBuilding(container)
	elseif eventName == "onHelp" then
	    LianMengPage.onHelp(container)
	elseif eventName == "onInput" then
	    LianMengPage.onInput(container)
    elseif eventName == "luaInputboxEnter" then
	    LianMengPage.onInputBoxEnter(container)
    end
end
-------------------------------------------------------------------
function LianMengPage.onHelp(container)
    LianMengHelpType=1
	MainFrame:getInstance():showPage("LianMengHelpPage")
end

function LianMengPage.onInput(container)
	if(LeaguaBaseInfo.playerGrade==3 or LeaguaBaseInfo.playerGrade==4)then
		container:registerLibOS()
		libOS:getInstance():showInputbox(false)
	end
end
function LianMengPage.onInputBoxEnter(container)
	local msgInput = container:getInputboxContent()
	if(not RestrictedWord:getInstance():isStringOK(msgInput))then
		MessageBoxPage:Msg_Box_Lan("@NameHaveForbbidenChar")
		return
	end
	if(GameMaths:isStringHasUTF8mb4(msgInput))then
		MessageBoxPage:Msg_Box_Lan("@NameHaveForbbidenChar")
		return
	end
	if(GameMaths:calculateStringCharacters(msgInput)>60)then
		MessageBoxPage:Msg_Box_Lan("@ChatMsgMax")
		return
	end
	local msg = LeagueStruct_ext_pb.OPRefreshLeaguaBroadcast()
	msg.broadcast = msgInput
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_REFRESH_LEAGUA_BROADCAST_C,pb_data,#pb_data,true)
	container:registerPacket(OP_League_pb.OPCODE_REFRESH_LEAGUA_BROADCASTRET_S)
end

function LianMengPage.onLMBattle(container)
    InBattleResultPage = true 
    if LianMengJoinBattle == true then
        MainFrame:getInstance():showPage("LianMengBattleResaultPage")
    else
        local msg = LeagueStruct_battle_pb.OPLianMengJoinBattle()
	    msg.version = 1
	    local pb_data = msg:SerializeToString()
	    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_JOIN_BATTLE_C,pb_data,#pb_data,true)
    end
	
end
local function OPGetLeaguaBuildingHandler(eventName,handler)
    if eventName == "luaReceivePacket" then
        local msg = LeagueStruct_pb.OPGetLeaguaBuildingRet()
	    local msgbuff = handler:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
	    LeaguaBuildingInfoList = {}
        for k, v in ipairs(msg._buildingInfoList) do
	        LeaguaBuildingInfoList[v.buildingID] = {}
	        LeaguaBuildingInfoList[v.buildingID]["buildingID"] = v.buildingID
	        LeaguaBuildingInfoList[v.buildingID]["buildingLevel"] = v.buildingLevel
	        LeaguaBuildingInfoList[v.buildingID]["buildingCurSchedule"] = v.buildingCurSchedule
	        LeaguaBuildingInfoList[v.buildingID]["buildingFinishSchedule"] = v.buildingFinishSchedule
        end
        MainFrame:getInstance():showPage("LianMengBuildingPage");
    end
end
PacketScriptHandler:new(OP_League_pb.OPCODE_GET_LEAGUABUILDINGRET_S, OPGetLeaguaBuildingHandler)

function LianMengPage.onLMBuilding(container)
    local msg = LeagueStruct_pb.OPGetLeaguaBuilding()
	msg.version = 1
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_GET_LEAGUABUILDING_C,pb_data,#pb_data,true)
end
-------------------------------------------------------------------
local function OPGetLeaguaMemberHandler(eventName,handler)
    if eventName == "luaReceivePacket" then
        local msg = LeagueStruct_pb.OPGetLeaguaMemberRet()
	    local msgbuff = handler:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
	    LeaguaMemberInfoList = {}
        for k, v in ipairs(msg._memberInfoList) do
	        LeaguaMemberInfoList[k] = {}
	        LeaguaMemberInfoList[k]["playerID"] = v.playerID
	        LeaguaMemberInfoList[k]["playerName"] = v.playerName
	        LeaguaMemberInfoList[k]["playerLevel"] = v.playerLevel
	        LeaguaMemberInfoList[k]["playerGrade"] = v.playerGrade
	        LeaguaMemberInfoList[k]["playerContribution"] = v.playerContribution
	        LeaguaMemberInfoList[k]["playerKillCount"] = v.playerKillCount
        end           
        MainFrame:getInstance():showPage("LianMengMemberPage")
    end
end
PacketScriptHandler:new(OP_League_pb.OPCODE_GET_LEAGUAMEMBER_S, OPGetLeaguaMemberHandler)

function LianMengPage.onLMMember(container)
    local msg = LeagueStruct_pb.OPGetLeaguaMember()
	msg.version = 1
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_GET_LEAGUAMEMBER_C,pb_data,#pb_data,true)
end

-------------------------------------------------------------------
local function OPGetLeaguaApplyInfoHandler(eventName,handler)
    if eventName == "luaReceivePacket" then
        local msg = LeagueStruct_pb.OPGetLeaguaApplyInfoRet()
	    local msgbuff = handler:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
	    LeaguaApplyInfoList = {}
        --[[for k, v in ipairs(msg._leaguaApplyInfos) do
	        LeaguaApplyInfoList[v.applyID] = {}
	        LeaguaApplyInfoList[v.applyID]["applyID"] = v.applyID
	        LeaguaApplyInfoList[v.applyID]["playerID"] = v.playerID
	        LeaguaApplyInfoList[v.applyID]["playerName"] = v.playerName
	        LeaguaApplyInfoList[v.applyID]["playerLevel"] = v.playerLevel
        end--]]
        for i=#msg._leaguaApplyInfos, 1, -1 do
	        local v = msg._leaguaApplyInfos[i]
	        LeaguaApplyInfoList[v.applyID] = {}
	        LeaguaApplyInfoList[v.applyID]["applyID"] = v.applyID
	        LeaguaApplyInfoList[v.applyID]["playerID"] = v.playerID
	        LeaguaApplyInfoList[v.applyID]["playerName"] = v.playerName
	        LeaguaApplyInfoList[v.applyID]["playerLevel"] = v.playerLevel
	    end
        MainFrame:getInstance():showPage("LianMengAccedePage");
    end
end
PacketScriptHandler:new(OP_League_pb.OPCODE_GET_LEAGUA_APPLYINFORET_S, OPGetLeaguaApplyInfoHandler)

function LianMengPage.onLMApply(container)
    if LeaguaBaseInfo.playerGrade == 3 or LeaguaBaseInfo.playerGrade == 4 then
        local msg = LeagueStruct_pb.OPGetLeaguaApplyInfo()
	    msg.version = 1
	    local pb_data = msg:SerializeToString()
	    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_GET_LEAGUA_APPLYINFO_C,pb_data,#pb_data,true)
    else
        MessageBoxPage:Msg_Box_Lan("@LianMengDealApply_NoPower")
    end
    
end

-------------------------------------------------------------------
local function OPGetLeaguaRankHandler(eventName,handler)
    if eventName == "luaReceivePacket" then
        local msg = LeagueStruct_pb.OPGetLeaguaRankRet()
	    local msgbuff = handler:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
	    LeaguaRankInfoList = {}
        for k, v in ipairs(msg._leaguaRankInfoList) do
            LeaguaRankInfoList[v.leaguaRank] = {}
	        LeaguaRankInfoList[v.leaguaRank]["leaguaID"] = v.leaguaID
	        LeaguaRankInfoList[v.leaguaRank]["leaguaName"] = v.leaguaName
	        LeaguaRankInfoList[v.leaguaRank]["leaguaLevel"] = v.leaguaLevel
	        LeaguaRankInfoList[v.leaguaRank]["leaguaMaxMemberCount"] = v.leaguaMaxMemberCount
	        LeaguaRankInfoList[v.leaguaRank]["leaguaCurMemberCount"] = v.leaguaCurMemberCount
	        LeaguaRankInfoList[v.leaguaRank]["ownerName"] = v.ownerName
	        LeaguaRankInfoList[v.leaguaRank]["leaguaRank"] = v.leaguaRank
	        LeaguaRankInfoList[v.leaguaRank]["leaguaWinRate"] = v.leaguaWinRate
	        LeaguaRankInfoList[v.leaguaRank]["medalID"] = v.medalID
        end
        MainFrame:getInstance():showPage("LianMengRankingPage")
    end
end
PacketScriptHandler:new(OP_League_pb.OPCODE_GET_LEAGUARANKRET_S, OPGetLeaguaRankHandler)

--there are 2 page use same proto message. 
--to avoid conflict, using command count to make sure message is used to go to totem page.
local OPLeagueGotoTotem_commandCount = 0
local function OPLeagueGotoTotem(eventName,handler)
    if eventName == "luaReceivePacket" and OPLeagueGotoTotem_commandCount >0 then
		OPLeagueGotoTotem_commandCount = OPLeagueGotoTotem_commandCount -1
        --if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_GET_TOTEMINFORET_S) then
		--container:removePacket(OP_League_pb.OPCODE_GET_TOTEMINFORET_S)
		local msg = LeagueStruct_pb.OPGetTotemInfoRet()
		msgbuff = handler:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		for k,v in ipairs(msg._totemInfoList) do
	        LeagueTotemInfo._totemInfoList[k] = v;
	    end
		LeagueTotemInfo.status = msg.status
		LeagueTotemInfo.totalContribution = msg.totalContribution
		LeagueTotemInfo.ReceiveContribution = msg.ReceiveContribution
		LeagueTotemInfo.coolDownSeconds = msg.coolDownSeconds
		MainFrame:getInstance():showPage("LianMengTotem")
		--end
    end
end
PacketScriptHandler:new(OP_League_pb.OPCODE_GET_TOTEMINFORET_S, OPLeagueGotoTotem)

function LianMeng_gotoTotem()
	--container:registerPacket(OP_League_pb.OPCODE_GET_TOTEMINFORET_S)
	OPLeagueGotoTotem_commandCount = OPLeagueGotoTotem_commandCount+1
	local msg = LeagueStruct_pb.OPGetTotemInfo()
	msg.version = 1
	msg.leaguaID = -1
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_GET_TOTEMINFO_C,pb_data,#pb_data,true)
end
------------------------------------------------------------------
function LianMengPage.onLMRank(container)
    MainFrame:getInstance():showPage("LianMengRankingPage")
    --[[
    local msg = LeagueStruct_pb.OPGetLeaguaRank()
	msg.version = 1
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_GET_LEAGUARANK_C,pb_data,#pb_data,true)--]]
end

-------------------------------------------------------------------
function LianMengPage.onLMTotem(container)
    --
    LianMeng_gotoTotem()
end

function LianMengPage.onLMBadge(container)
	--get all badges
	container:registerPacket(OP_League_pb.OPCODE_GET_LEAGUAMEDALRET_S)
    local msg = LeagueStruct_pb.OPGetLeaguaMedal()
	msg.version = 1
	local pb_data = msg:SerializeToString()
	container:sendPakcet(OP_League_pb.OPCODE_GET_LEAGUAMEDAL_C,pb_data,#pb_data,true)
end
-------------------------------------------------------------------
function LianMengPage.onInit(container)
    CCLuaLog("LianMengPage.onInit")
end

function LianMengPage.onEnter(container)
    CCLuaLog("LianMengPage.onEnter")
    CCLuaLog(container:dumpInfo())
    container:getVarLabelTTF("mlmname"):setString(LeaguaBaseInfo.leaguaName)
    local len = VaribleManager:getInstance():getSetting("LianMengMessageLen")
    local s =  LeaguaBaseInfo.leaguaBroadcast
    local descirbe = ""
    s, descirbe = GameMaths:stringAutoReturn(s, descirbe, len, 0) 
    container:getVarLabelBMFont("mlmannouncement"):setString(descirbe)
    container:getVarLabelBMFont("mlmlv"):setString(tostring(LeaguaBaseInfo.leaguaLevel))
    container:getVarLabelBMFont("mlmmoney"):setString(tostring(LeaguaBaseInfo.leaguaFunds))
    local peoplecount = tostring(LeaguaBaseInfo.leaguaCurMemberCount).."/"..tostring(LeaguaBaseInfo.leaguaMaxMemberCount)
    container:getVarLabelBMFont("mlmpeople"):setString(peoplecount)
    local badgeNode = CCSprite:create(LianMengBadges[LeaguaBaseInfo.leaguaActiveMedal].filename);
	container:getVarMenuItemSprite("mlmbadge"):setNormalImage(badgeNode)

end

function LianMengPage.onExit(container)	
    CCLuaLog("LianMengPage.onExit")
    container:removeLibOS()
end

function LianMengPage.onExecute(container)

end

function LianMengPage.onLoad(container)
	CCLuaLog("LianMengPage.onLoad")
	container:loadCcbiFile("LianMengPage.ccbi");
	CCLuaLog(container:dumpInfo())
end

function LianMengPage.onUnLoad(container)
	CCLuaLog("LianMengPage.onUnLoad")
end


function LianMengPage.onReceivePacket(container)
	CCLuaLog("LianMengPage.onReceivePacket")
	--Medal
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_GET_LEAGUAMEDALRET_S) then
		local msg = LeagueStruct_pb.OPGetLeaguaMedalRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		LeagueMedalInfoList = {}
		for k,v in ipairs(msg._medalInfoList) do
	        --LeagueMedalInfoList[v.medalID].medalID = v.medalID
	        LeagueMedalInfoList[v.medalID] = {}
			LeagueMedalInfoList[v.medalID].ownerLeaguaID = v.ownerLeaguaID
			LeagueMedalInfoList[v.medalID].ownerLeaguaName = v.ownerLeaguaName
		end
		LeagueMedalInfoList_alreadyGotSpecialMedal = msg.alreayGotSpecialMedal
	    MainFrame:getInstance():showPage("lianmenghuizhang")
	end
	-------------------------------------------------------------------------
	--Totem
	
	----------------------------------------------------------------------------------
	--boardcast
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_REFRESH_LEAGUA_BROADCASTRET_S) then
		local msg = LeagueStruct_ext_pb.OPRefreshLeaguaBroadcastRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		if(msg.status == 1)then
		    local len = VaribleManager:getInstance():getSetting("LianMengMessageLen")
		    local s =  msg.newBroadcast
            local descirbe = ""
            s, descirbe = GameMaths:stringAutoReturn(s, descirbe, len, 0) 
            container:getVarLabelBMFont("mlmannouncement"):setString(descirbe)
		elseif msg.status == 2 then
			MessageBoxPage:Msg_Box_Lan("@LMBoardCastFailed")
		elseif(msg.status == 3) then
				MessageBoxPage:Msg_Box_Lan("@LMBoardCastCDFailed")
		end
		container:removePacket(OP_League_pb.OPCODE_REFRESH_LEAGUA_BROADCASTRET_S)
	end
end

function LianMengPage.onGameMessage(container)
	CCLuaLog("LianMengPage.onGameMessage")
end

