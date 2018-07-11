require "Convert_pb"
ConvertInfo = {}
AdventureConvertContent = {}
local curScale = 0
local discipleScale = 0
local helpContent = {}
local status = {}
local adventureInfo = {
	adventureId = 22
}
local convertScrollView
local convertScrollViewOffset

function AdventureConvertContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        AdventureConvertContent.onRefreshItemView(container)
    elseif eventName == "onMAECButton" then
        AdventureConvertContent.onMAECButton(container)
    elseif eventName == "MAECFaceTarget" then
        AdventureConvertContent.onMAECFaceTarget(container)
    end
end

function AdventureConvertContent.onRefreshItemView(container)
   
    local id = container:getItemDate().mID
    
    local convertRewardInfo = {}
    
    local scale = container:getVarSprite("mMAECIcoPic1"):getScale()   
    if curScale == 0 then
        curScale = scale
    end
    if discipleScale == 0 then
        discipleScale = scale * 2.5
    end
    for i = 1, 3 do
        container:getVarLabelBMFont("mMAECEqNameNum" .. i):setVisible(false)
        container:getVarLabelBMFont("mMAECNum" .. i):setVisible(false)
        container:getVarSprite("mMAECIcoPic" .. i):setVisible(false)
        container:getVarMenuItemImage("mMAECFace" .. i):setVisible(false)
        
    end
    
    for i = 1, #ConvertInfo.item[id].consume do
        container:getVarLabelBMFont("mMAECEqNameNum" .. i):setVisible(true)
        container:getVarLabelBMFont("mMAECNum" .. i):setVisible(true)
        container:getVarSprite("mMAECIcoPic" .. i):setVisible(true)
        container:getVarMenuItemImage("mMAECFace" .. i):setVisible(true)
        
        local info=ResManager:getInstance():getResInfoByTypeAndId(ConvertInfo.item[id].consume[i].consumesType,ConvertInfo.item[id].consume[i].consumesId,ConvertInfo.item[id].consume[i].consumesQuantity)
        container:getVarLabelBMFont("mMAECEqNameNum" .. i):setString(info.name)
        container:getVarLabelBMFont("mMAECNum" .. i):setString("(" ..ConvertInfo.item[id].consume[i].itemCount .. "/" .. ConvertInfo.item[id].consume[i].consumesQuantity .. ")")
        container:getVarSprite("mMAECIcoPic" .. i):setTexture(info.icon)
        local quality=info.quality
        if info.type==DISCIPLE_TYPE or info.type==SOUL_TYPE or info.type == 32001 then
            container:getVarSprite("mMAECIcoPic" .. i):setScale(discipleScale)
        elseif info.type==USER_PROPERTY_TYPE or info.type==TOOLS_TYPE then
            quality=4
            container:getVarSprite("mMAECIcoPic" .. i):setScale(curScale)
        else
            container:getVarSprite("mMAECIcoPic" .. i):setScale(curScale)
        end
        if quality>4 or quality<1 then
            quality=4
        end

        container:getVarMenuItemImage("mMAECFace" .. i):setNormalImage(getFrameNormalSpirte(quality))
        container:getVarMenuItemImage("mMAECFace" .. i):setSelectedImage(getFrameSelectedSpirte(quality))
    
    end
    
    container:getVarLabelBMFont("mMAECExChangeNum"):setString(1)

    local infoTarget=ResManager:getInstance():getResInfoByTypeAndId(ConvertInfo.item[id].target.targetsType,ConvertInfo.item[id].target.targetsId,ConvertInfo.item[id].target.targetsQuantity)
    container:getVarLabelBMFont("mMAECEqNameNumTarget"):setString(infoTarget.name)
    container:getVarLabelBMFont("mMAECNumTarget"):setString("(" .. ConvertInfo.item[id].target.targetsQuantity .. ")")

    container:getVarSprite("mMAECIcoPicTarget"):setTexture(infoTarget.icon)

    local quality=infoTarget.quality
    if infoTarget.type==DISCIPLE_TYPE or infoTarget.type==SOUL_TYPE or infoTarget.type == 32001 then
        container:getVarSprite("mMAECIcoPicTarget"):setScale(discipleScale)
    elseif infoTarget.type==USER_PROPERTY_TYPE or infoTarget.type==TOOLS_TYPE then
        quality=4
        container:getVarSprite("mMAECIcoPicTarget"):setScale(curScale)
    else
        container:getVarSprite("mMAECIcoPicTarget"):setScale(curScale)
    end
    if quality>4 or quality<1 then
        quality=4
    end

    container:getVarMenuItemImage("mMAECFaceTarget"):setNormalImage(getFrameNormalSpirte(quality))
    --container:getVarMenuItemImage("mMAECFaceTarget"):setSelectedImage(getFrameSelectedSpirte(quality))


    local changeTimes = Language:getInstance():getString("@ExChangeExplan1")  
    changeTimes=string.gsub(changeTimes,"#v1#",ConvertInfo.item[id].converttTime)
    changeTimes=string.gsub(changeTimes,"#v2#",ConvertInfo.item[id].convertTotalTimes)
    
    if ConvertInfo.item[id].convertTotalTimes == -1 then
        changeTimes = Language:getInstance():getString("@ExChangeExplan2")  
    end
    
    container:getVarLabelBMFont("mMAECExChangeNum"):setString(changeTimes)

    
