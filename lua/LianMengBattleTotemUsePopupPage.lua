
local bidNum = 0

local LianMengBattleTotemUsePopupPage = {}

function luaCreat_LianMengBattleTotemUsePopupPage(container)
    CCLuaLog("OnCreat_LianMengBattleTotemUsePopupPage")
    container:registerFunctionHandler(LianMengBattleTotemUsePopupPage.onFunction)
end

function LianMengBattleTotemUsePopupPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengBattleTotemUsePopupPage.onEnter(container)
    elseif eventName == "luaExecute" then
        LianMengBattleTotemUsePopupPage.onExecute(container)
    elseif eventName == "onClose" then
    	MainFrame:getInstance():popPage("LianMengBattleTotemUsePopupPage")
    elseif eventName == "luaExit" then
        LianMengBattleTotemUsePopupPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengBattleTotemUsePopupPage.onLoad(container)
	elseif eventName == "onConfirm" then
		LianMengBattleTotemUsePopupPage.onConfirm(container)
	elseif eventName == "onCancle" then
    	MainFrame:getInstance():popPage("LianMengBattleTotemUsePopupPage")
    end
end

function LianMengBattleTotemUsePopupPage.onConfirm(container)
    MainFrame:getInstance():popPage("LianMengBattleTotemUsePopupPage")

    local msg = LeagueStruct_battle_pb.OPLianMengJoinBattle()
    msg.version = 1
    msg.buildingIndex = LianMengChooseTotemID - 1
    local pb_data = msg:SerializeToString()
    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_JOIN_BATTLE_C,pb_data,#pb_data,true)

end

function LianMengBattleTotemUsePopupPage.onEnter(container)

    if BlackBoard:getInstance():hasVarible("LianMengCurBidNum") then
        bidNum = BlackBoard:getInstance():getVarible("LianMengCurBidNum")
    end
    container:getVarSprite("mTotemPic"):setTexture(LianMengBuildings[LianMengChooseTotemID].buildingIcon)
    
--LeaguaBuildingInfoList
--LianMengChooseTotemID
end

function LianMengBattleTotemUsePopupPage.onExecute(container)
end

function LianMengBattleTotemUsePopupPage.onExit(container)	
--    LianMengBattleTotemUsePopupPage.clearAllItem(container)
--	container.m_pScrollViewFacade:delete()
--	container.m_pScrollViewFacade = nil
end

function LianMengBattleTotemUsePopupPage.onLoad(container)
	container:loadCcbiFile("LianMengTotemUsePopUp.ccbi")
--	container.mScrollView = container:getVarScrollView("mContent")
--	container.mScrollViewRootNode = container.mScrollView:getContainer()
end


function LianMengBattleTotemUsePopupPage.clearAllItem(container)
--    container.m_pScrollViewFacade:clearAllItems()
--    container.mScrollViewRootNode:removeAllChildren()
end

