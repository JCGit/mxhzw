require "OP_League_pb"
require "LeagueStruct_pb"
require "LeagueStruct_ext_pb"
require "IncPbCommon"

local LianMengShopPage = {}
LianMengShopPage.curCDTimeLeft = 0
LianMengShopPage.curRefreshTimeLeft = 0
function luaCreat_LianMengShopPage(container)
	container:registerFunctionHandler(LianMengShopPage.onFunction)
end

local LianMengShopContent = {}
LianMengShopContent.curBuyGoodIndex = 0

function getShopBuyGoodIndex()
	return LianMengShopContent.curBuyGoodIndex
end

function LianMengShopContent.onFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        LianMengShopContent.onRefreshItemView(container)
    elseif eventName == "onLMSBuy" then
        LianMengShopContent.onLMSBuy(container)
    elseif eventName == "onLMShop" then
	    LianMengShopContent.onLMShop(container)
    end
end

function LianMengShopContent.onRefreshItemView(container)
    local contentData = LeaguaShopInfo.shopGoodInfoList[container:getItemDate().mID]
    if contentData.goodType == 31 or contentData.goodType == 32 then --Disciple
        local item = Disciple:new_local(contentData.goodID, true, false)
        local frame = container:getVarMenuItemImage("mFace")
        frame:setNormalImage(item:getFrameNormalSpirte())
        frame:setSelectedImage(item:getFrameSelectedSpirte())
        local pic = container:getVarSprite("mLMSPic")
        pic:setTexture(item:iconPic())
        pic:setScale(0.8)
        container:getVarSprite("mEquipQuality"):setTexture(item:getQualityImageFile())
        container:getVarLabelBMFont("mLMSName"):setString(item:name())
    --[[elseif contentData.goodType == 32 then --Soul
        local item = Soul:new_local(contentData.goodID)
        local frame = container:getVarMenuItemImage("mFace")
        frame:setNormalImage(item:getFrameNormalSpirte())
        frame:setSelectedImage(item:getFrameSelectedSpirte())
        container:getVarSprite("mLMSPic"):setTexture(item:iconPic())
        container:getVarSprite("mEquipQuality"):setTexture(item:getQualityImageFile())
        container:getVarLabelBMFont("mLMSName"):setString(item:name())--]]
    elseif contentData.goodType == 50 then --equip
        local item = Equip:new_local(contentData.goodID, true, false)
        local frame = container:getVarMenuItemImage("mFace")
        frame:setNormalImage(item:getFrameNormalSpirte())
        frame:setSelectedImage(item:getFrameSelectedSpirte())
        local pic = container:getVarSprite("mLMSPic")
        pic:setTexture(item:iconPic())
        pic:setScale(0.3)
        --container:getVarSprite("mLMSPic"):setTexture(item:iconPic())
        container:getVarSprite("mEquipQuality"):setTexture(item:getQualityImageFile())
        container:getVarLabelBMFont("mLMSName"):setString(item:name())
    elseif contentData.goodType == 41 then --skill
        local item = Skill:new_local(contentData.goodID, true, false)
        local frame = container:getVarMenuItemImage("mFace")
        frame:setNormalImage(item:getFrameNormalSpirte())
        frame:setSelectedImage(item:getFrameSelectedSpirte())
        local pic = container:getVarSprite("mLMSPic")
        pic:setTexture(item:iconPic())
        pic:setScale(0.3)
        --container:getVarSprite("mLMSPic"):setTexture(item:iconPic())
        container:getVarSprite("mEquipQuality"):setTexture(item:getQualityImageFile())
        container:getVarLabelBMFont("mLMSName"):setString(item:name())
    elseif contentData.goodType == 61 then --good
        local item = ToolTableManager:getInstance():getToolItemByID(contentData.goodID);
        local frame = container:getVarMenuItemImage("mFace")
        frame:setNormalImage(CCSprite:create("mainScene/u_icobg02.png"))
        frame:setSelectedImage(CCSprite:create("mainScene/u_icobg02.png"))
        local pic = container:getVarSprite("mLMSPic")
        pic:setTexture(item.iconPic)
        pic:setScale(0.3)
        --container:getVarSprite("mLMSPic"):setTexture(item.iconPic)
        container:getVarSprite("mEquipQuality"):setVisible(false)
        container:getVarLabelBMFont("mLMSName"):setString(item.name)
    end
    
    if contentData.goodType == 32 then
        container:getVarSprite("mLMShopY"):setVisible(true)
    else
        container:getVarSprite("mLMShopY"):setVisible(false)
    end
    
    local tempLabel = container:getVarLabelBMFont("mLMSQX")
    if LeaguaBaseInfo.playerGrade < contentData.goodBuyPermissions then
        tempLabel:setVisible(true)
        local str = ""
        if contentData.goodBuyPermissions == 4 then
            str = Language:getInstance():getString("@LianMengShop_Buy1")
        elseif contentData.goodBuyPermissions == 3 then
            str = Language:getInstance():getString("@LianMengShop_Buy2")
        elseif contentData.goodBuyPermissions == 2 then
            str = Language:getInstance():getString("@LianMengShop_Buy3")
        end
        tempLabel:setString(str)
    else
        tempLabel:setVisible(false)
    end
    container:getVarLabelBMFont("mLMSNum"):setString(tostring(contentData.goodCount))
    container:getVarLabelBMFont("mLMSGold"):setString( contentData.goodPrice)
