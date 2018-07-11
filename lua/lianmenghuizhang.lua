-------------------------datas--------------------------------------
require "OP_League_pb"
require "LeagueStruct_ext_pb"
require "LeagueStruct_pb"
require "DecisionPage"

local lianmenghuizhang = {}
lianmenghuizhang.changingMedalID = -1
lianmenghuizhang.ChangeMessage = {}
lianmenghuizhang.alreadyGotSpecialMedal = false
lianmenghuizhang.mTabIndex=1
-------------------------initialize--------------------------------------
function luaCreat_lianmenghuizhang(container)
    CCLuaLog("OnCreat_lianmenghuizhang")
    container:registerFunctionHandler(lianmenghuizhang.onFunction)
end

function lianmenghuizhang.onFunction(eventName,container)
    if eventName == "luaInit" then
        lianmenghuizhang.onInit(container)
    elseif eventName == "luaEnter" then
        lianmenghuizhang.onEnter(container)
    elseif eventName == "luaExit" then
        lianmenghuizhang.onExit(container)
    elseif eventName == "luaExecute" then
        lianmenghuizhang.onExecute(container)
    elseif eventName == "luaLoad" then
        lianmenghuizhang.onLoad(container)
    elseif eventName == "luaUnLoad" then
        lianmenghuizhang.onUnLoad(container)
	elseif eventName == "luaGameMessage" then
		lianmenghuizhang.onGameMessage(container)
	elseif eventName == "luaReceivePacket" then
		lianmenghuizhang.onReceivePacket(container)
	--tabs
	elseif eventName == "onAll" then
		lianmenghuizhang.onAll(container)
	elseif eventName == "onChange" then
		lianmenghuizhang.onChange(container)
	elseif eventName == "onNews" then
	    lianmenghuizhang.onNews(container)
	    
	elseif eventName == "onReturn" then
		LianMeng_gotoMainPage()
	end
end
-------------------------------------------------------------------------
function lianmenghuizhang.onMsgReturn(isYes)
	if(isYes)then
		local msg = LeagueStruct_ext_pb.OPChangeLeaguaActiveMedal()
		msg.medalId  = lianmenghuizhang.changingMedalID
		local pb_data = msg:SerializeToString()
		PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_CHANGE_LEAGUAMEDAL,pb_data,#pb_data,true)
	end
end

function lianmenghuizhang.onContentFunction(eventName,container)
	if eventName == "onLMlingqu" then
		local outlog = "onLMlingqu" .. tostring(container:getTag())
		CCLuaLog(outlog)

		if(LeaguaBaseInfo.playerGrade==4) and (LeaguaBaseInfo.leaguaLevel>=7) and not lianmenghuizhang.alreadyGotSpecialMedal then
			local msg = LeagueStruct_pb.OPReceiveLeaguaMedal()
			msg.medalID = container:getTag()
			local pb_data = msg:SerializeToString()
			PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_RECEIVE_LEAGUAMEDAL_C,pb_data,#pb_data,true)
		elseif(LeaguaBaseInfo.playerGrade~=4)then
			MessageBoxPage:Msg_Box_Lan("@LianMengBadgeCantReceive")
		elseif (LeaguaBaseInfo.leaguaLevel<7)then
			MessageBoxPage:Msg_Box_Lan("@LianMengBadgeCantReceive2")
		elseif lianmenghuizhang.alreadyGotSpecialMedal then
			MessageBoxPage:Msg_Box_Lan("@LianMengBadgeCantReceive3")
		end
    end
    if eventName == "onLMHZ" then
		if(LeaguaBaseInfo.playerGrade == 4 or LeaguaBaseInfo.playerGrade == 3) then
			lianmenghuizhang.changingMedalID = container:getTag()
			if(LeagueMedalInfoList[lianmenghuizhang.changingMedalID].ownerLeaguaID == LeaguaBaseInfo.leaguaID)then
				local msg = Language:getInstance():getString("@LianMengChangeBadgeAsk")
				ShowDecisionPage(msg,lianmenghuizhang.onMsgReturn)
			end
		else
			MessageBoxPage:Msg_Box_Lan("@LianMengChangeBadgeCantStart")
		end
    end
end

