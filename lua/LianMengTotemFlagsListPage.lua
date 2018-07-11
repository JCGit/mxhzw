LianMengTotemFlagsListInfo={}
local ListContent = {}
function ListContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        ListContent.onRefreshItemView(container)
    elseif eventName == "onFlagsRob" then
        ListContent.onFlagsRob(container)
    end
end

function ListContent.onFlagsRob(container)
    local itemData = LianMengTotemFlagsListInfo[container:getItemDate().mID]
    local msg = LeagueStruct_ext_pb.OPRobLeaguaMedal()
    msg.version = 1
    msg.leaguaID = itemData.ownerLeaguaID
    msg.medalID = itemData.medalID
    local pb_data = msg:SerializeToString()
    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_ROB_LEAGUA_MEDAL_C,pb_data,#pb_data,true)
end

function ListContent.onRefreshItemView(container)
    local itemData = LianMengTotemFlagsListInfo[container:getItemDate().mID]
    container:getVarLabelBMFont("mNum1"):setString(tostring(itemData.count))
    container:getVarSprite("mFlagIcon"):setTexture(LianMengBadges[itemData.medalID].filename)
end

local LianMengTotemFlagsListPage = {}

function luaCreat_LianMengTotemFlagsListPage(container)
    CCLuaLog("OnCreat_LianMengTotemFlagsListPage")
    container:registerFunctionHandler(LianMengTotemFlagsListPage.onFunction)
end

function LianMengTotemFlagsListPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengTotemFlagsListPage.onEnter(container)
    elseif eventName == "luaReceivePacket" then
        LianMengTotemFlagsListPage.onReceivePacket(container)
    elseif eventName == "luaExit" then
        LianMengTotemFlagsListPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengTotemFlagsListPage.onLoad(container)
	elseif eventName == "onConfirm" then
		LianMengTotemFlagsListPage.onConfirm(container)
    elseif eventName == "onClose" then
        LianMengTotemFlagsListPage.closePage(container)
    elseif eventName == "luaGameMessage" then
        LianMengTotemFlagsListPage.gameMessage(container)
    end
end

function LianMengTotemFlagsListPage.closePage(container)
    MainFrame:getInstance():popPage("LianMengTotemFlagsListPage")
end

function LianMengTotemFlagsListPage.onConfirm(container)
    MainFrame:getInstance():popPage("LianMengTotemFlagsListPage")
end

function LianMengTotemFlagsListPage.onEnter(container)
    container:registerPacket(OP_League_pb.OPCODE_ROB_LEAGUA_MEDALRET_S)
    container:registerPacket(108)--UserBattle
    container:getVarLabelBMFont("mTitle"):setString(tostring(Language:getInstance():getString("@LMFlagsListTitle")))
    container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
	container.m_pScrollViewFacade:init(6,6)
    LianMengTotemFlagsListPage.rebuildAllItem(container)
end

function LianMengTotemFlagsListPage.onExit(container)	
    LianMengTotemFlagsListPage.clearAllItem(container)
	container.m_pScrollViewFacade:delete()
	container.m_pScrollViewFacade = nil
    container:removePacket(OP_League_pb.OPCODE_ROB_LEAGUA_MEDALRET_S)
end

function LianMengTotemFlagsListPage.onLoad(container)
	container:loadCcbiFile("LianMengTotemRobFlags.ccbi")
	container.mScrollView = container:getVarScrollView("mContent")
	container.mScrollViewRootNode = container.mScrollView:getContainer()
end

function LianMengTotemFlagsListPage.rebuildAllItem(container)
    LianMengTotemFlagsListPage.clearAllItem(container);
	LianMengTotemFlagsListPage.buildItem(container);
end

function LianMengTotemFlagsListPage.buildItem(container)
    local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
	local iCount = 0;
	local fOneItemHeight = 0;
	local fOneItemWidth = 0;

	for i=#LianMengTotemFlagsListInfo, 1, -1 do
		local pItemData = CCReViSvItemData:new()
		pItemData.mID = i
		pItemData.m_iIdx = i
		pItemData.m_ptPosition = ccp(0, fOneItemHeight*iCount)

		if iCount < iMaxNode then
			local pItem = ScriptContentBase:create("LianMengTotemRobFlagsContent.ccbi")
			pItem.id = iCount
			pItem:registerFunctionHandler(ListContent.onFunction)
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

