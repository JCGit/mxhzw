require "OP_League_pb"
require "LeagueStruct_pb"
require "LeagueStruct_ext_pb"

local LianMengMemberContent = {}
function LianMengMemberContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        LianMengMemberContent.onRefreshItemView(container)
    elseif eventName == "onLMMem" then
        LianMengMemberContent.onLMMem(container)
    end
end

function LianMengMemberContent.onRefreshItemView(container)
    container.mSelect = container:getVarMenuItemImage("mLMMem")
    --container.mSelect:getSelectedImage():setScaleY(0.2) --modify by dylan
	container.mSelect:unselected()
	if LeaguaBaseInfo.playerGrade == 4 then
        container.mSelect:setEnabled(true)
        container.mSelect:unselected()
    else
        container.mSelect:setEnabled(false)
    end
    local contentData = LeaguaMemberInfoList[container:getItemDate().mID]
    container:getVarLabelTTF("mname"):setString(contentData.playerName)
    container:getVarLabelBMFont("mmpLevel"):setString(tostring(contentData.playerLevel))
    if contentData.playerGrade == 4 then
        container:getVarSprite("mLMMJobs"):setTexture("lianmeng/u_LianMengBanner02.png")
    elseif contentData.playerGrade == 3 then
        container:getVarSprite("mLMMJobs"):setTexture("lianmeng/u_LianMengBanner03.png")
    elseif contentData.playerGrade == 2 then
        container:getVarSprite("mLMMJobs"):setTexture("lianmeng/u_LianMengBanner04.png")
    elseif contentData.playerGrade == 1 then
        container:getVarSprite("mLMMJobs"):setTexture("lianmeng/u_LianMengBanner05.png")
    end
    
    container:getVarLabelBMFont("mContribute"):setString(tostring(contentData.playerContribution))
    container:getVarLabelBMFont("mkills"):setString(contentData.playerKillCount)
end

function LianMengMemberContent.onLMMem(container)
    if LianMengMemberContent.mCurSellectedContent ~= nil then
		LianMengMemberContent.mCurSellectedContent.mSelect:unselected()
	end

	if LianMengMemberContent.mCurSellectedContent ~= container then
		LianMengMemberContent.mCurSellectedContent = container
		LianMengMemberContent.mCurSellectedContent.mSelect:selected()
	else
		LianMengMemberContent.mCurSellectedContent = nil
    end
end

local LianMengMemberPage = {}

function luaCreat_LianMengMemberPage(container)
    container:registerFunctionHandler(LianMengMemberPage.onFunction)
end

function LianMengMemberPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengMemberPage.onEnter(container)
    elseif eventName == "luaExecute" then
	    LianMengMemberPage.onExecute(container)
    elseif eventName == "luaExit" then
        LianMengMemberPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengMemberPage.onLoad(container)
	elseif eventName == "luaReceivePacket" then
		LianMengMemberPage.onReceivePacket(container)
	elseif eventName == "onTransfer" then
		LianMengMemberPage.onTransfer(container)
	elseif eventName == "onPromote" then
		LianMengMemberPage.onPromote(container)
	elseif eventName == "onKickedout" then
		LianMengMemberPage.onKickedout(container)
	elseif eventName == "onBack" then
		LianMengMemberPage.onBack(container)
	elseif eventName == "onFound" then
		LianMengMemberPage.onFound(container)
    end
end

function LianMengMemberPage.onFound(container)
    if LeaguaBaseInfo.playerGrade == 4 then
        ShowDecisionPage("@LianMengMember_Disband" , function (confirm)
            if confirm then
                container:registerPacket(OP_League_pb.OPCODE_DISBAND_LEAGUARET_S)
                local msg = LeagueStruct_ext_pb.OPDisbandLeagua()
	            msg.version = 1
	            local pb_data = msg:SerializeToString()
	            PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_DISBAND_LEAGUA_C,pb_data,#pb_data,true)
            end
        end)
    else
	    ShowDecisionPage("@LianMengMember_Quit" , function (confirm)
            if confirm then
                container:registerPacket(OP_League_pb.OPCODE_QUIT_LEAGUARET_S)
                local msg = LeagueStruct_ext_pb.OPQuitLeagua()
	            msg.version = 1
	            local pb_data = msg:SerializeToString()
	            PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_QUIT_LEAGUA_C,pb_data,#pb_data,true)
            end
        end)
    end
