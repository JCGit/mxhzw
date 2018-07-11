require "OP_League_pb"
require "LeagueStruct_pb"
require "LeagueStruct_ext_pb"

local LianMengBuildingPage = {}
LianMengBuildingPage.sellectedItemID = 1

function getSellectedBuildingID()
	return LianMengBuildingPage.sellectedItemID
end

function luaCreat_LianMengBuildingPage(container)
    container:registerFunctionHandler(LianMengBuildingPage.onFunction)
end

function LianMengBuildingPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengBuildingPage.onEnter(container)
    elseif eventName == "luaExit" then
        LianMengBuildingPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengBuildingPage.onLoad(container)
	elseif eventName == "luaGameMessage" then
		LianMengBuildingPage.onGameMessage(container)
	elseif eventName == "onLMjuanxian" then
		LianMengBuildingPage.onLMjuanxian(container)
	elseif eventName == "onLMshop" then
		LianMengBuildingPage.onLMshop(container)
	elseif eventName == "onLMreturn" then
		LianMengBuildingPage.onLMreturn(container)
    elseif eventName == "onHelp" then
        LianMengBuildingPage.onHelp(container)
	elseif string.find(eventName, "onmlmjiansheico") ~= nil then
		LianMengBuildingPage.onLMjiansheicon(container, eventName)
	end
end

function LianMengBuildingPage.onHelp(container)
    LianMengHelpType=3
    MainFrame:getInstance():showPage("LianMengHelpPage")
end

function LianMengBuildingPage.onLMjuanxian(container, eventName)
    if LianMengBuildings[LianMengBuildingPage.sellectedItemID].buildingType == 4 then
--        MessageBoxPage:Msg_Box("@MAINPAGE_COMINGSOON")
--        return
    end
    if LianMengBuildings[LianMengBuildingPage.sellectedItemID].buildingID == 2 then
        MainFrame:getInstance():pushPage("LianMengJuanXianPage")
    else
        --[[if LianMengBuildings[LianMengBuildingPage.sellectedItemID].buildingID >=3 and tonumber(LianMengBuildings[LianMengBuildingPage.sellectedItemID].buildingID) <= 7 then
	        MessageBoxPage:Msg_Box_Lan("@MAINPAGE_COMINGSOON")
        else]]
            MainFrame:getInstance():pushPage("LianMengJinGongPage")
        --end
    end
end

-------------------------------------------------------------------
function OPGetLeaguaShopInfoHandler(eventName,handler)
    if eventName == "luaReceivePacket" then
        local msg = LeagueStruct_ext_pb.OPGetLeaguaShopInfoRet()
	    local msgbuff = handler:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
	    LeaguaShopInfo.shopGoodInfoList = {}
        for k, v in ipairs(msg._shopGoodInfoList) do
	        LeaguaShopInfo.shopGoodInfoList[v.id] = {}
	        LeaguaShopInfo.shopGoodInfoList[v.id]["id"] = v.id
	        LeaguaShopInfo.shopGoodInfoList[v.id]["goodID"] = v.goodID
	        LeaguaShopInfo.shopGoodInfoList[v.id]["goodType"] = v.goodType
	        LeaguaShopInfo.shopGoodInfoList[v.id]["goodPrice"] = v.goodPrice
	        LeaguaShopInfo.shopGoodInfoList[v.id]["goodCount"] = v.goodCount
	        LeaguaShopInfo.shopGoodInfoList[v.id]["goodBuyPermissions"] = v.goodBuyPermissions
	        LeaguaShopInfo.shopGoodInfoList[v.id]["goodLevel"] = v.goodLevel
        end
        LeaguaShopInfo["cdTime"] = msg.cdTime
        LeaguaShopInfo["refreshTime"] = msg.refreshTime
        MainFrame:getInstance():showPage("LianMengShopPage");
    end
end
PacketScriptHandler:new(OP_League_pb.OPCODE_GET_LEAGUASHOPINFORET_S, OPGetLeaguaShopInfoHandler)

function LianMengBuildingPage.onLMshop(container)
    local msg = LeagueStruct_ext_pb.OPGetLeaguaShopInfo()
	msg.version = 1
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_GET_LEAGUASHOPINFO_C,pb_data,#pb_data,true)
end

-------------------------------------------------------------------
function LianMengBuildingPage.onLMreturn(container, eventName) 
    MainFrame:getInstance():showPage("LianMengPage")
end

