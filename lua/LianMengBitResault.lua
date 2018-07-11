require "LianMeng"
require "LianMengRobRank"

local LianMengBitResault = {}

function luaCreat_LianMengBitResault(container)
    container:registerFunctionHandler(LianMengBitResault.onFunction)
end

function LianMengBitResault.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengBitResault.onEnter(container)
    elseif eventName == "luaExit" then
        LianMengBitResault.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengBitResault.onLoad(container)
	elseif eventName == "luaReceivePacket" then
		LianMengBitResault.onReceivePacket(container)
	elseif eventName == "onLMAttack" then
		LianMengBitResault.closePage(container)
	end
end

function LianMengBitResault.closePage(container) 
	local msg = MsgMainFrameCoverHide:new()
	msg.pageName = "LianMengBitResault.ccbi"
	MessageManager:getInstance():sendMessageForScript(msg);
	
	local msg2 = MsgMainFrameChangePage()
	msg2.pageName = "LianMengTotem"
	MessageManager:getInstance():sendMessageForScript(msg2);
end

function LianMengBitResault.onEnter(container) 
	CCLuaLog("LianMengBitResault.onEnter")
    CCLuaLog(container:dumpInfo())
    container:getVarLabelBMFont("mLMGX"):setString(tostring(LianMengTotemRob.contribution))
    
	local sprite = container:getVarMenuItemSprite("mLMAttackHZ")
	local badgeNode = CCSprite:create(LianMengBadges[LianMengTotemRob.gotBadgeID].filename)
	sprite:setNormalImage(badgeNode)
    
end

function LianMengBitResault.onExit(container)	

end

function LianMengBitResault.onLoad(container)
	container:loadCcbiFile("LianMengBitResault.ccbi");
	
end

function LianMengBitResault.onReceivePacket(container)

end
