require "LianMeng"
require "LianMengRobRank"
require "UserBattle_pb"
require "LeagueStruct_ext_pb"
require "LianMengBitResault2"
LianMengTotemRob = {}
LianMengTotemRob.result = {
		status,--1: normal	2:	alread broken	3:	error
		contribution,
		fund,
		intrestLeftTimes,
		intrestMaxTimes,
		robLeftTimes,
		robMaxTimes
	}
--LianMengTotemRob.fightmessage
LianMengTotemRob.mAttackId = 0
function luaCreat_LianMengTotemRob(container)
    container:registerFunctionHandler(LianMengTotemRob.onFunction)
end

function LianMengTotemRob.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengTotemRob.onEnter(container)
    elseif eventName == "luaExecute" then
        LianMengTotemRob.onUpdateTimeLeft(container)
    elseif eventName == "luaExit" then
        LianMengTotemRob.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengTotemRob.onLoad(container)
	elseif eventName == "luaReceivePacket" then
		LianMengTotemRob.onReceivePacket(container)
	elseif eventName == "luaGameMessage" then
		LianMengTotemRob.gameMessage(container)
	elseif eventName == "mLMTotem1" then
		LianMengTotemRob.rob(container,LeagueTotemIndex[1])
	elseif eventName == "mLMTotem2" then
		LianMengTotemRob.rob(container,LeagueTotemIndex[2])
	elseif eventName == "mLMTotem3" then
		LianMengTotemRob.rob(container,LeagueTotemIndex[3])
	elseif eventName == "mLMTotem4" then
		LianMengTotemRob.rob(container,LeagueTotemIndex[4])
	elseif eventName == "mLMTotem5" then
		LianMengTotemRob.rob(container,LeagueTotemIndex[5])
    elseif eventName == "onRevert" then
        LianMengTotemRob.onRevert(container)
--	    LianMeng_gotoTotem()
    elseif eventName == "onPlunder" then
        LianMengTotemRob.gotoToPlunder(container)
    end
end

function LianMengTotemRob.onRevert(container)
    MainFrame:getInstance():showPage("LianMengRobRank");
end
function LianMengTotemRob.gotoToPlunder(container)
    LianMengTotemRob.mAttackId=0
    container:registerPacket(OP_League_pb.OPCODE_GET_LEAGUA_OWN_MEDAL_INFORET_S)
    local msg = LeagueStruct_pb.OPGetLeaguaOwnMedal()
    msg.leaguaId = LianMengRobRank.attackLeagueID
    local pb_data = msg:SerializeToString()
    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_GET_LEAGUA_OWN_MEDAL_INFO_C,pb_data,#pb_data,true)
end
function LianMengTotemRob.rob(container, id)
    local canAttack=false
    for k,v in ipairs(LianMengRobRank.LeagueTotemRobInfo._totemInfoList) do
        local info = LianMengRobRank.LeagueTotemRobInfo._totemInfoList[k]
        if info.totemID==id and info.status==1 then
            canAttack=true
        end
    end
    if canAttack then
        if LeaguaBaseInfo.robLeftTimes<=0 then
            MainFrame:getInstance():pushPage("LianMengTotemAddCountPage")
        else
            LianMengTotemRob.mAttackId=id
            container:registerPacket(OP_League_pb.OPCODE_ROB_LEAGUERET)
            container:registerPacket(108)--UserBattle
            local msg = LeagueStruct_ext_pb.OPGetLeaguaRob()
            msg.leaguaID = LianMengRobRank.attackLeagueID
            msg.version = 1
            msg.totemID = id
            local pb_data = msg:SerializeToString()
            PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_ROB_LEAGUE,pb_data,#pb_data,true)

            totemName = {}
            totemName[3] = Language:getInstance():getString("@LMTotemName1")
            totemName[4] = Language:getInstance():getString("@LMTotemName2")
            totemName[5] = Language:getInstance():getString("@LMTotemName3")
            totemName[6] = Language:getInstance():getString("@LMTotemName4")
            totemName[7] = Language:getInstance():getString("@LMTotemName5")

            if BlackBoard:getInstance():hasVarible("fightEnemyNameKey") then
                BlackBoard:getInstance():setVarible("fightEnemyNameKey",totemName[id])
            else
                BlackBoard:getInstance():addVarible("fightEnemyNameKey",totemName[id])
            end
        end
    else
        MessageBoxPage:Msg_Box_Lan("@TotemAlreadyBroken")
    end
