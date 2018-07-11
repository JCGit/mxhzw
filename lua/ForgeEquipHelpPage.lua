ForgeEquipHelpInfo={}
local ForgeEquipHelpContent = {}
function ForgeEquipHelpContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        ForgeEquipHelpContent.onRefreshItemView(container)
    end
end

function ForgeEquipHelpContent.onRefreshItemView(container)
    local itemData = ForgeEquipHelpInfo[container:getItemDate().mID]
    container:getVarLabelBMFont("mDZHelpT1"):setString(itemData.name)
    local s =  itemData.describe
    local describe = ""
    describe = GameMaths:stringAutoReturn(s, describe, 18, 0)
    describe = string.gsub(describe,"#","\n")
    container:getVarLabelBMFont("mDZHelpT2"):setString(describe)

--    local face = container:getVarSprite("LMHPic")
--    if  itemData.iconpath ~= "none" then
--        face:setVisible(true);
--        face:setTexture(itemData.iconpath)
--    else
--        face:setVisible(false);
--    end
end

local ForgeEquipHelpPage = {}

function luaCreat_ForgeEquipHelpPage(container)
    CCLuaLog("OnCreat_ForgeEquipHelpPage")
    container:registerFunctionHandler(ForgeEquipHelpPage.onFunction)
end

function ForgeEquipHelpPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        ForgeEquipHelpPage.onEnter(container)
    elseif eventName == "luaExit" then
        ForgeEquipHelpPage.onExit(container)
    elseif eventName == "luaLoad" then
        ForgeEquipHelpPage.onLoad(container)
    elseif eventName == "onReturn" then
        ForgeEquipHelpPage.onConfirm(container)
    end
end

function ForgeEquipHelpPage.onConfirm(container)
    local msg = MsgMainFrameChangePage:new()
    msg.pageName = "AdventurePage"
    MessageManager:getInstance():sendMessageForScript(msg)
end

function ForgeEquipHelpPage.onEnter(container)
    container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
    container.m_pScrollViewFacade:init(6,6)
    ForgeEquipHelpPage.rebuildAllItem(container)
end

function ForgeEquipHelpPage.onExit(container)
    ForgeEquipHelpPage.clearAllItem(container)
    container.m_pScrollViewFacade:delete()
    container.m_pScrollViewFacade = nil
end

function ForgeEquipHelpPage.onLoad(container)
    container:loadCcbiFile("duanzaoHelp.ccbi")
    container.mScrollView = container:getVarScrollView("mDZtuview")
    container.mScrollViewRootNode = container.mScrollView:getContainer()
end

function ForgeEquipHelpPage.rebuildAllItem(container)
    ForgeEquipHelpPage.clearAllItem(container);
    ForgeEquipHelpPage.buildItem(container);
end

function ForgeEquipHelpPage.buildItem(container)
    local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
    local iCount = 0;
    local fOneItemHeight = 0;
    local fOneItemWidth = 0;

    for i=#ForgeEquipHelpInfo, 1, -1 do
        local itemData = ForgeEquipHelpInfo[i]
        local pItemData = CCReViSvItemData:new()
        pItemData.mID = i
        pItemData.m_iIdx = i
        pItemData.m_ptPosition = ccp(0, fOneItemHeight*iCount)

        if iCount < iMaxNode then
            local pItem = ScriptContentBase:create("duanzaoHelpcontent.ccbi")
            pItem.id = iCount
            pItem:registerFunctionHandler(ForgeEquipHelpContent.onFunction)
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

function ForgeEquipHelpPage.clearAllItem(container)
    container.m_pScrollViewFacade:clearAllItems()
    container.mScrollViewRootNode:removeAllChildren()
end
