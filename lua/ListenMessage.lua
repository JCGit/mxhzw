local adventurePageTypeCfg = {
--	CallOfLufei = 109,
	WishingTree = 106
}

local msgHandler = MessageScriptHandler:new(function(eventName, gameMsg)
	if gameMsg:getTypeId() == MSG_MAINFRAME_CHANGEPAGE then
		local pageName = MsgMainFrameChangePage:getTrueType(gameMsg).pageName
		local adventurePageType = adventurePageTypeCfg[pageName]
		if adventurePageType ~= nil then
			BlackBoard:getInstance().ToAdventruePageType = adventurePageType
			local msg = MsgMainFrameChangePage:new()
			msg.pageName = "AdventurePage"
			MessageManager:getInstance():sendMessageForScript(msg)
		end
	end
end)

MessageManager:getInstance():regisiterMessageHandler(MSG_MAINFRAME_CHANGEPAGE, msgHandler)
