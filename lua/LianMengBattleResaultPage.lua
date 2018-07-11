
local mCount = 0
local mID = 0
local LianMengBattleResaultPage = {}
local damageTempIndexHM = 0
local damageTempIndexM = 0
local damageTempIndex1 = 0
local damageTempIndex2 = 0
local damageTempIndex3 = 0
local damageTemp1 = ""
local damageTemp2 = ""
local damageTemp3 = ""
local lastIndex = 0
InBattleResultPage = true


function luaCreat_LianMengBattleResaultPage(container)
    CCLuaLog("OnCreat_LianMengBattleResaultPage")
    container:registerFunctionHandler(LianMengBattleResaultPage.onFunction)
end

function LianMengBattleResaultPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengBattleResaultPage.onEnter(container)
    elseif eventName == "luaExecute" then
        LianMengBattleResaultPage.onExecute(container)
    elseif eventName == "onClose" then
    	MainFrame:getInstance():showPage("LianMengBattlePage")
    elseif eventName == "onBack" then
        MainFrame:getInstance():showPage("LianMengPage")
    elseif eventName == "luaExit" then
        LianMengBattleResaultPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengBattleResaultPage.onLoad(container)
	elseif eventName == "onConfirm" then
		LianMengBattleResaultPage.onConfirm(container)
    elseif eventName == "onAllReject" then
    	MainFrame:getInstance():showPage("LianMengBattlePage")
    elseif eventName == "onRevertLM" then
        LianMengBattleResaultPage.onRevertLM(container)
    end
end

function LianMengBattleResaultPage.onConfirm(container)
    MainFrame:getInstance():showPage("LianMengPage")
end

function LianMengBattleResaultPage.onRevertLM(container)
    local bidNum
    if BlackBoard:getInstance():hasVarible("LianMengCurBidNum") then
        bidNum = BlackBoard:getInstance():getVarible("LianMengCurBidNum")
    end
    
    LianMengJoinBattle = false
    local msg2 = LeagueStruct_battle_pb.OPLianMengRefreshBattle()
    msg2.version = 1
    msg2.strongHoldIndex = bidNum + 0
    msg2.operateType = 2
    local pb_data2 = msg2:SerializeToString()
    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_REFRESH_BATTLE_C,pb_data2,#pb_data2,true)
    

    local msg = LeagueStruct_battle_pb.OPLianMengJoinBattle()
    msg.version = 1
    local pb_data = msg:SerializeToString()
    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_JOIN_BATTLE_C,pb_data,#pb_data,true)

end

function LianMengBattleResaultPage.onEnter(container)
    
--    container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
--	container.m_pScrollViewFacade:init(6,6)
    LianMengBattleResaultPage.refreshContent(container)
    InBattleResultPage = true

end

function LianMengBattleResaultPage.onExecute(container)
    LianMengBattleResaultPage.countReliveTime(container)
end

function LianMengBattleResaultPage.countReliveTime(container)
    
    local hasKey = TimeCalculator:getInstance():hasKey("LMBattleFinishTime")
    local timeleft = 0;
    
    if(hasKey) then
        timeleft = TimeCalculator:getInstance():getTimeLeft("LMBattleFinishTime")
        LianMengBattleResaultPage.translateTime(container,timeleft)
    end
end

function LianMengBattleResaultPage.translateTime(container,timeleft)
    local m = (timeleft - timeleft%60)/60
    local s = timeleft%60
    if s < 10 then
        container:getVarLabelBMFont("mRemainingTime"):setString(m .. ":0" .. s)
    else
        container:getVarLabelBMFont("mRemainingTime"):setString(m .. ":" .. s)
    end
            
    local msg = LianmengBattleResultInfo.scrollMSG;
    local sep = 20 / #msg
            
    if s % 20 == 0 then
