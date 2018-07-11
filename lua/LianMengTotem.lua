require "LianMeng"
require "LeagueStruct_pb"
require "LeagueStruct_ext_pb"

local LianMengTotem = {}
LianMengTotem.repairID = nil

function luaCreat_LianMengTotem(container)
    CCLuaLog("OnCreat_LianMengTotem")
    container:registerFunctionHandler(LianMengTotem.onFunction)
end


function LianMengTotem.onFunction(eventName,container)
    if eventName == "luaInit" then
        LianMengTotem.onInit(container)
    elseif eventName == "luaEnter" then
        LianMengTotem.onEnter(container)
    elseif eventName == "luaExit" then
        LianMengTotem.onExit(container)
    elseif eventName == "luaExecute" then
        LianMengTotem.onExecute(container)
    elseif eventName == "luaLoad" then
        LianMengTotem.onLoad(container)
    elseif eventName == "luaUnLoad" then
        LianMengTotem.onUnLoad(container)
	elseif eventName == "luaGameMessage" then
		LianMengTotem.onGameMessage(container)
	elseif eventName == "luaReceivePacket" then
		LianMengTotem.onReceivePacket(container)
	---
	elseif eventName == "onDraw" then
	    LianMengTotem.onDraw(container)
	elseif eventName == "onAttack" then
		LianMengTotem.onAttack(container)
    elseif eventName == "onRevert" then
	    LianMeng_gotoMainPage()
	--switch pages
	elseif eventName == "onLMTotemMSG" then
	    MessageBoxPage:Msg_Box("@MAINPAGE_COMINGSOON")
	elseif eventName == "onLMTotem" then
	elseif eventName == "onLMT1" then
		LianMengTotem.onRepair(container,1)
	elseif eventName == "onLMT2" then
		LianMengTotem.onRepair(container,2)
	elseif eventName == "onLMT3" then
		LianMengTotem.onRepair(container,3)
	elseif eventName == "onLMT4" then
		LianMengTotem.onRepair(container,4)
	elseif eventName == "onLMT5" then
		LianMengTotem.onRepair(container,5)
    elseif eventName == "onHelp" then
        LianMengTotem.onHelp(container)
	end
end
-------------------------------------------------------------------

function LianMengTotem.onHelp(container)
    LianMengHelpType=2
    MainFrame:getInstance():showPage("LianMengHelpPage")
end

