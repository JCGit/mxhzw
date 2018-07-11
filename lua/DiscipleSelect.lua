DiscipleList = {
	list = nil,
	selected = nil,
	sortFunc = nil,
	sortDesc = true
}

--attention of "Keng": while using table.sort, sortFunc must be stable sorting
function DiscipleList.setList(list, filter, sortFunc, descending)
	DiscipleList.list = {}
	for k, v in pairs(list) do
		if filter == nil or filter(v) == true then
			--userDisciple info in list may not be async
			local userDisciple = ServerDateManager:getInstance():getUserDiscipleInfoByItemID(v.itemid)
			table.insert(DiscipleList.list, userDisciple)
		end
	end
	DiscipleList.sortFunc = sortFunc ~= nil and sortFunc or DiscipleList.sortByLevel
	if descending ~= nil then
		DiscipleList.sortDesc = not not descending
	else
		DiscipleList.sortDesc = true
	end

end

function DiscipleList.sortByLevel(discipleA, discipleB)
	local lvA = discipleA.level
	local lvB = discipleB.level
	if DiscipleList.sortDesc then
		if lvA ~= lvB then
			return lvA > lvB
		else
			return discipleA.id > discipleB.id
		end
	else 
		if lvA ~= lvB then
			return lvA < lvB
		else
			return discipleA.id < discipleB.id
		end
	end
end

function DiscipleList.setSelected(discipleId)
	DiscipleList.selected = discipleId
end

DiscipleSelectStatus = {}

function DiscipleSelectStatus.markPrevPage(prevPage, title)
	DiscipleSelectStatus.prevPage = prevPage
	DiscipleSelectStatus.title = title
end

local DiscipleSelect = {}

function luaCreat_DiscipleSelect(container)
	CCLuaLog("OnCreate__DiscipleSelect")
	container:registerFunctionHandler(DiscipleSelect.onFunction)
end

DiscipleSelect.handlerMap = {
	luaInit = "onInit",
	luaLoad = "onLoad",
	luaCreate = "onCreate",
	luaExecute = "onExecute",
	luaUnLoad = "onUnLoad",
	luaEnter = "onEnter",
	luaExit = "onExit",
	luaOnAnimationDone = "onAnimationDone",
	onConfirm = "onConfirm",
	onOrderByDesc = "orderByDesc",
	onFunciton = "gotoMarket"
}

function DiscipleSelect.onFunction(eventName, container)
	if DiscipleSelect.handlerMap[eventName] ~= nil then
		local funcName = DiscipleSelect.handlerMap[eventName]
		DiscipleSelect[funcName](container)
	else
		CCLuaLog("unExpected event Name : " .. eventName)
	end
end

function DiscipleSelect.onInit(container)
end

function DiscipleSelect.onLoad(container)
	container:loadCcbiFile("MemberReplace.ccbi")

	container.mScrollView = container:getVarScrollView("mChangeContent")
	container.mScrollViewRootNode = container.mScrollView:getContainer()
end

function DiscipleSelect.onCreate(container)
end

function DiscipleSelect.onExecute(container)
end

function DiscipleSelect.onEnter(container)
	container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
	container.m_pScrollViewFacade:init(6,6)
	DiscipleSelect.rebuildAllItems(container)
end

function DiscipleSelect.onExit(container)
	DiscipleSelect.clearItems(container)
	container.m_pScrollViewFacade:delete()
	container.m_pScrollViewFacade = nil
end

function DiscipleSelect.onAnimationDone(container)
end

function DiscipleSelect.onUnLoad(container)
end

function DiscipleSelect.rebuildAllItems(container)
	DiscipleSelect.clearItems(container)
	DiscipleSelect.buildItems(container)
end

