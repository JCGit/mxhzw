LianMengTotemRobFlagsPopPage={}


function luaCreat_LianMengTotemRobFlagsPopPage(container)
    CCLuaLog("OnCreat_LianMengTotemRobFlagsPopPage")
    container:registerFunctionHandler(LianMengTotemRobFlagsPopPage.onFunction)
end

function LianMengTotemRobFlagsPopPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengTotemRobFlagsPopPage.onEnter(container)
    elseif eventName == "luaExit" then
        LianMengTotemRobFlagsPopPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengTotemRobFlagsPopPage.onLoad(container)
	elseif eventName == "onButton" then
		LianMengTotemRobFlagsPopPage.onConfirm(container)
    elseif eventName == "onClose" then
        LianMengTotemRobFlagsPopPage.closePage(container)
    end
end

function LianMengTotemRobFlagsPopPage.closePage(container)
	local msg = MsgMainFrameCoverHide:new()
	msg.pageName = "LianMengTotemRobFlagsPopPage"
	MessageManager:getInstance():sendMessageForScript(msg);
end

function LianMengTotemRobFlagsPopPage.onConfirm(container)
	local msg = MsgMainFrameCoverHide:new()
	msg.pageName = "LianMengTotemRobFlagsPopPage"
	MessageManager:getInstance():sendMessageForScript(msg);
end

function LianMengTotemRobFlagsPopPage.onEnter(container)
    local _title="@LMPlunderFailTitle"
    local _isSuccess=false
    if LianMengTotemRob.status==1 and LianMengTotemRob.gotBadgeID ~=nil then
       _isSuccess=true
       _title="@LMPlunderSuccessTitle"
    end
    container:getVarLabelBMFont("mTitle"):setString(tostring(Language:getInstance():getString(_title)))
    if _isSuccess then
        container:getVarLabelBMFont("mContratulations"):setVisible(true)
        container:getVarLabelBMFont("mContratulations"):setString(tostring(Language:getInstance():getString("@LMPlunderSuccessCongratulations")))
        container:getVarSprite("mBadgePic"):setVisible(true)
        container:getVarSprite("mBadgePic"):setTexture(LianMengBadges[LianMengTotemRob.gotBadgeID].filename)
        container:getVarLabelBMFont("mMsg"):setVisible(false)
    else
        container:getVarLabelBMFont("mContratulations"):setVisible(false)
        container:getVarSprite("mBadgePic"):setVisible(false)
        container:getVarLabelBMFont("mMsg"):setVisible(true)
        if LianMengTotemRob.status==3 then
            container:getVarLabelBMFont("mMsg"):setString(tostring(Language:getInstance():getString("@LMPlunderFailMsg1")))
        else        
            container:getVarLabelBMFont("mMsg"):setString(tostring(Language:getInstance():getString("@LMPlunderFailMsg")))
        end
    end
end

function LianMengTotemRobFlagsPopPage.onExit(container)	

end

function LianMengTotemRobFlagsPopPage.onLoad(container)
	container:loadCcbiFile("LianMengTotemRobFlagsPopUp.ccbi")
end
