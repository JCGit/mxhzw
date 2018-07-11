require "OP_League_pb"
require "LeagueStruct_pb"
require "LeagueStruct_ext_pb"

local LianMengJinGongPage = {}

function luaCreat_LianMengJinGongPage(container)
    container:registerFunctionHandler(LianMengJinGongPage.onFunction)
end

function LianMengJinGongPage.onFunction(eventName,container)
    if eventName == "luaLoad" then
        LianMengJinGongPage.onLoad(container)
    elseif eventName == "luaReceivePacket" then
	    LianMengJinGongPage.onReceivePacket(container)
	elseif eventName == "onlianmengjingong1" then
	    LianMengJinGongPage.onlianmengjingong(container,1)
	elseif eventName == "onlianmengjingong2" then
	    LianMengJinGongPage.onlianmengjingong(container,2)
	elseif eventName == "onlianmengjingong3" then
	    LianMengJinGongPage.onlianmengjingong(container,3)
    elseif eventName == "onlianmengjingong4" then
        LianMengJinGongPage.onlianmengjingong(container,4)
	elseif eventName == "onClose" then
	    LianMengJinGongPage.onClose(container)
    end
end

function LianMengJinGongPage.onClose(container)
    MainFrame:getInstance():popPage("LianMengJinGongPage")
end

function LianMengJinGongPage.onlianmengjingong(container, type)
	container:registerPacket(OP_League_pb.OPCODE_DONATE_BUILDINGRET_S)
    local msg = LeagueStruct_pb.OPDonateBuilding()
	msg.buildingID = LianMengBuildings[getSellectedBuildingID()].buildingID
	msg.donateType = type
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_DONATE_BUILDING_C,pb_data,#pb_data,true)
end

function LianMengJinGongPage.onLoad(container)
	container:loadCcbiFile("lianmengjsjingong.ccbi");
end

function LianMengJinGongPage.onReceivePacket(container)
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_DONATE_BUILDINGRET_S) then
		local msg = LeagueStruct_pb.OPDonateBuildingRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)

		if msg:HasField("_buildingInfo") then
				local v = msg._buildingInfo
	            LeaguaBuildingInfoList[v.buildingID] = {}
	            LeaguaBuildingInfoList[v.buildingID]["buildingID"] = v.buildingID
	            LeaguaBuildingInfoList[v.buildingID]["buildingLevel"] = v.buildingLevel
	            LeaguaBuildingInfoList[v.buildingID]["buildingCurSchedule"] = v.buildingCurSchedule
	            LeaguaBuildingInfoList[v.buildingID]["buildingFinishSchedule"] = v.buildingFinishSchedule
	            if v.buildingID == 12 then
	                LeaguaBaseInfo.leaguaLevel = v.buildingLevel
	            end
        end
        if msg:HasField("goldcoins") then
            ServerDateManager:getInstance():getUserBasicInfo().goldcoins = msg.goldcoins
        end
        if msg:HasField("silvercoins") then
            ScriptMathToLua:modifySilverCoins(tonumber(msg.silvercoins))
        end
        if msg:HasField("playerLeftContribution") then
            LeaguaBaseInfo.playerLeftContribution = msg.playerLeftContribution
        end
        if msg:HasField("playerTotalContribution") then
            LeaguaBaseInfo.playerTotalContribution = msg.playerTotalContribution
        end
        if msg:HasField("leaguaMaxMemberCount") then
            LeaguaBaseInfo.leaguaMaxMemberCount = msg.leaguaMaxMemberCount
        end
            
		if msg.status == 1 then
            MessageBoxPage:Msg_Box_Lan("@LianMengJinGong_Success")
            local gamemsg = MsgMainFrameRefreshPage:new()
            gamemsg.pageName = "LianMengBuildingPage"
            MessageManager:getInstance():sendMessageForScript(gamemsg)
        elseif msg.status == 2 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengJinGong_Faild")
		elseif msg.status == 3 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengJinGong_Faild_Maxlevel")
		elseif msg.status == 4 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengJinGong_Faild_lowcoin")
		end
	end
end