end

function LianMengTotemRob.onUpdateTimeLeft(container)
    totemItem = {}
    totemItem[LeagueTotemIndex[1]] = container:getVarLabelBMFont("mbloodjin")
    totemItem[LeagueTotemIndex[2]] = container:getVarLabelBMFont("mbloodmu")
    totemItem[LeagueTotemIndex[3]] = container:getVarLabelBMFont("mbloodshui")
    totemItem[LeagueTotemIndex[4]] = container:getVarLabelBMFont("mbloodhuo")
    totemItem[LeagueTotemIndex[5]] = container:getVarLabelBMFont("mbloodtu")
    
    for k,v in ipairs(LianMengRobRank.LeagueTotemRobInfo._totemInfoList) do
	    container:getVarSprite("mLMTDestroy"..tostring(k)):setVisible(false)
		local info = LianMengRobRank.LeagueTotemRobInfo._totemInfoList[k]
		if info.status == 1 then
			local outstr = tostring(info.totemLeftHP).."/"..tostring(info.totemTotalHP)
			totemItem[info.totemID]:setString(outstr)
		end
		if info.status == 2 then
			local lang = Language:getInstance():getString("@LMTotemRuined")
			totemItem[info.totemID]:setString(lang)
			container:getVarSprite("mLMTDestroy"..tostring(k)):setVisible(true)
		end
		if info.status == 3 then
			if(info.repairTime<=0)then
				local outstr = tostring(info.totemTotalHP).."/"..tostring(info.totemTotalHP)
				totemItem[info.totemID]:setString(outstr)
			else
				local key = "LMTotemRepair"..tostring(k)
				local hasKey = TimeCalculator:getInstance():hasKey(key)
				local timeleft = 0;
				
				if(not hasKey) then
		            TimeCalculator:getInstance():createTimeCalcultor("LMTotemRepair"..tostring(k),info.repairTime)
		            hasKey = true
		        end
				if(hasKey)then
					info.repairTime =  TimeCalculator:getInstance():getTimeLeft(key)

					local lang = Language:getInstance():getString("@LMTotemAttactCant2")
					--[[local hh = math.floor(info.repairTime/60/60)
					local mm = math.floor((info.repairTime/60) %60)
					local ss = math.floor(info.repairTime%60)
					local outstr = lang..tostring(hh)..":"..tostring(mm)..":"..tostring(ss)
					totemItem[info.totemID]:setString(outstr)--]]
					totemItem[info.totemID]:setString(lang)
					
				end
			end
		end
	    --info.totemID info.totemTotalHP info.totemLeftHP info.status info.repairTime]]
    end
    LianMengTotemRob.onRefresh(container)
end
function LianMengTotemRob.onEnter(container) 
    local totemItem = {}

    for k,v in ipairs(LianMengRobRank.LeagueTotemRobInfo._totemInfoList) do
	    local info = LianMengRobRank.LeagueTotemRobInfo._totemInfoList[k]
	    if info.status == 3 then
		    if(info.repairTime>0)then
			    TimeCalculator:getInstance():createTimeCalcultor("LMTotemRobRepair"..tostring(k),info.repairTime)
		    end
	    end
    end
    LianMengTotemRob.onRefresh(container)
    LianMengTotemRob.onUpdateTimeLeft(container)
    container:registerMessage(26)--[[MSG_FIGHTPAGE_EXIT]]
end

function LianMengTotemRob.onRefresh(container)
    container:getVarLabelBMFont("mPC"):setString(tostring(LianMengRobRank.LeagueTotemRobInfo.curSurplusAddition).."%")
    container:getVarLabelBMFont("mlmsurplus"):setString(tostring(LianMengRobRank.LeagueTotemRobInfo.ReceiveContribution))
    container:getVarLabelBMFont("mLMCanPlunderCount"):setString(tostring(LeaguaBaseInfo.intrestLeftTimes).."/"..tostring(LeaguaBaseInfo.intrestMaxTimes))
    container:getVarLabelBMFont("mLMTodayCanPlunderCount"):setString(tostring(LeaguaBaseInfo.robLeftTimes).."/"..tostring(LeaguaBaseInfo.robMaxTimes))
end

function LianMengTotemRob.onExit(container)
    container:removeMessage(26)
end

function LianMengTotemRob.onLoad(container)
	container:loadCcbiFile("LianMengTotemRob.ccbi");
	CCLuaLog(container:dumpInfo())
end

