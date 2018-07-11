
local bidNum = 0

local LianMengBattleBidPage = {}

function luaCreat_LianMengBattleBidPage(container)
    CCLuaLog("OnCreat_LianMengBattleBidPage")
    container:registerFunctionHandler(LianMengBattleBidPage.onFunction)
end

function LianMengBattleBidPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengBattleBidPage.onEnter(container)
    elseif eventName == "luaExecute" then
        LianMengBattleBidPage.onExecute(container)
    elseif eventName == "onClose" then
    	MainFrame:getInstance():showPage("LianMengBattlePage")
    elseif eventName == "onBack" then
        MainFrame:getInstance():showPage("LianMengPage")
    elseif eventName == "luaExit" then
        LianMengBattleBidPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengBattleBidPage.onLoad(container)
	elseif eventName == "onConfirm" then
		LianMengBattleBidPage.onConfirm(container)
	elseif eventName == "onLMBid" then
        MainFrame:getInstance():showPage("LianMengBattleBidEnterPage")
	elseif eventName == "onShowPropInfo1" then
--        MainFrame:getInstance():showPage("LianMengBattleBidEnterPage")
	elseif eventName == "onShowPropInfo2" then
--        MainFrame:getInstance():showPage("LianMengBattleBidEnterPage")
    end
end

function LianMengBattleBidPage.onConfirm(container)
    MainFrame:getInstance():showPage("LianMengPage")
end

function LianMengBattleBidPage.onEnter(container)

    if BlackBoard:getInstance():hasVarible("LianMengCurBidNum") then
        bidNum = BlackBoard:getInstance():getVarible("LianMengCurBidNum")
    end
    
    container:getVarLabelBMFont("mIslandName"):setString(tostring(LianmengBattleInfo.strongHold[bidNum + 0].holdName))
    
    if LeaguaBaseInfo.playerGrade == 3 or LeaguaBaseInfo.playerGrade == 4 then
        container:getVarMenuItemImage("mLMBid"):setEnabled(true)
    else
        container:getVarMenuItemImage("mLMBid"):setEnabled(false)
    end

    for i = 1 , 2 do

        container:getVarLabelBMFont("mShopShow" .. i):setString(tostring(LianmengBattleInfo.strongHold[bidNum + 0].strongHoldReward[i].shopLevel))
        container:getVarSprite("mProp" .. i):setTexture("members/head_char_abisi.png")        
        local rewardType = LianmengBattleInfo.strongHold[bidNum + 0].strongHoldReward[i].rewardType        
        local rewardId = LianmengBattleInfo.strongHold[bidNum + 0].strongHoldReward[i].rewardId
        local rewardNum = LianmengBattleInfo.strongHold[bidNum + 0].strongHoldReward[i].rewardNum
        local shopLevel = LianmengBattleInfo.strongHold[bidNum + 0].strongHoldReward[i].shopLevel
        
        local shopName = Language:getInstance():getString("@ShopLevel")
        
        if rewardType == 31 or rewardType == 32 then --Disciple
            local item = Disciple:new_local(rewardId, true, false)
            local frame = container:getVarMenuItemImage("mFrame" .. i)
            frame:setNormalImage(item:getFrameNormalSpirte())
            frame:setSelectedImage(item:getFrameSelectedSpirte())
            local pic = container:getVarSprite("mProp" .. i)
            pic:setTexture(item:iconPic())
            pic:setScale(1.0)
            shopName = Language:getInstance():getString("@ShopLevel")
	        shopName=string.gsub(shopName,"#v1#",shopLevel)
            container:getVarLabelBMFont("mShopShow" .. i):setString(shopName)
            
        elseif rewardType == 50 then --equip
            local item = Equip:new_local(rewardId, true, false)
            local frame = container:getVarMenuItemImage("mFrame" .. i)
            item:getFrameNormalSpirte()
            frame:setNormalImage(item:getFrameNormalSpirte())
            item:getFrameSelectedSpirte()
            frame:setSelectedImage(item:getFrameSelectedSpirte())
            local pic = container:getVarSprite("mProp" .. i)
            pic:setTexture(item:iconPic())
            pic:setScale(0.4)
            
            shopName = Language:getInstance():getString("@ShopLevel")
	        shopName=string.gsub(shopName,"#v1#",shopLevel)
            container:getVarLabelBMFont("mShopShow" .. i):setString(shopName)
	
        elseif rewardType == 41 then --skill
            local item = Skill:new_local(rewardId, true, false)
            local frame = container:getVarMenuItemImage("mFrame" .. i)
            frame:setNormalImage(item:getFrameNormalSpirte())
            frame:setSelectedImage(item:getFrameSelectedSpirte())
            local pic = container:getVarSprite("mProp" .. i)
            pic:setTexture(item:iconPic())
            pic:setScale(0.4)
            
            shopName = Language:getInstance():getString("@ShopLevel")
	        shopName=string.gsub(shopName,"#v1#",shopLevel)
            container:getVarLabelBMFont("mShopShow" .. i):setString(shopName)

        elseif rewardType == 61 then --good
            local item = ToolTableManager:getInstance():getToolItemByID(rewardId);
            local frame = container:getVarMenuItemImage("mFrame" .. i)
            frame:setNormalImage(CCSprite:create("mainScene/u_icobg02.png"))
            frame:setSelectedImage(CCSprite:create("mainScene/u_icobg02.png"))
            local pic = container:getVarSprite("mProp" .. i)
            pic:setTexture(item.iconPic)
            pic:setScale(0.4)
            
            shopName = Language:getInstance():getString("@ShopLevel")
	        shopName=string.gsub(shopName,"#v1#",shopLevel)
            container:getVarLabelBMFont("mShopShow" .. i):setString(shopName)

        end

    end
--    container:getVarLabelBMFont("mShopShow1"):setString(tostring("5级商店"))
--    container:getVarLabelBMFont("mShopShow2"):setString(tostring("10级商店"))
    
--    container:getVarSprite("mProp1"):setTexture("members/head_char_abisi.png")
--    container:getVarSprite("mProp2"):setTexture("members/head_char_aibotaang.png")
    
--    container:getVarMenuItemSprite("mFrame1"):setNormalImage("mainScene/u_icobg02.png")
--    container:getVarMenuItemSprite("mFrame2"):setNormalImage("mainScene/u_icobg02.png")
    
end

function LianMengBattleBidPage.onExecute(container)
    local timeleft = TimeCalculator:getInstance():getTimeLeft("LianMengBattleCD")
    
    if timeleft <= 0 then
        local msg = LeagueStruct_battle_pb.OPLianMengJoinBattle()
        msg.version = 1
        local pb_data = msg:SerializeToString()
        PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_JOIN_BATTLE_C,pb_data,#pb_data,true)
    end
end

function LianMengBattleBidPage.onExit(container)	
--    LianMengBattleBidPage.clearAllItem(container)
--	container.m_pScrollViewFacade:delete()
--	container.m_pScrollViewFacade = nil
end

function LianMengBattleBidPage.onLoad(container)
	container:loadCcbiFile("LianMengBattleBid.ccbi")
--	container.mScrollView = container:getVarScrollView("mContent")
--	container.mScrollViewRootNode = container.mScrollView:getContainer()
end


function LianMengBattleBidPage.clearAllItem(container)
--    container.m_pScrollViewFacade:clearAllItems()
--    container.mScrollViewRootNode:removeAllChildren()
end