function LianMengTotemFlagsListPage.clearAllItem(container)
    container.m_pScrollViewFacade:clearAllItems()
    container.mScrollViewRootNode:removeAllChildren()
end

function LianMengTotemFlagsListPage.gameMessage(container)
    local message = container:getMessage()
    if message:getTypeId() == 26 then
        container:removeMessage(26)
        if LianMengTotemRob.status==1 and LianMengTotemRob.gotBadgeID ~=nil then
            local msg = MsgMainFrameCoverShow:new()
            msg.pageName = "LianMengTotemRobFlagsPopPage"
            MessageManager:getInstance():sendMessageForScript(msg)
        elseif LianMengTotemRob.status==1 and LianMengTotemRob.gotBadgeID ==nil then
            MessageBoxPage:Msg_Box_Lan("@LMPlunderFlagsFightFail")
        elseif LianMengTotemRob.status==2 then
            local msg = MsgMainFrameCoverShow:new()
            msg.pageName = "LianMengTotemRobFlagsPopPage"
            MessageManager:getInstance():sendMessageForScript(msg)
        elseif LianMengTotemRob.status==0 then
            MessageBoxPage:Msg_Box_Lan("@LMPlunderFlagsError")
        end
        LianMengTotemFlagsListPage.closePage(container)
    end
end

function LianMengTotemFlagsListPage.onReceivePacket(container)
    if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_ROB_LEAGUA_MEDALRET_S) then
        local msg = LeagueStruct_ext_pb.OPRobLeaguaMedalRet()
        msgbuff = container:getRecPacketBuffer();
        msg:ParseFromString(msgbuff)
        LianMengTotemRob.status = msg.status	--1: normal	2:	alread broken	3:	error
        LianMengTotemRob.contribution = msg.contribution
        LianMengTotemRob.fund = msg.fund
        LianMengTotemRob.intrestLeftTimes = msg.intrestLeftTimes
        LianMengTotemRob.intrestMaxTimes = msg.intrestMaxTimes
        LianMengTotemRob.robLeftTimes = msg.robLeftTimes
        LianMengTotemRob.robMaxTimes = msg.robMaxTimes
        LeaguaBaseInfo.intrestLeftTimes=msg.intrestLeftTimes
        LeaguaBaseInfo.robLeftTimes=msg.robLeftTimes
        LeaguaBaseInfo.intrestMaxTimes=msg.intrestMaxTimes
        LeaguaBaseInfo.robMaxTimes=msg.robMaxTimes
        if(msg:HasField("gotBadgeID"))then
            LianMengTotemRob.gotBadgeID = msg.gotBadgeID
        else
            LianMengTotemRob.gotBadgeID = nil
        end
        LeagueTotemInfo.coolDownSeconds = msg.coolDownSeconds
        if msg.status==1 then

        elseif msg.status==2 then
            LianMengTotemFlagsListPage.closePage(container)
            local msg = MsgMainFrameCoverShow:new()
            msg.pageName = "LianMengTotemRobFlagsPopPage"
            MessageManager:getInstance():sendMessageForScript(msg)
        elseif msg.status==0 then
            LianMengTotemFlagsListPage.closePage(container)
            MessageBoxPage:Msg_Box_Lan("@LMPlunderFlagsError")
        end
     elseif(container:getRecPacketOpcode() == 108) then
            container:removePacket(108)
            local fp = FightPage:getInstance()
            LianMengTotemRob.fightmessage = container:getRecPacketBuffer()
            fp:setMessage(container:getRecPacketBuffer(),container:getRecPacketBufferLength())
            --fp:setFightType(-1)
            local msg = MsgMainFrameCoverShow:new()
            msg.pageName = "FightPage"
            MessageManager:getInstance():sendMessageForScript(msg)
            container:registerMessage(26)--[[MSG_FIGHTPAGE_EXIT]]
    end
end