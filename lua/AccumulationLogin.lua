require "AccumulationLogin_pb"
local count
AccumulationLoginContent = {}
local AccumulationStatusLogin = {}
AccumulationLoginRewards = {}
local curScale = 0
local discipleScale = 0

function AccumulationLoginContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        AccumulationLoginContent.onRefreshItemView(container)
    elseif eventName == "onDraw" then
        AccumulationLoginContent.onDraw(container)
    end
end

function AccumulationLoginContent.onRefreshItemView(container)
    
    local id = container:getItemDate().mID
    
    local days = AccumulationLoginRewards[id].days
    local rewardContent = AccumulationLoginRewards[id].rewardContent
    
    local rewardIterms = Split(rewardContent, ",", 5)   
    local rewardIterms1 = Split(rewardIterms[1], ":", 5)   
    local rewardIterms2 = Split(rewardIterms[2], ":", 5)   
    local rewardIterms3 = Split(rewardIterms[3], ":", 5)   
    
    AccumulationLoginContent.info1=ResManager:getInstance():getResInfoByTypeAndId(rewardIterms1[1],rewardIterms1[2],rewardIterms1[3])
    AccumulationLoginContent.info2=ResManager:getInstance():getResInfoByTypeAndId(rewardIterms2[1],rewardIterms2[2],rewardIterms2[3])
    AccumulationLoginContent.info3=ResManager:getInstance():getResInfoByTypeAndId(rewardIterms3[1],rewardIterms3[2],rewardIterms3[3])
                 
    local scale = container:getVarSprite("mTLCIcoPic1"):getScale()   
    if curScale == 0 then
        curScale = scale
    end
    if discipleScale == 0 then
        discipleScale = scale * 2.5
    end
    local quality1=AccumulationLoginContent.info1.quality
    container:getVarSprite("mTLCIcoPic1"):setTexture(AccumulationLoginContent.info1.icon)
    if AccumulationLoginContent.info1.type==DISCIPLE_TYPE or AccumulationLoginContent.info1.type==SOUL_TYPE or AccumulationLoginContent.info1.type == 32001 then
        container:getVarSprite("mTLCIcoPic1"):setScale(discipleScale)
    elseif AccumulationLoginContent.info1.type==USER_PROPERTY_TYPE or AccumulationLoginContent.info1.type==TOOLS_TYPE then
        quality1=4
        container:getVarSprite("mTLCIcoPic1"):setScale(curScale)
    else
        container:getVarSprite("mTLCIcoPic1"):setScale(curScale)
    end
    if quality1>4 or quality1<1 then
        quality1=4
    end
    container:getVarMenuItemImage("mTDLCQuality1"):setNormalImage(getFrameNormalSpirte(quality1))
    container:getVarMenuItemImage("mTDLCQuality1"):setSelectedImage(getFrameSelectedSpirte(quality1))
    container:getVarLabelBMFont("mTLCEqName1"):setString(AccumulationLoginContent.info1.name .. "X" .. AccumulationLoginContent.info1.count)


    local quality2=AccumulationLoginContent.info2.quality
    container:getVarSprite("mTLCIcoPic2"):setTexture(AccumulationLoginContent.info2.icon)
    if AccumulationLoginContent.info2.type==DISCIPLE_TYPE or AccumulationLoginContent.info2.type==SOUL_TYPE or AccumulationLoginContent.info2.type == 32001 then
        container:getVarSprite("mTLCIcoPic2"):setScale(discipleScale)
    elseif AccumulationLoginContent.info2.type==USER_PROPERTY_TYPE or AccumulationLoginContent.info2.type==TOOLS_TYPE then
        quality2=4
        container:getVarSprite("mTLCIcoPic2"):setScale(curScale)
    else
        container:getVarSprite("mTLCIcoPic2"):setScale(curScale)
    end
    if quality2>4 or quality2<1 then
        quality2=4
    end
    container:getVarMenuItemImage("mTDLCQuality2"):setNormalImage(getFrameNormalSpirte(quality2))
    container:getVarMenuItemImage("mTDLCQuality2"):setSelectedImage(getFrameSelectedSpirte(quality2))
    container:getVarLabelBMFont("mTLCEqName2"):setString(AccumulationLoginContent.info2.name .. "X" .. AccumulationLoginContent.info2.count)
    
    
    local quality3=AccumulationLoginContent.info3.quality
    container:getVarSprite("mTLCIcoPic3"):setTexture(AccumulationLoginContent.info3.icon)
    if AccumulationLoginContent.info3.type==DISCIPLE_TYPE or AccumulationLoginContent.info3.type==SOUL_TYPE or AccumulationLoginContent.info3.type == 32001 then
        container:getVarSprite("mTLCIcoPic3"):setScale(discipleScale)
    elseif AccumulationLoginContent.info3.type==USER_PROPERTY_TYPE or AccumulationLoginContent.info3.type==TOOLS_TYPE then
        quality3=4
        container:getVarSprite("mTLCIcoPic3"):setScale(curScale)
    else
        container:getVarSprite("mTLCIcoPic3"):setScale(curScale)
    end
    if quality3>4 or quality3<1 then
        quality3=4
    end
    container:getVarMenuItemImage("mTDLCQuality3"):setNormalImage(getFrameNormalSpirte(quality3))
    container:getVarMenuItemImage("mTDLCQuality3"):setSelectedImage(getFrameSelectedSpirte(quality3))
    container:getVarLabelBMFont("mTLCEqName3"):setString(AccumulationLoginContent.info3.name .. "X" .. AccumulationLoginContent.info3.count)
    
    container:getVarLabelBMFont("mDaysNum"):setString(days)
    
    local rewardStr = Language:getInstance():getString("@GetReward")
    local getRewardStr = Language:getInstance():getString("@AlreadyGetReward")


    if AccumulationStatusLogin[id] == 0 then
        container:getVarMenuItemImage("mTDLCDraw"):setEnabled(true)
    else
        container:getVarMenuItemImage("mTDLCDraw"):setEnabled(false)
    end
    
    if AccumulationStatusLogin[id] == 1 then
        container:getVarLabelBMFont("mTDLCDrawText"):setString(getRewardStr)
    else
        container:getVarLabelBMFont("mTDLCDrawText"):setString(rewardStr)
    end
    
  
   