end

function LianMengMemberPage.onPromote(container)
    if LeaguaBaseInfo.playerGrade == 3 or LeaguaBaseInfo.playerGrade == 4 then
        MessageBoxPage:Msg_Box_Lan("@PromoteEnough")
    else
	    ShowDecisionPage("@LianMengMember_Promote" , function (confirm)
            if confirm then
                container:registerPacket(OP_League_pb.OPCODE_UPGRADE_LEAGUA_MEMBERRET_S)
                local msg = LeagueStruct_pb.OPUpgradeLeaguaMember()
	            msg.version = 1
	            local pb_data = msg:SerializeToString()
	            PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_UPGRADE_LEAGUA_MEMBER_C,pb_data,#pb_data,true)
            end
        end)
    end
end

function LianMengMemberPage.onBack(container)
    LianMeng_gotoMainPage()
end

function LianMengMemberPage.onKickedout(container)
    if LianMengMemberContent.mCurSellectedContent == nil then
        MessageBoxPage:Msg_Box_Lan("@LianMengMember_SellectMember")
        return
    end
    local contentData = LeaguaMemberInfoList[LianMengMemberContent.mCurSellectedContent:getItemDate().mID]
    if contentData.playerGrade == 4 then
        MessageBoxPage:Msg_Box_Lan("@LianMengMember_FireLeaderFaild")
    else
        ShowDecisionPage("@LianMengMember_Fire" , function (confirm)
            if confirm then
                container:registerPacket(OP_League_pb.OPCODE_FIRE_LEAGUA_MEMBERRET_S)
                local msg = LeagueStruct_pb.OPFireLeaguaMember()
	            msg.playerID = contentData.playerID
	            local pb_data = msg:SerializeToString()
	            PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_FIRE_LEAGUA_MEMBER_C,pb_data,#pb_data,true)
            end
        end)
    end
end

function LianMengMemberPage.onTransfer(container)

	local hasKey = TimeCalculator:getInstance():hasKey("LMTransLeaderCoolTime")
	if not hasKey then
		MessageBoxPage:Msg_Box_Lan("@LianMengMember_TransferInCD")
		return
	end

    local timeleft = TimeCalculator:getInstance():getTimeLeft("LMTransLeaderCoolTime")
	if timeleft ~= 0 then
	    MessageBoxPage:Msg_Box_Lan("@LianMengMember_TransferInCD")
        return
	end
    
    if LianMengMemberContent.mCurSellectedContent == nil then
        MessageBoxPage:Msg_Box_Lan("@LianMengMember_SellectMember")
        return
    end
    local contentData = LeaguaMemberInfoList[LianMengMemberContent.mCurSellectedContent:getItemDate().mID]
    if contentData.playerGrade == 4 then
        MessageBoxPage:Msg_Box_Lan("@LianMengMember_TransferLeaderFaild")
    else
        ShowDecisionPage("@LianMengMember_Transfer" , function (confirm)
            if confirm then
                container:registerPacket(OP_League_pb.OPCODE_TRANSFER_LEAGUAOWNERRET_S)
                local msg = LeagueStruct_pb.OPTransferLeaguaOwner()
	            msg.playerID = contentData.playerID
	            local pb_data = msg:SerializeToString()
	            PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_TRANSFER_LEAGUAOWNER_C,pb_data,#pb_data,true)
            end
        end)
    end
end

function LianMengMemberPage.onEnter(container)
    LianMengMemberContent.mCurSellectedContent = nil
    LianMengMemberPage.rebuildAllItem(container)
    local s
    local b = false
    if LeaguaBaseInfo.playerGrade == 4 then
        s = Language:getInstance():getString("@DisbandLeagua")
        b = true
    else
        s = Language:getInstance():getString("@QuitLeagua")
    end

    local hasKey = TimeCalculator:getInstance():hasKey("LMTransLeaderCoolTime")
    if hasKey then
		local timeleft = TimeCalculator:getInstance():getTimeLeft("LMTransLeaderCoolTime")
		local cdString = GameMaths:formatSecondsToTime(timeleft)
    end

    container:getVarLabelBMFont("mLMMemExit"):setString(s)
    container:getVarNode("mTransferNode"):setVisible(b)
    container:getVarNode("mKickdoutNode"):setVisible(b)

    if LeaguaBaseInfo.playerGrade == 4 or LeaguaBaseInfo.playerGrade == 3 then
        --container:getVarMenuItemSprite("mPromote"):setNormalImage(CCSprite:create("lianmeng/LianMengGreyBK.png"))
    end
