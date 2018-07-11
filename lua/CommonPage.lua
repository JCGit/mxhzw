CommonPage = {}

CommonPage.new = function(pageName, opt)
	opt = opt or {}
	local page = {}
	page.handlerMap = opt.handlerMap or {}
	page.handlerMap = common:table_merge(page.handlerMap, CommonPage.handlerMap)
	local showLog = opt.showLog == true
	page.onFunction = function(eventName, container)
		if page.handlerMap[eventName] ~= nil then
			local funcName = page.handlerMap[eventName]
			page[funcName](container)
		else
			CCLuaLog("error===>unExpected event Name : " .. pageName .. "->" .. eventName)
		end
	end
	table.foreach(page.handlerMap, function(eventName, funcName)
		page[funcName] = function(container)
			if showLog then CCLuaLog(pageName .. "   " .. funcName .. "  called!") end
			if funcName == "onLoad" and opt.ccbiFile ~= nil then
				container:loadCcbiFile(opt.ccbiFile)
			end
		end
	end)

	_G["luaCreat_" .. pageName] = function(container)
		CCLuaLog("OnCreate__" .. pageName)
		container:registerFunctionHandler(page.onFunction)
	end

	return page
end

CommonPage.handlerMap = {
	luaInit = "onInit",
	luaLoad = "onLoad",
	luaCreate = "onCreate",
	luaExecute = "onExecute",
	luaEnter = "onEnter",
	luaExit = "onExit",
	luaOnAnimationDone = "onAnimationDone",
	luaReceivePacket = "onReceivePacket"
}