function LianMengTotem.onAttack(container)
    CCLuaLog("LianMengTotem.onAttack")
    --MainFrame:getInstance():showPage("LianMengRobRank");
	container:registerPacket(OP_League_pb.OPCODE_GET_ROB_LISTRET)
	local msg = LeagueStruct_pb.OPGetLeaguaRobList()
	msg.version = 1
	local pb_data = msg:SerializeToString()
	container:sendPakcet(OP_League_pb.OPCODE_GET_ROB_LIST,pb_data,#pb_data,true)
end

function LianMengTotem.onDraw(container)
    CCLuaLog("LianMengTotem.onDraw")
    if LeagueTotemInfo.status ==1 then
        --MainFrame:getInstance():showPage("LianMengRobRank");
        container:registerPacket(OP_League_pb.OPCODE_RECEIVE_TOTEMCONTRIBUTIONRET_S)
        local msg = LeagueStruct_ext_pb.OPReceiveTotemContribution()
        msg.version = 1
        local pb_data = msg:SerializeToString()
        container:sendPakcet(OP_League_pb.OPCODE_RECEIVE_TOTEMCONTRIBUTION_C,pb_data,#pb_data,true)
    else
        MessageBoxPage:Msg_Box_Lan("@TotemGetContributionNotCurrectTime")
    end
end

function LianMengTotem.onRepair(container,id)
    CCLuaLog("LianMengTotem.onRepair")
    if(LeaguaBaseInfo.playerGrade ~= 4 and LeaguaBaseInfo.playerGrade ~= 3)then
		MessageBoxPage:Msg_Box_Lan("@LianMengTotemRepairCantStart")
    else
        LianMengTotem.repairID = LeagueTotemIndex[id]
        if(LeagueTotemInfo._totemInfoList[id].totemLeftHP >= LeagueTotemInfo._totemInfoList[id].totemTotalHP) then
            MessageBoxPage:Msg_Box_Lan("@TotemRepairingBloodFull")
        elseif LeagueTotemInfo._totemInfoList[id].status == 1 or LeagueTotemInfo._totemInfoList[id].status == 2 then
            container:registerPacket(OP_League_pb.OPCODE_TOTEM_REPAIR_COSTRET_S)
            local msg = LeagueStruct_ext_pb.OPGetTotemRepairCost()
            msg.totemID = LianMengTotem.repairID
            local pb_data = msg:SerializeToString()
            container:sendPakcet(OP_League_pb.OPCODE_TOTEM_REPAIR_COST_C,pb_data,#pb_data,true)
        end
	end
end

function LianMengTotem.onUpdateTimeLeft(container)
    totemItem = {}
    totemItem[LeagueTotemIndex[1]] = container:getVarLabelBMFont("mbloodjin")
    totemItem[LeagueTotemIndex[2]] = container:getVarLabelBMFont("mbloodmu")
    totemItem[LeagueTotemIndex[3]] = container:getVarLabelBMFont("mbloodshui")
    totemItem[LeagueTotemIndex[4]] = container:getVarLabelBMFont("mbloodhuo")
    totemItem[LeagueTotemIndex[5]] = container:getVarLabelBMFont("mbloodtu")

    
    for k,v in ipairs(LeagueTotemInfo._totemInfoList) do
		container:getVarSprite("mLMTDestroy"..tostring(k)):setVisible(false)
		local info = LeagueTotemInfo._totemInfoList[k]
		if info.status == 1 then
			local outstr = tostring(info.totemLeftHP).."/"..tostring(info.totemTotalHP)
			totemItem[info.totemID]:setString(outstr)
		end
		if info.status == 2 then
			--local outstr = "0/"..tostring(info.totemTotalHP)
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
			        local lang = Language:getInstance():getString("@TotemRepairing")
			        local hh = math.floor(info.repairTime/60/60)
			        local mm = math.floor((info.repairTime/60) %60)
			        local ss = math.floor(info.repairTime%60)
			        local outstr = lang..tostring(hh)..":"..tostring(mm)..":"..tostring(ss)
			        totemItem[info.totemID]:setString(outstr)
		        end

            end
		end
	end
end

function LianMengTotem.onRepairEnsure(isRepair)
	if(isRepair)then
		local msg = LeagueStruct_pb.OPRepairTotem()
		msg.totemID = LianMengTotem.repairID
		msg.type = 1
		local pb_data = msg:SerializeToString()
		PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_REPAIR_TOTEM_C,pb_data,#pb_data,true)
	end
end

---------------------------------------------------------
function LianMengTotem.onInit(container)
    CCLuaLog("LianMengTotem.onInit")
end

function LianMengTotem.onEnter(container)
    CCLuaLog("LianMengTotem.onEnter")
    for k,v in ipairs(LeagueTotemInfo._totemInfoList) do
	    local info = LeagueTotemInfo._totemInfoList[k]
	    if info.status == 3 and (info.repairTime>0)then
		    TimeCalculator:getInstance():createTimeCalcultor("LMTotemRepair"..tostring(k),info.repairTime)
	    end
    end
    LianMengTotem.onUpdateTimeLeft(container)

	local contriStr = ""
    if LeagueTotemInfo.status ==1 or LeagueTotemInfo.status ==2 then
        contriStr = tostring(LeagueTotemInfo.ReceiveContribution).."/"..tostring(LeagueTotemInfo.totalContribution)
    elseif LeagueTotemInfo.status ==3 then
        contriStr = Language:getInstance():getString("@LMTotemContributionGained")
    end
	container:getVarLabelBMFont("mcontribution"):setString(contriStr)
end

function LianMengTotem.onExit(container)	
    CCLuaLog("LianMengTotem.onExit")
end

function LianMengTotem.onExecute(container)
    LianMengTotem.onUpdateTimeLeft(container)
    if(TimeCalculator:getInstance():hasKey("LianmengTotemRepairEnsureCD"))then
        local timeleft = TimeCalculator:getInstance():getTimeLeft("LianmengTotemRepairEnsureCD")
        if(timeleft<=0)then
            MainFrame:getInstance():popPage("DecisionPage")
        end
    end
end

function LianMengTotem.onLoad(container)
	CCLuaLog("LianMengTotem.onLoad")
	container:loadCcbiFile("LianMengTotem.ccbi");
	CCLuaLog(container:dumpInfo())
end

function LianMengTotem.onUnLoad(container)
	CCLuaLog("LianMengTotem.onUnLoad")
end

function LianMengTotem.onReceivePacket(container)
	CCLuaLog("LianMengTotem.onReceivePacket")
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_GET_ROB_LISTRET) then
		container:removePacket(OP_League_pb.OPCODE_GET_ROB_LISTRET)
		local msg = LeagueStruct_pb.OPGetLeaguaRobListRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		--CCLuaLog("RobList")
		for k,v in ipairs(msg._leaguaRankInfoList) do
	        LianMengRobRank.mRobList[k] = v;
	        --CCLuaLog(tostring(v.leaguaID)..v.leaguaName)
	    end
		MainFrame:getInstance():showPage("LianMengRobRank");
	end
	
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_REPAIR_TOTEMRET_S) then
		container:removePacket(OP_League_pb.OPCODE_REPAIR_TOTEMRET_S)
		local msg = LeagueStruct_pb.OPRepairTotemRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		for k,v in ipairs(msg._totemInfoList) do
	        LeagueTotemInfo._totemInfoList[k] = v;
	    end
		if(msg.status and msg.status==1) then
			MessageBoxPage:Msg_Box_Lan("@LianMengTotemRepairDone")
		elseif(msg.status and msg.status==2) then
				MessageBoxPage:Msg_Box_Lan("@LianMengTotemRepairFailed2")
		elseif(msg.status and msg.status==3) then
			MessageBoxPage:Msg_Box_Lan("@LianMengTotemRepairFailed3")
		else
			MessageBoxPage:Msg_Box_Lan("@LianMengTotemRepairFailed")
		end
	end
	
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_RECEIVE_TOTEMCONTRIBUTIONRET_S) then
		container:removePacket(OP_League_pb.OPCODE_RECEIVE_TOTEMCONTRIBUTIONRET_S)
		local msg = LeagueStruct_ext_pb.OPReceiveTotemContributionRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		if (msg.status and msg.status==1) then
		    MessageBoxPage:Msg_Box_Lan("@LianMengTotemReceiveSuccess")
		    LeaguaBaseInfo.playerLeftContribution=LeaguaBaseInfo.playerLeftContribution+msg.receiveContribution
		    LeaguaBaseInfo.playerTotalContribution=msg.playerContribution
		    LeagueTotemInfo.status = 3
            contriStr = Language:getInstance():getString("@LMTotemContributionGained")
            container:getVarLabelBMFont("mcontribution"):setString(contriStr)
		else
            MessageBoxPage:Msg_Box_Lan("@LianMengTotemReceiveFailed")    
		end
	end
	
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_TOTEM_REPAIR_COSTRET_S) then
	    local msg = LeagueStruct_ext_pb.OPGetTotemRepairCostRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		
	    container:removePacket(OP_League_pb.OPCODE_TOTEM_REPAIR_COSTRET_S)
	    container:registerPacket(OP_League_pb.OPCODE_REPAIR_TOTEMRET_S)
        local str = Language:getInstance():getString("@LianMengTotemRepairEnsure")
	    ShowDecisionPage(msg.cost..str,LianMengTotem.onRepairEnsure)
	    
	    TimeCalculator:getInstance():createTimeCalcultor("LianmengTotemRepairEnsureCD",5)
	end
end

function LianMengTotem.onGameMessage(container)
	CCLuaLog("LianMengTotem.onGameMessage")
end

