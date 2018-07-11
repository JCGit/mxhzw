GoodsViewPage={}
GoodsViewPage.mTitle="@PackPreviewTitleView"
GoodsViewPage.mMsgContent="@PackPreviewMsgView"
GoodsViewPage.mViewGoodsListInfo={}
local GoodListContent = {}
function GoodListContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        GoodListContent.onRefreshItemView(container)
    end
end

function GoodListContent.onRefreshItemView(container)
    local itemData = GoodsViewPage.mViewGoodsListInfo[container:getItemDate().mID]
    local quality=itemData.quality
    local _type=itemData.type
    local scale = container:getVarSprite("mPropPic"):getScale()

    if _type==DISCIPLE_TYPE or _type==SOUL_TYPE or _type == 32001 then
        container:getVarSprite("mPropPic"):setScale(1.0)
    elseif _type==USER_PROPERTY_TYPE or _type==TOOLS_TYPE then
        quality=4
    end
    if quality>4 or quality<1 then
        quality=4
    end
    container:getVarMenuItemImage("mFrameBack"):setNormalImage(getFrameNormalSpirte(quality))
    container:getVarMenuItemImage("mFrameBack"):setSelectedImage(getFrameSelectedSpirte(quality))
    container:getVarLabelBMFont("mNumber"):setString(tostring(itemData.count))
    container:getVarLabelBMFont("mPropName"):setString(tostring(itemData.name))
    container:getVarSprite("mPropPic"):setTexture(itemData.icon)
end

local GoodsShowListPage = {}

function luaCreat_GoodsShowListPage(container)
    CCLuaLog("OnCreat_GoodsShowListPage")
    container:registerFunctionHandler(GoodsShowListPage.onFunction)
end

function GoodsShowListPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        GoodsShowListPage.onEnter(container)
    elseif eventName == "luaExit" then
        GoodsShowListPage.onExit(container)
    elseif eventName == "luaLoad" then
        GoodsShowListPage.onLoad(container)
	elseif eventName == "onConfirm" then
		GoodsShowListPage.onConfirm(container)
    elseif eventName == "onClose" then
        GoodsShowListPage.closePage(container)
    end
end

function GoodsShowListPage.closePage(container)
    MainFrame:getInstance():popPage("GoodsShowListPage")
end

function GoodsShowListPage.onConfirm(container)
    MainFrame:getInstance():popPage("GoodsShowListPage")
end

function GoodsShowListPage.onEnter(container)
    container:getVarLabelBMFont("mPackPageMsg"):setString(tostring(Language:getInstance():getString(GoodsViewPage.mMsgContent)))
    container:getVarLabelBMFont("mTitle"):setString(tostring(Language:getInstance():getString(GoodsViewPage.mTitle)))
    container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
	container.m_pScrollViewFacade:init(6,6)
    GoodsShowListPage.rebuildAllItem(container)
end

function GoodsShowListPage.onExit(container)	
    GoodsShowListPage.clearAllItem(container)
	container.m_pScrollViewFacade:delete()
	container.m_pScrollViewFacade = nil
end

function GoodsShowListPage.onLoad(container)
	container:loadCcbiFile("PackPreivew.ccbi")
	container.mScrollView = container:getVarScrollView("mContent")
	container.mScrollViewRootNode = container.mScrollView:getContainer()
end

function GoodsShowListPage.rebuildAllItem(container)
    GoodsShowListPage.clearAllItem(container);
	GoodsShowListPage.buildItem(container);
end

function GoodsShowListPage.buildItem(container)
    local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
	local iCount = 0;
	local fOneItemHeight = 0;
	local fOneItemWidth = 0;

	for i=#GoodsViewPage.mViewGoodsListInfo, 1, -1 do
		local pItemData = CCReViSvItemData:new()
		pItemData.mID = i
		pItemData.m_iIdx = i
		pItemData.m_ptPosition = ccp(0, fOneItemHeight*iCount)

		if iCount < iMaxNode then
			local pItem = ScriptContentBase:create("PackPreviewContent.ccbi")
			pItem.id = iCount
			pItem:registerFunctionHandler(GoodListContent.onFunction)
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

function GoodsShowListPage.clearAllItem(container)
    container.m_pScrollViewFacade:clearAllItems()
    container.mScrollViewRootNode:removeAllChildren()
end
