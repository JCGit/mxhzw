require "AdventureCharge_pb"
require "CommonHelpPage"
require "GoodsShowListPage"
local convertScrollView
local convertScrollViewOffset
local option = {
	ccbiFile = "MidAutumnARecharge.ccbi",
	handlerMap = {
		onMAARButton = "onRecharge",
		onExplanation = "onHelp"
	}
}
local RechargeFeedback = CommonPage.new("RechargeFeedback", option)

local OPCODE_ADVENTURE_CHARGE_INFO_C = 233;
local OPCODE_ADVENTURE_CHARGE_INFO_S = 234;
local OPCODE_ADVENTURE_CHARGE_GET_REWARD_C = 235;
local OPCODE_ADVENTURE_CHARGE_GET_REWARD_S = 236;

local ADVENTURE_TYPE_SINGLE = 0
local ADVENTURE_TYPE_ACCUMULATE = 1

local status = {
	isSingle = true,
	timerContainer = nil
}

local adventureInfo = {
	adventureId = 26,
	version = 1
--[[
  required int32 lastTime = 1;//倒计时
  optional string contentHeadTitle = 2;//内容标题
  optional string contentTailTitle = 3;//内容尾部标题
  optional string help = 4;//帮助
  optional int32 TotalCharged = 5;//累计充值的数目
  repeated ChargeItem items = 6;//每条的数据
  --]]
}

local RechargeFeedbackContent = {}

function RechargeFeedbackContent.onFunction(eventName, container)
	if eventName == "luaRefreshItemView" then
		RechargeFeedbackContent.onRefreshItemView(container)
	elseif eventName == "onMAARButton" then
		RechargeFeedbackContent.onGetReward(container)
	elseif tostring(eventName):sub(1, -2) == "onMAARCFace" then
		RechargeFeedbackContent.showResInfo(container, tostring(eventName):sub(-1) + 0)
	end
end

function RechargeFeedbackContent.onRefreshItemView(container)
	local rewardItem = adventureInfo.items[container:getItemDate().mID]
	local tipStr = rewardItem.rewardCondition .. " "
	if rewardItem.rewardsTotalTimes == -1 then
		tipStr = tipStr .. Language:getInstance():getString("@NoLimit")
	else
		tipStr = tipStr .. rewardItem.rewardsTime .. "/" .. rewardItem.rewardsTotalTimes
	end
	local lb2Str = {
		mMAECARechargeNum = tipStr
	}
	for k = 1, 3 do
		local rewardInfo = rewardItem.rewards[k]
		local iconNode = container:getVarSprite("mMAARCIcoPic" .. k)
		local qualityNode = container:getVarMenuItemImage("mMAARCFace" .. k)
		local nameNode = container:getVarNode("mNode" .. k)
		local hasRewardInfo = rewardInfo ~= nil

		iconNode:setVisible(hasRewardInfo)
		qualityNode:setVisible(hasRewardInfo)
		nameNode:setVisible(hasRewardInfo)

		if hasRewardInfo then
			local reward = ResManager:getInstance():getResInfoByTypeAndId(rewardInfo.rewardsType, rewardInfo.rewardsId, rewardInfo.rewardsQuantity)
			iconNode:setTexture(reward.icon)
			local resType = ResManager:getInstance():getResMainType(reward.type)
			if resType == DISCIPLE_TYPE or resType == SOUL_TYPE then
				iconNode:setScale(iconNode:getScale() * 2.5)
			end
			local quality = reward.quality >= 1 and reward.quality <= 4 and reward.quality or 4
			qualityNode:setNormalImage(getFrameNormalSpirte(quality))
			qualityNode:setSelectedImage(getFrameSelectedSpirte(quality))
			lb2Str["mMAARCEqNameNum" .. k] = reward.name .. "*" .. reward.count
		end
	end
	common:setStringForLabel(container, lb2Str)

	container:getVarMenuItem("mMAARButton"):setEnabled(rewardItem.canGetRewards == 1) --1: enable to receive
end

function RechargeFeedbackContent.onGetReward(container)
	RechargeFeedbackContent.sendPacketForReward(container)
    convertScrollViewOffset = convertScrollView:getContentOffset()
end