--        LianMengBattleResaultPage.sendPackageByM(container,s)	
    elseif s % 10 == 0 then
        LianMengBattleResaultPage.sendPackageByHM(container,s)	
    end
    
    if s % 1 == 0 then
        LianMengBattleResaultPage.refreshDamageByS(container,s)	
    end
    
    if timeleft <= 0 then
        if LianmengBattleResultInfo.lianMengBattle[1].lianMengScore > LianmengBattleResultInfo.lianMengBattle[2].lianMengScore then
            container:getVarSprite("mLMBRPic1"):setVisible(true)
            container:getVarSprite("mLMBRPic3"):setVisible(false)
            container:getVarSprite("mLMBRPic4"):setVisible(false)
            container:getVarSprite("mLMBRPic2"):setVisible(true)
        elseif LianmengBattleResultInfo.lianMengBattle[1].lianMengScore < LianmengBattleResultInfo.lianMengBattle[2].lianMengScore then
            container:getVarSprite("mLMBRPic1"):setVisible(false)
            container:getVarSprite("mLMBRPic3"):setVisible(true)
            container:getVarSprite("mLMBRPic4"):setVisible(true)
            container:getVarSprite("mLMBRPic2"):setVisible(false)
        else
            container:getVarSprite("mLMBRPic1"):setVisible(false)
            container:getVarSprite("mLMBRPic2"):setVisible(false)
            container:getVarSprite("mLMBRPic3"):setVisible(false)
            container:getVarSprite("mLMBRPic4"):setVisible(false)
        end
    --[[
        if LianmengBattleResultInfo.lianMengBattle[1].npcNeedScore == 0 or LianmengBattleResultInfo.lianMengBattle[2].npcNeedScore == 0 then
        
            if LianmengBattleResultInfo.lianMengBattle[1].lianMengScore > LianmengBattleResultInfo.lianMengBattle[2].lianMengScore then
                container:getVarSprite("mLMBRPic1"):setVisible(true)
                container:getVarSprite("mLMBRPic3"):setVisible(false)
                container:getVarSprite("mLMBRPic4"):setVisible(false)
                container:getVarSprite("mLMBRPic2"):setVisible(true)
            elseif LianmengBattleResultInfo.lianMengBattle[1].lianMengScore < LianmengBattleResultInfo.lianMengBattle[2].lianMengScore then
                container:getVarSprite("mLMBRPic1"):setVisible(false)
                container:getVarSprite("mLMBRPic3"):setVisible(true)
                container:getVarSprite("mLMBRPic4"):setVisible(true)
                container:getVarSprite("mLMBRPic2"):setVisible(false)
            else
                container:getVarSprite("mLMBRPic1"):setVisible(false)
                container:getVarSprite("mLMBRPic2"):setVisible(false)
                container:getVarSprite("mLMBRPic3"):setVisible(false)
                container:getVarSprite("mLMBRPic4"):setVisible(false)
            end
        elseif LianmengBattleResultInfo.lianMengBattle[1].npcNeedScore ~= 0 then
            if LianmengBattleResultInfo.lianMengBattle[2].lianMengScore >= LianmengBattleResultInfo.lianMengBattle[1].npcNeedScore then
                container:getVarSprite("mLMBRPic1"):setVisible(false)
                container:getVarSprite("mLMBRPic3"):setVisible(true)
                container:getVarSprite("mLMBRPic4"):setVisible(true)
                container:getVarSprite("mLMBRPic2"):setVisible(false)
            else
                container:getVarSprite("mLMBRPic1"):setVisible(true)
                container:getVarSprite("mLMBRPic3"):setVisible(false)
                container:getVarSprite("mLMBRPic4"):setVisible(false)
                container:getVarSprite("mLMBRPic2"):setVisible(true)
            end
        
        elseif LianmengBattleResultInfo.lianMengBattle[2].npcNeedScore ~= 0 then
            if LianmengBattleResultInfo.lianMengBattle[1].lianMengScore >= LianmengBattleResultInfo.lianMengBattle[2].npcNeedScore then
                container:getVarSprite("mLMBRPic1"):setVisible(true)
                container:getVarSprite("mLMBRPic3"):setVisible(false)
                container:getVarSprite("mLMBRPic4"):setVisible(false)
                container:getVarSprite("mLMBRPic2"):setVisible(true)
            else
                container:getVarSprite("mLMBRPic1"):setVisible(false)
                container:getVarSprite("mLMBRPic3"):setVisible(true)
                container:getVarSprite("mLMBRPic4"):setVisible(true)
                container:getVarSprite("mLMBRPic2"):setVisible(false)
            end
        
        end
        --]]
    else
        container:getVarSprite("mLMBRPic1"):setVisible(false)
        container:getVarSprite("mLMBRPic2"):setVisible(false)
        container:getVarSprite("mLMBRPic3"):setVisible(false)
        container:getVarSprite("mLMBRPic4"):setVisible(false)
    end
