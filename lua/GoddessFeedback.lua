require "GoddessRebate_pb"
require "IncPbCommon"
require "GoodsShowListPage"
local GoddessFeedback = {}

GoddessFeedback.mIsInitData = false
GoddessFeedback.mIsFirstIn = true
GoddessFeedback.mShowAni=false
GoddessFeedback.mLastInitDay=0
GoddessFeedback.mCurrFlower=0
GoddessFeedback.mDebug=false
GoddessFeedback.mShowGiftPop=false
GoddessFeedback.mCurrGiveId=1
GoddessFeedback.mHasReq=false
GoddessFeedback.mIntimate={[1]={count=0,needInit=1,consume=1},[2]={count=0,needInit=20,consume=5},[3]={count=0,needInit=30,consume=20},[4]={count=0,needInit=100,consume=50}}
function GoddessFeedback.onFunction(eventName,container)
    CCLuaLog("eventName"..eventName);
    if eventName == "luaInit" then
        GoddessFeedback.onInit(container)
    elseif eventName == "luaEnter" then
        GoddessFeedback.onEnter(container)
    elseif eventName == "luaExit" then
        GoddessFeedback.onExit(container)
    elseif eventName == "luaExecute" then
        GoddessFeedback.onExecute(container)
    elseif eventName == "luaLoad" then
        GoddessFeedback.onLoad(container)
    elseif eventName == "luaUnLoad" then
        GoddessFeedback.onUnLoad(container)
    elseif eventName == "luaGameMessage" then
        GoddessFeedback.onGameMessage(container)
    elseif eventName == "luaReceivePacket" then
        GoddessFeedback.onReceivePacket(container)
    elseif string.find(eventName, "onQmdButten") ~= nil then
        GoddessFeedback.onSendFlower(container, eventName)
    elseif eventName == "luaOnAnimationDone" then
        GoddessFeedback.onAnimationDone(container)
    elseif eventName=="onQmdHelp" then
        GoddessFeedback.onHelp(container)
    end
end

function GoddessFeedback.onHelp(container)
    MainFrame:getInstance():pushPage("GoddessFeedbackHelpPage")
end

function GoddessFeedback.onInit(container)
     GoddessFeedback.mShowAni=false
     MainFrame:getInstance():hideNoTouch()
end

function GoddessFeedback.onAnimationDone(container)
    if GoddessFeedback.mShowAni then
        GoddessFeedback.mShowAni=false
        GoddessFeedback.mHasReq=false
        MainFrame:getInstance():hideNoTouch()
        if GoddessFeedback.mShowGiftPop then
            GoddessFeedback.mShowGiftPop=false
            GoddessFeedback.mHasReq=false
            MainFrame:getInstance():pushPage("GoodsShowListPage")
        end
    end
end

