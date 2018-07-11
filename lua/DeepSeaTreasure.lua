require "DeepwaterExplore_pb"
require "IncPbCommon"
require "GoodsShowSinglePage"
DeepSeaTreasure = {}

DeepSeaTreasure.mIsInitData = false
DeepSeaTreasure.mIsFirstIn = true
DeepSeaTreasure.msg={lastTimes1=0,lastTimes2=0,lastTimes3=0}
DeepSeaTreasure.mConsume={[1]={type=0,price=0},[2]={type=0,price=0},[3]={type=0,price=0}}
DeepSeaTreasure.mCurrTab=1
DeepSeaTreasure.mAnimationTable={}
DeepSeaTreasure.mAnimationIndex=0
DeepSeaTreasure.mShowAni=false
DeepSeaTreasure.mRewardRes={}
DeepSeaTreasure.mLastInitDay=0
DeepSeaTreasure.isHavSkillBook=false
function DeepSeaTreasure.onFunction(eventName,container)
    CCLuaLog("eventName"..eventName);
    if eventName == "luaInit" then
        DeepSeaTreasure.onInit(container)
    elseif eventName == "luaEnter" then
        DeepSeaTreasure.onEnter(container)
    elseif eventName == "luaExit" then
        DeepSeaTreasure.onExit(container)
    elseif eventName == "luaExecute" then
        DeepSeaTreasure.onExecute(container)
    elseif eventName == "luaLoad" then
        DeepSeaTreasure.onLoad(container)
    elseif eventName == "luaUnLoad" then
        DeepSeaTreasure.onUnLoad(container)
    elseif eventName == "luaGameMessage" then
        DeepSeaTreasure.onGameMessage(container)
    elseif eventName == "luaReceivePacket" then
        DeepSeaTreasure.onReceivePacket(container)
    elseif eventName == "onShowNormal" then
        DeepSeaTreasure.onShowNormal(container)
    elseif eventName == "onShowBoutique" then
        DeepSeaTreasure.onShowBoutique(container)
    elseif eventName == "onShowNosuch" then
        DeepSeaTreasure.onShowNosuch(container)   
    elseif eventName == "onGetReward1" then
        DeepSeaTreasure.onGetReward1(container)      
    elseif eventName == "onGetReward2" then
        DeepSeaTreasure.onGetReward2(container)  
    elseif eventName == "onGetReward3" then
        DeepSeaTreasure.onGetReward3(container)    
    elseif eventName == "luaOnAnimationDone" then
        DeepSeaTreasure.onAnimationDone(container)    
    end
end

function DeepSeaTreasure.onInit(container)
     DeepSeaTreasure.mShowAni=false
     MainFrame:getInstance():hideNoTouch()
     if DeepSeaTreasureTable == nil then
		local tablemgr = TableReaderManager:getInstance()
		local tabel = tablemgr:getTableReader("DeepSeaTreasure.txt")
		local count = tabel:getLineCount()-1;
		DeepSeaTreasureTable = {}
		for i = 1,count do
			DeepSeaTreasureTable[i] = {}
			DeepSeaTreasureTable[i].index = tabel:getData(i,0)
			DeepSeaTreasureTable[i].type = tabel:getData(i,1)
			DeepSeaTreasureTable[i].itemId = tabel:getData(i,2)
			DeepSeaTreasureTable[i].level = tabel:getData(i,3)
			DeepSeaTreasureTable[i].count = tabel:getData(i,4)
			DeepSeaTreasureTable[i].iconpic = tabel:getData(i,5)
			DeepSeaTreasureTable[i].symbolpic = tabel:getData(i,6)
		end 
	end
end

