
require "OP_League_pb"
require "LeagueStruct_pb"
require "LeagueStruct_battle_pb"
require "LeagueStruct_ext_pb"

local HasLeagua = false

LeaguaBaseInfo = {
	leaguaID ,
	leaguaName = "some name",
	leaguaLevel = 10,
	leaguaMaxMemberCount  = 80,
	leaguaCurMemberCount  = 20,
	leaguaFunds  = 123456789,
	ownerName ,
	leaguaRank ,
	leaguaActiveMedal = 2,
	playerGrade ,
	playerLeftContribution ,
	playerTotalContribution ,
	playerKillCount ,
	leaguaBroadcast = "boardcast...",
	leaguaWinRate,
	transLeaderCoolTime,
    intrestLeftTimes,
    robLeftTimes,
    intrestMaxTimes,
    robMaxTimes
}

--[[
message LeaguaRankInfo
{
	required int32 leaguaID = 1;
	required string leaguaName = 2;
	required int32 leaguaLevel = 3;
	required int32 leaguaMaxMemberCount = 4;
	required int32 leaguaCurMemberCount = 5;
	required string ownerName = 6;
	required int32 leaguaRank = 7;
	optional float leaguaWinRate = 8;
	required int32 medalID = 9;
}
--]]
LeaguaRankInfoList = {} --{	v = leaguaRank, key = LeaguaRankInfo }

--[[
message LeaguaApplyInfo
{
	required int32 applyID = 1;
	required int32 playerID = 2;
	required string playerName = 3;
	required int32 playerLevel = 4;
}
--]]
LeaguaApplyInfoList = {}--{	v = applyID, key = LeaguaApplyInfo }

--[[
message LeaguaMemberInfo
{
	required int32 playerID = 1;
	required string playerName = 2;
	required int32 playerLevel = 3;
	required int32 playerGrade = 4;
	required int32 playerContribution = 5;
	required int32 playerKillCount = 6;
}
--]]
LeaguaMemberInfoList = {} --[[	v = playerID,	key = LeaguaMemberInfo	]]

--[[
message LeaguaMedalInfo
{
	required int32 medalID = 1;
	optional int32 ownerLeaguaID = 2;//-1 means no league has this medal
	optional string ownerLeaguaName = 3;
}
--]]
LeagueMedalInfoList = {} --[[	v = medalID(index),	key = LeaguaMedalInfo	]]
LeagueMedalInfoList_alreadyGotSpecialMedal = false
LianMengBadges = nil --[[:{{	v = index, key = {id,name,filename}},...}]]
local function load_LianMengBadges()
	if LianMengBadges == nil then
		local tablemgr = TableReaderManager:getInstance()
		local tabel = tablemgr:getTableReader("LianmengBadge.txt")
		local count = tabel:getLineCount()-1;
		local node = CCNode:create()
		local sizeX,sizeY
		LianMengBadges = {}
		for i = 1,count do
			local index = tabel:getData(i,0)
			if index then
			    LianMengBadges[i] = {}
			    LianMengBadges[i].index = index
			    LianMengBadges[i].name = tabel:getData(i,1)
			    LianMengBadges[i].filename = tabel:getData(i,3)
			end
		end --for i = 1,count do
	end --if(LianMengBadges == nil)
end
load_LianMengBadges()