-------------------------------------------------
function lianmenghuizhang.TabBadge(container)
	
	container:getVarMenuItem("mTabAll"):setEnabled(false)
	container:getVarMenuItem("mTabChange"):setEnabled(true)
	container:getVarMenuItem("mTabNews"):setEnabled(true)
	
	local mContent = container:getVarScrollView("mEquipContent")
	local node = CCNode:create()
	local sizeX = 0
	local sizeY = 0
	--[[
	local alreadyHadMeda = false
	for i, v in ipairs(LianMengBadges) do
		if(i>2 and LeagueMedalInfoList[tonumber(v.index)] ~= nil)then
			if(LeagueMedalInfoList[tonumber(v.index)].ownerLeaguaID == LeaguaBaseInfo.leaguaID)then
				alreadyHadMeda = true
			end
		end
	end--]]

	local count = #LianMengBadges

	if(LeagueMedalInfoList[2]==nil)then
		count = count-2
	else
		count = count-1
	end

	for i, v in ipairs(LianMengBadges) do
		if(i~=1 and LeagueMedalInfoList[tonumber(v.index)] ~= nil)then
			local pItem = ScriptContentBase:create("lianmenghzcontent1.ccbi",i)
			pItem:release()--release because ScriptContentBase is designed for New Scrollview
			CCLuaLog(pItem:dumpInfo())
			pItem:registerFunctionHandler(lianmenghuizhang.onContentFunction)
			node:addChild(pItem)

			local idx = i-3
			local rowcount = (idx%3)
			if(i==2)then rowcount = (count-1)%3 end
			local linecount = math.floor((count-idx+1)/3)--math.floor((count - i + 4)/3)
			if(i==2)then linecount = 0 end
			
			sizeX = pItem:getContentSize().width;
			sizeY = pItem:getContentSize().height
			pItem:setPositionX(rowcount*sizeX)
			pItem:setPositionY(linecount*sizeY)
			--texture
			local sprite = pItem:getVarMenuItemSprite("mlmhuizhang")
			local badgeNode = CCSprite:create(v.filename);
			sprite:setNormalImage(badgeNode)
			--set lingqu
			
			if LeagueMedalInfoList[tonumber(v.index)].ownerLeaguaID == 0 then
				--pItem:getVarNode("mHZLQ"):setVisible(not alreadyHadMeda)
				pItem:getVarNode("mHZLQ"):setVisible(not lianmenghuizhang.alreadyGotSpecialMedal)
				pItem:getVarNode("mHZGH"):setVisible(false)
				pItem:getVarLabelTTF("mLMName"):setVisible(false)
			elseif LeagueMedalInfoList[tonumber(v.index)].ownerLeaguaID ==LeaguaBaseInfo.leaguaID then
				pItem:getVarNode("mHZLQ"):setVisible(false)
				local activeMedal = (tonumber(v.index) == LeaguaBaseInfo.leaguaActiveMedal)
				pItem:getVarNode("mHZGH"):setVisible(not activeMedal)
				pItem:getVarLabelTTF("mLMName"):setVisible(activeMedal)
				if(activeMedal)then
					local str = Language:getInstance():getString("@LMBadgeUsing")
					pItem:getVarLabelTTF("mLMName"):setString(str)
				else
					pItem:getVarLabelTTF("mLMName"):setString(LeagueMedalInfoList[tonumber(v.index)].ownerLeaguaName)
				end

			else
				pItem:getVarNode("mHZLQ"):setVisible(false)
				pItem:getVarNode("mHZGH"):setVisible(false)
				pItem:getVarLabelTTF("mLMName"):setVisible(true)
				pItem:getVarLabelTTF("mLMName"):setString(LeagueMedalInfoList[tonumber(v.index)].ownerLeaguaName)
			end
		
		end--if(i~2)then
	end
	
	node:setContentSize(CCSize(3*sizeX,( math.ceil(count/3))*sizeY))
	mContent:setContainer(node)
	mContent:setContentOffset(mContent:minContainerOffset());
end

