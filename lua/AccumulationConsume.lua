
require "AccumulationConsume_pb"
local count
AccumulationConsumeContent = {}
AccumulationStatusConsume = {}
AccumulationConsumeRewards = {}
local maxDiamondNum = 0
local curDiamondNum = 0
local curScale = 0
local discipleScale = 0

function AccumulationConsumeContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        AccumulationConsumeContent.onRefreshItemView(container)
    elseif eventName == "onTDGCDraw" then
        AccumulationConsumeContent.onTDGCDraw(container)
    end
end

function AccumulationConsumeContent.onRefreshItemView(container)

    local id = container:getItemDate().mID
    
    local diamondNum = AccumulationConsumeRewards[id].diamondNum
    local rewardContent = AccumulationConsumeRewards[id].rewardContent
    
    local rewardIterms = Split(rewardContent, ",", 5)   
    local scale = container:getVarSprite("mTDGCEqPic1"):getScale()
    
    if curScale == 0 then
        curScale = scale
    end
    if discipleScale == 0 then
        discipleScale = scale * 2.5
    end
    if rewardIterms ~= nil or rewardIterms[1] ~= nil then
        local rewardIterms1
        if rewardIterms[1] == nil then
            rewardIterms1 = Split(rewardIterms, ":", 5)   
        else
            rewardIterms1 = Split(rewardIterms[1], ":", 5)   
        end
        AccumulationConsumeContent.info1=ResManager:getInstance():getResInfoByTypeAndId(rewardIterms1[1],rewardIterms1[2],rewardIterms1[3])

        container:getVarSprite("mTDGCEqPic1"):setTexture(AccumulationConsumeContent.info1.icon)
        local quality1=AccumulationConsumeContent.info1.quality
        if AccumulationConsumeContent.info1.type==DISCIPLE_TYPE or AccumulationConsumeContent.info1.type==SOUL_TYPE or AccumulationConsumeContent.info1.type == 32001 then
            container:getVarSprite("mTDGCEqPic1"):setScale(discipleScale)
        elseif AccumulationConsumeContent.info1.type==USER_PROPERTY_TYPE or AccumulationConsumeContent.info1.type==TOOLS_TYPE then
            quality1=4
            container:getVarSprite("mTDGCEqPic1"):setScale(curScale)
        else
            container:getVarSprite("mTDGCEqPic1"):setScale(curScale)
        end
        if quality1>4 or quality1<1 then
            quality1=4
        end
        container:getVarMenuItemImage("TDGCQuality1"):setNormalImage(getFrameNormalSpirte(quality1))
        container:getVarMenuItemImage("TDGCQuality1"):setSelectedImage(getFrameSelectedSpirte(quality1))

        container:getVarLabelBMFont("mTDGCNum1"):setString(AccumulationConsumeContent.info1.name .. "X" .. AccumulationConsumeContent.info1.count)
        container:getVarNode("mTDGCNode1"):setVisible(true)
    else
        container:getVarNode("mTDGCNode1"):setVisible(false)
    end

    if rewardIterms[2] ~= nil then
        local rewardIterms2 = Split(rewardIterms[2], ":", 5)   
        AccumulationConsumeContent.info2=ResManager:getInstance():getResInfoByTypeAndId(rewardIterms2[1],rewardIterms2[2],rewardIterms2[3])
        container:getVarSprite("mTDGCEqPic2"):setTexture(AccumulationConsumeContent.info2.icon)
        local quality2=AccumulationConsumeContent.info2.quality
        if AccumulationConsumeContent.info2.type==DISCIPLE_TYPE or AccumulationConsumeContent.info2.type==SOUL_TYPE or AccumulationConsumeContent.info2.type == 32001 then
            container:getVarSprite("mTDGCEqPic2"):setScale(discipleScale)
        elseif AccumulationConsumeContent.info2.type==USER_PROPERTY_TYPE or AccumulationConsumeContent.info2.type==TOOLS_TYPE then
            quality2=4
            container:getVarSprite("mTDGCEqPic2"):setScale(curScale)
        else
            container:getVarSprite("mTDGCEqPic2"):setScale(curScale)
        end
        if quality2>4 or quality2<1 then
            quality2=4
        end
        container:getVarMenuItemImage("TDGCQuality2"):setNormalImage(getFrameNormalSpirte(quality2))
        container:getVarMenuItemImage("TDGCQuality2"):setSelectedImage(getFrameSelectedSpirte(quality2))
        container:getVarLabelBMFont("mTDGCNum2"):setString(AccumulationConsumeContent.info2.name .. "X" .. AccumulationConsumeContent.info2.count)
        container:getVarNode("mTDGCNode2"):setVisible(true)
    else
        container:getVarNode("mTDGCNode2"):setVisible(false)
    end
    
    if rewardIterms[3] ~= nil then
        local rewardIterms3 = Split(rewardIterms[3], ":", 5)   
        AccumulationConsumeContent.info3=ResManager:getInstance():getResInfoByTypeAndId(rewardIterms3[1],rewardIterms3[2],rewardIterms3[3])
        container:getVarSprite("mTDGCEqPic3"):setTexture(AccumulationConsumeContent.info3.icon)
        local quality3=AccumulationConsumeContent.info3.quality
        if AccumulationConsumeContent.info3.type==DISCIPLE_TYPE or AccumulationConsumeContent.info3.type==SOUL_TYPE or AccumulationConsumeContent.info3.type == 32001 then
            container:getVarSprite("mTDGCEqPic3"):setScale(discipleScale)
        elseif AccumulationConsumeContent.info3.type==USER_PROPERTY_TYPE or AccumulationConsumeContent.info3.type==TOOLS_TYPE then
            quality3=4
            container:getVarSprite("mTDGCEqPic3"):setScale(curScale)
        else
            container:getVarSprite("mTDGCEqPic3"):setScale(curScale)
        end
        if quality3>4 or quality3<1 then
            quality3=4
        end
        container:getVarMenuItemImage("TDGCQuality3"):setNormalImage(getFrameNormalSpirte(quality3))
        container:getVarMenuItemImage("TDGCQuality3"):setSelectedImage(getFrameSelectedSpirte(quality3))
        container:getVarLabelBMFont("mTDGCNum3"):setString(AccumulationConsumeContent.info3.name .. "X" .. AccumulationConsumeContent.info3.count)
        container:getVarNode("mTDGCNode3"):setVisible(true)
    else
        container:getVarNode("mTDGCNode3"):setVisible(false)
    end
