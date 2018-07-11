require "CommonPage"

local option = {
	handlerMap = {
		onClose = "onClose"
	}
}
local CallOfLufeiHelpPage = CommonPage.new("CallOfLufeiHelpPage", option)
local HelpInfo = ConfigManager.getCallOfLufeiHelpInfo()

function CallOfLufeiHelpPage.onLoad(container)
	container:loadCcbiFile("WishingTreeHelp.ccbi")
	container.mScrollView = container:getVarScrollView("mWTSV")
	container.mScrollViewRootNode = container.mScrollView:getContainer()
end

function CallOfLufeiHelpPage.onEnter(container)
	container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
	container.m_pScrollViewFacade:init(6, 6)
	CallOfLufeiHelpPage.rebuildAllItem(container)
	common:setStringForLabel(container, {
		mWTHelpTitle = Language:getInstance():getString("@CallOfLufeiHelpTitle")
	})
end

function CallOfLufeiHelpPage.onClose(container)
	MainFrame:getInstance():popPage("CallOfLufeiHelpPage")
end

function CallOfLufeiHelpPage.onExit(container)
	CallOfLufeiHelpPage.clearAllItem(container)
	container.m_pScrollViewFacade:delete()
	container.m_pScrollViewFacade = nil
end

function CallOfLufeiHelpPage.rebuildAllItem(container)
	CallOfLufeiHelpPage.clearAllItem(container);
	CallOfLufeiHelpPage.buildItem(container);
end

function CallOfLufeiHelpPage.buildItem(container)
	local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
	local iCount = 0;
	local fOneItemHeight = 0;
	local fOneItemWidth = 0;

	for i = #HelpInfo, 1, -1 do
		local itemData = HelpInfo[i]
			local pItemData = CCReViSvItemData:new()
			pItemData.mID = i
			pItemData.m_iIdx = i
			pItemData.m_ptPosition = ccp(0, fOneItemHeight*iCount)

			if iCount < iMaxNode then
				local pItem = ScriptContentBase:create("WishingTreeHelpContent.ccbi")
				pItem.id = iCount
				pItem:registerFunctionHandler(CallOfLufeiHelpContent.onFunction)
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
end

function CallOfLufeiHelpPage.clearAllItem(container)
	container.m_pScrollViewFacade:clearAllItems()
	container.mScrollViewRootNode:removeAllChildren()
end

CallOfLufeiHelpContent = {}

function CallOfLufeiHelpContent.onFunction(eventName,container)
	if eventName == "luaRefreshItemView" then
		CallOfLufeiHelpContent.onRefreshItemView(container)
	end
end

function CallOfLufeiHelpContent.onRefreshItemView(container)
	local helpInfo = HelpInfo[container:getItemDate().mID]
	local s, helpContent = GameMaths:stringAutoReturn(helpInfo["content"], helpContent, 18, 0)
	local name2str = {
		mTarotHelpTitle = helpInfo["title"],
		mTDHelpText = helpContent
	}
	common:setStringForLabel(container, name2str)
	container:getVarNode("mTarotHelpNode"):setVisible(false)
end