function RechargeFeedbackContent.sendPacketForReward(container)
	local msg = AdventureCharge_pb.OPAdventureChargeGetRewards()
	msg.adventureId = 26 --todo
	msg.id = container:getItemDate().mID
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(OPCODE_ADVENTURE_CHARGE_GET_REWARD_C, pb_data, #pb_data, true)
end

function RechargeFeedbackContent.showResInfo(container, resIndex)
	local rewardItem = adventureInfo.items[container:getItemDate().mID]
	local resCfg = rewardItem.rewards[resIndex]
	common:showGiftPackage(resCfg.rewardsId)
end

function RechargeFeedback.onRecharge(container)
	MainFrame:getInstance():pushPage("RechargePage")
end

function RechargeFeedback.onHelp(container)
	local helpInfo = {}
	local attrs = {"title", "content"}
	for _, item in ipairs(Split(adventureInfo.help, "#")) do
		table.insert(helpInfo, common:table_combine(attrs, Split(item, "_")))
	end

	CommonHelpPageVar.set(helpInfo)
	MainFrame:getInstance():pushPage("CommonHelpPage")
end

function RechargeFeedback.onEnter(container)
    container.mScrollView = container:getVarScrollView("mMAESv")
    convertScrollView = container.mScrollView
	container.mScrollViewRootNode = container.mScrollView:getContainer()
	container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
	container.m_pScrollViewFacade:init(6,6)

	container:registerPacket(OPCODE_ADVENTURE_CHARGE_INFO_S)
	container:registerPacket(OPCODE_ADVENTURE_CHARGE_GET_REWARD_S)

	status.cachedKey = {
		help  = "AdventureHelp_" .. adventureInfo.adventureId,
		head = "AdventureHead_" .. adventureInfo.adventureId,
		tail = "AdventureTail_" .. adventureInfo.adventureId,
		version = "AdventureVersion_" .. adventureInfo.adventureId
	}
	RechargeFeedback.getAdventureInfo(container)
end

function RechargeFeedback.getAdventureInfo(container)
	local msg = AdventureCharge_pb.OPAdventureChargeInfo()
	msg.adventureId = adventureInfo.adventureId
	msg.bNeedUpdate = 0

	for name, key in pairs(status.cachedKey) do
		local savedStr= CCUserDefault:sharedUserDefault():getStringForKey(key)
		if savedStr and savedStr ~= "" then
			adventureInfo[name] = savedStr
		else
			msg.bNeedUpdate = 1
		end
	end
	msg.version = tonumber(adventureInfo.version)

	local pb_data = msg:SerializeToString()
	container:sendPakcet(OPCODE_ADVENTURE_CHARGE_INFO_C, pb_data, #pb_data, true)
end

function RechargeFeedback.onReceivePacket(container)
    if container:getRecPacketOpcode() == OPCODE_ADVENTURE_CHARGE_INFO_S then
		local msg = AdventureCharge_pb.OPAdventureChargeInfoRet()
		local msgBuff = container:getRecPacketBuffer()
		msg:ParseFromString(msgBuff)
		RechargeFeedback.onReceiveChargeInfo(container, msg)
		return
	end

    if container:getRecPacketOpcode() == OPCODE_ADVENTURE_CHARGE_GET_REWARD_S then
		local msg = AdventureCharge_pb.OPAdventureChargeGetRewardsRet()
		local msgBuff = container:getRecPacketBuffer()
		msg:ParseFromString(msgBuff)
		
        if msg:HasField("errorCode") then
			MessageBoxPage:Msg_Box("@AdventureRechargeError" .. msg.errorCode)
			return
        end
		local rewardMsg = {
			discipleInfo = msg.discipleInfo,
			soulInfo = msg.soulInfo,
			toolInfo = msg.toolInfo,
			equipInfo = msg.equipInfo,
			skillInfo = msg.skillInfo,
			silverCoins = msg.silverCoins,
			goldCoins = msg.goldCoins
		}
		DropManager.gotRewards(rewardMsg)

		RechargeFeedback.prepareRewardView(msg.reward)
		MainFrame:getInstance():pushPage("GoodsShowListPage")
		RechargeFeedback.onReceiveChargeInfo(container, msg.ChargeInfo)
		convertScrollView:setContentOffset(convertScrollViewOffset)
	end
end

function RechargeFeedback.onReceiveChargeInfo(container, msg)
	adventureInfo.lastTime = msg.lastTime
	adventureInfo.items = msg.items
	if msg:HasField("contentHeadTitle") then
		adventureInfo.contentHeadTitle = msg.contentHeadTitle
		CCUserDefault:sharedUserDefault():setStringForKey(status.cachedKey.head, adventureInfo.head)
		CCUserDefault:sharedUserDefault():flush()
	end
	if msg:HasField("contentTailTitle") then
		adventureInfo.contentTailTitle = msg.contentTailTitle
		CCUserDefault:sharedUserDefault():setStringForKey(status.cachedKey.tail, adventureInfo.tail)
		CCUserDefault:sharedUserDefault():flush()
	end
	if msg:HasField("help") then
		adventureInfo.help = msg.help
		CCUserDefault:sharedUserDefault():setStringForKey(status.cachedKey.help, adventureInfo.help)
		CCUserDefault:sharedUserDefault():flush()
	end
	if msg.version ~= tonumber(adventureInfo.version) then
		adventureInfo.version = msg.version
		CCUserDefault:sharedUserDefault():setStringForKey(status.cachedKey.version, tostring(adventureInfo.version))
		CCUserDefault:sharedUserDefault():flush()
	end

	if msg:HasField("TotalCharged") then
		adventureInfo.totalRecharged = msg.TotalCharged
	end
	status.isSingle = msg.chargeType == ADVENTURE_TYPE_SINGLE

	RechargeFeedback.rebuildAllItem(container)
end

function RechargeFeedback.rebuildAllItem(container)
	RechargeFeedback.clearAllItem(container);
	RechargeFeedback.buildItem(container);
end

function RechargeFeedback.buildItem(container)
	local lb2Str = {
		mMidAutumnTitle1 = adventureInfo.contentHeadTitle,
		mMAARPrompt = adventureInfo.contentTailTitle
	}

	local singleNode = container:getVarNode("mMAARMod")
	local acumNode = container:getVarNode("mMACumMode")

	singleNode:setVisible(status.isSingle)
	acumNode:setVisible(not status.isSingle)
	if not status.isSingle then
		lb2Str["mMAECNum2"] = adventureInfo.totalRecharged
	end
	common:setStringForLabel(container, lb2Str)

	RechargeFeedback.initScrollView(container)
	if adventureInfo.lastTime > 0 then
		status.timerName = "RechargeFeedback_" .. adventureInfo.adventureId
		status.timerContainer = container:getVarLabelBMFont("mMAECNum1")
		status.timerContainer:retain()
		TimeCalculator:getInstance():createTimeCalcultor(status.timerName, adventureInfo.lastTime)
		RegisterUpdateHandler(status.timerName, RechargeFeedback.onTimer)
	end
end

function RechargeFeedback.onTimer()
	local leftTime = TimeCalculator:getInstance():getTimeLeft(status.timerName)
	if leftTime + 1 > adventureInfo.lastTime then
		return
	end

	adventureInfo.lastTime = leftTime
	if adventureInfo.lastTime <= 0 then
		adventureInfo.lastTime = 0
		RemoveUpdateHandler(status.timerName)
	end
	if status.timerContainer ~= nil then
		local timeStr = Language:getInstance():getString("@TimeLeft"):gsub("#v1#", common:second2DateString(adventureInfo.lastTime))
		status.timerContainer:setString(timeStr)
	end
end

function RechargeFeedback.initScrollView(container)
	local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
	local iCount = 0;
	local fOneItemHeight = 0;
	local fOneItemWidth = 0;

	for i = #adventureInfo.items, 1, -1 do
		local itemData = adventureInfo.items[i]
			local pItemData = CCReViSvItemData:new()
			pItemData.mID = i
			pItemData.m_iIdx = i
			pItemData.m_ptPosition = ccp(0, fOneItemHeight * iCount)

			if iCount < iMaxNode then
				local pItem = ScriptContentBase:create("MidAutumnARechargeContent.ccbi")
				pItem.id = iCount
				pItem:registerFunctionHandler(RechargeFeedbackContent.onFunction)
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
	local size = CCSizeMake(fOneItemWidth, fOneItemHeight * iCount)
	container.mScrollView:setContentSize(size);
	container.mScrollView:setContentOffset(ccp(0, container.mScrollView:getViewSize().height - container.mScrollView:getContentSize().height*container.mScrollView:getScaleY()));
	container.m_pScrollViewFacade:setDynamicItemsStartPosition(iCount-1);
end

function RechargeFeedback.clearAllItem(container)
	container.m_pScrollViewFacade:clearAllItems()
	container.mScrollViewRootNode:removeAllChildren()
end

function RechargeFeedback.refreshContent(container)
	RechargeFeedback.buildItems(container)
end

function RechargeFeedback.prepareRewardView(rewardInfo)
	GoodsViewPage.mTitle = "@RewardTitle"
	GoodsViewPage.mMsgContent = "@RewardMsgContent"
	GoodsViewPage.mViewGoodsListInfo = {}
	for k, info in ipairs(rewardInfo) do
		local _resInfo = ResManager:getInstance():getResInfoByTypeAndId(info.itemType, info.itemId, info.count)
		GoodsViewPage.mViewGoodsListInfo[k] = {
			type = ResManager:getInstance():getResMainType(info.itemType),
			name = _resInfo.name,
			icon = _resInfo.icon,
			count = _resInfo.count,
			quality = _resInfo.quality
		}
	end
end

function RechargeFeedback.onExit(container)
	RechargeFeedback.clearAllItem(container)
	container.m_pScrollViewFacade:delete()
	container.m_pScrollViewFacade = nil
	container:removePacket(OPCODE_ADVENTURE_CHARGE_INFO_S)
	container:removePacket(OPCODE_ADVENTURE_CHARGE_GET_REWARD_S)
	RemoveUpdateHandler(status.timerName)
end