end

function LianMengMemberPage.onExecute(container)
	if LeaguaBaseInfo.playerGrade == 4 and TimeCalculator:getInstance():hasKey("LMTransLeaderCoolTime") then
		local timeleft = TimeCalculator:getInstance():getTimeLeft("LMTransLeaderCoolTime")
		if timeleft ~= 0 then
			local cdString = GameMaths:formatSecondsToTime(timeleft)
			container:getVarLabelBMFont("mLMTransfer"):setString(cdString)
		else
		    local str = Language:getInstance():getString("@LMTransfer")
			container:getVarLabelBMFont("mLMTransfer"):setString(str)
		end
	end
end

function LianMengMemberPage.onExit(container)	
    LianMengMemberPage.clearAllItem(container)
	container.m_pScrollViewFacade:delete()
	container.m_pScrollViewFacade = nil
	LianMengMemberContent.mCurSellectedContent = nil
end

function LianMengMemberPage.onLoad(container)
	container:loadCcbiFile("LianMengMember.ccbi")
	CCLuaLog(container:dumpInfo())
	container.mScrollView = container:getVarScrollView("mLMMemTable")
	container.mScrollViewRootNode = container.mScrollView:getContainer()
	container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
	container.m_pScrollViewFacade:init(6,6)
end

function LianMengMemberPage.rebuildAllItem(container)
    LianMengMemberPage.clearAllItem(container);
	LianMengMemberPage.buildItem(container);
end

function LianMengMemberPage.buildItem(container)
    local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
	local iCount = 0;
	local fOneItemHeight = 0;
	local fOneItemWidth = 0;

	table.sort(LeaguaMemberInfoList, 
        function (e1, e2)
            if not e2 then return true end
            if not e1 then return false end
              
            if e1.playerGrade ~= e2.playerGrade then
				return e1.playerGrade < e2.playerGrade
			elseif e1.playerLevel ~= e2.playerLevel then
				return e1.playerLevel < e2.playerLevel
			elseif e1.playerContribution ~= e2.playerContribution then
				return e1.playerContribution < e2.playerContribution
			else
				return e1.playerID < e2.playerID
			end
        end
	)

	for k, v in pairs(LeaguaMemberInfoList) do
		local pItemData = CCReViSvItemData:new()
		pItemData.mID =  k
		pItemData.m_iIdx = iCount
		pItemData.m_ptPosition = ccp(0, fOneItemHeight*iCount)

		if iCount < iMaxNode then
			local pItem = ScriptContentBase:create("LianMengMemberContent.ccbi")
			pItem.id = iCount
			pItem:registerFunctionHandler(LianMengMemberContent.onFunction)
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
	container.mScrollView:forceRecaculateChildren()
end

function LianMengMemberPage.clearAllItem(container)
    container.m_pScrollViewFacade:clearAllItems()
    container.mScrollViewRootNode:removeAllChildren()
end

