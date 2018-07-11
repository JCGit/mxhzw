require "ForgeEquipPiece_pb"
require "IncPbCommon"
local ForgeEquipPiecePage = {}

ForgeEquipPiecePage.mIsInitData = false
ForgeEquipPiecePage.mIsFirstIn = true
ForgeEquipPiecePage.mLastInitDay=0
ForgeEquipPiecePage.mLastSec=0
ForgeEquipPiecePage.mCanShowEquip=false
ForgeEquipPiecePage.mShowEquipId=0
ForgeEquipPiecePage.mPieceTarget=nil
ForgeEquipPiecePage.mCanPiece=false
ForgeEquipPiecePageCurrSelToolId=0
function ForgeEquipPiecePage.onFunction(eventName,container)
    CCLuaLog("eventName"..eventName);
    if eventName == "luaInit" then
        ForgeEquipPiecePage.onInit(container)
    elseif eventName == "luaEnter" then
        ForgeEquipPiecePage.onEnter(container)
    elseif eventName == "luaExit" then
        ForgeEquipPiecePage.onExit(container)
    elseif eventName == "luaExecute" then
        ForgeEquipPiecePage.onExecute(container)
    elseif eventName == "luaLoad" then
        ForgeEquipPiecePage.onLoad(container)
    elseif eventName == "luaUnLoad" then
        ForgeEquipPiecePage.onUnLoad(container)
    elseif eventName == "luaGameMessage" then
        ForgeEquipPiecePage.onGameMessage(container)
    elseif eventName == "luaReceivePacket" then
        ForgeEquipPiecePage.onReceivePacket(container)
    elseif eventName == "luaOnAnimationDone" then
        ForgeEquipPiecePage.onAnimationDone(container)
    elseif eventName == "onDZHelp" then
        ForgeEquipPiecePage.onShowHelp(container)
    elseif eventName == "onDZAdd1" then
        ForgeEquipPiecePage.onShowForceConfig(container)
    elseif eventName == "onDZAdd2" then
        ForgeEquipPiecePage.onShowEquipHand(container)
    elseif eventName == "onDZ" then
        ForgeEquipPiecePage.onForgeEquip(container)
    end
end