--    container:getVarMenuItemImage("mMAECFaceTarget"):setNormalImage()
    
end

function AdventureConvertContent.onMAECFaceTarget(container)
    local id = container:getItemDate().mID

    local infoTarget=ResManager:getInstance():getResInfoByTypeAndId(ConvertInfo.item[id].target.targetsType,ConvertInfo.item[id].target.targetsId,ConvertInfo.item[id].target.targetsQuantity)

    local item = ToolTableManager:getInstance():getToolItemByID(infoTarget.itemId);
    local rewardStr = item.includeStr

	if common:trim(rewardStr) == "" then return end

    local rewardDetail = Split(rewardStr, ",")   
    
    GoodsViewPage.mViewGoodsListInfo={}
    GoodsViewPage.mTitle = "@PackPreviewTitleView"
    GoodsViewPage.mMsgContent = "@PackPreviewMsgView"

    for i = 1, #rewardDetail do
        local rewardDetailItem = Split(rewardDetail[i], ":")
        local rewardDetailItemList=ResManager:getInstance():getResInfoByTypeAndId(rewardDetailItem[1],rewardDetailItem[2],rewardDetailItem[3])
        GoodsViewPage.mViewGoodsListInfo[i]={}
        GoodsViewPage.mViewGoodsListInfo[i].type=ResManager:getInstance():getResMainType(rewardDetailItemList.type)
        GoodsViewPage.mViewGoodsListInfo[i].name=rewardDetailItemList.name
        GoodsViewPage.mViewGoodsListInfo[i].icon=rewardDetailItemList.icon
        GoodsViewPage.mViewGoodsListInfo[i].count=rewardDetailItemList.count
        GoodsViewPage.mViewGoodsListInfo[i].quality=rewardDetailItemList.quality

    end
    
    MainFrame:getInstance():pushPage("GoodsShowListPage")
end