end

function LianMengShopContent.onLMSBuy(container)
    local contentData = LeaguaShopInfo.shopGoodInfoList[container:getItemDate().mID]
    if LianMengShopPage.curCDTimeLeft>0 then
        MessageBoxPage:Msg_Box_Lan("@LianMengShop_HasLeftTime")
    elseif contentData.goodBuyPermissions > LeaguaBaseInfo.playerGrade then
        MessageBoxPage:Msg_Box_Lan("@LianMengShop_BuyNoPower")
    else
	    LianMengShopContent.curBuyGoodIndex = container:getItemDate().mID
        MainFrame:getInstance():pushPage("LianMengShopBuyPage")
    end
end

function LianMengShopContent.onLMShop(container)
    return
    --[[
	local contentData = LeaguaShopInfo.shopGoodInfoList[container:getItemDate().mID]
	if contentData.goodType == 31 then --Disciple
		DiscipleHandInfoPage:showDisciplePage(contentData.goodID,true)
	elseif contentData.goodType == 32 then --Soul
        BlackBoard:getInstance().ShowSoul = contentData.goodID
		local gamemsg = MsgMainFramePushPage:new()
        gamemsg.pageName = "SoulInfoPage"
        MessageManager:getInstance():sendMessageForScript(gamemsg)  
	elseif contentData.goodType == 50 then --equip
		EquipHandInfoPage:showEquipPage(contentData.goodID,true)
	elseif contentData.goodType == 41 then --skill
		SkillHandInfoPage:showSkillPage(contentData.goodID,true)
	elseif contentData.goodType == 61 then --good
		PropInfoPage:showPropInfoPage(contentData.goodID, 2, false)
	end
    --]]
end

function LianMengShopPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengShopPage.onEnter(container)
    elseif eventName == "luaExecute" then
        LianMengShopPage.onExecute(container)
    elseif eventName == "luaReceivePacket" then
    	LianMengShopPage.onReceivePacket(container)
    elseif eventName == "luaExit" then
        LianMengShopPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengShopPage.onLoad(container)
	elseif eventName == "onLMreturnfront" then
		LianMengShopPage.onLMreturnfront(container)
    elseif eventName == "onCOButton" then
		LianMengShopPage.onCDButton(container)
    end
end

function LianMengShopPage.onCDButton(container)
	ShowDecisionPage("@LianMengShop_confirmCD" , function (confirm)
            if confirm then
                container:registerPacket(OP_League_pb.OPCODE_CLEAR_SHOPBUY_CDRET)
				local msg = LeagueStruct_ext_pb.OPClearShopBuyCd()
				msg.version = 1
				local pb_data = msg:SerializeToString()
				PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_CLEAR_SHOPBUY_CD,pb_data,#pb_data,true)
            end
        end)
end

function LianMengShopPage.onLMreturnfront(container)
    MainFrame:getInstance():showPage("LianMengBuildingPage")
end

