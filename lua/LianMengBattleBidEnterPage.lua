require "LianMengPage"

local mCount = 0
local mID = 0
local LianMengBattleBidEnterPage = {}
local largeNum = 10000000
local tiniNum = 1000000
local initNum = 5000000
local maxNum = 999000000

function luaCreat_LianMengBattleBidEnterPage(container)
    CCLuaLog("OnCreat_LianMengBattleBidEnterPage")
    container:registerFunctionHandler(LianMengBattleBidEnterPage.onFunction)
end

function LianMengBattleBidEnterPage.onFunction(eventName,container)
    if eventName == "luaEnter" then
        LianMengBattleBidEnterPage.onEnter(container)
    elseif eventName == "luaExecute" then
    elseif eventName == "onClose" then
    	MainFrame:getInstance():showPage("LianMengBattlePage")
    elseif eventName == "onBack" then
        MainFrame:getInstance():showPage("LianMengPage")
    elseif eventName == "luaExit" then
        LianMengBattleBidEnterPage.onExit(container)
    elseif eventName == "luaLoad" then
        LianMengBattleBidEnterPage.onLoad(container)
	elseif eventName == "onConfirm" then
		LianMengBattleBidEnterPage.onConfirm(container)
    elseif eventName == "onOK" then
        LianMengBattleBidEnterPage.onOK(container)
    elseif eventName == "onReduceNum" then
        mCount = mCount - tiniNum
        if mCount<initNum then
            mCount = initNum
        end
        if mCount == initNum then
   		    container:getVarMenuItemImage("mReduceButton10w"):setVisible(false)
		end
        container:getVarMenuItemImage("mAddButton10w"):setVisible(true)

        LianMengBattleBidEnterPage.caculatePrice(container)
    elseif eventName == "onAddNum" then
        mCount = mCount + tiniNum
        if mCount>tiniNum then
            container:getVarMenuItemImage("mAddButton10w"):setVisible(true)
        end		
		if mCount>maxNum then
			mCount = maxNum;
			container:getVarMenuItemImage("mAddButton10w"):setVisible(true)
		end
        LianMengBattleBidEnterPage.caculatePrice(container)
    elseif eventName == "onReduceNum10" then
        mCount = mCount - largeNum
        if mCount <= initNum then
			mCount = initNum
		end
			
		if mCount == initNum then
		    container:getVarMenuItemImage("mReduceButton10w"):setVisible(false)
		end
		
		container:getVarMenuItemImage("mAddButton10w"):setVisible(true)
		LianMengBattleBidEnterPage.caculatePrice(container)
    elseif eventName == "onAddNum10" then
        mCount = mCount + largeNum
        
        if mCount > largeNum then
		    container:getVarMenuItemImage("mReduceButton10w"):setVisible(true)
		end
		
		if mCount>maxNum then
			mCount = maxNum;
			container:getVarMenuItemImage("mAddButton10w"):setVisible(true)
        end
		
        LianMengBattleBidEnterPage.caculatePrice(container)
    end
end

function LianMengBattleBidEnterPage.onConfirm(container)
    MainFrame:getInstance():showPage("LianMengPage")
end

function LianMengBattleBidEnterPage.onEnter(container)
    container:getVarLabelBMFont("mLMBidPrompt"):setString(tostring(Language:getInstance():getString("@LMBidPrompt")))

    mCount = initNum
	
	LianMengBattleBidEnterPage.caculatePrice(container)
	
--  container.m_pScrollViewFacade = CCReViScrollViewFacade:new(container.mScrollView)
--	container.m_pScrollViewFacade:init(6,6)
end

function LianMengBattleBidEnterPage.onExit(container)	
--    LianMengBattleBidEnterPage.clearAllItem(container)
--	container.m_pScrollViewFacade:delete()
--	container.m_pScrollViewFacade = nil


end

function LianMengBattleBidEnterPage.onLoad(container)
	container:loadCcbiFile("LianMengBattleBidEnter.ccbi")
--	container.mScrollView = container:getVarScrollView("mContent")
--	container.mScrollViewRootNode = container.mScrollView:getContainer()
end

function LianMengBattleBidEnterPage.clearAllItem(container)
--    container.m_pScrollViewFacade:clearAllItems()
--    container.mScrollViewRootNode:removeAllChildren()
end

function LianMengBattleBidEnterPage.checkGoldEnough()
--    LeaguaBaseInfo.leaguaBroadcast
    local silver = LeaguaBaseInfo.leaguaFunds + 0
    if silver < mCount then
        return false
    end
    return true
end

function LianMengBattleBidEnterPage.caculatePrice(container)
    local checkGold = LianMengBattleBidEnterPage.checkGoldEnough(container)
    if checkGold then
        container:getVarLabelBMFont("mNum"):setString(tostring(mCount))
        container:getVarLabelBMFont("mLMBidPrompt"):setString(tostring(Language:getInstance():getString("@LMBidPrompt")))
    else
        container:getVarLabelBMFont("mNum"):setString(tostring(mCount))
        container:getVarLabelBMFont("mLMBidPrompt"):setString(tostring(Language:getInstance():getString("@BUYNotEnoughBL")))
    end
    
end


function LianMengBattleBidEnterPage.onOK(container)
    if LianMengBattleBidEnterPage.checkGoldEnough(container) == true then
    --·¢°ü
--        LianmengBattleInfo.strongHold[1].ownerName = "111111111111"
--        MainFrame:getInstance():showPage("LianMengBattlePage")
    
        local bidNum
        if BlackBoard:getInstance():hasVarible("LianMengCurBidNum") then
            bidNum = BlackBoard:getInstance():getVarible("LianMengCurBidNum")
        end
        
    
        local msg = LeagueStruct_battle_pb.OPLianMengJoinBattle()
        msg.version = 1
        msg.bidAmount = mCount
        msg.strongholdIndex = bidNum + 0
        local pb_data = msg:SerializeToString()
        PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LIANMENG_JOIN_BATTLE_C,pb_data,#pb_data,true)
    else
        MessageBoxPage:Msg_Box("@BUYNotEnoughBL")
    end


end