function LianMengTotemRob.gameMessage(container)
	local message = container:getMessage()
	if message:getTypeId() == 26 --[[MSG_FIGHTPAGE_EXIT]] then
		--local pagename = MsgMainFrameCoverHide:getTrueType(message).pageName
		--if(pagename == "FightPage") then
        LianMengTotemRob.onRefresh(container)
		CCLuaLog("show result")

		local msg = MsgMainFrameCoverShow:new()
		if LianMengTotemRob.mAttackId == 0 then
            msg.pageName = "LianMengTotemRobFlagsPopPage"
		else
            if(LianMengTotemRob.gotBadgeID~=nil)then
                msg.pageName = "LianMengBitResault"
            else
                msg.pageName = "LianMengBitResault2"
            end
		end
		MessageManager:getInstance():sendMessageForScript(msg)
		--end
	end
end

function LianMengTotemRob.onReceivePacket(container)
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_ROB_LEAGUERET) then
		container:removePacket(OP_League_pb.OPCODE_ROB_LEAGUERET)
		local msg = LeagueStruct_ext_pb.OPGetLeaguaRobRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		LianMengTotemRob.status = msg.status	--1: normal	2:	alread broken	3:	error
		LianMengTotemRob.contribution = msg.contribution
		LianMengTotemRob.fund = msg.fund

		if(msg:HasField("gotBadgeID"))then
			LianMengTotemRob.gotBadgeID = msg.gotBadgeID
		else
			LianMengTotemRob.gotBadgeID = nil
		end
        LianMengTotemRob.onRefresh(container)
		LeagueTotemInfo.coolDownSeconds = msg.coolDownSeconds
		
		if(msg.status == 2) then
			MessageBoxPage:Msg_Box_Lan("@TotemAlreadyBroken")
        else
            LianMengTotemRob.intrestLeftTimes = msg.intrestLeftTimes
            LianMengTotemRob.intrestMaxTimes = msg.intrestMaxTimes
            LianMengTotemRob.robLeftTimes = msg.robLeftTimes
            LianMengTotemRob.robMaxTimes = msg.robMaxTimes
            LeaguaBaseInfo.intrestLeftTimes=msg.intrestLeftTimes
            LeaguaBaseInfo.robLeftTimes=msg.robLeftTimes
            LeaguaBaseInfo.intrestMaxTimes=msg.intrestMaxTimes
            LeaguaBaseInfo.robMaxTimes=msg.robMaxTimes
		end
		if LianMengTotemRob.robLeftTimes ~=nil and (tonumber(LianMengTotemRob.robLeftTimes) <0) then
			MessageBoxPage:Msg_Box_Lan("@TotemNotEnoughTimes")
		end


		--MainFrame:getInstance():showPage("LianMengTotemRob")
	end
	if(container:getRecPacketOpcode() == 108) then
		container:removePacket(108)
		local fp = FightPage:getInstance()
		LianMengTotemRob.fightmessage = container:getRecPacketBuffer()
		fp:setMessage(container:getRecPacketBuffer(),container:getRecPacketBufferLength())
		--fp:setFightType(-1)
		local msg = MsgMainFrameCoverShow:new()
		msg.pageName = "FightPage"
		MessageManager:getInstance():sendMessageForScript(msg)
    end
    if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_GET_LEAGUA_OWN_MEDAL_INFORET_S) then
        container:removePacket(OP_League_pb.OPCODE_GET_LEAGUA_OWN_MEDAL_INFORET_S)
        local msg = LeagueStruct_pb.OPGetLeaguaOwnMedalRet()
        msgbuff = container:getRecPacketBuffer();
        msg:ParseFromString(msgbuff)
        local _hasFlags=false
        LianMengTotemFlagsListInfo={}
        for k,v in ipairs(msg._medalInfoList) do
            _hasFlags=true
            LianMengTotemFlagsListInfo[k]={}
            LianMengTotemFlagsListInfo[k].medalID=v.medalID
            LianMengTotemFlagsListInfo[k].ownerLeaguaID=v.ownerLeaguaID
            LianMengTotemFlagsListInfo[k].ownerLeaguaName=v.ownerLeaguaName
            LianMengTotemFlagsListInfo[k].count=v.count
        end
        if not _hasFlags then
            MessageBoxPage:Msg_Box_Lan("@LMNoFlags")
        else
            MainFrame:getInstance():pushPage("LianMengTotemFlagsListPage")
        end
    end
end