function DeepSeaTreasure.onAnimationDone(container)
    if DeepSeaTreasure.mShowAni then
        if DeepSeaTreasure.mAnimationIndex<8 then
            DeepSeaTreasure.mAnimationIndex=DeepSeaTreasure.mAnimationIndex+1
            container:runAnimation("animation"..DeepSeaTreasure.mAnimationTable[DeepSeaTreasure.mAnimationIndex].aniName)
        else
            DeepSeaTreasure.mShowAni=false
            MainFrame:getInstance():hideNoTouch()
            DeepSeaTreasure.mAnimationIndex=0
            DeepSeaTreasure.mAnimationTable={}
            container:runAnimation("Default Timeline")
            if DeepSeaTreasure.mRewardRes.index>=1 and DeepSeaTreasure.mRewardRes.index<=24 then    
                local _count=DeepSeaTreasureTable[DeepSeaTreasure.mRewardRes.index].count
                if DeepSeaTreasure.mRewardRes.count~=0 then
                _count=DeepSeaTreasure.mRewardRes.count
                end
                local _itemId=DeepSeaTreasureTable[DeepSeaTreasure.mRewardRes.index].itemId
                if DeepSeaTreasure.mRewardRes.itemId~=0 then
                    _itemId=DeepSeaTreasure.mRewardRes.itemId
                end
                --GoodsPopupPage:showGoodsPopup(DeepSeaTreasureTable[DeepSeaTreasure.mRewardRes.index].type,_itemId,_count,DeepSeaTreasure.mRewardRes.partId)
                GoodsShowSingleInfo.mType=DeepSeaTreasureTable[DeepSeaTreasure.mRewardRes.index].type
                GoodsShowSingleInfo.mItemId=_itemId
                GoodsShowSingleInfo.mCount=_count
                GoodsShowSingleInfo.mPartId=DeepSeaTreasure.mRewardRes.partId
                GoodsShowSingleInfo.mHelp="@DeepSeaHelp"
                local msg = MsgMainFramePushPage:new()
                msg.pageName = "GoodsShowSinglePage"
                MessageManager:getInstance():sendMessageForScript(msg)
            end
            DeepSeaTreasure.mRewardRes={}
        end
    end
end

