
local bidNum = 0

local LianMengBattleTotemUsePage = {}
LianMengChooseTotemID = 0

function luaCreat_LianMengBattleTotemUsePage(container)
    CCLuaLog("OnCreat_LianMengBattleTotemUsePage")
    container:registerFunctionHandler(LianMengBattleTotemUsePage.onFunction)
end

function LianMengBattleTotemUsePage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengBattleTotemUsePage.onEnter(container)
    elseif eventName == "luaExecute" then
        LianMengBattleTotemUsePage.onExecute(container)
    elseif eventName == "onClose" then
        LianMengTotemUseFlag = true
    	MainFrame:getInstance():showPage("LianMengBattlePage")
    elseif eventName == "onBack" then
        MainFrame:getInstance():showPage("LianMengPage")
    elseif eventName == "luaExit" then
        LianMengBattleTotemUsePage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengBattleTotemUsePage.onLoad(container)
	elseif eventName == "onConfirm" then
		LianMengBattleTotemUsePage.onConfirm(container)
    elseif (string.find(eventName,"onLMTotem") ~= nil) then 
	    LianMengBattleTotemUsePage.useTotem(string.sub(eventName,  string.len(eventName)))
    end
end

function LianMengBattleTotemUsePage.onConfirm(container)
    MainFrame:getInstance():showPage("LianMengPage")
end

function LianMengBattleTotemUsePage.onEnter(container)

    if BlackBoard:getInstance():hasVarible("LianMengCurBidNum") then
        bidNum = BlackBoard:getInstance():getVarible("LianMengCurBidNum")
    end


    container:getVarSprite("mLMTDestroy1"):setVisible(false)
    container:getVarSprite("mLMTDestroy2"):setVisible(false)
    container:getVarSprite("mLMTDestroy3"):setVisible(false)
    container:getVarSprite("mLMTDestroy4"):setVisible(false)
    container:getVarSprite("mLMTDestroy5"):setVisible(false)
    
    container:getVarLabelBMFont("mBloodJin"):setVisible(false)
    container:getVarLabelBMFont("mBloodTu"):setVisible(false)
    container:getVarLabelBMFont("mBloodMu"):setVisible(false)
    container:getVarLabelBMFont("mBloodHuo"):setVisible(false)
    container:getVarLabelBMFont("mBloodShui"):setVisible(false)
    
    for i = 1,5 do
        if LianmengBattleInfo.buildingInfo[i].buildingHealth == 1 then
            container:getVarMenuItemImage("mLMTotem" .. i):setEnabled(true)
        elseif LianmengBattleInfo.buildingInfo[i].buildingHealth == 0 then
            container:getVarMenuItemImage("mLMTotem" .. i):setEnabled(false)
        end
        
        local str=Language:getInstance():getString("@LMBattleBuildingLV")
        str=string.gsub(str,"#v1#",tostring(LianmengBattleInfo.buildingInfo[i].buildingLevel))
        container:getVarLabelBMFont("mTotemLV" .. i):setString(str)
        
    end
end

function LianMengBattleTotemUsePage.onExecute(container)
    local timeleft = TimeCalculator:getInstance():getTimeLeft("LianMengBattleCD")
    local m = (timeleft - timeleft%60)/60
    local s = timeleft%60
    if s < 10 then
        container:getVarLabelBMFont("mSelectTime"):setString(m .. ":0" .. s)
    else
        container:getVarLabelBMFont("mSelectTime"):setString(m .. ":" .. s)
    end
    
    if timeleft <= 0 then
        local msg = LeagueStruct_battle_pb.OPLianMengJoinBattle()
        msg.version = 1
        local pb_data = msg:SerializeToString()
        PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_JOIN_BATTLE_C,pb_data,#pb_data,true)
    end

end

function LianMengBattleTotemUsePage.onExit(container)	
--    LianMengBattleTotemUsePage.clearAllItem(container)
--	container.m_pScrollViewFacade:delete()
--	container.m_pScrollViewFacade = nil
end

function LianMengBattleTotemUsePage.onLoad(container)
	container:loadCcbiFile("LianMengTotemUse.ccbi")
--	container.mScrollView = container:getVarScrollView("mContent")
--	container.mScrollViewRootNode = container.mScrollView:getContainer()
end


function LianMengBattleTotemUsePage.clearAllItem(container)
--    container.m_pScrollViewFacade:clearAllItems()
--    container.mScrollViewRootNode:removeAllChildren()
end

function LianMengBattleTotemUsePage.useTotem(totemNum)
    LianMengChooseTotemID = totemNum + 3
    MainFrame:getInstance():pushPage("LianMengBattleTotemUsePopupPage")
    
--    container.m_pScrollViewFacade:clearAllItems()
--    container.mScrollViewRootNode:removeAllChildren()
end