end

function LianMengBattleResaultPage.sendPackageByHM(container,s)
    if s ~= damageTempIndexHM then
        damageTempIndexHM = s
        local bidNum
        if BlackBoard:getInstance():hasVarible("LianMengCurBidNum") then
            bidNum = BlackBoard:getInstance():getVarible("LianMengCurBidNum")
        end
        
        LianMengJoinBattle = true
        local msg2 = LeagueStruct_battle_pb.OPLianMengRefreshBattle()
        msg2.version = 1
        msg2.strongHoldIndex = bidNum + 0
        local pb_data2 = msg2:SerializeToString()
        PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_REFRESH_BATTLE_C,pb_data2,#pb_data2,true)
    end
end

function LianMengBattleResaultPage.sendPackageByM(container,s)
    if s ~= damageTempIndexM then
        damageTempIndexM = s
        local bidNum
        if BlackBoard:getInstance():hasVarible("LianMengCurBidNum") then
            bidNum = BlackBoard:getInstance():getVarible("LianMengCurBidNum")
        end
        
        LianMengJoinBattle = true
        local msg2 = LeagueStruct_battle_pb.OPLianMengRefreshBattle()
        msg2.version = 1
        msg2.strongHoldIndex = bidNum + 0
        msg2.operateType = 1
        local pb_data2 = msg2:SerializeToString()
        PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_REFRESH_BATTLE_C,pb_data2,#pb_data2,true)
    end
end