function DeepSeaTreasure.onEnter(container)
    container:registerMessage(3)--[[MSG_MAINFRAME_POPPAGE]]
    container:getVarNode("mSilverCoin"):setVisible(true)
    container:getVarNode("mGoldCoin"):setVisible(false)
    container:getVarMenuItemImage("mGetReward1"):setVisible(true)
    container:getVarMenuItemImage("mGetReward2"):setVisible(false)
    container:getVarMenuItemImage("mGetReward3"):setVisible(false)
    if DeepSeaTreasure.mCurrTab==1 then
        DeepSeaTreasure.onShowNormal(container)
    elseif DeepSeaTreasure.mCurrTab==2 then
        DeepSeaTreasure.onShowBoutique(container)
    else
        DeepSeaTreasure.onShowNosuch(container)
    end    
    container:runAnimation("Default Timeline")
    container:registerPacket(276)
    if DeepSeaTreasure.mLastInitDay==0 then
        DeepSeaTreasure.mLastInitDay=os.date("*t").day
    else
        local currDay=os.date("*t").day
        if DeepSeaTreasure.mLastInitDay~=currDay and os.date("*t").min>10 then
            DeepSeaTreasure.mIsInitData=false
            DeepSeaTreasure.mLastInitDay=currDay
        end
    end    
            
    if not DeepSeaTreasure.mIsInitData then
        local msg = DeepwaterExplore_pb.OPDeepWaterExplore()
        msg.version = 1
        local pb_data = msg:SerializeToString()
        container:sendPakcet(275,pb_data,#pb_data,true)
    end
end

function DeepSeaTreasure.onShowContent(container,_end)
    for i=1, 8 do 
        local _showIndex=i+_end;
        local info={}
        local quality=4
        if DeepSeaTreasureTable[_showIndex].iconpic~="none" then
            container:getVarSprite("mHeadPic"..i):setTexture(DeepSeaTreasureTable[_showIndex].iconpic)
        else
            info=ResManager:getInstance():getResInfoByTypeAndId(DeepSeaTreasureTable[_showIndex].type,DeepSeaTreasureTable[_showIndex].itemId,DeepSeaTreasureTable[_showIndex].count)
            quality=info.quality  
            container:getVarSprite("mHeadPic"..i):setTexture(info.icon)
        end
        if DeepSeaTreasureTable[_showIndex].symbolpic~="none" then
            container:getVarSprite("mGrade"..i):setVisible(true)
            container:getVarSprite("mGrade"..i):setTexture(DeepSeaTreasureTable[_showIndex].symbolpic)
        else
            container:getVarSprite("mGrade"..i):setVisible(false)
        end  
        local _type=ResManager:getInstance():getResMainType(DeepSeaTreasureTable[_showIndex].type)
        if _type==DISCIPLE_TYPE or _type==SOUL_TYPE then
            container:getVarSprite("mHeadPic"..i):setScale(1.0)
        elseif _type==USER_PROPERTY_TYPE or _type==TOOLS_TYPE then
            quality=4   
        end
        if quality>4 or quality<1 then
            quality=4
        end
        local color = VaribleManager:getInstance():getSetting("FrameColor_Quality"..tostring(quality))
        local colorRGB=StringConverter:parseColor3B(color)
        container:getVarSprite("mFace"..i):setColor(colorRGB)
        local node = container:getVarNode("mcontrollable"..i)
        if tonumber(DeepSeaTreasureTable[_showIndex].level)>0 then
            node:setVisible(true)
            container:getVarSprite("mQlyFrame"..i):setColor(colorRGB)
            container:getVarLabelBMFont("mQuantity"..i):setString(DeepSeaTreasureTable[_showIndex].level)
        else
            node:setVisible(false)
        end

        if tonumber(DeepSeaTreasureTable[_showIndex].count)>1 then
            container:getVarSprite("mPic"..i):setVisible(true)
            container:getVarLabelBMFont("mNumber"..i):setVisible(true)
            container:getVarLabelBMFont("mNumber"..i):setString(tostring(DeepSeaTreasureTable[_showIndex].count))
        else
            container:getVarSprite("mPic"..i):setVisible(false)
            container:getVarLabelBMFont("mNumber"..i):setVisible(false)
        end

    end 
end

function DeepSeaTreasure.onExit(container)    
    CCLuaLog("DeepSeaTreasure.onExit")
    DeepSeaTreasure.mShowAni=false
    container:removePacket(276)
    container:removeMessage(3)--[[MSG_MAINFRAME_POPPAGE]]
end

function DeepSeaTreasure.onExecute(container)

end

function DeepSeaTreasure.changePowerStatus(container)
    return
    
end

function DeepSeaTreasure.onLoad(container)
    container:loadCcbiFile("DeepSeaTreasure.ccbi")
    container:getVarNode("mSilverCoin"):setVisible(true)
    container:getVarNode("mGoldCoin"):setVisible(false)
    container:getVarMenuItemImage("mGetReward1"):setVisible(true)
    container:getVarMenuItemImage("mGetReward2"):setVisible(false)
    container:getVarMenuItemImage("mGetReward3"):setVisible(false)
end

function DeepSeaTreasure.onUnLoad(container)
    CCLuaLog("DeepSeaTreasure.onUnLoad");
end

function DeepSeaTreasure.onShowNormal(container)
    DeepSeaTreasure.mCurrTab=1
    container:getVarMenuItemImage("mTab1"):selected()
    container:getVarMenuItemImage("mTab2"):unselected()
    container:getVarMenuItemImage("mTab3"):unselected()
    DeepSeaTreasure.onShowContent(container,0)
    if DeepSeaTreasure.mIsInitData then
        DeepSeaTreasure.onShowSurplusDay(container)
        local str=Language:getInstance():getString("@DeeSeaSurplusTimes")
        str=string.gsub(str,"#v1#",tostring(DeepSeaTreasure.msg.lastTimes1))
        container:getVarLabelBMFont("mSurplusTimes"):setString(str)
        CCLuaLog(StringConverter:toString(ServerDateManager:getInstance():getUserBasicInfo().silvercoins))
        container:getVarLabelBMFont("mAlreadyGotNum"):setString(StringConverter:toString(ServerDateManager:getInstance():getUserBasicInfo().silvercoins))
        container:getVarLabelBMFont("mNeedNum"):setString(StringConverter:toString(DeepSeaTreasure.mConsume[1].price))
        container:getVarNode("mSilverCoin"):setVisible(true)
        container:getVarNode("mGoldCoin"):setVisible(false)
        container:getVarMenuItemImage("mGetReward1"):setVisible(true)
        container:getVarMenuItemImage("mGetReward2"):setVisible(false)
        container:getVarMenuItemImage("mGetReward3"):setVisible(false)
    end
end

function DeepSeaTreasure.onShowBoutique(container)
    DeepSeaTreasure.mCurrTab=2
    container:getVarMenuItemImage("mTab1"):unselected()
    container:getVarMenuItemImage("mTab2"):selected()
    container:getVarMenuItemImage("mTab3"):unselected()
    DeepSeaTreasure.onShowContent(container,8)
    if DeepSeaTreasure.mIsInitData then
        DeepSeaTreasure.onShowSurplusDay(container)
        local str=Language:getInstance():getString("@DeeSeaSurplusTimes")
        str=string.gsub(str,"#v1#",tostring(DeepSeaTreasure.msg.lastTimes2))
        container:getVarLabelBMFont("mSurplusTimes"):setString(str)
        container:getVarLabelBMFont("mAlreadyGotNum"):setString(tostring(ServerDateManager:getInstance():getUserBasicInfo().goldcoins))
        container:getVarLabelBMFont("mNeedNum"):setString(StringConverter:toString(DeepSeaTreasure.mConsume[2].price))
        container:getVarNode("mSilverCoin"):setVisible(false)
        container:getVarNode("mGoldCoin"):setVisible(true)
        container:getVarMenuItemImage("mGetReward1"):setVisible(false)
        container:getVarMenuItemImage("mGetReward2"):setVisible(true)
        container:getVarMenuItemImage("mGetReward3"):setVisible(false)
    end
end

function DeepSeaTreasure.onShowNosuch(container)
    DeepSeaTreasure.mCurrTab=3
    container:getVarMenuItemImage("mTab1"):unselected()
    container:getVarMenuItemImage("mTab2"):unselected()
    container:getVarMenuItemImage("mTab3"):selected()
    DeepSeaTreasure.onShowContent(container,16)
    if DeepSeaTreasure.mIsInitData then
        DeepSeaTreasure.onShowSurplusDay(container)
        local str=Language:getInstance():getString("@DeeSeaSurplusTimes")
        str=string.gsub(str,"#v1#",tostring(DeepSeaTreasure.msg.lastTimes3))
        container:getVarLabelBMFont("mSurplusTimes"):setString(str)
        container:getVarLabelBMFont("mAlreadyGotNum"):setString(tostring(ServerDateManager:getInstance():getUserBasicInfo().goldcoins))
        container:getVarLabelBMFont("mNeedNum"):setString(StringConverter:toString(DeepSeaTreasure.mConsume[3].price))
        container:getVarNode("mSilverCoin"):setVisible(false)
        container:getVarNode("mGoldCoin"):setVisible(true)
        container:getVarMenuItemImage("mGetReward1"):setVisible(false)
        container:getVarMenuItemImage("mGetReward2"):setVisible(false)
        container:getVarMenuItemImage("mGetReward3"):setVisible(true)
    end
end

function DeepSeaTreasure.onShowSurplusDay(container)
        local str=Language:getInstance():getString("@lastDays")
        str=string.gsub(str,"#v1#",tostring(DeepSeaTreasure.msg.lastDays))
        container:getVarLabelBMFont("mSurplusDay"):setString(str)
end

function DeepSeaTreasure.onGetReward1(container)
    if DeepSeaTreasure.mShowAni==false then
        if ScriptMathToLua:compareSilverCoins(DeepSeaTreasure.mConsume[1].price) and DeepSeaTreasure.msg.lastTimes1>0 then
            local msg = DeepwaterExplore_pb.OPDeepWaterExplore()
                msg.version = 1
                msg.kind=1
                local pb_data = msg:SerializeToString()
                container:sendPakcet(275,pb_data,#pb_data,true)
        elseif DeepSeaTreasure.msg.lastTimes1<=0 then
            MessageBoxPage:Msg_Box_Lan("@DeeSeaTreasureTimesNotEnougth")
        else
            MessageBoxPage:Msg_Box_Lan("@SilverCoinsNotEnougth")
        end
    end
end

function DeepSeaTreasure.onGetReward2(container)
    if DeepSeaTreasure.mShowAni==false then
        if DeepSeaTreasure.mConsume[2].price>ServerDateManager:getInstance():getUserBasicInfo().goldcoins then
            PopupPage:Pop_Box(NotEnoughGold)
        elseif DeepSeaTreasure.msg.lastTimes2<=0 then
            MessageBoxPage:Msg_Box_Lan("@DeeSeaTreasureTimesNotEnougth")
        else
            local msg = DeepwaterExplore_pb.OPDeepWaterExplore()
                msg.version = 1
                msg.kind=2
                local pb_data = msg:SerializeToString()
                container:sendPakcet(275,pb_data,#pb_data,true)
        end
    end
end

function DeepSeaTreasure.onGetReward3(container)
    if DeepSeaTreasure.mShowAni==false then
        if DeepSeaTreasure.mConsume[2].price>ServerDateManager:getInstance():getUserBasicInfo().goldcoins then
            PopupPage:Pop_Box(NotEnoughGold)
        elseif DeepSeaTreasure.msg.lastTimes3<=0 then
            MessageBoxPage:Msg_Box_Lan("@DeeSeaTreasureTimesNotEnougth")
        else
            local msg = DeepwaterExplore_pb.OPDeepWaterExplore()
                msg.version = 1
                msg.kind=3
                local pb_data = msg:SerializeToString()
                container:sendPakcet(275,pb_data,#pb_data,true)
        end      
    end  
end

function DeepSeaTreasure.onReceivePacket(container)
    if container:getRecPacketOpcode()==276 then
        DeepSeaTreasure.mIsInitData = true;
        local msg = DeepwaterExplore_pb.OPDeepWaterExploreRet()
        msgbuff = container:getRecPacketBuffer();
        msg:ParseFromString(msgbuff)
        DeepSeaTreasure.msg.lastTimes1=msg.lastTimes1
        DeepSeaTreasure.msg.lastTimes2=msg.lastTimes2
        DeepSeaTreasure.msg.lastTimes3=msg.lastTimes3
        DeepSeaTreasure.msg.lastDays=msg.lastDays
        if msg:HasField("goldcoins") then
            ServerDateManager:getInstance():getUserBasicInfo().goldcoins=msg.goldcoins
        end
        if msg:HasField("silvercoins") then
           ScriptMathToLua:modifySilverCoins(msg.silvercoins)
        end
        if msg:HasField("selectedId") then
            CCLuaLog("selectedId:"..msg.selectedId)
            DeepSeaTreasure.mRewardRes={}
            DeepSeaTreasure.mRewardRes.index=(DeepSeaTreasure.mCurrTab-1)*8+msg.selectedId+1
            DeepSeaTreasure.mRewardRes.itemId=0
            DeepSeaTreasure.mRewardRes.count=0
            DeepSeaTreasure.mRewardRes.partId=0
            if msg:HasField("addSilvercoins") then
                DeepSeaTreasure.mRewardRes.count=msg.addSilvercoins
            end
            if msg:HasField("addGoldcoins") then
                DeepSeaTreasure.mRewardRes.count=msg.addGoldcoins
            end
            DeepSeaTreasure.isHavSkillBook=false
            for k, info in ipairs(msg.skillbookInfo) do
                DeepSeaTreasure.mRewardRes.count=1
                DeepSeaTreasure.mRewardRes.itemId=info.skillId
--                local msgs = AdventureInfo_pb.OPAdventureInfo()
--                msgs.version = 1
--                local pb_data = msgs:SerializeToString()
--                container:sendPakcet(105,pb_data,#pb_data,true)
                DropManager.gotSkillBook(info)
                DeepSeaTreasure.isHavSkillBook=true
            end 
            for k, info in ipairs(msg.soulInfo) do
                DropManager.gotSoul(info)
                DeepSeaTreasure.mRewardRes.count=info.count
                DeepSeaTreasure.mRewardRes.itemId=info.itemid
            end 
            for k, info in ipairs(msg.skillInfo) do
                DropManager.gotSkill(info)
                DeepSeaTreasure.mRewardRes.count=info.level
                DeepSeaTreasure.mRewardRes.itemId=info.itemid
            end 
            for k, info in ipairs(msg.equipInfo) do
                DeepSeaTreasure.mRewardRes.count=info.level
                DeepSeaTreasure.mRewardRes.itemId=info.itemid
                DropManager.gotEquipment(info)
            end 
            for k, info in ipairs(msg.toolInfo) do
                local userToolInfo = ServerDateManager:getInstance():getAndCreatToolInfo(info.id)
                if info.count>userToolInfo.count then
                    DeepSeaTreasure.mRewardRes.count=info.count-userToolInfo.count
                else    
                    DeepSeaTreasure.mRewardRes.count=info.count
                end
                DeepSeaTreasure.mRewardRes.itemId=info.itemid
                DropManager.gotTool(info)
            end 
            for k, info in ipairs(msg.discipleInfo) do
                DeepSeaTreasure.mRewardRes.count=info.level
                DeepSeaTreasure.mRewardRes.itemId=info.itemid
                DropManager.gotDisciple(info)
            end 
            if msg:HasField("addExp") then
                CCLuaLog("DeepSeaTreasure.onReceivePacket addExp")
            end
            for i=1,7 do
                DeepSeaTreasure.mAnimationTable[i]={}
                DeepSeaTreasure.mAnimationTable[i].aniName=math.random(8)
            end
            DeepSeaTreasure.mAnimationTable[8]={}
            DeepSeaTreasure.mAnimationTable[8].aniName=msg.selectedId+1
            DeepSeaTreasure.mAnimationIndex=0
            DeepSeaTreasure.mShowAni=true
            MainFrame:getInstance():showNoTouch()
            container:runAnimation("Start")  
        end
        
        if DeepSeaTreasure.mIsFirstIn then 
            for k, _var in ipairs(msg.costInfo) do
                DeepSeaTreasure.mConsume[_var.kind].type=_var.costType
                DeepSeaTreasure.mConsume[_var.kind].price=_var.price
            end

            if DeepSeaTreasure.msg.lastTimes1~=0 then
               DeepSeaTreasure.onShowNormal(container)
            elseif DeepSeaTreasure.msg.lastTimes2~=0 then
               DeepSeaTreasure.onShowBoutique(container)
            else
               DeepSeaTreasure.onShowNosuch(container)
            end
            
            DeepSeaTreasure.mIsFirstIn=false
        end
        if DeepSeaTreasure.mCurrTab==1 then
           DeepSeaTreasure.onShowNormal(container)
        elseif  DeepSeaTreasure.mCurrTab==2 then
           DeepSeaTreasure.onShowBoutique(container)
        else
           DeepSeaTreasure.onShowNosuch(container)
        end      
        --[[amstatus = msg.amStatus
        pmstatus = msg.pmStatus--]]
    end    
end

function DeepSeaTreasure.onGameMessage(container)
    local message = container:getMessage()
    if message:getTypeId() == 3 --[[MSG_MAINFRAME_POPPAGE]] then
        if DeepSeaTreasure.isHavSkillBook then
            local msg = MsgMainFrameChangePage:new()
            msg.pageName = "AdventurePage"
            MessageManager:getInstance():sendMessageForScript(msg)
        end
    end

end

function luaCreat_DeepSeaTreasure(container)
    CCLuaLog("OnCreat_DeepSeaTreasure")
    container:registerFunctionHandler(DeepSeaTreasure.onFunction)
end

local function calbackfun(eventName)
    CCLuaLog("DeepSeaTreasure.calbackfun")
    if eventName == "onFunction1" then
        MessageBoxPage:Msg_Box("@LevelForArena")
    elseif eventName == "onFunction2" then
        MessageBoxPage:Msg_Box_Lan("@LevelForArena")
    end
end