function GoddessFeedback.onParticleBack()
end
function GoddessFeedback.onEnter(container)
    GoddessFeedback.mHasReq=false
    if not GoddessFeedback.mIsFirstIn then
        container:getVarNode("mNSParticle"):scheduleUpdateWithPriorityLua(GoddessFeedback.onParticleBack,1)
    end
    container:runAnimation("Default Timeline")
    container:registerPacket(226)  --OPCODE_GODDESS_REBATE_INFO_C/OPCODE_GODDESS_REBATE_INFORET_S
    container:registerPacket(228)
    if GoddessFeedback.mLastInitDay==0 then
        GoddessFeedback.mLastInitDay=os.date("*t").day
    else
        local currDay=os.date("*t").day
        if GoddessFeedback.mLastInitDay~=currDay and os.date("*t").min>10 then
            GoddessFeedback.mIsInitData=false
            GoddessFeedback.mLastInitDay=currDay
        end
    end    

    if not GoddessFeedback.mIsInitData then
        local msg = GoddessRebate_pb.OPGoddessRebateInfo()
        msg.version = 1
        local pb_data = msg:SerializeToString()
        container:sendPakcet(225,pb_data,#pb_data,true)
    else
        if GoddessAutoReceive.mHasRecharge then
            GoddessFeedback.mCurrFlower=GoddessAutoReceive.totalCount
            GoddessAutoReceive.mHasRecharge=false
        end
        GoddessFeedback.onShowContent(container)
    end
    if GoddessFeedback.mDebug then
        GoddessFeedback.onShowContent(container)
    end

end

function GoddessFeedback.onShowContent(container)
    for i=1, table.maxn(GoddessFeedback.mIntimate) do
        local currConfig=GoddessFeedback.mIntimate[i];
        container:getVarLabelBMFont("mQinmidu"..i):setString(tostring(currConfig.count).."/"..tostring(currConfig.needInit))
        container:getVarLabelBMFont("mflowerNum"):setString(tostring(GoddessFeedback.mCurrFlower))
        local str=Language:getInstance():getString("@GoddessBtnName")
        str=string.gsub(str,"#v1#",tostring(currConfig.consume))
        container:getVarLabelBMFont("mQmdTex"..i):setString(str)
    end
end

function GoddessFeedback.onExit(container)    
    CCLuaLog("GoddessFeedback.onExit")
    GoddessFeedback.mShowAni=false
    GoddessFeedback.mHasReq=false
    container:removePacket(226)
    container:removePacket(228)
end

function GoddessFeedback.onExecute(container)

end

function GoddessFeedback.onLoad(container)
    container:loadCcbiFile("Nvshendehuikui.ccbi")
end

function GoddessFeedback.onUnLoad(container)
    CCLuaLog("GoddessFeedback.onUnLoad");
end

function GoddessFeedback.onSendFlower(container,eventName)
    
    local iconItem = string.gsub(eventName, "onQmdButten","")
    local _index=tonumber(iconItem)
    if table.maxn(GoddessFeedback.mIntimate)>=_index then
       local currConfig=GoddessFeedback.mIntimate[_index]
       if currConfig==nil then
           MessageBoxPage:Msg_Box_Lan("@GoddessDataErr")
       else
           if GoddessFeedback.mCurrFlower>=currConfig.consume and not GoddessFeedback.mHasReq then
               GoddessFeedback.mHasReq=true
               local msg = GoddessRebate_pb.OPGoddessGiveFlower()
               msg.version = 1
               msg.kind=_index
               GoddessFeedback.mCurrGiveId=_index
               local pb_data = msg:SerializeToString()
               container:sendPakcet(227,pb_data,#pb_data,true)
           else
               MessageBoxPage:Msg_Box_Lan("@GoddessFlowNotEnough")
           end
       end
    end
end

function GoddessFeedback.onReceivePacket(container)
    if container:getRecPacketOpcode()==226 then
        GoddessFeedback.mIsInitData = true;
        local msg = GoddessRebate_pb.OPGoddessRebateInfoRet()
        msgbuff = container:getRecPacketBuffer();
        msg:ParseFromString(msgbuff)
        GoddessFeedback.mCurrFlower=msg.totleCount
        for k, info in ipairs(msg.basicInfo) do
            if table.maxn(GoddessFeedback.mIntimate)>=info.id then
                GoddessFeedback.mIntimate[info.id].count=info.intimacy
                GoddessFeedback.mIntimate[info.id].needInit=info.needTimes
                GoddessFeedback.mIntimate[info.id].consume=info.price
            else
                GoddessFeedback.mIntimate[info.id]={}
                GoddessFeedback.mIntimate[info.id].count=info.intimacy
                GoddessFeedback.mIntimate[info.id].needInit=info.needTimes
                GoddessFeedback.mIntimate[info.id].consume=info.price
            end
        end
     elseif container:getRecPacketOpcode()==228 then
        local msg = GoddessRebate_pb.OPGoddessGiveFlowerRet()
        msgbuff = container:getRecPacketBuffer();
        msg:ParseFromString(msgbuff)
        if msg:HasField("goldcoins") then
            ServerDateManager:getInstance():getUserBasicInfo().goldcoins=msg.goldcoins
        end
        if msg:HasField("silvercoins") then
           ScriptMathToLua:modifySilverCoins(msg.silvercoins)
        end
        for k, info in ipairs(msg.intimacy) do
            if table.maxn(GoddessFeedback.mIntimate)>=info.id then
                GoddessFeedback.mIntimate[info.id].count=info.num
                GoddessFeedback.mShowAni=true
                GoddessFeedback.onShowContent(container)
                MainFrame:getInstance():showNoTouch()
            end
        end
        container:runAnimation("animation"..tostring(GoddessFeedback.mCurrGiveId))
        if msg:HasField("addSilvercoins") then
        end
        if msg:HasField("addGoldcoins") then
        end
        for k, info in ipairs(msg.skillbookInfo) do
            if ServerDateManager:getInstance():getAdventureItemInfoMapTotalNum()==0 then
            local msgs = AdventureInfo_pb.OPAdventureInfo()
            msgs.version = 1
            local pb_data = msgs:SerializeToString()
            container:sendPakcet(105,pb_data,#pb_data,true)
            else
                DropManager.gotSkillBook(info)
            end
        end
        for k, info in ipairs(msg.soulInfo) do
            DropManager.gotSoul(info)
        end
        for k, info in ipairs(msg.skillInfo) do
            DropManager.gotSkill( info)
        end
        for k, info in ipairs(msg.equipInfo) do
            DropManager.gotEquipment(info)
        end
        for k, info in ipairs(msg.toolInfo) do
            DropManager.gotTool(info)
        end
        for k, info in ipairs(msg.discipleInfo) do
            DropManager.gotDisciple(info)
        end
        GoodsViewPage.mViewGoodsListInfo={}
        GoodsViewPage.mTitle="@GoddPackPreviewTitleView"
        GoodsViewPage.mMsgContent="@GoddPackPreviewMsgView"
        for k, info in ipairs(msg.rewardInfo) do
            local _resInfo=ResManager:getInstance():getResInfoByTypeAndId(info.type,info.itemid,info.count)
            GoodsViewPage.mViewGoodsListInfo[k]={}
            GoodsViewPage.mViewGoodsListInfo[k].type=info.type
            GoodsViewPage.mViewGoodsListInfo[k].name=_resInfo.name
            GoodsViewPage.mViewGoodsListInfo[k].icon=_resInfo.icon
            GoodsViewPage.mViewGoodsListInfo[k].count=_resInfo.count
            GoodsViewPage.mViewGoodsListInfo[k].quality=_resInfo.quality
            GoddessFeedback.mShowGiftPop=true
        end
        GoddessFeedback.mCurrFlower=msg.totalCount
        GoddessFeedback.onShowContent(container)
    end
    if GoddessFeedback.mIsFirstIn then
        GoddessFeedback.onShowContent(container)
        GoddessFeedback.mIsFirstIn=false
    end
end

function GoddessFeedback.onGameMessage(container)
    CCLuaLog("GoddessFeedback.onGameMessage")
end

function luaCreat_GoddessFeedback(container)
    CCLuaLog("OnCreat_GoddessFeedback")
    container:registerFunctionHandler(GoddessFeedback.onFunction)
end

local function calbackfun(eventName)
    CCLuaLog("GoddessFeedback.calbackfun")
    if eventName == "onFunction1" then
        MessageBoxPage:Msg_Box("@LevelForArena")
    elseif eventName == "onFunction2" then
        MessageBoxPage:Msg_Box_Lan("@LevelForArena")
    end
end
