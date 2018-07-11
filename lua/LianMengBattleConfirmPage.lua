
local bidNum = 0

local LianMengBattleConfirmPage = {}

function luaCreat_LianMengBattleConfirmPage(container)
    CCLuaLog("OnCreat_LianMengBattleConfirmPage")
    container:registerFunctionHandler(LianMengBattleConfirmPage.onFunction)
end

function LianMengBattleConfirmPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengBattleConfirmPage.onEnter(container)
    elseif eventName == "luaExecute" then
        LianMengBattleConfirmPage.onExecute(container)
    elseif eventName == "onClose" then
    	MainFrame:getInstance():showPage("LianMengBattlePage")
    elseif eventName == "onBack" then
        MainFrame:getInstance():showPage("LianMengPage")
    elseif eventName == "luaExit" then
        LianMengBattleConfirmPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengBattleConfirmPage.onLoad(container)
	elseif eventName == "onConfirm" then
		LianMengBattleConfirmPage.onConfirm(container)
	elseif eventName == "onLMBid" then
        MainFrame:getInstance():showPage("LianMengBattleBidEnterPage")
	elseif eventName == "onWitness" then
        LianMengBattleConfirmPage.onWitness(container)
	elseif eventName == "onJoin" then
        LianMengBattleConfirmPage.onJoin(container)
    end
end

function LianMengBattleConfirmPage.onConfirm(container)
    MainFrame:getInstance():showPage("LianMengPage")
end

function LianMengBattleConfirmPage.onExecute(container)
    local timeleft = TimeCalculator:getInstance():getTimeLeft("LianMengBattleCD")
    
    if timeleft <= 0 then
        local msg = LeagueStruct_battle_pb.OPLianMengJoinBattle()
        msg.version = 1
        local pb_data = msg:SerializeToString()
        PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_JOIN_BATTLE_C,pb_data,#pb_data,true)
    end
end

function LianMengBattleConfirmPage.onWitness(container)
    local bidNum
    if BlackBoard:getInstance():hasVarible("LianMengCurBidNum") then
        bidNum = BlackBoard:getInstance():getVarible("LianMengCurBidNum")
    end
    ViewLianMengBattle = true
    LianMengJoinBattle = true
    InBattleResultPage = true
    local msg2 = LeagueStruct_battle_pb.OPLianMengRefreshBattle()
    msg2.version = 1
    msg2.strongHoldIndex = bidNum + 0
    local pb_data2 = msg2:SerializeToString()
    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_REFRESH_BATTLE_C,pb_data2,#pb_data2,true)

end

function LianMengBattleConfirmPage.onJoin(container)
    local bidNum
    if BlackBoard:getInstance():hasVarible("LianMengCurBidNum") then
        bidNum = BlackBoard:getInstance():getVarible("LianMengCurBidNum")
    end
    ViewLianMengBattle = false
    LianMengJoinBattle = true
    InBattleResultPage = true
    local msg2 = LeagueStruct_battle_pb.OPLianMengRefreshBattle()
    msg2.version = 1
    msg2.strongHoldIndex = bidNum + 0
    msg2.operateType = 1
    local pb_data2 = msg2:SerializeToString()
    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_REFRESH_BATTLE_C,pb_data2,#pb_data2,true)
end