function ForgeEquipPiecePage.onForgeEquip(container)
    if not ForgeEquipPiecePage.mCanPiece then
        MessageBoxPage:Msg_Box_Lan("@ForgeEquipNotEnough")
    else
        container:registerPacket(286)
        local msg = ForgeEquipPiece_pb.OPForgeEquipPiece()
        msg.euipItem = ForgeEquipPiecePageCurrSelToolId
        local pb_data = msg:SerializeToString()
        container:sendPakcet(285,pb_data,#pb_data,true)
    end

end

function ForgeEquipPiecePage.onShowForceConfig(container)
    container:registerMessage(1)--[[MSG_MAINFRAME_CHANGEPAGE]]
    local msg = MsgMainFrameChangePage:new()
    msg.pageName = "ForgeEquipToolsPicPage"
    MessageManager:getInstance():sendMessageForScript(msg)
end

function ForgeEquipPiecePage.onShowEquipHand(container)
    if ForgeEquipPiecePage.mCanShowEquip and tonumber(ForgeEquipPiecePage.mShowEquipId)~=0 then
        EquipHandInfoPage:showEquipPage(ForgeEquipPiecePage.mShowEquipId,true)
    end
end

function ForgeEquipPiecePage.onShowHelp(container)
    if ForgeEquipHelpInfo==nil or table.maxn(ForgeEquipHelpInfo)<=0 then
        local tabel = TableReaderManager:getInstance():getTableReader("ForgeEquipHelp.txt")
        local count = tabel:getLineCount()-1;
        for i = 1,count do
            local index = tonumber(tabel:getData(i,0))
            if index then
                ForgeEquipHelpInfo[index] = {}
                ForgeEquipHelpInfo[index].name = tabel:getData(i,1)
                ForgeEquipHelpInfo[index].describe = tabel:getData(i,2)
            end
        end
    end
    local msg = MsgMainFrameChangePage:new()
    msg.pageName = "ForgeEquipHelpPage"
    MessageManager:getInstance():sendMessageForScript(msg)
end

function ForgeEquipPiecePage.onInit(container)
     ForgeEquipPiecePage.mShowAni=false

end

function ForgeEquipPiecePage.onAnimationDone(container)

end

function ForgeEquipPiecePage.resetData()
    ForgeEquipPiecePage.mCanShowEquip=false
    ForgeEquipPiecePage.mShowEquipId=0
    ForgeEquipPiecePage.mPieceTarget=nil
    ForgeEquipPiecePage.mCanPiece=false
end

function ForgeEquipPiecePage.onEnter(container)
    ForgeEquipPiecePage.resetData()
    container:registerPacket(286)
    if ForgeEquipPiecePage.mLastInitDay==0 then
        ForgeEquipPiecePage.mLastInitDay=os.date("*t").day
    else
        local currDay=os.date("*t").day
        if ForgeEquipPiecePage.mLastInitDay~=currDay and os.date("*t").min>10 then
            ForgeEquipPiecePage.mIsInitData=false
            ForgeEquipPiecePage.mLastInitDay=currDay
        end
    end

    ForgeEquipPiecePage.refresh(container)
end

function  ForgeEquipPiecePage.refresh(container)
    ForgeEquipPiecePage.resetData()
    container:getVarLabelBMFont("mSuipianAnum1"):setString(tostring(getToolsCount(5003001))..Language:getInstance():getString("@RecruitNum"))
    container:getVarLabelBMFont("mSuipianAnum2"):setString(tostring(getToolsCount(5003002))..Language:getInstance():getString("@RecruitNum"))
    container:getVarMenuItemImage("mDZAdd2"):setNormalImage(getFrameNormalSpirte(4))
    if ForgeEquipPiecePageCurrSelToolId==0 then
        container:getVarNode("mDZ111"):setVisible(true)
        container:getVarNode("mDZ222"):setVisible(false)
        container:getVarSprite("mEQpic1"):setVisible(false)
        container:getVarSprite("mEQpic2"):setVisible(false)
        container:getVarLabelBMFont("mDuanzaoTa"):setVisible(true)
        container:getVarLabelBMFont("mDuanzaoTb"):setVisible(true)
        container:getVarMenuItemImage("mDZ"):setEnabled(false)
    else
        local toolItem = ToolTableManager:getInstance():getToolItemByID(ForgeEquipPiecePageCurrSelToolId)
        container:getVarSprite("mEQpic1"):setTexture(toolItem.iconPic)
        container:getVarSprite("mEQpic1"):setVisible(true)
        container:getVarSprite("mEQpic2"):setVisible(true)
        container:getVarNode("mDZ111"):setVisible(false)
        container:getVarNode("mDZ222"):setVisible(true)
        container:getVarLabelBMFont("mDuanzaoTa"):setVisible(false)
        container:getVarLabelBMFont("mDuanzaoTb"):setVisible(false)
        local equipFragmentItem=TableManagerForLua.equipmentFragmentList[ForgeEquipPiecePageCurrSelToolId]
        if equipFragmentItem~=nil then
           local pieceConsume=getResTable(equipFragmentItem.pieceConsume)
           if pieceConsume~=nil then
              local consumeStr=""
              local j=1
              ForgeEquipPiecePage.mCanPiece=true
              for i=1,table.maxn(pieceConsume) do
                  local info=ResManager:getInstance():getResInfoByTypeAndId(pieceConsume[i].type,pieceConsume[i].itemId,pieceConsume[i].count)
                  if ForgeEquipPiecePageCurrSelToolId~=tonumber(pieceConsume[i].itemId) then
                      if j~=1 then
                          consumeStr=consumeStr..","
                      end
                      consumeStr=consumeStr..info.name.."x"..info.count
                      j=j+1
                  end
                  if info.count>getToolsCount(info.itemId) then
                      ForgeEquipPiecePage.mCanPiece=false
                  end
              end
              container:getVarLabelBMFont("mDuanzaoT2_b"):setString(tostring(autoReturn(consumeStr,18)))
           end
           container:getVarLabelBMFont("mSuipianANum5"):setString(tostring(equipFragmentItem.pieceRate).."%")
           local quality=4
           local _target=getResTable(equipFragmentItem.pieceTarget)
           if _target~=nil and table.maxn(_target)==1 then
               local info=ResManager:getInstance():getResInfoByTypeAndId(_target[1].type,_target[1].itemId,_target[1].count)
               quality=info.quality
               container:getVarSprite("mEQpic2"):setTexture(info.icon)
               local _type=ResManager:getInstance():getResMainType(_target[1].type)
               if _type==DISCIPLE_TYPE or _type==SOUL_TYPE then
                   container:getVarSprite("mEQpic2"):setScale(1.0)
               elseif _type==USER_PROPERTY_TYPE or _type==TOOLS_TYPE then
                   quality=4
               elseif _type==EQUIP_TYPE then
                   ForgeEquipPiecePage.mCanShowEquip=true
                   ForgeEquipPiecePage.mShowEquipId=_target[1].itemId
                   ForgeEquipPiecePage.mPieceTarget=_target[1]
               end
               if quality>4 or quality<1 then
                   quality=4
               end
               local color = VaribleManager:getInstance():getSetting("FrameColor_Quality"..tostring(quality))
               local colorRGB=StringConverter:parseColor3B(color)
               --container:getVarSprite("mDZAdd2"):setColor(colorRGB)
               container:getVarMenuItemImage("mDZAdd2"):setNormalImage(getFrameNormalSpirte(quality))
           end
        else

        end
        container:getVarMenuItemImage("mDZ"):setEnabled(true)
    end
end

function ForgeEquipPiecePage.onExit(container)    
    CCLuaLog("ForgeEquipPiecePage.onExit")
    ForgeEquipPiecePage.mShowAni=false
    container:removePacket(276)
end

function ForgeEquipPiecePage.onExecute(container)
    if os.date("*t").sec>ForgeEquipPiecePage.mLastSec or os.date("*t").sec==1 then
        ForgeEquipPiecePage.refresh(container)
    end
end

function ForgeEquipPiecePage.onLoad(container)
    container:loadCcbiFile("duanzao.ccbi")
end

function ForgeEquipPiecePage.onUnLoad(container)
    CCLuaLog("ForgeEquipPiecePage.onUnLoad");
end

function ForgeEquipPiecePage.onReceivePacket(container)
    if container:getRecPacketOpcode()==286 then
        local msg = ForgeEquipPiece_pb.OPForgeEquipPieceRet()
        msgbuff = container:getRecPacketBuffer();
        msg:ParseFromString(msgbuff)
        local status=msg.status
        if status==1 then
            if msg:HasField("equipsInfo") then
                DropManager.gotEquipment(msg.equipsInfo)
            end 
            for k, info in ipairs(msg.toolsInfo) do
                DropManager.gotTool(info)
            end
            GoodsShowSingleInfo.mType=ForgeEquipPiecePage.mPieceTarget.type
            GoodsShowSingleInfo.mItemId=ForgeEquipPiecePage.mPieceTarget.itemId
            GoodsShowSingleInfo.mCount=ForgeEquipPiecePage.mPieceTarget.count
            GoodsShowSingleInfo.mPartId=0
            GoodsShowSingleInfo.mHelp="@PackPreviewPageMsg"
            MainFrame:getInstance():pushPage("GoodsShowSinglePage")
            ForgeEquipPiecePageCurrSelToolId=0
            ForgeEquipPiecePage.resetData()
            ForgeEquipPiecePage.refresh(container)
        elseif status==2 then
            if msg:HasField("equipsInfo") then
                DropManager.gotEquipment(msg.equipsInfo)
            end
            for k, info in ipairs(msg.toolsInfo) do
                DropManager.gotTool(info)
            end
            ForgeEquipPiecePageCurrSelToolId=0
            ForgeEquipPiecePage.resetData()
            ForgeEquipPiecePage.refresh(container)
            MessageBoxPage:Msg_Box_Lan("@ForgeEquipPieceFail")
        elseif status==3 then
            MessageBoxPage:Msg_Box_Lan("@ForgeEquipClose")
        elseif status==4 then
            MessageBoxPage:Msg_Box_Lan("@ForgeEquipToolsNotEnough")
        elseif status==0 then
            MessageBoxPage:Msg_Box_Lan("@ExceptionFound")
        end

    end    
end

function ForgeEquipPiecePage.onGameMessage(container)
    local message = container:getMessage()
    if message:getTypeId() == 1 --[[MSG_MAINFRAME_CHANGEPAGE]] then
        container:removeMessage(1)
        ForgeEquipPiecePage.refresh(container)
    end
end

function luaCreat_ForgeEquipPiecePage(container)
    CCLuaLog("OnCreat_ForgeEquipPiecePage")
    container:registerFunctionHandler(ForgeEquipPiecePage.onFunction)
end

local function calbackfun(eventName)
    CCLuaLog("ForgeEquipPiecePage.calbackfun")
    if eventName == "onFunction1" then
        MessageBoxPage:Msg_Box("@LevelForArena")
    elseif eventName == "onFunction2" then
        MessageBoxPage:Msg_Box_Lan("@LevelForArena")
    end
end