end

function AccumulationLoginContent.onReceivePacket(container)
	if container:getRecPacketOpcode()==250 then
        local msg = AccumulationLogin_pb.OPAccumulationLoginGetRewardRet()
        local msgbuff = container:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
            
    end
end



function AccumulationLoginContent.sendLoginReward(container)
    
    local msg = AccumulationLogin_pb.OPAccumulationLoginGetReward()
	msg.version = 1
	msg.id = AccumulationLoginRewards[container:getItemDate().mID].index + 0
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(249,pb_data,#pb_data,true)
end

function AccumulationLoginContent.onDraw(container)
    AccumulationLoginContent.sendLoginReward(container)
end

AccumulationLogin = {}

function AccumulationLogin.onFunction(eventName,container)
    CCLuaLog("eventName"..eventName);
    if eventName == "luaInit" then
        AccumulationLogin.onInit(container)
    elseif eventName == "luaEnter" then
        AccumulationLogin.onEnter(container)
    elseif eventName == "luaExit" then
        AccumulationLogin.onExit(container)
    elseif eventName == "luaExecute" then
        AccumulationLogin.onExecute(container)
    elseif eventName == "luaLoad" then
        AccumulationLogin.onLoad(container)
    elseif eventName == "luaUnLoad" then
        AccumulationLogin.onUnLoad(container)
    elseif eventName == "luaGameMessage" then
        AccumulationLogin.onGameMessage(container)
    elseif eventName == "luaReceivePacket" then
        AccumulationLogin.onReceivePacket(container)
    end
end

function AccumulationLogin.onInit(container)
end

function AccumulationLogin.onAnimationDone(container)
end



function AccumulationLogin.sendLoginInfo(container)

    local msg = AccumulationLogin_pb.OPAccumulationLoginInfo()
	msg.version = 1
	local pb_data = msg:SerializeToString()
	PacketManager:getInstance():sendPakcet(247,pb_data,#pb_data,true)
    
end

function AccumulationLogin.onReceivePacket(container)
    
	if container:getRecPacketOpcode()==248 then
        local msg = AccumulationLogin_pb.OPAccumulationLoginInfoRet()
        msgbuff = container:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
	    local statusLogin = json.decode(msg.loginStatus)

        table.sort(AccumulationLoginRewards, 
            function (e1, e2)
                if not e2 then return true end
                if not e1 then return false end
                  
                return e1.days + 0 > e2.days + 0
            end
        )

	    for i = 1,count do
	    
	        if statusLogin[AccumulationLoginRewards[i].index] == 1 then
	            AccumulationStatusLogin[i] = statusLogin[AccumulationLoginRewards[i].index]
	        else
	            AccumulationStatusLogin[i] = 0
	        end
	        if AccumulationLoginRewards[i].days + 0 > statusLogin["c"] then
	            AccumulationStatusLogin[i] = -1
	        end
	    end
             
        
    AccumulationLogin.rebuildAllItem(container)
    elseif container:getRecPacketOpcode()==250 then
        local msg = AccumulationLogin_pb.OPAccumulationLoginGetRewardRet()
        msgbuff = container:getRecPacketBuffer();
	    msg:ParseFromString(msgbuff)
	    
	    
        for k, info in ipairs(msg.soulInfo) do
            DropManager.gotSoul(info)
        end 
        for k, info in ipairs(msg.skillInfo) do
            DropManager.gotSkill(info)
        end 
        for k, info in ipairs(msg.equipInfo) do
            DropManager.gotEquipment(info)
        end 
        for k, info in ipairs(msg.toolInfo) do
			DropManager.gotTool(info)
        end 
        for k, info in ipairs(msg.disciple) do
            DropManager.gotDisciple(info)
        end 
        

        if msg:HasField("power") then
            ServerDateManager:getInstance():getUserBasicInfo().power=msg.power
        end
        if msg:HasField("vitality") then
            ServerDateManager:getInstance():getUserBasicInfo().vitality=msg.vitality
        end
        if msg:HasField("exp") then
            ServerDateManager:getInstance():getUserBasicInfo().exp=msg.exp
        end
        if msg:HasField("goldcoins") then
            ServerDateManager:getInstance():getUserBasicInfo().goldcoins=msg.goldcoins
        end
        if msg:HasField("silvercoins") then
           ScriptMathToLua:modifySilverCoins(msg.silvercoins)
        end
        AccumulationLogin.sendLoginInfo(container)


        GoodsViewPage.mViewGoodsListInfo={}
        GoodsViewPage.mTitle="@AccumulationLoginRewardTitle"
        GoodsViewPage.mMsgContent="@AccumulationLoginRewardContent"
        
        for i = 1,#msg.reward do
            local reward=ResManager:getInstance():getResInfoByTypeAndId(msg.reward[i].itemType,msg.reward[i].itemId,msg.reward[i].count)
            GoodsViewPage.mViewGoodsListInfo[i]={}
            GoodsViewPage.mViewGoodsListInfo[i].type=reward.type
            GoodsViewPage.mViewGoodsListInfo[i].name=reward.name
            GoodsViewPage.mViewGoodsListInfo[i].icon=reward.icon
            GoodsViewPage.mViewGoodsListInfo[i].count=reward.count
            GoodsViewPage.mViewGoodsListInfo[i].quality=reward.quality
        end
        
        MainFrame:getInstance():pushPage("GoodsShowListPage")
	end
    
end

function AccumulationLogin.onEnter(container)
    container:registerPacket(248)
    container:registerPacket(250)
    
    AccumulationLogin.onShowRewards(container)
    AccumulationLogin.sendLoginInfo(container)
end

function AccumulationLogin.onExit(container)    
    CCLuaLog("AccumulationLogin.onExit")
    AccumulationLogin.mShowAni=false

    container:removePacket(248)
    container:removePacket(250)

end

function AccumulationLogin.onExecute(container)

end

function AccumulationLogin.changePowerStatus(container)
    return
    
end

function AccumulationLogin.onLoad(container)
    container:loadCcbiFile("TeacherDayLogin.ccbi")	
    container.mScrollView = container:getVarScrollView("mTDGSv")
	container.mScrollViewRootNode = container.mScrollView:getContainer()
	container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
	container.m_pScrollViewFacade:init(6,6)

end

function AccumulationLogin.onShowRewards(container)
    if AccumulationLoginRewards==nil or table.maxn(AccumulationLoginRewards)<=0 then
        local tabel = TableReaderManager:getInstance():getTableReader("AccumulationLoginConfig.txt")
        count = tabel:getLineCount()-1;
        for i = 1,count do
            local index = tonumber(tabel:getData(i,0))
            if AccumulationLoginRewards[index] == nil then
                AccumulationLoginRewards[index] = {}
                AccumulationLoginRewards[index].index = tabel:getData(i,0)
                AccumulationLoginRewards[index].days = tabel:getData(i,1)
                AccumulationLoginRewards[index].rewardContent = tabel:getData(i,2)
            end        
        end
    end
end

function AccumulationLogin.rebuildAllItem(container)
    AccumulationLogin.clearAllItem(container)
    AccumulationLogin.buildItem(container)
end

function AccumulationLogin.clearAllItem(container)
    container.m_pScrollViewFacade:clearAllItems()
    container.mScrollViewRootNode:removeAllChildren()
end

function AccumulationLogin.buildItem(container)
    local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
	local iCount = 0;
	local fOneItemHeight = 0;
	local fOneItemWidth = 0;
    AccumulationLoginRewardsCopy = AccumulationLoginRewards;
	

	
	for k, v in pairs(AccumulationLoginRewards) do
		local pItemData = CCReViSvItemData:new()
		pItemData.mID =  k
		pItemData.m_iIdx = iCount
		pItemData.m_ptPosition = ccp(0, fOneItemHeight*iCount)

		if iCount < iMaxNode then
			local pItem = ScriptContentBase:create("TeacherDayLoginContent.ccbi")
			pItem.id = iCount
			pItem:registerFunctionHandler(AccumulationLoginContent.onFunction)
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



function AccumulationLogin.onUnLoad(container)
    CCLuaLog("AccumulationLogin.onUnLoad");
end


function AccumulationLogin.onGameMessage(container)
    CCLuaLog("AccumulationLogin.onGameMessage")
    --[[
    if container:getMessageID()==1 then
        CCLuaLog("!!!special message")
        CCLuaLog(container:getMessagePara())
    end
    --]]
end

function luaCreat_AccumulationLogin(container)
    CCLuaLog("OnCreat_AccumulationLogin")
    container:registerFunctionHandler(AccumulationLogin.onFunction)
end