function LianMengBattleResaultPage.refreshDamageByS(container,s)

    if damageTempIndex3 ~= s then
        
        damageTempIndex1 = damageTempIndex2
        damageTempIndex2 = damageTempIndex3
        damageTempIndex3 = s
        
        local msg = LianmengBattleResultInfo.scrollMSG;
        
        local str = Language:getInstance():getString("@LMBattleScrollMSG1")

        
        if #msg == 0 then
            container:getVarLabelBMFont("mLMBattleNotes"):setVisible(false)
        else
            if msg[LianMengBattleResaultSecond%#msg+1].lianmengName2 == "" then
                str = Language:getInstance():getString("@LMBattleScrollMSG3")
            elseif msg[LianMengBattleResaultSecond%#msg+1].continuation ~= 0 then
                str = Language:getInstance():getString("@LMBattleScrollMSG2")
            end
            
            if LianMengBattleResaultSecond == 1 then
                LianMengBattleResaultPage.refreshContent(container)	
            end
            
            str=string.gsub(str,"#v1#",msg[LianMengBattleResaultSecond%#msg+1].lianmengName1)
            str=string.gsub(str,"#v3#",msg[LianMengBattleResaultSecond%#msg+1].lianmengName2)
            str=string.gsub(str,"#v2#",msg[LianMengBattleResaultSecond%#msg+1].playerName1)
            str=string.gsub(str,"#v4#",msg[LianMengBattleResaultSecond%#msg+1].playerName2)
            
            local role1 = Language:getInstance():getString("@LMRole" .. msg[LianMengBattleResaultSecond%#msg+1].grade1)
            str=string.gsub(str,"#v6#",role1)
            local role2 = Language:getInstance():getString("@LMRole" .. msg[LianMengBattleResaultSecond%#msg+1].grade2)
            str=string.gsub(str,"#v7#",role2)
            str=string.gsub(str,"#v8#",msg[LianMengBattleResaultSecond%#msg+1].continuation)
            
            if msg[LianMengBattleResaultSecond%#msg+1].contribution > 0 then
                local msgType = Language:getInstance():getString("@LMBattleScrollMSGType1")
                str=string.gsub(str,"#v9#",msgType)
                str=string.gsub(str,"#v5#",msg[LianMengBattleResaultSecond%#msg+1].contribution)    
            else
                local msgType = Language:getInstance():getString("@LMBattleScrollMSGType2")
                str=string.gsub(str,"#v9#",msgType)
                str=string.gsub(str,"#v5#",-msg[LianMengBattleResaultSecond%#msg+1].contribution)    
            end
            
            local descirbe = ""
            local damageTempStr = ""
            str, damageTempStr = GameMaths:stringAutoReturn(str, descirbe, 28, 0) 
            
            if LianMengBattleResaultSecond > #LianmengBattleResultInfo.scrollMSG then
            else
                if lastIndex ~= msg[LianMengBattleResaultSecond%#msg+1].index then
                    damageTemp1 = damageTemp2
                    damageTemp2 = damageTemp3
                    damageTemp3 = damageTempStr
                end
                local damageTemp = damageTemp1 .. "\n" .. damageTemp2 .. "\n" .. damageTemp3
                container:getVarLabelBMFont("mLMBattleNotes"):setVisible(true)
                container:getVarLabelBMFont("mLMBattleNotes"):setString(damageTemp)
            end
            LianMengBattleResaultSecond = LianMengBattleResaultSecond + 1
        end
        
        local resultStr = Language:getInstance():getString("@MyResault")
        resultStr=string.gsub(resultStr,"#v1#",LianmengBattleResultInfo.killPersonNum)
        resultStr=string.gsub(resultStr,"#v2#",LianmengBattleResultInfo.contributeNum)
        container:getVarLabelBMFont("mMyResault"):setString(resultStr)
        if RefreshLianMengBattle == true then
            RefreshLianMengBattle = false
            local bidNum
            if BlackBoard:getInstance():hasVarible("LianMengCurBidNum") then
                bidNum = BlackBoard:getInstance():getVarible("LianMengCurBidNum")
            end
            container:getVarLabelBMFont("mLMCoinWin1"):setVisible(true)
            container:getVarLabelBMFont("mLMCoinWin1"):setString(LianmengBattleResultInfo.lianMengBattle[1].personNumInBattle)
            
            container:getVarLabelBMFont("mLMCoinLost1"):setVisible(true)
            container:getVarLabelBMFont("mLMCoinLost1"):setString(LianmengBattleResultInfo.lianMengBattle[2].personNumInBattle)
            
            for k, v in ipairs(LianmengBattleResultInfo.continueKillRank) do
                local frame = container:getVarMenuItemSprite("mFace" .. k)
                container:getVarSprite("mFlagPic" .. k):setTexture(LianMengBadges[v.lianMengBadgeId].filename)
                container:getVarLabelTTF("mPlayerName" .. k):setString(v.playerName)
                container:getVarLabelTTF("mLMName" .. k):setString(v.lianMengName)
            end        
        end
        
        if LianmengBattleResultInfo.continueKillRank[3] == nil then
            container:getVarSprite("mFlagPic3"):setVisible(false)
            container:getVarLabelTTF("mPlayerName3"):setVisible(false)
            container:getVarLabelTTF("mLMName3"):setVisible(false)
        else
            container:getVarSprite("mFlagPic3"):setVisible(true)
            container:getVarLabelTTF("mPlayerName3"):setVisible(true)
            container:getVarLabelTTF("mLMName3"):setVisible(true)
        end
        if LianmengBattleResultInfo.continueKillRank[2] == nil then
            container:getVarSprite("mFlagPic2"):setVisible(false)
            container:getVarLabelTTF("mPlayerName2"):setVisible(false)
            container:getVarLabelTTF("mLMName2"):setVisible(false)
        else
            container:getVarSprite("mFlagPic2"):setVisible(true)
            container:getVarLabelTTF("mPlayerName2"):setVisible(true)
            container:getVarLabelTTF("mLMName2"):setVisible(true)
        end
        if LianmengBattleResultInfo.continueKillRank[1] == nil then
            container:getVarSprite("mFlagPic1"):setVisible(false)
            container:getVarLabelTTF("mPlayerName1"):setVisible(false)
            container:getVarLabelTTF("mLMName1"):setVisible(false)
        else
            container:getVarSprite("mFlagPic1"):setVisible(true)
            container:getVarLabelTTF("mPlayerName1"):setVisible(true)
            container:getVarLabelTTF("mLMName1"):setVisible(true)
        end
        
    end
	
end

function LianMengBattleResaultPage.refreshContent(container)	
    container:getVarLabelBMFont("mLMCoinLost"):setVisible(false)
    container:getVarLabelBMFont("mLMCoinLost1"):setVisible(false)
    container:getVarLabelBMFont("mLMCoinWin"):setVisible(false)
    container:getVarLabelBMFont("mLMCoinWin1"):setVisible(false)
        
    local restraintStr1 = ""
    if LianmengBattleResultInfo.lianMengBattle[1].restraintStatus == 1 then--克制
        restraintStr1 = restraintStr1 .. Language:getInstance():getString("@restraintStr1")
        restraintStr1 = restraintStr1 .. Language:getInstance():getString("@Attack")
        restraintStr1 = restraintStr1 .. Language:getInstance():getString("@restraintStr2")
    elseif LianmengBattleResultInfo.lianMengBattle[1].restraintStatus == -1 then--被克制
        restraintStr1 = restraintStr1 .. Language:getInstance():getString("@byRestraintStr1")
        restraintStr1 = restraintStr1 .. Language:getInstance():getString("@Attack")
        restraintStr1 = restraintStr1 .. Language:getInstance():getString("@byRestraintStr2")
    elseif LianmengBattleResultInfo.lianMengBattle[1].restraintStatus == 0 then--没有克制关系
        restraintStr1 = restraintStr1 .. Language:getInstance():getString("@Attack")
        restraintStr1 = restraintStr1 .. Language:getInstance():getString("@restraintStr2")
    end
    local restraintNumTemp = string.gsub(LianmengBattleResultInfo.lianMengBattle[1].restraintNum,"_","") + 0
    if restraintNumTemp < 0 then
        restraintStr1 = restraintStr1 .. restraintNumTemp * -1
    else
        restraintStr1 = restraintStr1 .. restraintNumTemp
    end
--    restraintStr1 = string.gsub(restraintStr1,"_","\%")
    restraintStr1 = restraintStr1 .. "%"
    restraintStr1 = string.gsub(restraintStr1,"_","")
                
    local restraintStr2 = ""
    if LianmengBattleResultInfo.lianMengBattle[2].restraintStatus == 1 then--克制
        restraintStr2 = restraintStr2 .. Language:getInstance():getString("@restraintStr1")
        restraintStr2 = restraintStr2 .. Language:getInstance():getString("@Attack")
        restraintStr2 = restraintStr2 .. Language:getInstance():getString("@restraintStr2")
    elseif LianmengBattleResultInfo.lianMengBattle[2].restraintStatus == -1 then--被克制
        restraintStr2 = restraintStr2 .. Language:getInstance():getString("@byRestraintStr1")
        restraintStr2 = restraintStr2 .. Language:getInstance():getString("@Attack")
        restraintStr2 = restraintStr2 .. Language:getInstance():getString("@byRestraintStr2")
    elseif LianmengBattleResultInfo.lianMengBattle[2].restraintStatus == 0 then--没有克制关系
        restraintStr2 = restraintStr2 .. Language:getInstance():getString("@Attack")
        restraintStr2 = restraintStr2 .. Language:getInstance():getString("@restraintStr2")
    end
    local restraintNum = string.gsub(LianmengBattleResultInfo.lianMengBattle[2].restraintNum,"_","") + 0
    if restraintNum < 0 then
        restraintStr2 = restraintStr2 .. (restraintNum * -1)
    else
        restraintStr2 = restraintStr2 .. restraintNum
    end
--    restraintStr2 = string.gsub(restraintStr2,"_","\%")
    restraintStr2 = restraintStr2 .. "%"
    restraintStr2 = string.gsub(restraintStr2,"_","")
    
        
    container:getVarLabelTTF("mLMNameWin"):setString(LianmengBattleResultInfo.lianMengBattle[1].lianMengName)
    container:getVarLabelBMFont("mEffectWin"):setString(restraintStr1)
    container:getVarLabelBMFont("mLMCoinWin"):setVisible(true)
    container:getVarLabelBMFont("mLMCoinWin"):setString(LianmengBattleResultInfo.lianMengBattle[1].lianMengScore)
    local badgeStr = VaribleManager:getInstance():getSetting("noLianMengBuildingIcon")
    local badgeNode1 = CCSprite:create(badgeStr)
    local badgeNode2 = CCSprite:create(badgeStr)
    
    if LianmengBattleResultInfo.lianMengBattle[1].lianMengBuildingIndex == 0 then
	    container:getVarMenuItemImage("mBadge1"):setNormalImage(badgeNode1)
    else
        badgeNode1 = CCSprite:create(LianMengBuildings[LianmengBattleResultInfo.lianMengBattle[1].lianMengBuildingIndex + 1].buildingIcon);
	    container:getVarMenuItemImage("mBadge1"):setNormalImage(badgeNode1)
    end

    if LianmengBattleResultInfo.lianMengBattle[2].lianMengBuildingIndex == 0 then
	    container:getVarMenuItemImage("mBadge2"):setNormalImage(badgeNode2)
    else
        badgeNode2 = CCSprite:create(LianMengBuildings[LianmengBattleResultInfo.lianMengBattle[2].lianMengBuildingIndex + 1].buildingIcon);
	    container:getVarMenuItemImage("mBadge2"):setNormalImage(badgeNode2)
    end

    container:getVarLabelTTF("mLMNameLost"):setString(LianmengBattleResultInfo.lianMengBattle[2].lianMengName)
    container:getVarLabelBMFont("mEffectLost"):setString(restraintStr2)
    container:getVarLabelBMFont("mLMCoinLost"):setVisible(true)
    container:getVarLabelBMFont("mLMCoinLost"):setString(LianmengBattleResultInfo.lianMengBattle[2].lianMengScore)


    container:getVarLabelBMFont("mReject"):setVisible(false)
    container:getVarMenuItemImage("mAllReject"):setVisible(false)
    if ViewLianMengBattle == false then
        container:getVarLabelBMFont("mMyResault"):setVisible(true)
        container:getVarLabelBMFont("mMyMark"):setVisible(true)
    else
        container:getVarLabelBMFont("mMyResault"):setVisible(false)
        container:getVarLabelBMFont("mMyMark"):setVisible(false)
    end

    local quitBattleStr = Language:getInstance():getString("@QuitBattle")
    container:getVarLabelBMFont("mRevert"):setString(quitBattleStr)
    
end

function LianMengBattleResaultPage.onExit(container)	
    InBattleResultPage = false
--    LianMengBattleResaultPage.clearAllItem(container)
--	container.m_pScrollViewFacade:delete()
--	container.m_pScrollViewFacade = nil
end

function LianMengBattleResaultPage.onLoad(container)
	container:loadCcbiFile("LianMengBattleResault.ccbi")
--	container.mScrollView = container:getVarScrollView("mContent")
--	container.mScrollViewRootNode = container.mScrollView:getContainer()
end

function LianMengBattleResaultPage.clearAllItem(container)
--    container.m_pScrollViewFacade:clearAllItems()
--    container.mScrollViewRootNode:removeAllChildren()
end
