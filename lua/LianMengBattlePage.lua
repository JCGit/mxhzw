

LianMengTotemUseFlag = false
local LianMengBattleItem = {}

function LianMengBattleItem.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        LianMengBattleItem.onRefreshItemView(container)
    end
end

function LianMengBattleItem.onRefreshItemView(container)
    local itemData = LianmengHelpInfo[container:getItemDate().mID]
    
    container:getVarLabelBMFont("mName"):setString(itemData.name)
    
    local s =  itemData.describe
    local descirbe = ""
	s, descirbe = GameMaths:stringAutoReturn(s, descirbe, 18, 0) 
    container:getVarLabelBMFont("mDes"):setString(descirbe)
    
    local face = container:getVarSprite("mIcon")
    if  itemData.iconPic ~= "none" then
        face:setVisible(true);
		face:setTexture(itemData.iconpath)
    else
        face:setVisible(false);
    end
end

local LianMengBattlePage = {}

function luaCreat_LianMengBattlePage(container)
    CCLuaLog("OnCreat_LianMengBattlePage")
    container:registerFunctionHandler(LianMengBattlePage.onFunction)
end

function LianMengBattlePage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengBattlePage.onEnter(container)
    elseif eventName == "luaExecute" then
        LianMengBattlePage.onExecute(container)
    elseif eventName == "onLMTotemMSG" then
        MainFrame:getInstance():showPage("LianMengBattleMSGPage")
    elseif eventName == "onBack" then 
        MainFrame:getInstance():showPage("LianMengPage")
    elseif eventName == "luaExit" then
        LianMengBattlePage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengBattlePage.onLoad(container)
	elseif eventName == "onConfirm" then 
		LianMengBattlePage.onConfirm(container)
	elseif (string.find(eventName,"onLMBPic") ~= nil) then 
	    LianMengBattlePage.showBidPage(string.sub(eventName,  string.len(eventName)))
    end
end

function LianMengBattlePage.showBidPage(BidNumber)
    
    if BlackBoard:getInstance():hasVarible("LianMengCurBidNum") then
        BlackBoard:getInstance():setVarible("LianMengCurBidNum",BidNumber)
    else
        BlackBoard:getInstance():addVarible("LianMengCurBidNum",BidNumber)
    end
    
    if LianmengBattleInfo.battleStatus == 1 then --竞价阶段
        MainFrame:getInstance():showPage("LianMengBattleBidPage")
    elseif LianmengBattleInfo.battleStatus == 2 then --公布阶段
        
        if LianmengBattleInfo.strongHold[BidNumber+0].strongHoldBid[1] == nil then
            MessageBoxPage:Msg_Box("@LMNoBattle")
        else
            MainFrame:getInstance():showPage("LianMengBattleConfirmPage")    
        end
        
    elseif LianmengBattleInfo.battleStatus == 3 then --对战准备阶段
        
        if LianmengBattleInfo.strongHold[BidNumber+0].strongHoldBid[1] == nil then
            MessageBoxPage:Msg_Box("@LMNoBattle")
        else
            MainFrame:getInstance():showPage("LianMengBattleConfirmPage")    
        end
        
    elseif LianmengBattleInfo.battleStatus == 4 then --战斗阶段
        if LianmengBattleInfo.strongHold[BidNumber+0].strongHoldBid[1] == nil then
            MessageBoxPage:Msg_Box("@LMNoBattle")
        else
            MainFrame:getInstance():showPage("LianMengBattleConfirmPage")
        end
    end
end

function LianMengBattlePage.onConfirm(container)
    MainFrame:getInstance():showPage("LianMengPage")
end

function LianMengBattlePage.onEnter(container)

--    container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
--	container.m_pScrollViewFacade:init(6,6)
    
    LianMengBattlePage.rebuildAllItem(container)
end

