require "CommonPage"

local option = {
	handlerMap = {
		onClose = "onClose"
	}
}
local CommonHelpPage = CommonPage.new("CommonHelpPage", option)

local HelpTitle = "@Explantation"
local HelpInfo = nil

CommonHelpPageVar = {
	set = function(helpInfo, title)
			HelpInfo = helpInfo
			HelpTitle = Language:getInstance():getString(title or "@Explanation")
		end
}

local HelpContent = {}

function HelpContent:new(mID)
	local pItem = ScriptContentBase:create("MidAutumnPopUpContent.ccbi")
	local helpInfo = HelpInfo[mID]

	local lbTitle = pItem:getVarLabelBMFont("mMAPUCTitle")
	local lbContent = pItem:getVarLabelBMFont("mMatterLabel")
	local s, helpContent = GameMaths:stringAutoReturn(helpInfo["content"], helpContent, 19, 0)
	lbTitle:setString(tostring(helpInfo["title"]))
	lbContent:setString(tostring(helpContent))

	local middleNode = pItem:getVarNode("mMiddleNode")
	local msgHeight = lbContent:getContentSize().height
	local midNodeHeight = middleNode:getContentSize().height
	if msgHeight + 50 > midNodeHeight * middleNode:getScaleY() then --50 : height for space
		local scaleY = (msgHeight + 50) / midNodeHeight
		middleNode:setScaleY(scaleY)
		lbContent:setPositionY(middleNode:getPositionY() + midNodeHeight * scaleY * lbContent:getAnchorPoint().y)

		local topNode = pItem:getVarNode("mTopNode")
		local endNode = pItem:getVarNode("mEndNode")
		topNode:setPositionY(middleNode:getPositionY() + midNodeHeight * scaleY - 15)
		local lbTitle = pItem:getVarLabelBMFont("mMAPUCTitle")
		lbTitle:setPositionY(topNode:getPositionY() + topNode:getContentSize().height * 0.5)

		local size = CCSizeMake(pItem:getContentSize().width, topNode:getContentSize().height + midNodeHeight * middleNode:getScaleY() + endNode:getContentSize().height - 15)
		pItem:setContentSize(size)
	end
	return pItem
end

function CommonHelpPage.onLoad(container)
	container:loadCcbiFile("MidAutumnPopUp.ccbi")
	container.mScrollView = container:getVarScrollView("mMAPUSv")
	container.mScrollViewRootNode = container.mScrollView:getContainer()
end

function CommonHelpPage.onEnter(container)
	CommonHelpPage.rebuildAllItem(container)
	common:setStringForLabel(container, {mExplanation = HelpTitle})
end

function CommonHelpPage.onClose(container)
	MainFrame:getInstance():popPage("CommonHelpPage")
end

function CommonHelpPage.onExit(container)
	CommonHelpPage.clearAllItem(container)
end

function CommonHelpPage.rebuildAllItem(container)
	CommonHelpPage.clearAllItem(container);
	CommonHelpPage.buildItem(container);
end

function CommonHelpPage.buildItem(container)
	local fOneItemWidth = 0;
	local positionY = 0;

	for i = #HelpInfo, 1, -1 do
		local pItem = HelpContent:new(i)
		container.mScrollViewRootNode:addChild(pItem)
		pItem:setPosition(ccp(0, positionY))
		if fOneItemWidth < pItem:getContentSize().width then
			fOneItemWidth = pItem:getContentSize().width
		end
		positionY = positionY + pItem:getContentSize().height
	end
	local size = CCSizeMake(fOneItemWidth, positionY)
	container.mScrollView:setContentSize(size);
	container.mScrollView:setContentOffset(ccp(0, container.mScrollView:getViewSize().height - container.mScrollView:getContentSize().height * container.mScrollView:getScaleY()));
end

function CommonHelpPage.clearAllItem(container)
	container.mScrollViewRootNode:removeAllChildren()
end