--[[
    if rewardIterms[4] ~= nil then
        local rewardIterms4 = Split(rewardIterms[4], ":", 5)   
        AccumulationConsumeContent.info4=ResManager:getInstance():getResInfoByTypeAndId(rewardIterms4[1],rewardIterms4[2],rewardIterms4[3])
        container:getVarSprite("mTDGCEqPic4"):setTexture(AccumulationConsumeContent.info4.icon)
        local quality4=AccumulationConsumeContent.info4.quality
        if AccumulationConsumeContent.info4.type==DISCIPLE_TYPE or AccumulationConsumeContent.info4.type==SOUL_TYPE or AccumulationConsumeContent.info4.type == 32001 then
            container:getVarSprite("mTDGCEqPic4"):setScale(discipleScale)
        elseif AccumulationConsumeContent.info4.type==USER_PROPERTY_TYPE or AccumulationConsumeContent.info4.type==TOOLS_TYPE then
            quality4=4
            container:getVarSprite("mTDGCEqPic4"):setScale(curScale)
        else
            container:getVarSprite("mTDGCEqPic4"):setScale(curScale)
        end
        if quality4>4 or quality4<1 then
            quality4=4
        end
        container:getVarMenuItemImage("TDGCQuality4"):setNormalImage(getFrameNormalSpirte(quality4))
        container:getVarMenuItemImage("TDGCQuality4"):setSelectedImage(getFrameSelectedSpirte(quality4))
        container:getVarLabelBMFont("mTDGCNum4"):setString(AccumulationConsumeContent.info4.name .. "X" .. AccumulationConsumeContent.info4.count)
        container:getVarNode("mTDGCNode4"):setVisible(true)
    else
        container:getVarNode("mTDGCNode4"):setVisible(false)
    end
--]]    
    local rewardStr = Language:getInstance():getString("@consumeDiamond")  
    rewardStr=string.gsub(rewardStr,"#v1#",diamondNum)
    
    if diamondNum + 0 > maxDiamondNum then
        maxDiamondNum = diamondNum + 0
    end
    
    container:getVarLabelBMFont("mDiamondsNum"):setString(rewardStr)
        
    local rewardStr = Language:getInstance():getString("@GetReward")
    local getRewardStr = Language:getInstance():getString("@AlreadyGetReward")
    
    if AccumulationStatusConsume[id] == 0 then
        container:getVarMenuItemImage("mTDGCDraw"):setEnabled(true)
    else
        container:getVarMenuItemImage("mTDGCDraw"):setEnabled(false)
    end
    
    if AccumulationStatusConsume[id] == 1 then
        container:getVarLabelBMFont("mTDGCText2"):setVisible(false)
        container:getVarLabelBMFont("mDrawText"):setString(getRewardStr)
    else
        container:getVarLabelBMFont("mTDGCText2"):setVisible(false)
        container:getVarLabelBMFont("mDrawText"):setString(rewardStr)
    end

    if AccumulationStatusConsume[id] == -1 then
        container:getVarLabelBMFont("mTDGCText1"):setVisible(false)
    else
        container:getVarLabelBMFont("mTDGCText1"):setVisible(false)
    end

