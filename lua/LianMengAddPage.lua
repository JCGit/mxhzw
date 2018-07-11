require "OP_League_pb"
require "LeagueStruct_pb"
require "LeagueStruct_ext_pb"

local LianMengAddContent = {}
function LianMengAddContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        LianMengAddContent.onRefreshItemView(container)
    elseif eventName == "onadd" then
        LianMengAddContent.onAdd(container)
    elseif eventName == "luaReceivePacket" then
	    LianMengAddContent.onReceivePacket(container)
    end
end

function LianMengAddContent.onRefreshItemView(container)
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

function LianMengAddContent.onAdd(container)
    if ServerDateManager:getInstance():getUserBasicInfo().level < 17 then
        MessageBoxPage:Msg_Box_Lan("@LianMengAdd_LowLevel")
    else
        local msg = LeagueStruct_ext_pb.OPApplyLeagua()
	    msg.leaguaID = LeaguaRankInfoList[container:getItemDate().mID].leaguaID
	    local pb_data = msg:SerializeToString()
	    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_APPLY_LEAGUA_C,pb_data,#pb_data,true)
    end
end

local function LianMengAddHandler(eventName,handler)
    if eventName == "luaReceivePacket" then
        local msg = LeagueStruct_ext_pb.OPApplyLeaguaRet()
	    local msgbuff = handler:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
        if msg.status == 1 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengAdd_Success")
		elseif msg.status == 2 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengAdd_HasLeagua")
		elseif msg.status == 3 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengAdd_NotLeagua")
		elseif msg.status == 4 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengAdd_TooMuch")
		elseif msg.status == 5 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengAdd_CD")
		end
    end
end
PacketScriptHandler:new(OP_League_pb.OPCODE_APPLY_LEAGUARET_S, LianMengAddHandler)

local LianMengAddPage = {}

function luaCreat_LianMengAddPage(container)
    CCLuaLog("OnCreat_LianMengAddPage")
    container:registerFunctionHandler(LianMengAddPage.onFunction)
end

local regisiterpage_LianMengPage = false

function LianMengAddPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengAddPage.onEnter(container)
    elseif eventName == "luaExit" then
        LianMengAddPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengAddPage.onLoad(container)
	elseif eventName == "onFound" then
		LianMengAddPage.onFound(container)
    end
end

function LianMengAddPage.onFound(container)
    --[[if ServerDateManager:getInstance():getUserBasicInfo().level < 17 then
        MessageBoxPage:Msg_Box_Lan("@LianMengCreat_LowLevel")
    elseif ServerDateManager:getInstance():getUserBasicInfo().goldcoins < 300 then
        MessageBoxPage:Msg_Box_Lan("@LianMengCreat_LowGoldcoins")
    else    
        MainFrame:getInstance():pushPage("LianMengCreatePage")
    end--]]
    MainFrame:getInstance():pushPage("LianMengCreatePage")
end

function LianMengAddPage.onEnter(container)
    CCLuaLog("LianMengAddPage.onEnter")
    LianMengAddPage.rebuildAllItem(container)
end

function LianMengAddPage.onExit(container)	
    CCLuaLog("LianMengAddPage.onExit")
    LianMengAddPage.clearAllItem(container)
	container.m_pScrollViewFacade:delete()
	container.m_pScrollViewFacade = nil
end

function LianMengAddPage.onLoad(container)
	CCLuaLog("LianMengAddPage.onLoad")
	container:loadCcbiFile("LianMengAdd.ccbi");
	CCLuaLog(container:dumpInfo())
	container.mScrollView = container:getVarScrollView("mLMAddContent")
	container.mScrollViewRootNode = container.mScrollView:getContainer()
	container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
	container.m_pScrollViewFacade:init(6,6)
end

function LianMengAddPage.rebuildAllItem(container)
    LianMengAddPage.clearAllItem(container);
	LianMengAddPage.buildItem(container);
end

function LianMengAddPage.buildItem(container)
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
			local pItem = ScriptContentBase:create("LianMengAddContent.ccbi")
			pItem.id = iCount
			pItem:registerFunctionHandler(LianMengAddContent.onFunction)
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

function LianMengAddPage.clearAllItem(container)
    container.m_pScrollViewFacade:clearAllItems()
    container.mScrollViewRootNode:removeAllChildren()
end