function LianMengShopPage.onEnter(container)
	container:registerPacket(OP_League_pb.OPCODE_LEAGUASHOPBUYRET_S)
    LianMengShopPage.rebuildAllItem(container)
    LianMengShopPage.refreshPage(container)
end

function LianMengShopPage.onExecute(container)
    if TimeCalculator:getInstance():hasKey("LianMengShopCD") then
        local timeleft = TimeCalculator:getInstance():getTimeLeft("LianMengShopCD")
        if timeleft ~= LianMengShopPage.curCDTimeLeft then
            LianMengShopPage.curCDTimeLeft = timeleft
            local cdString = GameMaths:formatSecondsToTime(LianMengShopPage.curCDTimeLeft)
            container:getVarLabelBMFont("mLjsshoptime1"):setString(cdString)
        end
    end
    if TimeCalculator:getInstance():hasKey("LianMengShopRefreshTime") then
        local timeleft = TimeCalculator:getInstance():getTimeLeft("LianMengShopRefreshTime")
        if timeleft ~= LianMengShopPage.curRefreshTimeLeft then
            if timeleft == 0 then
                local msg = LeagueStruct_ext_pb.OPGetLeaguaShopInfo()
                msg.version = 1
                local pb_data = msg:SerializeToString()
                PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_GET_LEAGUASHOPINFO_C,pb_data,#pb_data,true)
            end
            LianMengShopPage.curRefreshTimeLeft = timeleft
            local cdString = GameMaths:formatSecondsToTime(LianMengShopPage.curRefreshTimeLeft)
            container:getVarLabelBMFont("mLjsshoptime2"):setString(cdString)
        end
    end
end

function LianMengShopPage.onExit(container)
    LianMengShopPage.clearAllItem(container)
    container.m_pScrollViewFacade:delete()
    container.m_pScrollViewFacade = nil
end

function LianMengShopPage.onLoad(container)
    container:loadCcbiFile("LianMengjsshop.ccbi");
    CCLuaLog(container:dumpInfo())
    container.mScrollView = container:getVarScrollView("mlmjiansheshopico")
    container.mScrollViewRootNode = container.mScrollView:getContainer()
    container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
    container.m_pScrollViewFacade:init(6,6)
end

function LianMengShopPage.refreshPage(container)
    CCLuaLog(container:dumpInfo())
    container:getVarLabelBMFont("mlmjsgongxiannum"):setString(LeaguaBaseInfo.playerLeftContribution)
    container:getVarLabelBMFont("mLMshopLVnum"):setString(LeaguaBuildingInfoList[1].buildingLevel)

    LianMengShopPage.curCDTimeLeft = LeaguaShopInfo.cdTime
    local cdString = GameMaths:formatSecondsToTime(LianMengShopPage.curCDTimeLeft)
    TimeCalculator:getInstance():createTimeCalcultor("LianMengShopCD", LianMengShopPage.curCDTimeLeft)
    container:getVarLabelBMFont("mLjsshoptime1"):setString(cdString)

    LianMengShopPage.curRefreshTimeLeft = LeaguaShopInfo.refreshTime
    local refreshTimeString = GameMaths:formatSecondsToTime(LianMengShopPage.curRefreshTimeLeft)
    TimeCalculator:getInstance():createTimeCalcultor("LianMengShopRefreshTime", LianMengShopPage.curRefreshTimeLeft)
    container:getVarLabelBMFont("mLjsshoptime2"):setString(refreshTimeString)
end

function LianMengShopPage.rebuildAllItem(container)
    LianMengShopPage.clearAllItem(container);
	LianMengShopPage.buildItem(container);
end

function LianMengShopPage.buildItem(container)
    local iMaxNode = container.m_pScrollViewFacade:getMaxDynamicControledItemViewsNum();
	local iCount = 0;
	local fOneItemHeight = 0;
	local fOneItemWidth = 0;

	for k, v in pairs(LeaguaShopInfo.shopGoodInfoList) do
		local pItemData = CCReViSvItemData:new()
		pItemData.mID = k
		pItemData.m_ptPosition = ccp(0, fOneItemHeight*iCount)

		if iCount < iMaxNode then
			local pItem = ScriptContentBase:create("lianmengjsshopcontent.ccbi")
			pItem.id = iCount
			pItem:registerFunctionHandler(LianMengShopContent.onFunction)
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