function AdventureConvertContent.sendChangeReward(container)
    
    local msg = Convert_pb.OPConvert()
	msg.adventureId = 22
	msg.id = container:getItemDate().mID + 0
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(239,pb_data,#pb_data,true)
end

function AdventureConvertContent.onMAECButton(container)
    AdventureConvertContent.sendChangeReward(container)
    convertScrollViewOffset = convertScrollView:getContentOffset()
end

AdventureConvert = {}

function AdventureConvert.onFunction(eventName,container)
    CCLuaLog("eventName"..eventName);
    if eventName == "luaInit" then
        AdventureConvert.onInit(container)
    elseif eventName == "luaEnter" then
        AdventureConvert.onEnter(container)
    elseif eventName == "luaExit" then
        AdventureConvert.onExit(container)
    elseif eventName == "luaExecute" then
        AdventureConvert.onExecute(container)
    elseif eventName == "luaLoad" then
        AdventureConvert.onLoad(container)
    elseif eventName == "luaUnLoad" then
        AdventureConvert.onUnLoad(container)
    elseif eventName == "onExplanation" then
        AdventureConvert.onExplanation(container)
    elseif eventName == "luaGameMessage" then
        AdventureConvert.onGameMessage(container)
    elseif eventName == "luaReceivePacket" then
        AdventureConvert.onReceivePacket(container)
    end
end

function AdventureConvert.onInit(container)
end

function AdventureConvert.onAnimationDone(container)
end

function AdventureConvert.sendConvertInfo(container)
    local msg = Convert_pb.OPConvertInfo()
	msg.adventureId = 22
    msg.bNeedUpdate = 0
	
    for name, key in pairs(status.cachedKey) do
		local savedStr= CCUserDefault:sharedUserDefault():getStringForKey(key)
		if savedStr and savedStr ~= "" then
			adventureInfo[name] = savedStr
		else
			msg.bNeedUpdate = 1
		end
	end
	if adventureInfo.version == nil then
	    adventureInfo.version = 1
	end
	msg.version = adventureInfo.version
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(237,pb_data,#pb_data,true)
end

function AdventureConvert.onReceivePacket(container)
    
	if container:getRecPacketOpcode()==238 then
        local msg = Convert_pb.OPConvertInfoRet()
        msgbuff = container:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
	    
	    AdventureConvert.setConvertInfo(container,msg)
	    AdventureConvert.refreshPage(container)
	    AdventureConvert.rebuildAllItem(container)
	    
		
    elseif container:getRecPacketOpcode()==240 then
                    
        local msg = Convert_pb.OPConvertRet()
        msgbuff = container:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)

        for k, info in ipairs(msg.discipleInfo) do
            DropManager.gotDisciple(info)
        end 
        for k, info in ipairs(msg.soulInfo) do
            DropManager.gotSoul(info)
        end 
        for k, info in ipairs(msg.toolInfo) do
			DropManager.gotTool(info)
        end 
        for k, info in ipairs(msg.equipInfo) do
            DropManager.gotEquipment(info)
        end 
        for k, info in ipairs(msg.skillInfo) do
            DropManager.gotSkill(info)
        end 

        if msg:HasField("goldCoins") then
            ServerDateManager:getInstance():getUserBasicInfo().goldcoins=msg.goldCoins
        end
        if msg:HasField("silverCoins") then
           ScriptMathToLua:modifySilverCoins(msg.silverCoins)
        end
        if msg:HasField("errorCode") then
           MessageBoxPage:Msg_Box("@AdventureConvertError" .. msg.errorCode)
        end
        
        for k, info in ipairs(msg.reward) do
            GoodsViewPage.mViewGoodsListInfo={}
            GoodsViewPage.mTitle = "@RewardTitle"
            GoodsViewPage.mMsgContent = "@RewardMsgContent"
            
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
            break

        end 
        if  msg:HasField("converInfo") then
	        AdventureConvert.setConvertInfo(container,msg.converInfo)
        end
	    AdventureConvert.refreshPage(container)
	    AdventureConvert.rebuildAllItem(container)
        convertScrollView:setContentOffset(convertScrollViewOffset)
	end
    
end

function AdventureConvert.setConvertInfo(container,msg)
    ConvertInfo.lastTime = msg.lastTime
    if msg:HasField("contentHeadTitle") then
		adventureInfo.contentHeadTitle = msg.contentHeadTitle
		CCUserDefault:sharedUserDefault():setStringForKey(status.cachedKey.head, adventureInfo.contentHeadTitle)
		CCUserDefault:sharedUserDefault():flush()
	end
    if msg:HasField("contentTailTitle") then
		adventureInfo.contentTailTitle = msg.contentTailTitle
		CCUserDefault:sharedUserDefault():setStringForKey(status.cachedKey.tail, adventureInfo.contentTailTitle)
		CCUserDefault:sharedUserDefault():flush()
	end
    if msg:HasField("help") then
		adventureInfo.contentHelpTitle = msg.help
		CCUserDefault:sharedUserDefault():setStringForKey(status.cachedKey.help, adventureInfo.contentHelpTitle)
		CCUserDefault:sharedUserDefault():flush()
	end
	
    ConvertInfo.version = msg.version
    ConvertInfo.item = {}
    for i = 1 , #msg.item do
        ConvertInfo.item[i] = {}
        ConvertInfo.item[i].consume = {}
        for j = 1 , #msg.item[i].consume do
            ConvertInfo.item[i].consume[j] = {}
            ConvertInfo.item[i].consume[j].consumesType = msg.item[i].consume[j].consumesType
            ConvertInfo.item[i].consume[j].consumesId = msg.item[i].consume[j].consumesId
            ConvertInfo.item[i].consume[j].consumesQuantity = msg.item[i].consume[j].consumesQuantity
            ConvertInfo.item[i].consume[j].itemCount = msg.item[i].consume[j].itemCount
        end
        ConvertInfo.item[i].target = {}
        ConvertInfo.item[i].target.targetsType = msg.item[i].target.targetsType
        ConvertInfo.item[i].target.targetsId = msg.item[i].target.targetsId
        ConvertInfo.item[i].target.targetsQuantity = msg.item[i].target.targetsQuantity
        ConvertInfo.item[i].target.userTargetCount = msg.item[i].target.userTargetCount
        ConvertInfo.item[i].converttTime = msg.item[i].converttTime
        ConvertInfo.item[i].convertTotalTimes = msg.item[i].convertTotalTimes
    end

end

function AdventureConvert.refreshPage(container)

    container:getVarLabelBMFont("mMAETitle"):setString(adventureInfo.head)
	container:getVarLabelBMFont("mMAEPrompt"):setString(adventureInfo.tail)
	if ConvertInfo.lastTime > 0 then
		status.timerName = "RechargeFeedback_" .. 22
		status.timerContainer = container:getVarLabelBMFont("mMAECNum1")
		status.timerContainer:retain()
		TimeCalculator:getInstance():createTimeCalcultor(status.timerName, ConvertInfo.lastTime)
		RegisterUpdateHandler(status.timerName, AdventureConvert.onTimer)
	end

end

function AdventureConvert.onTimer()
	ConvertInfo.lastTime = TimeCalculator:getInstance():getTimeLeft(status.timerName)
	if ConvertInfo.lastTime <= 0 then
		ConvertInfo.lastTime = 0
		RemoveUpdateHandler(status.timerName)
	end
	if status.timerContainer ~= nil then
		local timeStr = Language:getInstance():getString("@TimeLeft"):gsub("#v1#", common:second2DateString(ConvertInfo.lastTime))
		status.timerContainer:setString(timeStr)
	end
end

function AdventureConvert.onExplanation(container)
    if adventureInfo.contentHelpTitle == nil then
    else
        helpContent = Split(adventureInfo.contentHelpTitle, "#")   

        local ConvertInfoHelp = {}
        
        for i = 1 , #helpContent do
            ConvertInfoHelp[i] = {}
            local helpContentDetail = Split(helpContent[i], "_")   
            ConvertInfoHelp[i].title = helpContentDetail[1]
            ConvertInfoHelp[i].content = helpContentDetail[2]
            
        end
        
        CommonHelpPageVar.set(ConvertInfoHelp,"@Explanation")
        MainFrame:getInstance():pushPage("CommonHelpPage")
    end	

end

function AdventureConvert.onEnter(container)
    container:registerPacket(238)
    container:registerPacket(240)
    
    status.cachedKey = {
		help  = "AdventureHelp_" .. adventureInfo.adventureId,
		head = "AdventureHead_" .. adventureInfo.adventureId,
		tail = "AdventureTail_" .. adventureInfo.adventureId,
		version = "AdventureVersion_" .. adventureInfo.adventureId
	}
    
    AdventureConvert.onShowRewards(container)
    AdventureConvert.sendConvertInfo(container)
end

function AdventureConvert.onExit(container)    
    CCLuaLog("AdventureConvert.onExit")
    AdventureConvert.mShowAni=false
	RemoveUpdateHandler(status.timerName)
    container:removePacket(238)
    container:removePacket(240)

end

function AdventureConvert.onExecute(container)

end

function AdventureConvert.changePowerStatus(container)
    
end

function AdventureConvert.onLoad(container)
    container:loadCcbiFile("MidAutumnExchange.ccbi")	
    container.mScrollView = container:getVarScrollView("mMAESv")
    convertScrollView = container.mScrollView
	container.mScrollViewRootNode = container.mScrollView:getContainer()
	container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
	container.m_pScrollViewFacade:init(6,6)

end

function AdventureConvert.onShowRewards(container)
end

function AdventureConvert.rebuildAllItem(container)
    AdventureConvert.clearAllItem(container)
    AdventureConvert.buildItem(container)
end

function AdventureConvert.clearAllItem(container)
    container.m_pScrollViewFacade:clearAllItems()
    container.mScrollViewRootNode:removeAllChildren()
end

function AdventureConvert.buildItem(container)
    local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
	local iCount = 0;
	local fOneItemHeight = 0;
	local fOneItemWidth = 0;

	for k, v in pairs(ConvertInfo.item) do
		local pItemData = CCReViSvItemData:new()
		pItemData.mID =  k
		pItemData.m_iIdx = iCount
		pItemData.m_ptPosition = ccp(0, fOneItemHeight*iCount)

		if iCount < iMaxNode then
			local pItem = ScriptContentBase:create("MidAutumnExchangeContent.ccbi")
			pItem.id = iCount
			pItem:registerFunctionHandler(AdventureConvertContent.onFunction)
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
	
--    container:getVarLabelBMFont("mTDGCostNum1"):setString(curDiamondNum)
--    container:getVarLabelBMFont("mTDGCostNum2"):setString(maxDiamondNum)
end

function AdventureConvert.onUnLoad(container)
    CCLuaLog("AdventureConvert.onUnLoad");
end

function AdventureConvert.onGameMessage(container)
    CCLuaLog("AdventureConvert.onGameMessage")
end

function luaCreat_AdventureConvert(container)
    CCLuaLog("OnCreat_AdventureConvert")
    container:registerFunctionHandler(AdventureConvert.onFunction)
end