function lianmenghuizhang.TabChange(container)
    local mContent = container:getVarScrollView("mEquipContent")
    mContent:removeAllChildren()
	local node = CCNode:create()
	local sizeX = 0
    local sizeY = 0
    
    local baseString = Language:getInstance():getString("@LMMedalMessageContent")
    local count = #lianmenghuizhang.ChangeMessage
    for k,v in ipairs(lianmenghuizhang.ChangeMessage) do
        local pItem = ScriptContentBase:create("lianmenghzcontent2.ccbi")
        -- set var
        local _time = v.changeTime
        local yy = tostring(os.date("%Y",_time))
        local mm = tostring(os.date("%m",_time))
        local dd = tostring(os.date("%d",_time))
        local med = LianMengBadges[v.medalID].name
        local str = baseString
        --{yy}??{mm}??{dd}??{league1}??{player}?????{league2}??{medal}
        str=string.gsub(str, "{yy}", yy)
        str=string.gsub(str, "{mm}", mm)
        str=string.gsub(str, "{dd}", dd)

        str=string.gsub(str, "{league1}", v.afterOwnerLeaguaName)
        str=string.gsub(str, "{league2}", v.beforeOwnerLeaguaName)
        str=string.gsub(str, "{medal}", med)
        str=string.gsub(str, "{player}", v.robPlayerName)

        pItem:getVarLabelTTF("mlmbiandong"):setString(autoReturn(str,20))
		node:addChild(pItem)
		local linecount = math.floor(count - k )
		sizeX = pItem:getContentSize().width;
		sizeY = pItem:getContentSize().height
		pItem:setPositionY(linecount*sizeY)
    end
    node:setContentSize(CCSize(sizeX,(count*sizeY)))
    mContent:setContainer(node)
    mContent:setContentOffset(mContent:minContainerOffset());
end

function lianmenghuizhang.TabMessage(container)
    MessageBoxPage:Msg_Box("@MAINPAGE_COMINGSOON")
end
--------------------------------------------------------------------------------
function lianmenghuizhang.onInit(container)
    CCLuaLog("lianmenghuizhang.onInit")
end

function lianmenghuizhang.onEnter(container)
	lianmenghuizhang.alreadyGotSpecialMedal = LeagueMedalInfoList_alreadyGotSpecialMedal
	container:registerPacket(OP_League_pb.OPCODE_RECEIVE_LEAGUAMEDALRET_S)
	container:registerPacket(OP_League_pb.OPCODE_CHANGE_LEAGUAMEDALRET)
    lianmenghuizhang.TabBadge(container)
end

function lianmenghuizhang.onExit(container)	
    CCLuaLog("lianmenghuizhang.onExit")
    container:removePacket(OP_League_pb.OPCODE_RECEIVE_LEAGUAMEDALRET_S)
	container:removePacket(OP_League_pb.OPCODE_CHANGE_LEAGUAMEDALRET)
end

function lianmenghuizhang.onExecute(container)

end

function lianmenghuizhang.onLoad(container)
	CCLuaLog("lianmenghuizhang.onLoad")
	container:loadCcbiFile("lianmenghuizhang.ccbi");
	CCLuaLog(container:dumpInfo())
end

function lianmenghuizhang.onUnLoad(container)
	CCLuaLog("lianmenghuizhang.onUnLoad")
end