function LianMengShopPage.clearAllItem(container)
    container.m_pScrollViewFacade:clearAllItems()
    container.mScrollViewRootNode:removeAllChildren()
end

function LianMengShopPage.onReceivePacket(container)
	if container:getRecPacketOpcode() == OP_League_pb.OPCODE_LEAGUASHOPBUYRET_S then
		local msg = LeagueStruct_ext_pb.OPLeaguaShopBuyRet()
		msgbuff = container:getRecPacketBuffer()
		msg:ParseFromString(msgbuff)

		LeaguaShopInfo.cdTime = msg.cdTime
		LeaguaBaseInfo.playerLeftContribution = msg.playerContribution

		if msg:HasField("toolInfo") then
			DropManager.gotTool(msg.toolInfo)
		end

		if msg:HasField("equipInfo") then
			DropManager.gotEquipment(msg.equipInfo)
		end

		if msg:HasField("skillInfo") then
			DropManager.gotSkill(msg.skillInfo)
		end

		if msg:HasField("soulInfo") then
			DropManager.gotSoul(msg.soulInfo)
		end

		if msg:HasField("discipleInfo") then
			DropManager.gotDisciple(msg.discipleInfo)
		end

		if msg.status == 1 then
		    LeaguaShopInfo.shopGoodInfoList = {}
		    for k, v in ipairs(msg._shopGoodInfoList) do
			    LeaguaShopInfo.shopGoodInfoList[v.id] = {}
			    LeaguaShopInfo.shopGoodInfoList[v.id]["id"] = v.id
			    LeaguaShopInfo.shopGoodInfoList[v.id]["goodID"] = v.goodID
			    LeaguaShopInfo.shopGoodInfoList[v.id]["goodType"] = v.goodType
			    LeaguaShopInfo.shopGoodInfoList[v.id]["goodPrice"] = v.goodPrice
			    LeaguaShopInfo.shopGoodInfoList[v.id]["goodCount"] = v.goodCount
			    LeaguaShopInfo.shopGoodInfoList[v.id]["goodBuyPermissions"] = v.goodBuyPermissions
			    LeaguaShopInfo.shopGoodInfoList[v.id]["goodLevel"] = v.goodLevel
		    end
			MessageBoxPage:Msg_Box_Lan("@LianMengShop_BuySuccess")
		elseif msg.status == 2 then
			MessageBoxPage:Msg_Box_Lan("@LianMengShop_Buy_LowContribution")
		elseif msg.status == 3 then
			MessageBoxPage:Msg_Box_Lan("@LianMengShop_Buy_NoPower")
		elseif msg.status == 4 then
			MessageBoxPage:Msg_Box_Lan("@LianMengShop_BuyOver")
		elseif msg.status == 5 then
			MessageBoxPage:Msg_Box_Lan("@LianMengShop_Buy_DataError")
		end
		
		LianMengShopPage.onEnter(container)
	elseif container:getRecPacketOpcode() == OP_League_pb.OPCODE_CLEAR_SHOPBUY_CDRET  then
	    local msg = LeagueStruct_ext_pb.OPClearShopBuyCdRet()
		msgbuff = container:getRecPacketBuffer()
		msg:ParseFromString(msgbuff)
		
		if msg:HasField("goldcoins") then
            ServerDateManager:getInstance():getUserBasicInfo().goldcoins = msg.goldcoins
        end
		
	    if msg.status == 1 then
			MessageBoxPage:Msg_Box_Lan("@LianMengShop_RefreshCD_success")
			LeaguaShopInfo["cdTime"] = 0
			LianMengShopPage.curCDTimeLeft = LeaguaShopInfo.cdTime
			local cdString = GameMaths:formatSecondsToTime(LianMengShopPage.curCDTimeLeft)
			TimeCalculator:getInstance():createTimeCalcultor("LianMengShopCD", LianMengShopPage.curCDTimeLeft)
			container:getVarLabelBMFont("mLjsshoptime1"):setString(cdString)
		elseif msg.status == 2 then
			MessageBoxPage:Msg_Box_Lan("@LianMengShop_RefreshCD_faild")
	    end
	end
end
