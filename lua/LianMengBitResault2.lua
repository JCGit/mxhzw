require "LianMeng"
require "LianMengRobRank"

local LianMengBitResault2 = {}
LianMengBitResault2.sellectedItemID = 1

function luaCreat_LianMengBitResault2(container)
    container:registerFunctionHandler(LianMengBitResault2.onFunction)
end

function LianMengBitResault2.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengBitResault2.onEnter(container)
    elseif eventName == "luaExit" then
        LianMengBitResault2.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengBitResault2.onLoad(container)
	elseif eventName == "luaReceivePacket" then
		LianMengBitResault2.onReceivePacket(container)
	elseif eventName == "onLMAttack" then
        LianMengBitResault2.closePage(container)
    elseif eventName == "onLMAttackAgain" then
        LianMengBitResault2.onAttack(container)
    elseif eventName == "onClose" then
        LianMengBitResault2.closePage(container)
    elseif eventName == "onLMReturn" then
        LianMengBitResault2.closePage(container)
    elseif eventName == "luaGameMessage" then
        LianMengBitResault2.gameMessage(container)
	end
end

function LianMengBitResault2.onAttack(container)
    local canAttack=false
    for k,v in ipairs(LianMengRobRank.LeagueTotemRobInfo._totemInfoList) do
        local info = LianMengRobRank.LeagueTotemRobInfo._totemInfoList[k]
        if info.totemID==LianMengTotemRob.mAttackId and info.status==1 then
            canAttack=true
        end
    end
    if canAttack then
        if LeaguaBaseInfo.robLeftTimes<=0 then
            MainFrame:getInstance():pushPage("LianMengTotemAddCountPage")
        else
            container:registerPacket(OP_League_pb.OPCODE_ROB_LEAGUERET)
            container:registerPacket(108)--UserBattle
            local msg = LeagueStruct_ext_pb.OPGetLeaguaRob()
            msg.leaguaID = LianMengRobRank.attackLeagueID
            msg.version = 1
            msg.totemID = LianMengTotemRob.mAttackId
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

function LianMengBitResault2.closePage(container) 
	local msg = MsgMainFrameCoverHide:new()
	msg.pageName = "LianMengBitResault2.ccbi"
	MessageManager:getInstance():sendMessageForScript(msg);
	
    MainFrame:getInstance():showPage("LianMengRobRank");
--[[	
	local msg2 = MsgMainFrameChangePage()
	msg2.pageName = "LianMengTotem"
	MessageManager:getInstance():sendMessageForScript(msg2);
--]]
end

function LianMengBitResault2.onEnter(container) 
	CCLuaLog("LianMengBitResault2.onEnter")
    CCLuaLog(container:dumpInfo())
    container:getVarLabelBMFont("mLMGX"):setString(tostring(LianMengTotemRob.contribution))
end

function LianMengBitResault2.onExit(container)	

end

function LianMengBitResault2.onLoad(container)
	container:loadCcbiFile("LianMengBitResault2.ccbi");

end

function LianMengBitResault2.gameMessage(container)
    local message = container:getMessage()
    if message:getTypeId() == 26 --[[MSG_FIGHTPAGE_EXIT]] then
        container:removeMessage(26)
        CCLuaLog("show result")
        local msg = MsgMainFrameCoverShow:new()
        if(LianMengTotemRob.gotBadgeID~=nil)then
            msg.pageName = "LianMengBitResault"
        else
            msg.pageName = "LianMengBitResault2"
        end
        MessageManager:getInstance():sendMessageForScript(msg)
        --end
    end
end

function LianMengBitResault2.onReceivePacket(container)
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
    elseif(container:getRecPacketOpcode() == 108) then
        container:removePacket(108)
        local fp = FightPage:getInstance()
        LianMengTotemRob.fightmessage = container:getRecPacketBuffer()
        fp:setMessage(container:getRecPacketBuffer(),container:getRecPacketBufferLength())
        --fp:setFightType(-1)
        local msg = MsgMainFrameCoverShow:new()
        msg.pageName = "FightPage"
        MessageManager:getInstance():sendMessageForScript(msg)
        container:registerMessage(26)--[[MSG_FIGHTPAGE_EXIT]]
    end
end