function DiscipleSelect.buildItems(container)
	if DiscipleSelectStatus.title ~= nil then
		local titleStr = tostring(Language:getInstance():getString(DiscipleSelectStatus.title))
		container:getVarLabelBMFont("mReplaceMem"):setString(titleStr)
	end

	if DiscipleList.list == nil or #DiscipleList.list == 0 then
		local longBtn = ScriptContentBase:create("LongButton.ccbi")
		local view = container.mScrollView
		if longBtn ~= nil then
			longBtn:registerFunctionHandler(DiscipleSelect.onFunction)
			longBtn:getVarLabelBMFont("mButtonLabel"):setString(tostring(Language:getInstance():getString("@GoMarketGetDisciple")))
			longBtn:setPosition(ccp(0, 0))
			container.mScrollViewRootNode:addChild(longBtn)
			view:setContentSize(CCSizeMake(longBtn:getContentSize().width, longBtn:getContentSize().height))
			view:setContentOffset(ccp(0, view:getViewSize().height - view:getContentSize().height * view:getScaleY()))
		end

		local tips = tostring(Language:getInstance():getString("@noDiscipleToWish"))

		local labelTip_1 = CCLabelBMFont:create("T", "Lang/heiOutline24.fnt", 10)
		labelTip_1:setString(tips)
		labelTip_1:setColor(common:getColorFromSetting("Color_Black"))
		labelTip_1:setScale(1)
		labelTip_1:setPosition(ccp(view:getViewSize().width / 2 + 2, -view:getViewSize().height / 2 - 2))
		container.mScrollViewRootNode:addChild(labelTip_1)

		local labelTip_2 = CCLabelBMFont:create("T", "Lang/heiOutline24.fnt", 10)
		labelTip_2:setString(tips)
		labelTip_2:setColor(common:getColorFromSetting("Color_Gray"))
		labelTip_2:setScale(1)
		labelTip_2:setPosition(ccp(view:getViewSize().width / 2, -view:getViewSize().height / 2))
		container.mScrollViewRootNode:addChild(labelTip_2)
		return
	end

	local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
	local iCount = 0;
	local fOneItemHeight = 0;
	local fOneItemWidth = 0;

	local orderStr = DiscipleList.sortDesc and "@OrderByAsce" or "@OrderByDesc"
	container:getVarLabelBMFont("mFuncLable"):setString(tostring(Language:getInstance():getString(orderStr)))
	table.sort(DiscipleList.list, DiscipleList.sortFunc)
	for i = #DiscipleList.list, 1, -1 do
		local pItemData = CCReViSvItemData:new()
		pItemData.mID = i
		pItemData.m_iIdx = i
		pItemData.m_ptPosition = ccp(0, fOneItemHeight * iCount)

		if iCount < iMaxNode then
			local pItem = ScriptContentBase:create("MemberReplaceContent.ccbi")
			pItem.id = iCount
			pItem:registerFunctionHandler(DiscipleItem.onFunction)
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
		iCount = iCount + 1
	end
	local size = CCSizeMake(fOneItemWidth, fOneItemHeight * iCount)
	container.mScrollView:setContentSize(size);
	container.mScrollView:setContentOffset(ccp(0, container.mScrollView:getViewSize().height - container.mScrollView:getContentSize().height*container.mScrollView:getScaleY()));
	container.m_pScrollViewFacade:setDynamicItemsStartPosition(iCount-1);
	container.mScrollView:forceRecaculateChildren() --scrollview may be unscrollable if no this line
end

function DiscipleSelect.clearItems(container)
	container.m_pScrollViewFacade:clearAllItems()
	container.mScrollViewRootNode:removeAllChildren()
end

function DiscipleSelect.onConfirm(container)
	if DiscipleItem.selectedItem ~= nil then
		SelectedDiscipleInfo = DiscipleList.list[DiscipleItem.selectedItem:getItemDate().mID]
		DiscipleList.selected = SelectedDiscipleInfo.itemid
	end

	local gameMsg = MsgMainFrameChangePage:new()
	local prevPage = DiscipleSelectStatus.prevPage
	gameMsg.pageName = prevPage ~= nil and prevPage or "AdventurePage"
	MessageManager:getInstance():sendMessageForScript(gameMsg)