function LianMengBattlePage.onExecute(container)
    local timeleft = TimeCalculator:getInstance():getTimeLeft("LianMengBattleCD")
    local m = (timeleft - timeleft%60)/60
    local s = timeleft%60
    if s < 10 then
        container:getVarLabelBMFont("mLMBattleCD"):setString(m .. ":0" .. s)
    else
        container:getVarLabelBMFont("mLMBattleCD"):setString(m .. ":" .. s)
    end
    container:getVarLabelBMFont("mLMBattleCD"):setVisible(true)

    if timeleft <= 0 and JoinLianMengBattle == true then
--        MainFrame:getInstance():showPage("LianMengPage")
        local msg = LeagueStruct_battle_pb.OPLianMengJoinBattle()
        msg.version = 1
        local pb_data = msg:SerializeToString()
        PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_JOIN_BATTLE_C,pb_data,#pb_data,true)
        JoinLianMengBattle = false
    else
        LianMengBattlePage.refreshByStatus(container)
    end
end

function LianMengBattlePage.refreshByStatus(container)
    if LianmengBattleInfo.battleStatus == 1 then
        for k, v in ipairs(LianmengBattleInfo.strongHold) do
            
            local str
            if LianmengBattleInfo.strongHold[k].ownerName == "" then
                str = Language:getInstance():getString("@NeverOccupy")
                local icon = VaribleManager:getInstance():getSetting("noOccupyLianMengBattleIcon")
                container:getVarMenuItemImage("mLMBPic" .. k):setNormalImage(CCSprite:create(icon))
            else
                str = LianmengBattleInfo.strongHold[k].ownerName
                container:getVarMenuItemImage("mLMBPic" .. k):setNormalImage(CCSprite:create(LianMengBadges[LianmengBattleInfo.strongHold[k].ownerBadgeId].filename))
            end
            container:getVarLabelTTF("mLMName" .. k):setString(str)
        end
    
        container:getVarLabelBMFont("mLMBattlePrompt"):setVisible(true)
        container:getVarNode("mLMBattleCDNode"):setVisible(false)
        container:getVarNode("mLMBattling"):setVisible(false)
    
    elseif LianmengBattleInfo.battleStatus == 2 then
        for k, v in ipairs(LianmengBattleInfo.strongHold) do
            
            local str
            if v.strongHoldBid[1] == nil then
            --无盟战
                local icon = VaribleManager:getInstance():getSetting("noLianMengBattleIcon")
                if LianmengBattleInfo.strongHold[k].ownerBadgeId == 0 then
                else
                    icon = LianMengBadges[LianmengBattleInfo.strongHold[k].ownerBadgeId].filename
                end                    
                container:getVarMenuItemImage("mLMBPic" .. k):setNormalImage(CCSprite:create(icon))
                str = Language:getInstance():getString("@LMNoBattle")    

            else
            --战争中
                local icon = VaribleManager:getInstance():getSetting("inLianMengBattleIcon")
                container:getVarMenuItemImage("mLMBPic" .. k):setNormalImage(CCSprite:create(icon))
                str = Language:getInstance():getString("@LMBattleWaiting")    
            end
            container:getVarLabelTTF("mLMName" .. k):setString(str)
            
        end

        container:getVarLabelBMFont("mLMBattlePrompt"):setVisible(false)
        local cdStr = Language:getInstance():getString("@LMBattleShowCD")    
        container:getVarLabelBMFont("mLMBattleCDTitle"):setString(cdStr)
        container:getVarNode("mLMBattleCDNode"):setVisible(true)
        container:getVarNode("mLMBattling"):setVisible(false)
    elseif LianmengBattleInfo.battleStatus == 3 then
        local chooseTotem = false
        
        if LianMengTotemUseFlag == false then
            if LianmengBattleInfo.buildingInfo[1] == nil then
            else
                if(LeaguaBaseInfo.playerGrade==3 or LeaguaBaseInfo.playerGrade==4)then
                    if LianmengBattleInfo.buildingIndex == 0 then
                        MainFrame:getInstance():showPage("LianMengBattleTotemUsePage")
                        chooseTotem = true
                    else
                    end
                else
                end
            end
        end
        
        if chooseTotem == true then
        else
            for k, v in ipairs(LianmengBattleInfo.strongHold) do
                
                local str
                if v.strongHoldBid[1] == nil then
                --无盟战
                    local icon = VaribleManager:getInstance():getSetting("noLianMengBattleIcon")
                    if LianmengBattleInfo.strongHold[k].ownerBadgeId == 0 then
                    else
                        icon = LianMengBadges[LianmengBattleInfo.strongHold[k].ownerBadgeId].filename
                    end                    
                    container:getVarMenuItemImage("mLMBPic" .. k):setNormalImage(CCSprite:create(icon))
                    str = Language:getInstance():getString("@LMNoBattle")    
                        
                else
                --战争中
                    local icon = VaribleManager:getInstance():getSetting("inLianMengBattleIcon")
                    container:getVarMenuItemImage("mLMBPic" .. k):setNormalImage(CCSprite:create(icon))
                    str = Language:getInstance():getString("@LMBattleWaiting")    
                end
                container:getVarLabelTTF("mLMName" .. k):setString(str)
                
            end
            container:getVarLabelBMFont("mLMBattlePrompt"):setVisible(false)
            local cdStr = Language:getInstance():getString("@LMBattleBeginCD")    
            container:getVarLabelBMFont("mLMBattleCDTitle"):setString(cdStr)
            container:getVarNode("mLMBattleCDNode"):setVisible(true)
            container:getVarNode("mLMBattling"):setVisible(false)
        end
    elseif LianmengBattleInfo.battleStatus == 4 then
        
        if chooseTotem == true then
        else
            for k, v in ipairs(LianmengBattleInfo.strongHold) do
                
                local str
                if v.strongHoldBid[1] == nil then
                --无盟战
                    local icon = VaribleManager:getInstance():getSetting("noLianMengBattleIcon")
                    if LianmengBattleInfo.strongHold[k].ownerBadgeId == 0 then
                    else
                        icon = LianMengBadges[LianmengBattleInfo.strongHold[k].ownerBadgeId].filename
                    end                    
                    container:getVarMenuItemImage("mLMBPic" .. k):setNormalImage(CCSprite:create(icon))
                    str = Language:getInstance():getString("@LMNoBattle")    

                else
                --战争中
                    local icon = VaribleManager:getInstance():getSetting("inLianMengBattleIcon")
                    container:getVarMenuItemImage("mLMBPic" .. k):setNormalImage(CCSprite:create(icon))
                    str = Language:getInstance():getString("@LMBattling")    
                end
                container:getVarLabelTTF("mLMName" .. k):setString(str)
                
            end
            container:getVarLabelBMFont("mLMBattlePrompt"):setVisible(false)
            local cdStr = Language:getInstance():getString("@LMBattleFinishCD")    
            container:getVarLabelBMFont("mLMBattleCDTitle"):setString(cdStr)
            container:getVarNode("mLMBattleCDNode"):setVisible(true)
            container:getVarNode("mLMBattling"):setVisible(false)
        end
--        MainFrame:getInstance():showPage("LianMengBattleResaultPage")
    end
end

function LianMengBattlePage.onExit(container)	
--    LianMengBattlePage.clearAllItem(container)
--	container.m_pScrollViewFacade:delete()
--	container.m_pScrollViewFacade = nil
end

function LianMengBattlePage.onLoad(container)

    
	container:loadCcbiFile("LianMengBattle.ccbi")
--	container.mScrollView = container:getVarScrollView("mContent")
--	container.mScrollViewRootNode = container.mScrollView:getContainer()
end

function LianMengBattlePage.rebuildAllItem(container)
    LianMengBattlePage.clearAllItem(container);
	LianMengBattlePage.buildItem(container);
end

function LianMengBattlePage.buildItem(container)
    local iMaxNode = 5;
	local iCount = 0;

	for i=1, iMaxNode do
	    
		local pItem = container:getVarMenuItemImage("mLMBPic1")
--		pItem.id = i
--		pItem:registerFunctionHandler(LianMengBattleItem.onFunction)
	end
end

function LianMengBattlePage.clearAllItem(container)
--    container.m_pScrollViewFacade:clearAllItems()
--    container.mScrollViewRootNode:removeAllChildren()
end
