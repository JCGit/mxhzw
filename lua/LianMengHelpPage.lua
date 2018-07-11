LianMengHelpType=1
local LianMengHelpContent = {}
function LianMengHelpContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        LianMengHelpContent.onRefreshItemView(container)
    end
end

function LianMengHelpContent.onRefreshItemView(container)
    local itemData = LianmengHelpInfo[container:getItemDate().mID]
    
    container:getVarLabelBMFont("mlmbiandong"):setString(itemData.name)
    
    local s =  itemData.describe
    local descirbe = ""
	s, descirbe = GameMaths:stringAutoReturn(s, descirbe, 18, 0) 
    container:getVarLabelBMFont("mlmhelptext"):setString(descirbe)
    
    local face = container:getVarSprite("LMHPic")
    if  itemData.iconpath ~= "none" then
        face:setVisible(true);
		face:setTexture(itemData.iconpath)
    else
        face:setVisible(false);
    end
end

local LianMengHelpPage = {}

function luaCreat_LianMengHelpPage(container)
    CCLuaLog("OnCreat_LianMengHelpPage")
    container:registerFunctionHandler(LianMengHelpPage.onFunction)
end

function LianMengHelpPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengHelpPage.onEnter(container)
    elseif eventName == "luaExit" then
        LianMengHelpPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengHelpPage.onLoad(container)
	elseif eventName == "onRevert" then
		LianMengHelpPage.onConfirm(container)
    end
end

function LianMengHelpPage.onConfirm(container)
    MainFrame:getInstance():showPage("LianMengPage")
end

function LianMengHelpPage.onEnter(container)
    container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
	container.m_pScrollViewFacade:init(6,6)
    LianMengHelpPage.rebuildAllItem(container)
end

function LianMengHelpPage.onExit(container)	
    LianMengHelpPage.clearAllItem(container)
	container.m_pScrollViewFacade:delete()
	container.m_pScrollViewFacade = nil
end

function LianMengHelpPage.onLoad(container)
	container:loadCcbiFile("LianMengHelp.ccbi")
	container.mScrollView = container:getVarScrollView("mLMTContent")
	container.mScrollViewRootNode = container.mScrollView:getContainer()
end

function LianMengHelpPage.rebuildAllItem(container)
    LianMengHelpPage.clearAllItem(container);
	LianMengHelpPage.buildItem(container);
end

function LianMengHelpPage.buildItem(container)
    local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
	local iCount = 0;
	local fOneItemHeight = 0;
	local fOneItemWidth = 0;

	for i=#LianmengHelpInfo, 1, -1 do
        local itemData = LianmengHelpInfo[i]
        if tonumber(itemData.showType)==LianMengHelpType then
            local pItemData = CCReViSvItemData:new()
            pItemData.mID = i
            pItemData.m_iIdx = i
            pItemData.m_ptPosition = ccp(0, fOneItemHeight*iCount)

            if iCount < iMaxNode then
                local pItem = ScriptContentBase:create("LianMengHelpContent.ccbi")
                pItem.id = iCount
                pItem:registerFunctionHandler(LianMengHelpContent.onFunction)
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
	end
	local size = CCSizeMake(fOneItemWidth, fOneItemHeight*iCount)
	container.mScrollView:setContentSize(size);
	container.mScrollView:setContentOffset(ccp(0, container.mScrollView:getViewSize().height - container.mScrollView:getContentSize().height*container.mScrollView:getScaleY()));
	container.m_pScrollViewFacade:setDynamicItemsStartPosition(iCount-1);
end

function LianMengHelpPage.clearAllItem(container)
    container.m_pScrollViewFacade:clearAllItems()
    container.mScrollViewRootNode:removeAllChildren()
end
