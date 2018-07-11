local ForgeEquipToolsContent = {}
function ForgeEquipToolsContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        ForgeEquipToolsContent.onRefreshItemView(container)
    elseif eventName == "onDZAdd" then
        ForgeEquipToolsContent.onSelPic(container)
    end
end

function ForgeEquipToolsContent.onSelPic(container)
    if ForgeEquipToolsContent.mCurSellectedContent ~= nil then
        ForgeEquipToolsContent.mCurSellectedContent.mSelect:unselected()
    end

    if ForgeEquipToolsContent.mCurSellectedContent ~= container then
        ForgeEquipToolsContent.mCurSellectedContent = container
        ForgeEquipToolsContent.mCurSellectedContent.mSelect:selected()
    else
        ForgeEquipToolsContent.mCurSellectedContent = nil
    end
end

function ForgeEquipToolsContent.onRefreshItemView(container)
    container.mSelect = container:getVarMenuItemImage("mDZAdd")
    container.mSelect:unselected()
    local itemData = TableManagerForLua.ToolsList[container:getItemDate().mID]

    container:getVarLabelBMFont("mEQName"):setString(itemData.name)
    container:getVarSprite("mHead1"):setTexture(itemData.iconPic)
    local _toolsInfo=ServerDateManager:getInstance():getUserToolInfoByItemId(itemData.itemID)
    local _count=0
    if _toolsInfo~=nil then
        _count=_toolsInfo.count
    end
    if _count > 0 then
        container.mSelect:setEnabled(true)
        container.mSelect:unselected()
    else
        container.mSelect:setEnabled(false)
    end
    container:getVarLabelBMFont("mDZTuNum"):setString(_count)
    local s =  itemData.describe
    local descirbe = ""
    descirbe = GameMaths:stringAutoReturn(s, descirbe, 18, 0)
    container:getVarLabelBMFont("mDZAText"):setString(descirbe)

end

local ForgeEquipToolsPicPage = {}

function luaCreat_ForgeEquipToolsPicPage(container)
    CCLuaLog("OnCreat_ForgeEquipToolsPicPage")
    container:registerFunctionHandler(ForgeEquipToolsPicPage.onFunction)
end

function ForgeEquipToolsPicPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        ForgeEquipToolsPicPage.onEnter(container)
    elseif eventName == "luaExit" then
        ForgeEquipToolsPicPage.onExit(container)
    elseif eventName == "luaLoad" then
        ForgeEquipToolsPicPage.onLoad(container)
    elseif eventName == "onSure" then
        ForgeEquipToolsPicPage.onConfirm(container)
    end
end

function ForgeEquipToolsPicPage.onConfirm(container)
    if ForgeEquipToolsContent.mCurSellectedContent == nil then
        MessageBoxPage:Msg_Box_Lan("@ForgeEquipNoSel")
    else
        local contentData = TableManagerForLua.ToolsList[ForgeEquipToolsContent.mCurSellectedContent:getItemDate().mID]
        local _toolsInfo=ServerDateManager:getInstance():getUserToolInfoByItemId(contentData.itemID)
        local _count=0
        if _toolsInfo~=nil then
            _count=_toolsInfo.count
        end
        if _count <= 0 then
            MessageBoxPage:Msg_Box_Lan("@ForgeEquipNotEnough")
        else
            ForgeEquipPiecePageCurrSelToolId=contentData.itemID
        end
    end
    local msg = MsgMainFrameChangePage:new()
    msg.pageName = "AdventurePage"
    MessageManager:getInstance():sendMessageForScript(msg)
end

function ForgeEquipToolsPicPage.onEnter(container)
    ForgeEquipToolsContent.mCurSellectedContent = nil
    container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
    container.m_pScrollViewFacade:init(6,6)
    ForgeEquipToolsPicPage.rebuildAllItem(container)
end

function ForgeEquipToolsPicPage.onExit(container)
    ForgeEquipToolsPicPage.clearAllItem(container)
    container.m_pScrollViewFacade:delete()
    container.m_pScrollViewFacade = nil
end

function ForgeEquipToolsPicPage.onLoad(container)
    container:loadCcbiFile("duanzaoAdd.ccbi")
    container.mScrollView = container:getVarScrollView("mDZtuview")
    container.mScrollViewRootNode = container.mScrollView:getContainer()
end

function ForgeEquipToolsPicPage.rebuildAllItem(container)
    ForgeEquipToolsPicPage.clearAllItem(container);
    ForgeEquipToolsPicPage.buildItem(container);
end

function ForgeEquipToolsPicPage.buildItem(container)
    local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
    local iCount = 0;
    local fOneItemHeight = 0;
    local fOneItemWidth = 0;
    local hasTools=false
    for i=#TableManagerForLua.ToolsList, 1, -1 do
        local itemData = TableManagerForLua.ToolsList[i]
        local itemIdHead=tonumber(string.sub(tostring(itemData.itemID),1,4))
        if (itemIdHead==5004 or itemIdHead==5005 or itemIdHead==5006) and tonumber(getToolsCount(itemData.itemID))>0  then
            hasTools=true
            local pItemData = CCReViSvItemData:new()
            pItemData.mID = i
            pItemData.m_iIdx = i
            pItemData.m_ptPosition = ccp(0, fOneItemHeight*iCount)

            if iCount < iMaxNode then
                local pItem = ScriptContentBase:create("duanzaoAddcontent.ccbi")
                pItem.id = iCount
                pItem:registerFunctionHandler(ForgeEquipToolsContent.onFunction)
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
    if not hasTools then
        container:getVarLabelBMFont("mDZtuText"):setVisible(true)
    else
        container:getVarLabelBMFont("mDZtuText"):setVisible(false)
    end
end

function ForgeEquipToolsPicPage.clearAllItem(container)
    container.m_pScrollViewFacade:clearAllItems()
    container.mScrollViewRootNode:removeAllChildren()
end