end

function AccumulationConsumeContent.sendConsumeReward(container)   
    local msg = AccumulationConsume_pb.OPAccumulationConsumeGetReward()
	msg.version = 1
	msg.id = AccumulationConsumeRewards[container:getItemDate().mID].index + 0
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(253,pb_data,#pb_data,true)
end

function AccumulationConsumeContent.onTDGCDraw(container)
    AccumulationConsumeContent.sendConsumeReward(container)    
end

AccumulationConsume = {}

function AccumulationConsume.onFunction(eventName,container)
    CCLuaLog("eventName"..eventName);
    if eventName == "luaInit" then
        AccumulationConsume.onInit(container)
    elseif eventName == "luaEnter" then
        AccumulationConsume.onEnter(container)
    elseif eventName == "luaExit" then
        AccumulationConsume.onExit(container)
    elseif eventName == "luaExecute" then
        AccumulationConsume.onExecute(container)
    elseif eventName == "luaLoad" then
        AccumulationConsume.onLoad(container)
    elseif eventName == "luaUnLoad" then
        AccumulationConsume.onUnLoad(container)
    elseif eventName == "luaGameMessage" then
        AccumulationConsume.onGameMessage(container)
    elseif eventName == "onTDGDarwButton" then
        AccumulationConsume.onTDGDarw(container)
    elseif eventName == "luaReceivePacket" then
        AccumulationConsume.onReceivePacket(container)
    end
end

function AccumulationConsume.onInit(container)
end

function AccumulationConsume.onTDGDarw(container)
    local msg = MsgMainFramePushPage:new()
    msg.pageName = "RechargePage"
    MessageManager:getInstance():sendMessageForScript(msg)

end

function AccumulationConsume.onAnimationDone(container)
end

function AccumulationConsume.onEnter(container)

    container:registerPacket(252)
    container:registerPacket(254)
    AccumulationConsume.onShowRewards(container)
    AccumulationConsume.sendComsumeInfo(container)
end

function AccumulationConsume.sendComsumeInfo(container)
    local msg = AccumulationConsume_pb.OPAccumulationConsumeInfo()
	msg.version = 1
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(251,pb_data,#pb_data,true)
end

function AccumulationConsume.onExit(container)    
    CCLuaLog("AccumulationConsume.onExit")
    AccumulationConsume.mShowAni=false
    container:removePacket(252)
    container:removePacket(254)
end

function AccumulationConsume.onExecute(container)

end

function AccumulationConsume.changePowerStatus(container)
    return
    
end

function AccumulationConsume.onLoad(container)
    container:loadCcbiFile("TeachersDayGift.ccbi")	
    container.mScrollView = container:getVarScrollView("mTDG")
    
	container.mScrollViewRootNode = container.mScrollView:getContainer()
	container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
	container.m_pScrollViewFacade:init(6,6)

end

function AccumulationConsume.onShowRewards(container)
    if AccumulationConsumeRewards==nil or table.maxn(AccumulationConsumeRewards)<=0 then
        local tabel = TableReaderManager:getInstance():getTableReader("AccumulationConsumeConfig.txt")
        count = tabel:getLineCount()-1;
        for i = 1,count do
            local index = tonumber(tabel:getData(i,0))
            if AccumulationConsumeRewards[index] == nil then
                AccumulationConsumeRewards[index] = {}
                AccumulationConsumeRewards[index].index = tabel:getData(i,0)
                AccumulationConsumeRewards[index].diamondNum = tabel:getData(i,1)
                AccumulationConsumeRewards[index].rewardContent = tabel:getData(i,2)
            end        
        end
    end
end

function AccumulationConsume.rebuildAllItem(container)
    AccumulationConsume.clearAllItem(container)
    AccumulationConsume.buildItem(container)
end

function AccumulationConsume.clearAllItem(container)
    container.m_pScrollViewFacade:clearAllItems()
    container.mScrollViewRootNode:removeAllChildren()
end

function AccumulationConsume.buildItem(container)
    local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
	local iCount = 0;
	local fOneItemHeight = 0;
	local fOneItemWidth = 0;
	


	for k, v in pairs(AccumulationConsumeRewards) do
		local pItemData = CCReViSvItemData:new()
		pItemData.mID =  k
		pItemData.m_iIdx = iCount
		pItemData.m_ptPosition = ccp(0, fOneItemHeight*iCount)

		if iCount < iMaxNode then
			local pItem = ScriptContentBase:create("TeachersDayGiftContent.ccbi")
			pItem.id = iCount
			pItem:registerFunctionHandler(AccumulationConsumeContent.onFunction)
			if  fOneItemHeight < pItem:getContentSize().height then
				fOneItemHeight = pItem:getContentSize().height
			end
			if fOneItemWidth < pItem:getContentSize().width then
				fOneItemWidth = pItem:getContentSize().width
			end
			container.m_pScrollViewFacade:addItem(pItemData, pItem.__CCReViSvItemNodeFacade__)
		else
               container.m_pScrollViewFacade:addItem(pItemData)
        end
		iCount = iCount+1
	end
	local size = CCSizeMake(fOneItemWidth, fOneItemHeight*iCount)
	container.mScrollView:setContentSize(size);
	container.mScrollView:setContentOffset(ccp(0, container.mScrollView:getViewSize().height - container.mScrollView:getContentSize().height*container.mScrollView:getScaleY()));
	container.m_pScrollViewFacade:setDynamicItemsStartPosition(iCount-1);
	container.mScrollView:forceRecaculateChildren()
	
    container:getVarLabelBMFont("mTDGCostNum1"):setString(curDiamondNum)
    container:getVarLabelBMFont("mTDGCostNum2"):setString(maxDiamondNum)
    
end

function AccumulationConsume.onUnLoad(container)
    CCLuaLog("AccumulationConsume.onUnLoad");
end

function AccumulationConsume.onReceivePacket(container)
	if container:getRecPacketOpcode()==252 then
	    local msg = AccumulationConsume_pb.OPAccumulationConsumeInfoRet()
        msgbuff = container:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
        local statusComsume = json.decode(msg.consumeStatus)
        curDiamondNum = statusComsume["s"]
       	table.sort(AccumulationConsumeRewards, 
            function (e1, e2)
                if not e2 then return true end
                if not e1 then return false end
              
			    return e1.diamondNum + 0 > e2.diamondNum + 0
            end
	    )
	    
        for i = 1,count do
	    
	        if statusComsume[AccumulationConsumeRewards[i].index] == 1 then
	            AccumulationStatusConsume[i] = statusComsume[AccumulationConsumeRewards[i].index]
	        else
	            AccumulationStatusConsume[i] = 0
	        end
	        if AccumulationConsumeRewards[i].diamondNum + 0 > statusComsume["s"] then
	            AccumulationStatusConsume[i] = -1
	        end
	    end
        AccumulationConsume.rebuildAllItem(container)
 
	elseif container:getRecPacketOpcode()==254 then
        local msg = AccumulationConsume_pb.OPAccumulationConsumeGetRewardRet()
        msgbuff = container:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
	    

        for k, info in ipairs(msg.soulInfo) do
            DropManager.gotSoul(info)
        end 
        for k, info in ipairs(msg.skillInfo) do
            DropManager.gotSkill(info)
        end 
        for k, info in ipairs(msg.equipInfo) do
            DropManager.gotEquipment(info)
        end 
        for k, info in ipairs(msg.toolInfo) do
			DropManager.gotTool(info)
        end 
        for k, info in ipairs(msg.disciple) do
            DropManager.gotDisciple(info)
        end 

        if msg:HasField("power") then
            ServerDateManager:getInstance():getUserBasicInfo().power=msg.power
        end
        if msg:HasField("vitality") then
            ServerDateManager:getInstance():getUserBasicInfo().vitality=msg.vitality
        end
        if msg:HasField("exp") then
            ServerDateManager:getInstance():getUserBasicInfo().exp=msg.exp
        end
        if msg:HasField("goldcoins") then
            ServerDateManager:getInstance():getUserBasicInfo().goldcoins=msg.goldcoins
        end
        if msg:HasField("silvercoins") then
           ScriptMathToLua:modifySilverCoins(msg.silvercoins)
        end
        AccumulationConsume.sendComsumeInfo(container)


        GoodsViewPage.mViewGoodsListInfo={}
        GoodsViewPage.mTitle="@AccumulationConsumeRewardTitle"
        GoodsViewPage.mMsgContent="@AccumulationConsumeRewardContent"
        
        for i = 1,#msg.reward do
            local reward=ResManager:getInstance():getResInfoByTypeAndId(msg.reward[i].itemType,msg.reward[i].itemId,msg.reward[i].count)
            GoodsViewPage.mViewGoodsListInfo[i]={}
            GoodsViewPage.mViewGoodsListInfo[i].type=reward.type
            GoodsViewPage.mViewGoodsListInfo[i].name=reward.name
            GoodsViewPage.mViewGoodsListInfo[i].icon=reward.icon
            GoodsViewPage.mViewGoodsListInfo[i].count=reward.count
            GoodsViewPage.mViewGoodsListInfo[i].quality=reward.quality
        end
        
        MainFrame:getInstance():pushPage("GoodsShowListPage")
	end
end

function AccumulationConsume.onGameMessage(container)
    CCLuaLog("AccumulationConsume.onGameMessage")
    --[[
    if container:getMessageID()==1 then
        CCLuaLog("!!!special message")
        CCLuaLog(container:getMessagePara())
    end
    --]]
end

function luaCreat_AccumulationConsume(container)
    CCLuaLog("OnCreat_AccumulationConsume")
    container:registerFunctionHandler(AccumulationConsume.onFunction)
end

