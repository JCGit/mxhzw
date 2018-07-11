
require "LeagueStruct_pb"
require "LeagueStruct_ext_pb"

local LianMengRankingContent = {}
function LianMengRankingContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        LianMengRankingContent.onRefreshItemView(container)
    end
end

function LianMengRankingContent.onRefreshItemView(container)
    local contentData = LeaguaRankInfoList[container:getItemDate().mID]
    container:getVarSprite("mflagpic"):setTexture(LianMengBadges[contentData.medalID].filename)
    local rankingNum = container:getVarLabelBMFont("mRankingNum")
    local rankingpic = container:getVarSprite("mrankingpic")
    if contentData.leaguaRank == 1 then
        rankingNum:setVisible(false)
        rankingpic:setVisible(true)
        rankingpic:setTexture("mainScene/u_LianMengNum01.png")
    elseif contentData.leaguaRank == 2 then
        rankingNum:setVisible(false)
        rankingpic:setVisible(true)
        rankingpic:setTexture("mainScene/u_LianMengNum02.png")
    elseif contentData.leaguaRank == 3 then
        rankingNum:setVisible(false)
        rankingpic:setVisible(true)
        rankingpic:setTexture("mainScene/u_LianMengNum03.png")
    else
        rankingNum:setVisible(true)
        rankingpic:setVisible(false)
        rankingNum:setString(tostring(contentData.leaguaRank))
    end

    container:getVarLabelTTF("mteamname"):setString(contentData.leaguaName)
    container:getVarLabelBMFont("mmpLevel"):setString(tostring(contentData.leaguaLevel))
    container:getVarLabelTTF("mname"):setString(contentData.ownerName)
    local rate = math.ceil(contentData.leaguaWinRate*100);
	if rate>100 then rate = 100	end
	container:getVarLabelBMFont("mteamnum"):setString(tostring(rate).."%")
    container:getVarLabelBMFont("mteampeople"):setString( contentData.leaguaCurMemberCount .. "/".. contentData.leaguaMaxMemberCount)
end

local LianMengRankingPage = {}

function luaCreat_LianMengRankingPage(container)
    CCLuaLog("OnCreat_LianMengRankingPage")
    container:registerFunctionHandler(LianMengRankingPage.onFunction)
end

function LianMengRankingPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengRankingPage.onEnter(container)
    elseif eventName == "luaExit" then
        LianMengRankingPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengRankingPage.onLoad(container)
	elseif eventName == "onAllReject" then
		LianMengRankingPage.onAllReject(container)
    end
end

function LianMengRankingPage.onAllReject(container)
    LianMeng_gotoMainPage()
end

function LianMengRankingPage.onEnter(container)
    container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
	container.m_pScrollViewFacade:init(6,6)
    LianMengRankingPage.rebuildAllItem(container)
end

function LianMengRankingPage.onExit(container)	
    LianMengRankingPage.clearAllItem(container)
	container.m_pScrollViewFacade:delete()
	container.m_pScrollViewFacade = nil
end

function LianMengRankingPage.onLoad(container)
	container:loadCcbiFile("LianMengRanking.ccbi");
	container.mScrollView = container:getVarScrollView("mLMRankingContent")
	container.mScrollViewRootNode = container.mScrollView:getContainer()
end

function LianMengRankingPage.rebuildAllItem(container)
    LianMengRankingPage.clearAllItem(container);
	LianMengRankingPage.buildItem(container);
end

function LianMengRankingPage.buildItem(container)
    local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
	local iCount = 0;
	local fOneItemHeight = 0;
	local fOneItemWidth = 0;

	for i=#LeaguaRankInfoList, 1, -1 do
		local pItemData = CCReViSvItemData:new()
		pItemData.mID = i
		pItemData.m_iIdx = i
		pItemData.m_ptPosition = ccp(0, fOneItemHeight*iCount)

		if iCount < iMaxNode then
			local pItem = ScriptContentBase:create("LianMengRankingContent.ccbi")
			pItem.id = iCount
			pItem:registerFunctionHandler(LianMengRankingContent.onFunction)
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

function LianMengRankingPage.clearAllItem(container)
    container.m_pScrollViewFacade:clearAllItems()
    container.mScrollViewRootNode:removeAllChildren()
end
