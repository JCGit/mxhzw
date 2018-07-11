require "OP_League_pb"
require "LeagueStruct_pb"
require "LeagueStruct_ext_pb"

local LianMengJuanXianPage = {}
LianMengJuanXianPage.Num = 0
function luaCreat_LianMengJuanXianPage(container)
    container:registerFunctionHandler(LianMengJuanXianPage.onFunction)
end

function LianMengJuanXianPage.onFunction(eventName,container)
    if eventName == "luaLoad" then
        LianMengJuanXianPage.onLoad(container)
    elseif eventName == "luaReceivePacket" then
	    LianMengJuanXianPage.onReceivePacket(container)
	elseif eventName == "onReduceNum10" then
	    LianMengJuanXianPage.onReduceNum10(container)
	elseif eventName == "onReduceNum" then
	    LianMengJuanXianPage.onReduceNum(container)
	elseif eventName == "onAddNum" then
	    LianMengJuanXianPage.onAddNum(container)
	elseif eventName == "onAddNum10" then
	    LianMengJuanXianPage.onAddNum10(container)
	elseif eventName == "onConfirm" then
	    LianMengJuanXianPage.onConfirm(container)
	elseif eventName == "onClose" then
	    LianMengJuanXianPage.onClose(container)
    end
end

function LianMengJuanXianPage.onClose(container)
    MainFrame:getInstance():popPage("LianMengJuanXianPage")
end

function LianMengJuanXianPage.onReduceNum(container)
    if LianMengJuanXianPage.Num < 20000 then
        LianMengJuanXianPage.Num = 0
    else 
        LianMengJuanXianPage.Num = LianMengJuanXianPage.Num - 20000
    end
    LianMengJuanXianPage.refresh(container)
end

function LianMengJuanXianPage.onReduceNum10(container)
    if LianMengJuanXianPage.Num < 2000000 then
        LianMengJuanXianPage.Num = 0
    else 
        LianMengJuanXianPage.Num = LianMengJuanXianPage.Num - 2000000
    end
    LianMengJuanXianPage.refresh(container)
end

function LianMengJuanXianPage.onAddNum(container)
    LianMengJuanXianPage.Num = LianMengJuanXianPage.Num + 20000
    if ScriptMathToLua:compareSilverCoins(1000000000) then
        if LianMengJuanXianPage.Num > 1000000000 then
            LianMengJuanXianPage.Num = 1000000000
            MessageBoxPage:Msg_Box_Lan("@LianMengJuanXian_Max")
        end
    else
        if not ScriptMathToLua:compareSilverCoins(LianMengJuanXianPage.Num) then
            LianMengJuanXianPage.Num = LianMengJuanXianPage.Num - 20000
            MessageBoxPage:Msg_Box_Lan("@LianMengJuanXian_Max")
        end
    end
    LianMengJuanXianPage.refresh(container)
end

function LianMengJuanXianPage.onAddNum10(container)
    LianMengJuanXianPage.Num = LianMengJuanXianPage.Num + 2000000
    if ScriptMathToLua:compareSilverCoins(1000000000) then
        if LianMengJuanXianPage.Num > 1000000000 then
            LianMengJuanXianPage.Num = 1000000000
            MessageBoxPage:Msg_Box_Lan("@LianMengJuanXian_Max")
        end
    else
        if not ScriptMathToLua:compareSilverCoins(LianMengJuanXianPage.Num) then
            LianMengJuanXianPage.Num = LianMengJuanXianPage.Num - 2000000
            MessageBoxPage:Msg_Box_Lan("@LianMengJuanXian_Max")
        end
    end
    LianMengJuanXianPage.refresh(container)
end

function LianMengJuanXianPage.onConfirm(container)
	container:registerPacket(OP_League_pb.OPCODE_DONATE_FOUNDSRET_S)
    local msg = LeagueStruct_ext_pb.OPDonateFounds()
	msg.num = LianMengJuanXianPage.Num
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_DONATE_FOUNDS_C,pb_data,#pb_data,true)
	
	LianMengJuanXianPage.Num = 0
	LianMengJuanXianPage.refresh(container)
end

function LianMengJuanXianPage.refresh(container)
	container:getVarLabelBMFont("mNum"):setString(tostring(LianMengJuanXianPage.Num))
	container:getVarLabelBMFont("mlmjsjuanxiantitle"):setString(tostring(Language:getInstance():getString("@mlmjsjuanxianshopTitle")))
	container:getVarLabelBMFont("mjuanxianNote"):setString(tostring(Language:getInstance():getString("@mlmjsjuanxianshopCount")))
end

function LianMengJuanXianPage.onLoad(container)
	container:loadCcbiFile("lianmengjsjuanxian.ccbi")
	LianMengJuanXianPage.refresh(container)
end

function LianMengJuanXianPage.onReceivePacket(container)
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_DONATE_FOUNDSRET_S) then
		local msg = LeagueStruct_ext_pb.OPDonateFoundsRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)

        if msg:HasField("leaguaFunds") then
            LeaguaBaseInfo.leaguaFunds = msg.leaguaFunds
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
            
		if msg.status == 1 then
            MessageBoxPage:Msg_Box_Lan("@LianMengJuanXian_Success")
            local gamemsg = MsgMainFrameRefreshPage:new()
            gamemsg.pageName = "LianMengBuildingPage"
            MessageManager:getInstance():sendMessageForScript(gamemsg)
		elseif msg.status == 2 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengJuanXian_Faild")
		end
	end
end