end

function DiscipleSelect.orderByDesc(container)
	DiscipleList.sortDesc = not DiscipleList.sortDesc
	DiscipleItem.selectedItem = nil
	DiscipleSelect.rebuildAllItems(container)
end

function DiscipleSelect.gotoMarket(container)
	local gameMsg = MsgMainFrameChangePage:new()
	gameMsg.pageName = "MarketPage"
	MessageManager:getInstance():sendMessageForScript(gameMsg)
end

ChangeContent = {
}

ChangeContent.handlerMap = {
	luaRefreshItemView = "refreshItemView"
}

function ChangeContent.onFunction(eventName, container)
	if ChangeContent.handlerMap[eventName] ~= nil then
		local funcName = ChangeContent.handlerMap[eventName]
		ChangeContent[funcName](container)
	else
		CCLuaLog("unExpected event Name : " .. eventName)
	end
end

function ChangeContent.refreshItemView(container)
end

DiscipleItem = {
	selectedItem = nil
}

DiscipleItem.handlerMap = {
	onConfirm = "onConfirm",
	luaRefreshItemView = "refreshItemView",
	luaOnAnimationDone = "onAnimationDone",
	onSelected = "onSelected"
}

function DiscipleItem.onFunction(eventName, container)
	if DiscipleItem.handlerMap[eventName] ~= nil then
		local funcName = DiscipleItem.handlerMap[eventName]
		DiscipleItem[funcName](container)
	else
		CCLuaLog("unExpected event Name : " .. eventName)
	end
end

function DiscipleItem.onConfirm(container)
end

function DiscipleItem.refreshItemView(container)
	local DiscipleInfo = DiscipleList.list[container:getItemDate().mID]
	local disciple = Disciple:new_local(DiscipleInfo.itemid, true, false)

	container:getVarSprite("mHeadPic"):setTexture(disciple:iconPic())

	local mQualityFrame = container:getVarMenuItemImage("mQualityFrame")
	local _quality = disciple:quality()
	mQualityFrame:setNormalImage(disciple:getFrameNormalSpirte())
	mQualityFrame:setSelectedImage(disciple:getFrameSelectedSpirte())

	container:getVarSprite("mMemQuality"):setTexture(disciple:getQualityImageFile(false))

	local labelName2Str = {
		mName = disciple:name(),
		mMemLevel = DiscipleInfo.level,
		mMemValue = disciple:getDiscipleValue()
	}
	common:setStringForLabel(container, labelName2Str)

	DiscipleItem.setSelected(container, DiscipleInfo.itemid == DiscipleList.selected)
end

function DiscipleItem.onAnimationDone(container)
end

function DiscipleItem.onSelected(container)
	if DiscipleItem.selectedItem ~= nil then
		DiscipleItem.setSelected(DiscipleItem.selectedItem, false)
	end

	if DiscipleItem.selectedItem ~= container then
		DiscipleItem.setSelected(container, true)
	else
		DiscipleItem.selectedItem = nil
	end
end

function DiscipleItem.setSelected(container, selected)
	local mSelect = container:getVarMenuItemImage("mSelect")
	if not selected then
		mSelect:setNormalImage(getContentUnselectedSpirte("Normal"))
		mSelect:setSelectedImage(getContentUnselectedSpirte("Normal"))
	else 
		mSelect:setNormalImage(getContentSelectedSpirte("Normal"))
		mSelect:setSelectedImage(getContentSelectedSpirte("Normal"))
		DiscipleItem.selectedItem = container
		SelectedDiscipleInfo = DiscipleList.list[DiscipleItem.selectedItem:getItemDate().mID]
		DiscipleList.selected = SelectedDiscipleInfo.itemid
	end
end
