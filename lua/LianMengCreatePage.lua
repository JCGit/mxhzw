require "OP_League_pb"
require "LeagueStruct_pb"
require "LeagueStruct_ext_pb"

local LianMengCreatePage = {}
LianMengCreatePage.inputName = nil
function luaCreat_LianMengCreatePage(container)
    container:registerFunctionHandler(LianMengCreatePage.onFunction)
end

function LianMengCreatePage.onFunction(eventName,container)
    if eventName == "luaLoad" then
        LianMengCreatePage.onLoad(container)
    elseif eventName == "luaUnLoad" then
        LianMengCreatePage.onUnLoad(container)
	elseif eventName == "luaInputboxEnter" then
        LianMengCreatePage.onInputboxEnter(container)
    elseif eventName == "luaReceivePacket" then
	    LianMengCreatePage.onReceivePacket(container)
	elseif eventName == "onLMInput" then
	    LianMengCreatePage.onLMInput(container)
	elseif eventName == "onOK" then
	    LianMengCreatePage.onOK(container)
	elseif eventName == "onClose" then
	    LianMengCreatePage.onClose(container)
    end
end

function LianMengCreatePage.onInputboxEnter(container)
    local content = container:getInputboxContent()
    local nameOK = true
    if GameMaths:isStringHasUTF8mb4(content) then
		nameOK = false
    end
	if not RestrictedWord:getInstance():isStringOK(content) then
		nameOK = false
	end
    if content == "" then
		nameOK = false
    end
	if not nameOK then
        MessageBoxPage:Msg_Box("@NameHaveForbbidenChar")
        content = nil
        return
    end
	if GameMaths:calculateStringCharacters(content) <= 7 then
		LianMengCreatePage.inputName = content
	else
		LianMengCreatePage.inputName = GameMaths:getStringSubCharacters(content,0,7)
	end
    container:getVarLabelTTF("mLianMengInput"):setString(LianMengCreatePage.inputName)    
end

function LianMengCreatePage.onLMInput(container)
	container:registerLibOS()
	libOS:getInstance():showInputbox(false)
end

function LianMengCreatePage.onOK(container)
    if LianMengCreatePage.inputName then
        container:registerPacket(OP_League_pb.OPCODE_CREATE_LEAGUARET_S)
        local msg = LeagueStruct_pb.OPCreateLeagua()
	    msg.leaguaName = LianMengCreatePage.inputName
	    local pb_data = msg:SerializeToString()
	    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_CREATE_LEAGUA_C,pb_data,#pb_data,true)
	else
	    MessageBoxPage:Msg_Box("@LianMengCreat_InputName")
	end
end

function LianMengCreatePage.onClose(container)
	MainFrame:getInstance():popPage("LianMengCreatePage")
end

function LianMengCreatePage.onLoad(container)
	container:loadCcbiFile("LianMengCreate.ccbi")
	if LianMengCreatePage.inputName then
	    container:getVarLabelTTF("mLianMengInput"):setString(LianMengCreatePage.inputName)
	else
	    container:getVarLabelTTF("mLianMengInput"):setString("")
    end
end

function LianMengCreatePage.onUnLoad(container)
	container:removeLibOS()
end

function LianMengCreatePage.onReceivePacket(container)
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_CREATE_LEAGUARET_S) then
		local msg = LeagueStruct_pb.OPCreateLeaguaRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		
		if msg.status == 1 then
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
            end
            if msg:HasField("goldcoins") then
                ServerDateManager:getInstance():getUserBasicInfo().goldcoins = msg.goldcoins
            end
            MainFrame:getInstance():popPage("LianMengCreatePage")
            LianMeng_gotoMainPage()
		elseif msg.status == 2 then --name repeat
		    MessageBoxPage:Msg_Box_Lan("@LianMengCreat_NameRepeat")
		elseif msg.status == 3 then --already in leagua
		    MessageBoxPage:Msg_Box_Lan("@LianMengCreat_HasLeagua")
		elseif msg.status == 4 then --level or coin not enough
		    MessageBoxPage:Msg_Box_Lan("@LianMengCreat_LowLevelorGoldcoins")
		end
	end
end