function lianmenghuizhang.onReceivePacket(container)
	CCLuaLog("lianmenghuizhang.onReceivePacket")
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_RECEIVE_LEAGUAMEDALRET_S) then
		local msg = LeagueStruct_pb.OPReceiveLeaguaMedalRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		LeagueMedalInfoList = nil
		LeagueMedalInfoList = {}
		local gotOne = false
		for k,v in ipairs(msg._medalInfoList) do
	        --LeagueMedalInfoList[v.medalID].medalID = v.medalID
	        LeagueMedalInfoList[v.medalID] = {}
			LeagueMedalInfoList[v.medalID].ownerLeaguaID = v.ownerLeaguaID
			LeagueMedalInfoList[v.medalID].ownerLeaguaName = v.ownerLeaguaName

			if(v.medalID >2 and v.ownerLeaguaID == LeaguaBaseInfo.leaguaID) then
				gotOne = true
			end
		end
		lianmenghuizhang.alreadyGotSpecialMedal = gotOne
	    lianmenghuizhang.TabBadge(container)
	end
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_CHANGE_LEAGUAMEDALRET) then
		local msg = LeagueStruct_ext_pb.OPChangeLeaguaActiveMedalRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		if(msg.status) then
			MessageBoxPage:Msg_Box_Lan("@LianMengChangeMedalDone")
			LeaguaBaseInfo.leaguaActiveMedal = lianmenghuizhang.changingMedalID
			LianMeng_gotoMainPage()
		else
			MessageBoxPage:Msg_Box_Lan("@LeagueChangeFailed")
		end
	end
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_GET_LEAGUAMEDALRET_S) then
		local msg = LeagueStruct_pb.OPGetLeaguaMedalRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		LeagueMedalInfoList = {}
		for k,v in ipairs(msg._medalInfoList) do
	        --LeagueMedalInfoList[v.medalID].medalID = v.medalID
	        LeagueMedalInfoList[v.medalID] = {}
			LeagueMedalInfoList[v.medalID].ownerLeaguaID = v.ownerLeaguaID
			LeagueMedalInfoList[v.medalID].ownerLeaguaName = v.ownerLeaguaName
	    end
	    lianmenghuizhang.TabBadge(container)
	end
	
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_GET_MEDALCHANGEINFORET_S) then
		local msg = LeagueStruct_pb.OPGetMedalChangeInfoRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		LeagueMedalInfoList = {}
        lianmenghuizhang.ChangeMessage={}
		for k,v in ipairs(msg.MedalChangeInfoList) do
	        lianmenghuizhang.ChangeMessage[k] = v
        end
        if lianmenghuizhang.mTabIndex==2 then
            container:getVarMenuItem("mTabAll"):setEnabled(true)
            container:getVarMenuItem("mTabChange"):setEnabled(false)
            container:getVarMenuItem("mTabNews"):setEnabled(true)
        else
            container:getVarMenuItem("mTabAll"):setEnabled(true)
            container:getVarMenuItem("mTabChange"):setEnabled(true)
            container:getVarMenuItem("mTabNews"):setEnabled(false)
        end
	    lianmenghuizhang.TabChange(container)
	end

end

function lianmenghuizhang.onAll(container)
    lianmenghuizhang.mTabIndex=1
    container:getVarMenuItem("mTabAll"):setEnabled(false)
    container:getVarMenuItem("mTabChange"):setEnabled(true)
    container:getVarMenuItem("mTabNews"):setEnabled(true)
    container:registerPacket(OP_League_pb.OPCODE_GET_LEAGUAMEDALRET_S)
    local msg = LeagueStruct_pb.OPGetLeaguaMedal()
	msg.version = 1
	local pb_data = msg:SerializeToString()
	container:sendPakcet(OP_League_pb.OPCODE_GET_LEAGUAMEDAL_C,pb_data,#pb_data,true)
end

function lianmenghuizhang.onChange(container)
    container:getVarMenuItem("mTabAll"):setEnabled(true)
    container:getVarMenuItem("mTabChange"):setEnabled(false)
    container:getVarMenuItem("mTabNews"):setEnabled(true)
    lianmenghuizhang.mTabIndex=2
    container:registerPacket(OP_League_pb.OPCODE_GET_MEDALCHANGEINFORET_S)
    local msg = LeagueStruct_pb.OPGetMedalChangeInfo()
	msg.version = 1
    msg.type=1
	local pb_data = msg:SerializeToString()
	container:sendPakcet(OP_League_pb.OPCODE_GET_MEDALCHANGEINFO_C,pb_data,#pb_data,true)
end

function lianmenghuizhang.onNews(container)
    container:getVarMenuItem("mTabAll"):setEnabled(true)
    container:getVarMenuItem("mTabChange"):setEnabled(true)
    container:getVarMenuItem("mTabNews"):setEnabled(false)
    lianmenghuizhang.mTabIndex=3
	container:registerPacket(OP_League_pb.OPCODE_GET_MEDALCHANGEINFORET_S)
    local msg = LeagueStruct_pb.OPGetMedalChangeInfo()
	msg.version = 1
    msg.type=2
	local pb_data = msg:SerializeToString()
	container:sendPakcet(OP_League_pb.OPCODE_GET_MEDALCHANGEINFO_C,pb_data,#pb_data,true)
end
function lianmenghuizhang.onGameMessage(container)
	CCLuaLog("lianmenghuizhang.onGameMessage")
end

