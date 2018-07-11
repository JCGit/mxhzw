local GoddessFeedbackHelpPage = {}

function luaCreat_GoddessFeedbackHelpPage(container)
    CCLuaLog("OnCreat_GoddessFeedbackHelpPage")
    container:registerFunctionHandler(GoddessFeedbackHelpPage.onFunction)
end

function GoddessFeedbackHelpPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        GoddessFeedbackHelpPage.onEnter(container)
    elseif eventName == "luaExit" then
        GoddessFeedbackHelpPage.onExit(container)
    elseif eventName == "luaLoad" then
        GoddessFeedbackHelpPage.onLoad(container)
	elseif eventName == "onConfirm" then
		GoddessFeedbackHelpPage.onConfirm(container)
    elseif eventName == "onNSHelpclose" then
        GoddessFeedbackHelpPage.closePage(container)
    end

end

function GoddessFeedbackHelpPage.closePage(container)
    MainFrame:getInstance():popPage("GoddessFeedbackHelpPage")
end

function GoddessFeedbackHelpPage.onConfirm(container)
    MainFrame:getInstance():popPage("GoddessFeedbackHelpPage")
end

function GoddessFeedbackHelpPage.onEnter(container)
end

function GoddessFeedbackHelpPage.onExit(container)
end

function GoddessFeedbackHelpPage.onLoad(container)
	container:loadCcbiFile("Nvshendehuikuicontent.ccbi")
end
