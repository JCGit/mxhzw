
local LianMengHelpContent = {}
function LianMengHelpContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        LianMengHelpContent.onRefreshItemView(container)
    end
end

function LianMengHelpContent.onRefreshItemView(container)
    local itemData = LianmengHelpInfo[container:getItemDate().mID]
    
    container:getVarLabelBMFont("mName"):setString(itemData.name)
    
    local s =  itemData.describe
    local descirbe = ""
	s, descirbe = GameMaths:stringAutoReturn(s, descirbe, 18, 0) 
    container:getVarLabelBMFont("mDes"):setString(descirbe)
    
    local face = container:getVarSprite("mIcon")
    if  itemData.iconPic ~= "none" then
        face:setVisible(true);
		face:setTexture(itemData.iconpath)
    else
        face:setVisible(false);
    end
end

local LianMengBattleMSGPage = {}

function luaCreat_LianMengBattleMSGPage(container)
    CCLuaLog("OnCreat_LianMengBattleMSGPage")
    container:registerFunctionHandler(LianMengBattleMSGPage.onFunction)
end

function LianMengBattleMSGPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengBattleMSGPage.onEnter(container)
    elseif eventName == "luaExecute" then
    elseif eventName == "onLMTotem" then
    	MainFrame:getInstance():showPage("LianMengBattlePage")
    elseif eventName == "onBack" then
        MainFrame:getInstance():showPage("LianMengPage")
    elseif eventName == "luaExit" then
        LianMengBattleMSGPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengBattleMSGPage.onLoad(container)
	elseif eventName == "onConfirm" then
		LianMengBattleMSGPage.onConfirm(container)
    end
end

function LianMengBattleMSGPage.onConfirm(container)
    MainFrame:getInstance():showPage("LianMengPage")
end

function LianMengBattleMSGPage.onEnter(container)
--    container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
--	container.m_pScrollViewFacade:init(6,6)
    LianMengBattleMSGPage.rebuildAllItem(container)
    if container:getVarLabelBMFont("mLMTotem1") ~= nil then 
        container:getVarLabelBMFont("mLMTotem1"):setString(tostring(Language:getInstance():getString("@LMBattle")))
    end
    
    if container:getVarLabelBMFont("mLMTotem2") ~= nil then
        container:getVarLabelBMFont("mLMTotem2"):setString(tostring(Language:getInstance():getString("@onLMBattleMSG")))
    end
			
end

function LianMengBattleMSGPage.onExit(container)	
--  LianMengBattleMSGPage.clearAllItem(container)
--	container.m_pScrollViewFacade:delete()
--	container.m_pScrollViewFacade = nil
end

function LianMengBattleMSGPage.onLoad(container)
	container:loadCcbiFile("LianMengBattleMSG.ccbi")
    container.mScrollView = container:getVarScrollView("mLMBattleMSGContent")
    container.mScrollViewRootNode = container.mScrollView:getContainer()
    container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
    container.m_pScrollViewFacade:init(6,6)
    
end

function LianMengBattleMSGPage.rebuildAllItem(container)
    LianMengBattleMSGPage.clearAllItem(container);
	LianMengBattleMSGPage.buildItem(container);
end

function LianMengBattleMSGPage.buildItem(container)
--    local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum()
    --[[
	local pItemData = CCReViSvItemData:new()
    local node = CCLabelBMFont:create()
    node:setString("aaa")
    container.m_pScrollViewFacade:addItem(pItemData, node.__CCReViSvItemNodeFacade__)
]]
--	container.mScrollView:setContentSize(size);
--	container.mScrollView:setContentOffset(ccp(0, container.mScrollView:getViewSize().height - container.mScrollView:getContentSize().height*container.mScrollView:getScaleY()));
--	container.m_pScrollViewFacade:setDynamicItemsStartPosition(iCount-1);

    local str = ""
    for k, v in ipairs(LianmengBattleInfo.battleMSG) do
        local holdName = LianmengBattleInfo.battleMSG[k].holdName
        local firstBidName = LianmengBattleInfo.battleMSG[k].firstBidName
        local secondBidName = LianmengBattleInfo.battleMSG[k].secondBidName
     
        str = str .. "\n" .. holdName .. " " .. firstBidName .. " " .. Language:getInstance():getString("@LMBattleMSGCode" .. LianmengBattleInfo.battleMSG[k].status) .. " " ..secondBidName
    
    end

    container:getVarLabelTTF("mLMBattleMSG"):setString(str)
    
end

function LianMengBattleMSGPage.clearAllItem(container)
--    container.m_pScrollViewFacade:clearAllItems()
--    container.mScrollViewRootNode:removeAllChildren()
end
