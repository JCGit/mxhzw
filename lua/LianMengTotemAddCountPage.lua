local LianMengTotemAddCountPage={}

LianMengTotemAddCountPage.mNeedGold=200
function luaCreat_LianMengTotemAddCountPage(container)
    CCLuaLog("OnCreat_LianMengTotemAddCountPage")
    container:registerFunctionHandler(LianMengTotemAddCountPage.onFunction)
end

function LianMengTotemAddCountPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengTotemAddCountPage.onEnter(container)
    elseif eventName == "luaExit" then
        LianMengTotemAddCountPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengTotemAddCountPage.onLoad(container)
	elseif eventName == "onButton" then
		LianMengTotemAddCountPage.onConfirm(container)
    elseif eventName == "onClose" then
        LianMengTotemAddCountPage.closePage(container)
    elseif eventName == "onLmzjAA1" then
        LianMengTotemAddCountPage.closePage(container)
    elseif eventName == "onLmzjAA2" then
        LianMengTotemAddCountPage.onAddCount(container)
    elseif eventName == "luaReceivePacket" then
        LianMengTotemAddCountPage.onReceivePacket(container)
    end
end

function LianMengTotemAddCountPage.closePage(container)
    MainFrame:getInstance():popPage("LianMengTotemAddCountPage")
end

function LianMengTotemAddCountPage.onConfirm(container)
    MainFrame:getInstance():popPage("LianMengTotemAddCountPage")
end

function LianMengTotemAddCountPage.onAddCount(container)
    if LianMengTotemAddCountPage.mNeedGold>ServerDateManager:getInstance():getUserBasicInfo().goldcoins then
        PopupPage:Pop_Box(NotEnoughGold)
    else
        container:registerPacket(OP_League_pb.OPCODE_ADD_ATTACK_NUMRET_S)
        local msg = LeagueStruct_ext_pb.OPAddAttackNum()
        msg.version = 1
        local pb_data = msg:SerializeToString()
        PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_ADD_ATTACK_NUM_C,pb_data,#pb_data,true)
    end
end

function LianMengTotemAddCountPage.onEnter(container)
    container:getVarLabelBMFont("mLmzjA1"):setString(tostring(Language:getInstance():getString("@Back")))
    container:getVarLabelBMFont("mLmzjA2"):setString(tostring(Language:getInstance():getString("@LMAddPlunderCount")))
    container:getVarLabelBMFont("mLmzjNumber"):setString(tostring(LianMengTotemAddCountPage.mNeedGold))
end

function LianMengTotemAddCountPage.onExit(container)	

end

function LianMengTotemAddCountPage.onLoad(container)
	container:loadCcbiFile("LianMengTotemRobcococo.ccbi")
end

function LianMengTotemAddCountPage.onReceivePacket(container)
    if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_ADD_ATTACK_NUMRET_S) then
        container:removePacket(OP_League_pb.OPCODE_ADD_ATTACK_NUMRET_S)
        local msg = LeagueStruct_ext_pb.OPAddAttackNumRet()
        msgbuff = container:getRecPacketBuffer();
        msg:ParseFromString(msgbuff)
        if msg.status==2 then
            LianMengTotemAddCountPage.closePage(container)
            PopupPage:Pop_Box(NotEnoughGold)
        else
           ServerDateManager:getInstance():getUserBasicInfo().goldcoins=msg.goldCoins
           LeaguaBaseInfo.robLeftTimes=msg.leftAttackNum
           MainFrame:getInstance():showPage("LianMengTotemRob")
           LianMengTotemAddCountPage.closePage(container)
        end
    end
end