function LianMengBattleConfirmPage.onEnter(container)

    if BlackBoard:getInstance():hasVarible("LianMengCurBidNum") then
        bidNum = BlackBoard:getInstance():getVarible("LianMengCurBidNum")
    end
    
    if LianmengBattleInfo.strongHold[bidNum + 0].strongHoldBid[1] == nil then
    else

        container:getVarLabelBMFont("mLMBattlefield"):setString(tostring(LianmengBattleInfo.strongHold[bidNum + 0].holdName))

        container:getVarLabelBMFont("mlmbid1"):setString(tostring(LianmengBattleInfo.strongHold[bidNum + 0].strongHoldBid[1].bidAmount))
        container:getVarLabelTTF("mlmname1"):setString(LianmengBattleInfo.strongHold[bidNum + 0].strongHoldBid[1].bidName)
        local icon1 = LianMengBadges[LianmengBattleInfo.strongHold[bidNum + 0].strongHoldBid[1].bidBadgeId].filename
        container:getVarMenuItemImage("mLMBattlefield1"):setNormalImage(CCSprite:create(icon1))
        container:getVarLabelBMFont("mNumberOfWar1"):setString(LianmengBattleInfo.strongHold[bidNum + 0].strongHoldBid[1].bidNum)
            
        container:getVarLabelTTF("mlmname2"):setString(LianmengBattleInfo.strongHold[bidNum + 0].ownerName)
        local icon2
        if LianmengBattleInfo.strongHold[bidNum + 0].strongHoldBid[1].defenceBadgeId == 0 then
            icon2 = VaribleManager:getInstance():getSetting("noOccupyLianMengBattleIcon")
        else
            icon2 = LianMengBadges[LianmengBattleInfo.strongHold[bidNum + 0].strongHoldBid[1].defenceBadgeId].filename
        end
        container:getVarMenuItemImage("mLMBattlefield2"):setNormalImage(CCSprite:create(icon2))
        container:getVarLabelBMFont("mNumberOfWar2"):setString(LianmengBattleInfo.strongHold[bidNum + 0].strongHoldBid[1].defenceNum)
        container:getVarLabelBMFont("mLMBid2"):setVisible(false)
        container:getVarSprite("mSoulQulityPic2"):setVisible(false)
     
        if LianmengBattleInfo.battleStatus == 2 or LianmengBattleInfo.battleStatus == 3 then
            container:getVarMenuItemImage("mJoin"):setEnabled(false)
            container:getVarMenuItemImage("mWitness"):setEnabled(false)
        else
            if LeaguaBaseInfo.leaguaName == LianmengBattleInfo.strongHold[bidNum + 0].ownerName or LeaguaBaseInfo.leaguaName == LianmengBattleInfo.strongHold[bidNum + 0].strongHoldBid[1].bidName then
                container:getVarMenuItemImage("mJoin"):setEnabled(true)
            else
                container:getVarMenuItemImage("mJoin"):setEnabled(false)
            end
            container:getVarMenuItemImage("mWitness"):setEnabled(true)
        end
    end
--[[        
    for i = 1 , 2 do

        container:getVarLabelBMFont("mlmbid" .. i):setString(tostring(LianmengBattleInfo.strongHold[bidNum + 0].strongHoldBid[i].bidAmount))
        container:getVarLabelBMFont("mlmname" .. i):setString(LianmengBattleInfo.strongHold[bidNum + 0].strongHoldBid[i].bidName)
        local icon = LianMengBadges[LianmengBattleInfo.strongHold[bidNum + 0].strongHoldBid[i].bidBadgeId].filename
        container:getVarMenuItemImage("mLMBattlefield" .. i):setNormalImage(CCSprite:create(icon))
        container:getVarLabelBMFont("mNumberOfWar" .. i):setString(LianmengBattleInfo.strongHold[bidNum + 0].strongHoldBid[i].bidNum)
        
    end
]]    
    
    
--    container:getVarLabelBMFont("mlmbid2"):setString(tostring("mlmbid2"))
    
--    container:getVarLabelBMFont("mlmname1"):setString(tostring("mlmname1"))

--    container:getVarLabelBMFont("mlmname2"):setString(tostring("mlmname2"))




--    container:getVarLabelBMFont("mIslandName"):setString(tostring("名字"))
--    container:getVarLabelBMFont("mShopShow1"):setString(tostring("5级商店"))
--    container:getVarLabelBMFont("mShopShow2"):setString(tostring("10级商店"))
    
--    container:getVarSprite("mProp1"):setTexture("members/head_char_abisi.png")
--    container:getVarSprite("mProp2"):setTexture("members/head_char_aibotaang.png")
    
--    container:getVarMenuItemSprite("mFrame1"):setNormalImage("mainScene/u_icobg02.png")
--    container:getVarMenuItemSprite("mFrame2"):setNormalImage("mainScene/u_icobg02.png")
    
end

function LianMengBattleConfirmPage.onExit(container)	
--    LianMengBattleConfirmPage.clearAllItem(container)
--	container.m_pScrollViewFacade:delete()
--	container.m_pScrollViewFacade = nil
end

function LianMengBattleConfirmPage.onLoad(container)
	container:loadCcbiFile("LianMengBattleConfirm.ccbi")
--	container.mScrollView = container:getVarScrollView("mContent")
--	container.mScrollViewRootNode = container.mScrollView:getContainer()
end


function LianMengBattleConfirmPage.clearAllItem(container)
--    container.m_pScrollViewFacade:clearAllItems()
--    container.mScrollViewRootNode:removeAllChildren()
end