--[[totemID,//301~305
	totemTotalHP,
	totemLeftHP,
	status,//1 available, 2 broken, 3 repairing
	repairTime//in seconds]]

LeagueTotemInfo = {
	_totemInfoList = {};--[[:{{	v = index, key = {totemID,totemTotalHP,totemLeftHP,status,repairTime}},...}]]
	status,
	totalContribution,
	ReceiveContribution,
	coolDownSeconds
}
LeagueTotemIndex = {3,4,5,6,7}
LeagueTotemIndexRev = {}
for i,v in ipairs(LeagueTotemIndex) do
	LeagueTotemIndexRev[v]=i
end

--[[
message LeaguaBuildingInfo
{
	required int32 buildingID = 1;
	required int32 buildingLevel = 2;
	optional int32 buildingCurSchedule = 3;
	optional int32 buildingFinishSchedule = 4;
}
--]]
LeaguaBuildingInfoList = {} --{	v = buildingID, key = LeaguaBuildingInfo }

LianMengBuildings = {} --{ v = buildingID, key = {buildingID, buildingType, buildingName, buildingDescribe, buildingIcon} }
local function load_LianMengBuildings()
    --local tablemgr = TableReaderManager:getInstance()
	local tabel = TableReaderManager:getInstance():getTableReader("LianmengBuilding.txt")
	local count = tabel:getLineCount()-1;
	for i = 1,count do
		local index = tonumber(tabel:getData(i,5))
		if index then
		    LianMengBuildings[index] = {}
		    LianMengBuildings[index].buildingID = tonumber(tabel:getData(i,0))
		    LianMengBuildings[index].buildingType = tonumber(tabel:getData(i,1))
		    LianMengBuildings[index].buildingName = tabel:getData(i,2)
		    LianMengBuildings[index].buildingDescribe = tabel:getData(i,3)
		    LianMengBuildings[index].buildingIcon = tabel:getData(i,4)
		end
	end
end
load_LianMengBuildings()

LianmengBuildingLvlInfo = {}
local function load_LianmengBuildingLvlInfo()
	local tabel = TableReaderManager:getInstance():getTableReader("LianmengBuildingLvlInfo.txt")
	local count = tabel:getLineCount()-1;
	for i = 1,count do
		local index = tonumber(tabel:getData(i,0))
		if index then
		    LianmengBuildingLvlInfo[index] = {}
		    LianmengBuildingLvlInfo[index].Num = tabel:getData(i,1)
		    LianmengBuildingLvlInfo[index].C_Buff = tabel:getData(i,2)
		    LianmengBuildingLvlInfo[index].C_Exp = tabel:getData(i,3)
		    LianmengBuildingLvlInfo[index].D_Exp = tabel:getData(i,4)
		    LianmengBuildingLvlInfo[index].D_Attack = tabel:getData(i,5)
		    LianmengBuildingLvlInfo[index].D_Defense = tabel:getData(i,6)
		    LianmengBuildingLvlInfo[index].D_Will = tabel:getData(i,7)
		end
	end
end
load_LianmengBuildingLvlInfo()

--[[
message LeaguaShopGoodInfo
{
	required int32 goodID = 1;
	required int32 goodType = 2;
	required int32 goodPrice = 3;
	required int32 goodCount = 4;
	required int32 shopLevel = 5;
}
--]]
LeaguaShopInfo = {
    shopGoodInfoList = {}, --{	v = index, key = LeaguaShopGoodInfo }
	cdTime,
	crefreshTime
}

LianmengHelpInfo = {}
local function load_LianmengHelpInfo()
	local tabel = TableReaderManager:getInstance():getTableReader("LianMengHelp.txt")
	local count = tabel:getLineCount()-1;
	for i = 1,count do
		local index = tonumber(tabel:getData(i,0))
		if index then
		    LianmengHelpInfo[index] = {}
		    LianmengHelpInfo[index].name = tabel:getData(i,1)
		    LianmengHelpInfo[index].describe = tabel:getData(i,2)
		    LianmengHelpInfo[index].iconpath = tabel:getData(i,3)
		    LianmengHelpInfo[index].showType = tabel:getData(i,4)
		end
	end
end
load_LianmengHelpInfo()


local LianMengContinueKillRank = {}
local LianMengBattle = {}

LianmengBattleResultInfo = {

	finishTime = 1;
	continueKillRank = LianMengContinueKillRank;
	lianMengBattle = LianMengBattle;
	scrollMSG = {};
	killPersonNum = 2;
	contributeNum = 3;
	lastTime = 5;
}

LianMengJoinBattle = false
LianMengBattleResaultSecond = 1
RefreshLianMengBattle = false--∩?㊣?芍?車?車迆??∩??車那?米???～邦o車?⊿D?㏒?2?辰a?????⊿D?
function OPGetLianMengBattleResultHandler(eventName,handler)
    if eventName == "luaReceivePacket" then
        local msg = LeagueStruct_battle_pb.OPLianMengRefreshBattleRet()
	    local msgbuff = handler:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
	    LianmengBattleResultInfo.finishTime = msg.finishTime
	    TimeCalculator:getInstance():createTimeCalcultor("LMBattleFinishTime",LianmengBattleResultInfo.finishTime)

        LianmengBattleResultInfo.continueKillRank = {}
	    for k1,v1 in ipairs(msg.continueKillRank) do
	        LianmengBattleResultInfo.continueKillRank[k1] = {}
	        LianmengBattleResultInfo.continueKillRank[k1].rank = v1.rank
	        LianmengBattleResultInfo.continueKillRank[k1].playerName = v1.playerName
	        LianmengBattleResultInfo.continueKillRank[k1].lianMengName = v1.lianMengName
	        LianmengBattleResultInfo.continueKillRank[k1].lianMengBadgeId = v1.lianMengBadgeId
	    end
	    
	    LianmengBattleResultInfo.lianMengBattle = {}
	    for k1,v1 in ipairs(msg.lianMengBattle) do
	        LianmengBattleResultInfo.lianMengBattle[k1] = {}
	        LianmengBattleResultInfo.lianMengBattle[k1].index = v1.index
	        LianmengBattleResultInfo.lianMengBattle[k1].lianMengName = v1.lianMengName
	        LianmengBattleResultInfo.lianMengBattle[k1].lianMengBuildingIndex = v1.lianMengBuildingIndex
	        LianmengBattleResultInfo.lianMengBattle[k1].personNumInBattle = v1.personNumInBattle
	        LianmengBattleResultInfo.lianMengBattle[k1].lianMengBadgeId = v1.lianMengBadgeId
	        LianmengBattleResultInfo.lianMengBattle[k1].lianMengScore = v1.lianMengScore
	        LianmengBattleResultInfo.lianMengBattle[k1].restraintStatus = v1.restraintStatus
	        LianmengBattleResultInfo.lianMengBattle[k1].restraintNum = v1.restraintNum
	        LianmengBattleResultInfo.lianMengBattle[k1].npcNeedScore = v1.npcNeedScore
	    end
	    
        LianmengBattleResultInfo.scrollMSG = {}
        for k1,v1 in ipairs(msg.scrollMSG) do
	        LianmengBattleResultInfo.scrollMSG[k1] = {}
	        LianmengBattleResultInfo.scrollMSG[k1].index = v1.index
	        LianmengBattleResultInfo.scrollMSG[k1].lianmengName1 = v1.lianmengName1
	        LianmengBattleResultInfo.scrollMSG[k1].grade1 = v1.grade1
	        LianmengBattleResultInfo.scrollMSG[k1].playerName1 = v1.playerName1
	        LianmengBattleResultInfo.scrollMSG[k1].lianmengName2 = v1.lianmengName2
	        LianmengBattleResultInfo.scrollMSG[k1].grade2 = v1.grade2
	        LianmengBattleResultInfo.scrollMSG[k1].playerName2 = v1.playerName2
	        LianmengBattleResultInfo.scrollMSG[k1].continuation = v1.continuation
	        LianmengBattleResultInfo.scrollMSG[k1].contribution = v1.contribution
	    end
	    
	    LianmengBattleResultInfo.killPersonNum = msg.killPersonNum
	    LianmengBattleResultInfo.contributeNum = msg.contributeNum
        ScriptMathToLua:modifySilverCoins(msg.playerSilver)
	    LianmengBattleResultInfo.lastTime = msg.lastTime 
    	LianMengBattleResaultSecond = 1
    	if LianmengBattleResultInfo.lastTime == -1 then
    	    MainFrame:getInstance():showPage("LianMengAddPage")
    	elseif InBattleResultPage == true then
            if LianMengJoinBattle == false then
                MainFrame:getInstance():showPage("LianMengBattlePage")
            else
                RefreshLianMengBattle = true
                MainFrame:getInstance():showPage("LianMengBattleResaultPage")
            end
        end

	end
end
PacketScriptHandler:new(OP_League_pb.OPCODE_LIANMENG_REFRESH_BATTLERET_S, OPGetLianMengBattleResultHandler)


local LianmengStrongHoleList = {}
local LianmengBattleMSGList = {}
local LianmengBattleBuildingInfo = {}
local function load_LianmengStrongHoleList()
	local tabel = TableReaderManager:getInstance():getTableReader("LianmengStrongHole.txt")
	local count = tabel:getLineCount()-1;
	for i = 1,count do
		local index = tonumber(tabel:getData(i,0))
		if index then
		    LianmengStrongHoleList[index] = {}
		    LianmengStrongHoleList[index].id = tabel:getData(i,0)
		    LianmengStrongHoleList[index].holdName = tabel:getData(i,1)
		    LianmengStrongHoleList[index].ownerName = ""
		    LianmengStrongHoleList[index].ownerBadgeId = 0
		    
            local strongHoldBidList = {}
		    for j = 1,2 do
		        strongHoldBidList[j] = {}
		        strongHoldBidList[j].bidName = "bidName"
		        strongHoldBidList[j].bidAmount = 300
		        strongHoldBidList[j].bidNum = 4
		    end
		    LianmengStrongHoleList[index].strongHoldBid = strongHoldBidList
		    
		    local strongHoldRewardList = {}
		    for j = 1,2 do
		        strongHoldRewardList[j] = {}
		        strongHoldRewardList[j].shopLevel = 5
		        strongHoldRewardList[j].rewardType = 50
		        strongHoldRewardList[j].rewardId = 44
		        strongHoldRewardList[j].rewardNum = 31
		    end
		    LianmengStrongHoleList[index].strongHoldReward = strongHoldRewardList
		    
            local battleBuildingInfo = {}
		    for j = 1,5 do
		        battleBuildingInfo[j] = {}
		        battleBuildingInfo[j].index = j
		        battleBuildingInfo[j].buildingHealth = 0
		    end
		    LianmengStrongHoleList[index].buildingInfo = battleBuildingInfo
		    
		end
	end


end
load_LianmengStrongHoleList()

LianmengBattleInfo = {
    servertime = 0;
	battleStatus = 0;
	strongHold = LianmengStrongHoleList;
	battleMSG = LianmengBattleMSGList;
	buildingInfo = LianmengBattleBuildingInfo;
	finishTime = 0;
}

JoinLianMengBattle = false--∩?㊣?芍?車?車迆??∩??車那?米???～邦o車?⊿D?㏒?2?辰a?????⊿D?
function OPGetLianMengBattleHandler(eventName,handler)

    if eventName == "luaReceivePacket" then
        JoinLianMengBattle = true
        local msg = LeagueStruct_battle_pb.OPLianMengJoinBattleRet()
	    local msgbuff = handler:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
	    LianmengBattleInfo.battleStatus = msg.battleStatus
	    LianmengBattleInfo.strongHold = {}
	    for k1,v1 in ipairs(msg.strongHold) do
	        LianmengBattleInfo.strongHold[k1] = {}
	        LianmengBattleInfo.strongHold[k1].holdName = v1.holdName
            LianmengBattleInfo.strongHold[k1].ownerName = v1.ownerName
            LianmengBattleInfo.strongHold[k1].ownerBadgeId = v1.ownerBadgeId
            
            LianmengBattleInfo.strongHold[k1].strongHoldBid = {}
            for k2,v2 in ipairs( msg.strongHold[k1].strongHoldBid ) do
                LianmengBattleInfo.strongHold[k1].strongHoldBid[k2] = {}
                LianmengBattleInfo.strongHold[k1].strongHoldBid[k2].bidName = v2.bidName
                LianmengBattleInfo.strongHold[k1].strongHoldBid[k2].bidAmount = v2.bidAmount
                LianmengBattleInfo.strongHold[k1].strongHoldBid[k2].bidNum = v2.bidNum
                LianmengBattleInfo.strongHold[k1].strongHoldBid[k2].bidBadgeId = v2.bidBadgeId
                LianmengBattleInfo.strongHold[k1].strongHoldBid[k2].defenceBadgeId = v2.defenceBadgeId
                LianmengBattleInfo.strongHold[k1].strongHoldBid[k2].defenceNum = v2.defenceNum
            end

            LianmengBattleInfo.strongHold[k1].strongHoldReward = {}
            for k3,v3 in ipairs( msg.strongHold[k1].strongHoldReward ) do
                LianmengBattleInfo.strongHold[k1].strongHoldReward[k3] = {}
                LianmengBattleInfo.strongHold[k1].strongHoldReward[k3].shopLevel = v3.shopLevel
                LianmengBattleInfo.strongHold[k1].strongHoldReward[k3].rewardType = v3.rewardType
                LianmengBattleInfo.strongHold[k1].strongHoldReward[k3].rewardId = v3.rewardId
                LianmengBattleInfo.strongHold[k1].strongHoldReward[k3].rewardNum = v3.rewardNum
            end
	    end
        
        LianmengBattleInfo.battleMSG = {}
	    for k,v in ipairs(msg.battleMSG) do
	        LianmengBattleInfo.battleMSG[k] = {}
	        LianmengBattleInfo.battleMSG[k].index = v.index
	        LianmengBattleInfo.battleMSG[k].holdName = v.holdName
	        LianmengBattleInfo.battleMSG[k].firstBidName = v.firstBidName
	        LianmengBattleInfo.battleMSG[k].secondBidName = v.secondBidName
	        LianmengBattleInfo.battleMSG[k].status = v.status
	    end
	    
	    LianmengBattleInfo.buildingInfo = {}
	    for k,v in ipairs(msg.buildingInfo) do
	        LianmengBattleInfo.buildingInfo[k] = {}
	        LianmengBattleInfo.buildingInfo[k].index = v.index
	        LianmengBattleInfo.buildingInfo[k].buildingHealth = v.buildingHealth
	        LianmengBattleInfo.buildingInfo[k].buildingLevel = v.buildingLevel
	    end
	    
        LianmengBattleInfo.buildingIndex = msg.buildingIndex
	    if LianmengBattleInfo.battleStatus == 4 then
	    
	        local msg2 = LeagueStruct_battle_pb.OPLianMengRefreshBattle()
            msg2.version = 1
            msg2.strongHoldIndex = 1
            local pb_data2 = msg2:SerializeToString()
            PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_REFRESH_BATTLE_C,pb_data2,#pb_data2,true)

        else
            MainFrame:getInstance():showPage("LianMengBattlePage")
        end
        if msg.errorCode ~= 0 then
            MessageBoxPage:Msg_Box("@LMBattleErrorCode" .. msg.errorCode)
        end
        TimeCalculator:getInstance():createTimeCalcultor("LianMengBattleCD", msg.finishTime)
    end
    
end
PacketScriptHandler:new(OP_League_pb.OPCODE_LIANMENG_JOIN_BATTLERET_S, OPGetLianMengBattleHandler)


function OPGetUserLeaguaInfoHandler(eventName,handler)
    if eventName == "luaReceivePacket" then
        local msg = LeagueStruct_pb.OPGetUserLeaguaInfoRet()
	    local msgbuff = handler:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
        
        HasLeagua = msg.hasLeagua
        
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

        if msg:HasField("_leaguaBaseInfo") then
            LeaguaBaseInfo.leaguaID = msg._leaguaBaseInfo.leaguaID
            LeaguaBaseInfo.leaguaName = msg._leaguaBaseInfo.leaguaName
            LeaguaBaseInfo.leaguaLevel = msg._leaguaBaseInfo.leaguaLevel
            LeaguaBaseInfo.leaguaMaxMemberCount = msg._leaguaBaseInfo.leaguaMaxMemberCount
            LeaguaBaseInfo.leaguaCurMemberCount = msg._leaguaBaseInfo.leaguaCurMemberCount
            LeaguaBaseInfo.leaguaFunds = msg._leaguaBaseInfo.leaguaFunds
            LeaguaBaseInfo.ownerName = msg._leaguaBaseInfo.ownerName
            LeaguaBaseInfo.leaguaRank = msg._leaguaBaseInfo.leaguaRank
            LeaguaBaseInfo.leaguaActiveMedal = msg._leaguaBaseInfo.leaguaActiveMedal
            LeaguaBaseInfo.playerGrade = msg._leaguaBaseInfo.playerGrade
            LeaguaBaseInfo.playerLeftContribution = msg._leaguaBaseInfo.playerLeftContribution
            LeaguaBaseInfo.playerTotalContribution = msg._leaguaBaseInfo.playerTotalContribution
            LeaguaBaseInfo.playerKillCount = msg._leaguaBaseInfo.playerKillCount
            if msg._leaguaBaseInfo:HasField("leaguaBroadcast") then
                LeaguaBaseInfo.leaguaBroadcast = msg._leaguaBaseInfo.leaguaBroadcast
            end
            if msg._leaguaBaseInfo:HasField("leaguaWinRate") then
                LeaguaBaseInfo.leaguaWinRate = msg._leaguaBaseInfo.leaguaWinRate
            end
            if msg._leaguaBaseInfo:HasField("transLeaderCoolTime") then
	            LeaguaBaseInfo.transLeaderCoolTime = msg._leaguaBaseInfo.transLeaderCoolTime
	            TimeCalculator:getInstance():createTimeCalcultor("LMTransLeaderCoolTime", LeaguaBaseInfo.transLeaderCoolTime)
            end
            if msg._leaguaBaseInfo:HasField("intrestLeftTimes") then
                LeaguaBaseInfo.intrestLeftTimes = msg._leaguaBaseInfo.intrestLeftTimes
            end
            if msg._leaguaBaseInfo:HasField("robLeftTimes") then
                LeaguaBaseInfo.robLeftTimes = msg._leaguaBaseInfo.robLeftTimes
            end
            if msg._leaguaBaseInfo:HasField("intrestMaxTimes") then
                LeaguaBaseInfo.intrestMaxTimes = msg._leaguaBaseInfo.intrestMaxTimes
            end
            if msg._leaguaBaseInfo:HasField("robMaxTimes") then
                LeaguaBaseInfo.robMaxTimes = msg._leaguaBaseInfo.robMaxTimes
            end
        end  
        
        if HasLeagua then
            MainFrame:getInstance():showPage("LianMengPage")
        else
            MainFrame:getInstance():showPage("LianMengAddPage")
        end
    end
end
PacketScriptHandler:new(OP_League_pb.OPCODE_GET_USERLEAGUAINFORET_S, OPGetUserLeaguaInfoHandler)

function initLianMengServerData()
    LeaguaBaseInfo = {}
    LeaguaRankInfoList = {}
    LeaguaApplyInfoList = {}
    LeaguaMemberInfoList = {}
    LeagueMedalInfoList = {}
    LeaguaBuildingInfoList = {}
    LeaguaShopInfo = {}
end

function LianMeng_gotoMainPage()
    if ServerDateManager:getInstance():getUserBasicInfo().level < 17 then
        MessageBoxPage:Msg_Box_Lan("@LianMeng_LowLevel")
    else
        local msg = LeagueStruct_pb.OPGetUserLeaguaInfo()
        msg.version = 1
        local pb_data = msg:SerializeToString()
        PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_GET_USERLEAGUAINFO_C,pb_data,#pb_data,true)
    end
end

function MainFrame_onButton7()

	--MessageBoxPage:Msg_Box_Lan("@MAINPAGE_COMINGSOON")
	
	if(true)then
		LianMeng_gotoMainPage()
	end
    
    return 1;
end