function LianMengMemberPage.onReceivePacket(container)
	if container:getRecPacketOpcode() == OP_League_pb.OPCODE_DISBAND_LEAGUARET_S then
	    local msg = LeagueStruct_ext_pb.OPDisbandLeaguaRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		if msg.status == 1 then
		    initLianMengServerData()
		    --MainFrame:getInstance():showPage("MainPage")
		    LianMeng_gotoMainPage()
		else
		    MessageBoxPage:Msg_Box_Lan("@LianMengMember_DisbandFaild")
		end
	elseif container:getRecPacketOpcode() == OP_League_pb.OPCODE_QUIT_LEAGUARET_S then
	    local msg = LeagueStruct_ext_pb.OPQuitLeaguaRet()
		msgbuff = container:getRecPacketBuffer()
		msg:ParseFromString(msgbuff)
		if msg.status == 1 then
		    --MainFrame:getInstance():showPage("MainPage")
		    LianMeng_gotoMainPage()
		else
		    MessageBoxPage:Msg_Box_Lan("@LianMengMember_QuitFaild")
		end
	elseif container:getRecPacketOpcode() == OP_League_pb.OPCODE_UPGRADE_LEAGUA_MEMBERRET_S then
	    local msg = LeagueStruct_pb.OPUpgradeLeaguaMemberRet()
		msgbuff = container:getRecPacketBuffer()
		msg:ParseFromString(msgbuff)
        LeaguaMemberInfoList = {}
		for k, v in ipairs(msg._memberInfoList) do
	        LeaguaMemberInfoList[k] = {}
	        LeaguaMemberInfoList[k]["playerID"] = v.playerID
	        LeaguaMemberInfoList[k]["playerName"] = v.playerName
	        LeaguaMemberInfoList[k]["playerLevel"] = v.playerLevel
	        LeaguaMemberInfoList[k]["playerGrade"] = v.playerGrade
	        LeaguaMemberInfoList[k]["playerContribution"] = v.playerContribution
	        LeaguaMemberInfoList[k]["playerKillCount"] = v.playerKillCount
        end
        if msg:HasField("playerGrade") then
            LeaguaBaseInfo.playerGrade = msg.playerGrade
        end
		if msg.status == 1 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengMember_UpgradeSuccess")
		else
		    MessageBoxPage:Msg_Box_Lan("@LianMengMember_UpgradeFaild")
		end
		LianMengMemberPage.onEnter(container)
	elseif container:getRecPacketOpcode() == OP_League_pb.OPCODE_FIRE_LEAGUA_MEMBERRET_S then
	    local msg = LeagueStruct_pb.OPFireLeaguaMemberRet()
		msgbuff = container:getRecPacketBuffer()
		msg:ParseFromString(msgbuff)
		LeaguaMemberInfoList = {}
		for k, v in ipairs(msg._memberInfoList) do
	        LeaguaMemberInfoList[k] = {}
	        LeaguaMemberInfoList[k]["playerID"] = v.playerID
	        LeaguaMemberInfoList[k]["playerName"] = v.playerName
	        LeaguaMemberInfoList[k]["playerLevel"] = v.playerLevel
	        LeaguaMemberInfoList[k]["playerGrade"] = v.playerGrade
	        LeaguaMemberInfoList[k]["playerContribution"] = v.playerContribution
	        LeaguaMemberInfoList[k]["playerKillCount"] = v.playerKillCount
        end
		if msg.status == 1 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengMember_FireSuccess")
		elseif msg.status == 2 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengMember_FireFaild_DataError")
		elseif msg.status == 3 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengMember_FireFaild_NoPower")
		end
		LianMengMemberPage.onEnter(container)
	elseif container:getRecPacketOpcode() == OP_League_pb.OPCODE_TRANSFER_LEAGUAOWNERRET_S then
	    local msg = LeagueStruct_pb.OPTransferLeaguaOwnerRet()
		msgbuff = container:getRecPacketBuffer()
		msg:ParseFromString(msgbuff)
        LeaguaMemberInfoList = {}
		for k, v in ipairs(msg._memberInfoList) do
	        LeaguaMemberInfoList[k] = {}
	        LeaguaMemberInfoList[k]["playerID"] = v.playerID
	        LeaguaMemberInfoList[k]["playerName"] = v.playerName
	        LeaguaMemberInfoList[k]["playerLevel"] = v.playerLevel
	        LeaguaMemberInfoList[k]["playerGrade"] = v.playerGrade
	        LeaguaMemberInfoList[k]["playerContribution"] = v.playerContribution
	        LeaguaMemberInfoList[k]["playerKillCount"] = v.playerKillCount
        end
        if msg:HasField("playerGrade") then
            LeaguaBaseInfo.playerGrade = msg.playerGrade
        end
		if msg.status == 1 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengMember_TransferSuccess")
		    LeaguaBaseInfo.transLeaderCoolTime = nil
		elseif msg.status == 2 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengMember_TransferFaild_DataError")
		elseif msg.status == 3 then
		    MessageBoxPage:Msg_Box_Lan("@LianMengMember_TransferFaild_NoPower")
		end
		LianMengMemberPage.onEnter(container)
	end
end
