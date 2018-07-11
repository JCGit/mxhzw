GoodsShowSingleInfo={}
GoodsShowSingleInfo.mType=0
GoodsShowSingleInfo.mItemId=0
GoodsShowSingleInfo.mCount=0
GoodsShowSingleInfo.mPartId=0
GoodsShowSingleInfo.mHelp="@DeepSeaHelp"
local GoodsShowSinglePage={}
local curScale = 0
local discipleScale = 0

function luaCreat_GoodsShowSinglePage(container)
    CCLuaLog("OnCreat_GoodsShowSinglePage")
    container:registerFunctionHandler(GoodsShowSinglePage.onFunction)
end

function GoodsShowSinglePage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        GoodsShowSinglePage.onEnter(container)
    elseif eventName == "luaExit" then
        GoodsShowSinglePage.onExit(container)
    elseif eventName == "luaLoad" then
        GoodsShowSinglePage.onLoad(container)
	elseif eventName == "onButton" then
		GoodsShowSinglePage.onConfirm(container)
    elseif eventName == "onClose" then
        GoodsShowSinglePage.closePage(container)
    end
end

function GoodsShowSinglePage.closePage(container)
    --MainFrame:getInstance():popPage("GoodsShowSinglePage")
    local msg = MsgMainFramePopPage:new()
    msg.pageName = "GoodsShowSinglePage"
    MessageManager:getInstance():sendMessageForScript(msg)
end

function GoodsShowSinglePage.onConfirm(container)
    --MainFrame:getInstance():popPage("GoodsShowSinglePage")
    local msg = MsgMainFramePopPage:new()
    msg.pageName = "GoodsShowSinglePage"
    MessageManager:getInstance():sendMessageForScript(msg)
end

function GoodsShowSinglePage.onEnter(container)
    local _info=ResManager:getInstance():getResInfoByTypeAndId(GoodsShowSingleInfo.mType,GoodsShowSingleInfo.mItemId,GoodsShowSingleInfo.mCount,GoodsShowSingleInfo.mPartId);
    --container:getVarLabelBMFont("mHelp"):setString(Language:getInstance():getString(GoodsShowSingleInfo.mHelp))
    local _type=ResManager:getInstance():getResMainType(_info.type)
    local _quality=_info.quality
    if _type==DISCIPLE_TYPE or _type==SOUL_TYPE then
        container:getVarSprite("mHeadPic"):setScale(1.0)
    elseif _type==USER_PROPERTY_TYPE or _type==TOOLS_TYPE then
        _quality=4
    end
    if _quality>4 or _quality<1 then
        _quality=4
    end
    
    local scale = container:getVarSprite("mHeadPic"):getScale()
    
    if curScale == 0 then
        curScale = scale
    end
    if discipleScale == 0 then
        discipleScale = scale * 2.5
    end
    
    container:getVarSprite("mHeadPic"):setTexture(_info.icon)
    if _info.type == 32001 then
        container:getVarSprite("mHeadPic"):setScale(discipleScale)
    else
        container:getVarSprite("mHeadPic"):setScale(curScale)
    end
    container:getVarLabelBMFont("mItemName"):setString(tostring(_info.name))
    container:getVarMenuItemImage("mFrame"):setNormalImage(getFrameNormalSpirte(_quality))
    container:getVarMenuItemImage("mFrame"):setSelectedImage(getFrameSelectedSpirte(_quality))

    if tonumber(GoodsShowSingleInfo.mCount)>=1 then
        if _type==USER_PROPERTY_TYPE or _type==TOOLS_TYPE then
            container:getVarNode("mDeepSeaLV"):setVisible(false)
            container:getVarNode("mDeepSeaNum"):setVisible(true)
            container:getVarLabelBMFont("mItemNum"):setString("x"..tostring(_info.count))
        else
            container:getVarNode("mDeepSeaNum"):setVisible(true)
            container:getVarLabelBMFont("mItemNum"):setString("x1")
            if tonumber(GoodsShowSingleInfo.mCount)==1 then
                container:getVarNode("mDeepSeaLV"):setVisible(false)
            else
                container:getVarNode("mDeepSeaLV"):setVisible(true)

                container:getVarLabelBMFont("mItemLV"):setString(tostring(_info.count))
                local color = VaribleManager:getInstance():getSetting("FrameColor_Quality"..tostring(_quality))
                local colorRGB=StringConverter:parseColor3B(color)
                container:getVarSprite("lvlnum1"):setColor(colorRGB)
            end
        end
    else
        container:getVarNode("mDeepSeaLV"):setVisible(false)
        container:getVarNode("mDeepSeaNum"):setVisible(false)
    end
end

function GoodsShowSinglePage.onExit(container)	

end

function GoodsShowSinglePage.onLoad(container)
	container:loadCcbiFile("DeepSeaTreasurePage.ccbi")
end
