require "CommonPage"
require "Exchange_pb"
require "GoodsShowListPage"

local option = {
	ccbiFile = "TeachersDay.ccbi",
	handlerMap = {
		onSummon = "onCall",
		onTDHelp = "onHelp"
	}
}
local CallOfLufei = CommonPage.new("CallOfLufei", option)

registerScriptPage("CallOfLufeiHelpPage")

local OPCODE_EXCHANGE_C = 241
local OPCODE_EXCHANGERET_S = 242

local status = {
	isMainEnough = false,
	isAdditionEnough = false,
	isRunningAni = false
}

function CallOfLufei.onHelp(container)
	MainFrame:getInstance():pushPage("CallOfLufeiHelpPage")
end

function CallOfLufei.onEnter(container)
	CallOfLufei.buildItems(container)
	container:registerPacket(OPCODE_EXCHANGERET_S)
end

function CallOfLufei.buildItems(container)
	local config = ConfigManager.getExchanges()[1]

	local from = config["from"]
	fromInfo = ResManager:getInstance():getResInfoByTypeAndId(from.type, from.id, from.count)
	userFromInfo = UserDataManager.getUserDataByTypeAndItemId(from.type, from.id) or {}

	local addition = config["add"][1]
	additionInfo = ResManager:getInstance():getResInfoByTypeAndId(addition.type, addition.id, addition.count)
	userAdditionInfo = UserDataManager.getUserDataByTypeAndItemId(addition.type, addition.id) or {}

	local name2Str = {
		--mRightText = 
		mLeftNum1 = userFromInfo.count or 0,
		mLeftNum2 = from.count,
		mRightNum1 = userAdditionInfo.count or 0,
		mRightNum2 = addition.count
	}
	common:setStringForLabel(container, name2Str)

	container:getVarSprite("mLeftPic"):setTexture(fromInfo.icon)
	container:getVarSprite("mRightPic"):setTexture(additionInfo.icon)
	container:getVarSprite("mRightPic"):setScale(0.5)

	status.isMainEnough = name2Str["mLeftNum1"] >= name2Str["mLeftNum2"]
	status.isAdditionEnough = name2Str["mRightNum1"] >= name2Str["mRightNum2"]

	container:getVarMenuItem("mSummon"):setEnabled(status.isMainEnough and status.isAdditionEnough)
end

function CallOfLufei.onCall(container)
	if status.isMainEnough == false then
		MessageBoxPage:Msg_Box_Lan("@lackOfSoulOfLufei")
	elseif status.isAdditionEnough == false then
		MessageBoxPage:Msg_Box_Lan("@lackOfItem")
	else
		CallOfLufei.sendCallPacket(container)
		container:getVarMenuItem("mSummon"):setEnabled(false)
	end
end

function CallOfLufei.sendCallPacket(container)
	local msg = Exchange_pb.OPExchange()
	msg.id = 1
	local pb_data = msg:SerializeToString()
	container:sendPakcet(OPCODE_EXCHANGE_C, pb_data, #pb_data, true)
end

function CallOfLufei.onReceivePacket(container)
    if container:getRecPacketOpcode() == OPCODE_EXCHANGERET_S then
		local msg = Exchange_pb.OPExchangeRet()
		local msgBuff = container:getRecPacketBuffer()
		msg:ParseFromString(msgBuff)
		
		if msg.discipleInfo ~= nil then
			for _, info in ipairs(msg.discipleInfo) do
				DropManager.gotDisciple(info)
			end
		end
		if msg.soulInfo ~= nil then
			for _, info in ipairs(msg.soulInfo) do
				DropManager.gotSoul(info)
			end
		end
		if msg.toolInfo ~= nil then
			for _, info in ipairs(msg.toolInfo) do
				DropManager.gotTool(info)
			end
		end
		if msg.equipInfo ~= nil then
			for _, info in ipairs(msg.equipInfo) do
				DropManager.gotEquipment(info)
			end
		end
		if msg.skillInfo ~= nil then
			for _, info in ipairs(msg.skillInfo) do
				DropManager.gotSkill(info)
			end
		end

		CallOfLufei.prepareRewardView(msg.reward)
	end

	container:runAnimation("Ani")
	status.isRunningAni = true
end

function CallOfLufei.onExit(container)
	container:removePacket(OPCODE_EXCHANGERET_S)
end

function CallOfLufei.onAnimationDone(container)
	if status.isRunningAni then
		status.isRunningAni = false
		container:runAnimation("Default Timeline")
		MainFrame:getInstance():pushPage("GoodsShowListPage")
		CallOfLufei.refreshContent(container)
	end
end

function CallOfLufei.refreshContent(container)
	CallOfLufei.buildItems(container)
end

function CallOfLufei.prepareRewardView(rewardInfo)
	GoodsViewPage.mTitle = "@CallOfLufeiRewardTitle"
	GoodsViewPage.mMsgContent = "@CallOfLufeiRewardMsgContent"
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
