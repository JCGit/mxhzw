require "OP_League_pb"
require "LeagueStruct_pb"
require "LeagueStruct_ext_pb"

local LianMengAccedePage = {}
LianMengAccedePage.DealList = {}
LianMengAccedePage.hasApply = false
function luaCreat_LianMengAccedePage(container)
	container:registerFunctionHandler(LianMengAccedePage.onFunction)
end

local LianMengAccedeContent = {}
function LianMengAccedeContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        LianMengAccedeContent.onRefreshItemView(container)
    elseif eventName == "onAccept" then
		LianMengAccedeContent.onAccept(container)
	elseif eventName == "onReject" then
		LianMengAccedeContent.onReject(container)
    end
end

function LianMengAccedeContent.onRefreshItemView(container)
    local contentData = LeaguaApplyInfoList[container:getItemDate().mID]
    container:getVarLabelTTF("mname"):setString(contentData.playerName)
    container:getVarLabelBMFont("mmpLevel"):setString(tostring(contentData.playerLevel))
end

function LianMengAccedeContent.onAccept(container)
    local msg = LeagueStruct_ext_pb.OPDealApplyLeagua()
	local k = container:getItemDate().mID
    LianMengAccedePage.DealList[#LianMengAccedePage.DealList+1] = k
    msg.applyID:append(k)
    msg.result:append(true)
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_DEAL_APPLY_LEAGUA_C,pb_data,#pb_data,true)
end

function LianMengAccedeContent.onReject(container)
    local msg = LeagueStruct_ext_pb.OPDealApplyLeagua()
	local k = container:getItemDate().mID
	LianMengAccedePage.DealList[#LianMengAccedePage.DealList+1] = k
    msg.applyID:append(k)
    msg.result:append(false)
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_DEAL_APPLY_LEAGUA_C,pb_data,#pb_data,true)
end

function LianMengAccedePage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengAccedePage.onEnter(container)
    elseif eventName == "luaExit" then
        LianMengAccedePage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengAccedePage.onLoad(container)
	elseif eventName == "luaReceivePacket" then
		LianMengAccedePage.onReceivePacket(container)
    elseif eventName == "luaTimeout" or eventName == "luaPacketError" or eventName == "luaSendPacketFailed" then
        LianMengAccedePage.onReceiveFaild(container)
	elseif eventName == "onAllAccept" then
		LianMengAccedePage.onAllAccept(container)
	elseif eventName == "onAllReject" then
		LianMengAccedePage.onAllReject(container)
	elseif eventName == "onRevertLM" then
		LianMengAccedePage.onRevertLM(container)
    end
end

function LianMengAccedePage.onAllAccept(container)
    local hasItem = false
    local msg = LeagueStruct_ext_pb.OPDealApplyLeagua()
    for k, v in pairs(LeaguaApplyInfoList) do
        LianMengAccedePage.DealList[#LianMengAccedePage.DealList+1] = v.applyID
        msg.applyID:append(k)
        msg.result:append(true)
        hasItem = true
    end
    if hasItem then
	    local pb_data = msg:SerializeToString()
	    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_DEAL_APPLY_LEAGUA_C,pb_data,#pb_data,true)
	end
end

function LianMengAccedePage.onAllReject(container)
	local hasItem = false
    local msg = LeagueStruct_ext_pb.OPDealApplyLeagua()
    for k, v in pairs(LeaguaApplyInfoList) do
        LianMengAccedePage.DealList[#LianMengAccedePage.DealList+1] = v.applyID
        msg.applyID:append(k)
        msg.result:append(false)
        hasItem = true
    end
    if hasItem then
	    local pb_data = msg:SerializeToString()
	    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_DEAL_APPLY_LEAGUA_C,pb_data,#pb_data,true)
	end
end

function LianMengAccedePage.onRevertLM(container)
    LianMeng_gotoMainPage()
end

function LianMengAccedePage.onEnter(container)
    LianMengAccedePage.hasApply = false
    container:registerPacket(OP_League_pb.OPCODE_DEAL_APPLY_LEAGUARET_S)
    LianMengAccedePage.rebuildAllItem(container)
    if not LianMengAccedePage.hasApply then
        container:getVarLabelBMFont("mNoAccede"):setVisible(true)
    else
        container:getVarLabelBMFont("mNoAccede"):setVisible(false)
    end
end

function LianMengAccedePage.onExit(container)
    LianMengAccedePage.clearAllItem(container)
    container.m_pScrollViewFacade:delete()
	container.m_pScrollViewFacade = nil
	container:removePacket(OP_League_pb.OPCODE_DEAL_APPLY_LEAGUARET_S)
end

function LianMengAccedePage.onLoad(container)
	container:loadCcbiFile("LianMengAccede.ccbi")
	CCLuaLog(container:dumpInfo())
	container.mScrollView = container:getVarScrollView("mLMAccedeContent")
	container.mScrollViewRootNode = container.mScrollView:getContainer()
	container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
	container.m_pScrollViewFacade:init(6,6)
end

function LianMengAccedePage.rebuildAllItem(container)
    LianMengAccedePage.clearAllItem(container);
	LianMengAccedePage.buildItem(container);
end

function LianMengAccedePage.buildItem(container)
    local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
	local iCount = 0;
	local fOneItemHeight = 0;
	local fOneItemWidth = 0;

	--for i=#LeaguaApplyInfoList, 1, -1 do
	for k, v in pairs(LeaguaApplyInfoList) do
		local pItemData = CCReViSvItemData:new()
		pItemData.mID = k
		pItemData.m_iIdx = iCount
		pItemData.m_ptPosition = ccp(0, fOneItemHeight*iCount)

		if iCount < iMaxNode then
			local pItem = ScriptContentBase:create("LianMengAccedeContent.ccbi")
			pItem.id = iCount
			pItem:registerFunctionHandler(LianMengAccedeContent.onFunction)
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
	if iCount ~= 0 then
	    LianMengAccedePage.hasApply = true
	end
	
	local size = CCSizeMake(fOneItemWidth, fOneItemHeight*iCount)
	container.mScrollView:setContentSize(size);
	container.mScrollView:setContentOffset(ccp(0, container.mScrollView:getViewSize().height - container.mScrollView:getContentSize().height*container.mScrollView:getScaleY()));
	container.m_pScrollViewFacade:setDynamicItemsStartPosition(iCount-1);
end

function LianMengAccedePage.clearAllItem(container)
    container.m_pScrollViewFacade:clearAllItems()
    container.mScrollViewRootNode:removeAllChildren()
end

function LianMengAccedePage.onReceivePacket(container)
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_DEAL_APPLY_LEAGUARET_S) then
		local msg = LeagueStruct_ext_pb.OPDealApplyLeaguaRet()
	    local msgbuff = container:getRecPacketBuffer()
	    msg:ParseFromString(msgbuff)
		
        if msg.status == 1 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengDealAplly_Success")
		elseif msg.status == 2 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengDealAplly_Faild")
		elseif msg.status == 3 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengDealAplly_Faild_TopNum")
		end
		LeaguaBaseInfo.leaguaCurMemberCount = msg.leaguaCurMemberCount
		for k, v in ipairs(LianMengAccedePage.DealList) do
		    LeaguaApplyInfoList[v] = nil
        end
        LianMengAccedePage.DealList = {}
        LianMengAccedePage.onEnter(container)
	end
end

function LianMengAccedePage.onReceiveFaild(container)
    if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_DEAL_APPLY_LEAGUARET_S) then
        LianMengAccedePage.DealList = nil
	end
end