function LianMengBuildingPage.onLMjiansheicon(container, eventName) 
    local iconItem = string.gsub(eventName, "onmlmjiansheico","")
    LianMengBuildingPage.sellectItem(container, tonumber(iconItem))
end

function LianMengBuildingPage.refreshPage(container)
    container:getVarLabelTTF("mLMName"):setString(LeaguaBaseInfo.leaguaName)
    container:getVarLabelBMFont("mLMLV"):setString(tostring(LeaguaBaseInfo.leaguaLevel))
    container:getVarLabelBMFont("mlmpeople"):setString(LeaguaBaseInfo.leaguaCurMemberCount.."/"..LeaguaBaseInfo.leaguaMaxMemberCount)
    container:getVarLabelBMFont("mLMMoney"):setString(tostring(LeaguaBaseInfo.leaguaFunds))
    
    for k,v in ipairs(LianMengBuildings) do
        container:getVarSprite( "mlmjiansheico" .. k ):setTexture(v.buildingIcon)
    end
end

function LianMengBuildingPage.sellectItem(container, item)
    if LianMengBuildingPage.sellectedItemID ~= nil then
		container:getVarMenuItemImage("mmlmjiansheframe" .. LianMengBuildingPage.sellectedItemID):unselected()
	end
    container:getVarMenuItemImage("mmlmjiansheframe" .. item):selected()
    LianMengBuildingPage.sellectedItemID = item
    local building = LianMengBuildings[LianMengBuildingPage.sellectedItemID]
    container:getVarSprite("mlmjsico"):setTexture(building.buildingIcon)
    container:getVarLabelBMFont("mLMBDName"):setString(building.buildingName)
    
    local lvInfo = LianmengBuildingLvlInfo[LeaguaBuildingInfoList[LianMengBuildings[item].buildingID].buildingLevel]
    local t = {}
    if building.buildingType == 3 then
        t["%d1"] = lvInfo.C_Exp
        t["%d2"] = lvInfo.C_Buff
    elseif building.buildingID == 12 then
        t["%d1"] = lvInfo.Num
    elseif building.buildingID == 8 then
        t["%d1"] = lvInfo.D_Exp
    elseif building.buildingID == 9 then
        t["%d1"] = lvInfo.D_Attack
    elseif building.buildingID == 10 then
        t["%d1"] = lvInfo.D_Defense
    elseif building.buildingID == 11 then
        t["%d1"] = lvInfo.D_Will
    end
    local s = string.gsub(building.buildingDescribe, "%%d%d", t)
    local descirbe = ""
    s, descirbe = GameMaths:stringAutoReturn(s, descirbe, 10, 0) 
    container:getVarLabelBMFont("mlmjsxinxi"):setString(descirbe)
    
    container:getVarLabelBMFont("mlmjslmLV"):setString(LeaguaBuildingInfoList[LianMengBuildings[item].buildingID].buildingLevel)
    if building.buildingID == 2 then
        local s = Language:getInstance():getString("@LianMeng_Zijin")
        container:getVarLabelBMFont("mlmjsjinduTex"):setString(s)
        container:getVarLabelBMFont("mlmjsjindu"):setString(tostring(LeaguaBaseInfo.leaguaFunds))
    else
        local s = Language:getInstance():getString("@LianMeng_Jindu")
        container:getVarLabelBMFont("mlmjsjinduTex"):setString(s)
        if LeaguaBuildingInfoList[LianMengBuildings[item].buildingID].buildingLevel == 7 then
            container:getVarLabelBMFont("mlmjsjindu"):setString("MAX")
        else
            container:getVarLabelBMFont("mlmjsjindu"):setString(LeaguaBuildingInfoList[LianMengBuildings[item].buildingID].buildingCurSchedule .. "/" .. LeaguaBuildingInfoList[LianMengBuildings[item].buildingID].buildingFinishSchedule)
        end
    end
end

function LianMengBuildingPage.onEnter(container) 
    LianMengBuildingPage.refreshPage(container)
    LianMengBuildingPage.sellectItem(container, LianMengBuildingPage.sellectedItemID)
    container:registerMessage(MSG_MAINFRAME_REFRESH)
end

function LianMengBuildingPage.onExit(container)	

end

function LianMengBuildingPage.onLoad(container)
	container:loadCcbiFile("LianMengjianshe.ccbi");
end

function LianMengBuildingPage.onGameMessage(container)
    if container:getMessage():getTypeId() == MSG_MAINFRAME_REFRESH then
        LianMengBuildingPage.onEnter(container)
    end
end
