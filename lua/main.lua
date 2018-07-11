
-- avoid memory leak
collectgarbage("setpause", 100) 
collectgarbage("setstepmul", 5000)
	
--require "Arena_Script"
--require "AddPowerPage"
require "LianMeng"
--require "fightbugRepair"
require "GoddessAutoReceive"
require "TableManagerForLua"
require "IncScriptPage"
json = require('json')
require "ListenMessage"
----------------


CCLuaLog("main.lua excute");
--registerScriptPage("LianMengPage")
--registerScriptPage("LianMengAddPage")
--registerScriptPage("LianMengCreatePage")
--registerScriptPage("LianMengRankingPage")
--registerScriptPage("LianMengAccedePage")
--registerScriptPage("LianMengMemberPage")
--registerScriptPage("lianmenghuizhang")
--registerScriptPage("LianMengTotem")
--registerScriptPage("LianMengRobRank")
--registerScriptPage("LianMengTotemRob")
--registerScriptPage("LianMengBuildingPage")
--registerScriptPage("LianMengJinGongPage")
--registerScriptPage("LianMengJuanXianPage")
--registerScriptPage("LianMengBitResault")
--registerScriptPage("LianMengBitResault2")
--registerScriptPage("DecisionPage")
--registerScriptPage("LianMengShopPage")
--registerScriptPage("LianMengShopBuyPage")
--registerScriptPage("LianMengHelpPage")
--registerScriptPage("LianMengBattlePage")
--registerScriptPage("LianMengBattleMSGPage")
--registerScriptPage("LianMengBattleBidPage")
--registerScriptPage("LianMengBattleConfirmPage")
--registerScriptPage("LianMengBattleBidEnterPage")
--registerScriptPage("LianMengBattleResaultPage")
--registerScriptPage("LianMengBattleTotemUsePage")
--registerScriptPage("GoddessFeedbackHelpPage")
--registerScriptPage("GoodsShowListPage")
--registerScriptPage("GoodsShowSinglePage")
--registerScriptPage("LianMengTotemFlagsListPage")
--registerScriptPage("LianMengTotemRobFlagsPopPage")
--registerScriptPage("LianMengTotemAddCountPage")
--registerScriptPage("ForgeEquipHelpPage")
--registerScriptPage("ForgeEquipToolsPicPage")
--registerScriptPage("LianMengBattleTotemUsePopupPage")

function GamePrecedure_preEnterMainMenu()
    CCLuaLog("GamePrecedure_preEnterMainMenu")
end

function GamePrecedure_enterBackGround()
    CCLuaLog("GamePrecedure_enterBackGround")
end

function GamePrecedure_enterForeground()
    CCLuaLog("GamePrecedure_enterForeground")
end

local needRefresh = true
function refreshImageset()
    --framecache = CCSpriteFrameCache:sharedSpriteFrameCache()
    --framecache:addSpriteFramesNameWithFile("Imagesetfile/battle.plist")

    needRefresh = false
end 

--updateHandler can be removed after big version update
local updateHandler = {}

function RegisterUpdateHandler(name, func)
	updateHandler[name] = func
end

function RemoveUpdateHandler(name)
	updateHandler[name] = nil
end

function GamePrecedure_update(gameprecedure)
    LianMengBattleRefresh(gameprecedure)
    if needRefresh then
        refreshImageset()
    end
    --CCLuaLog("GamePrecedure_update")
	for name, func in pairs(updateHandler) do
		func()
	end
end

local LianMengBattleLeftTime = 0
function LianMengBattleRefresh(gameprecedure)
    if LianMengJoinBattle == true then
        local hasKey = TimeCalculator:getInstance():hasKey("LMBattleFinishTime")
    
        local timeleft = 0
        if(hasKey) then
            timeleft = TimeCalculator:getInstance():getTimeLeft("LMBattleFinishTime")
        end
        
        
        if timeleft % 20 == 0 and LianMengBattleLeftTime ~= timeleft then
            LianMengBattleLeftTime = timeleft
            local bidNum
            if BlackBoard:getInstance():hasVarible("LianMengCurBidNum") then
                bidNum = BlackBoard:getInstance():getVarible("LianMengCurBidNum")
            end
            
            
            local msg2 = LeagueStruct_battle_pb.OPLianMengRefreshBattle()
            msg2.version = 1
            msg2.strongHoldIndex = bidNum + 0
            if ViewLianMengBattle == false then
                msg2.operateType = 1
            end
            local pb_data2 = msg2:SerializeToString()
            PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_REFRESH_BATTLE_C,pb_data2,#pb_data2,true)
        
        end
    end
    --CCLuaLog("GamePrecedure_update")
end

--[[
function ScriptContentBase.onFunction(eventName,container)
    --CCLuaLog(container:dumpInfo())
    if eventName == "luaInitItemView" then
    elseif eventName == "luaRefreshItemView" then
    elseif eventName == "luaOnAnimationDone" then
    end
end

function CCBScriptContainer.onFunction(eventName,container)
    if eventName == "luaInit" then
    elseif eventName == "luaEnter" then
    elseif eventName == "luaExit" then
    elseif eventName == "luaExecute" then
    elseif eventName == "luaLoad" then
    elseif eventName == "luaUnLoad" then
	elseif eventName == "luaGameMessage" then
	elseif eventName == "luaReceivePacket" then
	elseif eventName == "luaSendPacketFailed" then
	elseif eventName == "luaConnectFailed" then
	elseif eventName == "luaTimeout" then
	elseif eventName == "luaPacketError" then
	elseif eventName == "luaInputboxEnter" then
	elseif eventName == "luaMessageboxEnter" then
	elseif eventName == "luaOnAnimationDone" then
	end
end

function PacketScriptHandler(eventName,handler)
    if eventName == "luaReceivePacket" then
    elseif eventName == "luaSendPacketFailed" then
    elseif eventName == "luaConnectFailed" then
    elseif eventName == "luaTimeout" then
    elseif eventName == "luaPacketError" then   
    end
end
--]]