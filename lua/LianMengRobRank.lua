require "LianMeng"

LianMengRobRank = {}
LianMengRobRank.mRobList = {}
LianMengRobRank.LeagueTotemRobInfo = {
	 _totemInfoList = {},
}
--LianMengRobRank.attackLeagueID
local LianMengTotemInfo={[1]={iconpath="lianmeng/u_LianMengRBIcePic.png"},[2]={iconpath="lianmeng/u_LianMengRBFirePic.png"},[3]={iconpath="lianmeng/u_LianMengRBWindPic.png"},[4]={iconpath="lianmeng/u_LianMengRBDustPic.png"},[5]={iconpath="lianmeng/u_LianMengRBThunderPic.png"}}
function luaCreat_LianMengRobRank(container)
    CCLuaLog("OnCreat_LianMengRobRank")
    container:registerFunctionHandler(LianMengRobRank.onFunction)
end

function LianMengRobRank.onFunction(eventName,container)
    if eventName == "luaInit" then
        LianMengRobRank.onInit(container)
    elseif eventName == "luaEnter" then
        LianMengRobRank.onEnter(container)
    elseif eventName == "luaExit" then
        LianMengRobRank.onExit(container)
    elseif eventName == "luaExecute" then
        LianMengRobRank.onExecute(container)
    elseif eventName == "luaLoad" then
        LianMengRobRank.onLoad(container)
    elseif eventName == "luaUnLoad" then
        LianMengRobRank.onUnLoad(container)
	elseif eventName == "luaGameMessage" then
		LianMengRobRank.onGameMessage(container)
	elseif eventName == "luaReceivePacket" then
		LianMengRobRank.onReceivePacket(container)
	---
	elseif eventName == "onAllReject" then
		--MainFrame:getInstance():showPage("LianMengTotem")
		LianMeng_gotoTotem()
	end
end
-------------------------------------------------------------------

function LianMengRobRank.onAttackPress(funcname,container)
    CCLuaLog("LianMengPage.onInit")
    if funcname == "onShowMemberInfo" then 
    elseif funcname == "onRob" then
		local id = container:getTag()
		v = LianMengRobRank.mRobList[id]
		LianMengRobRank.attackLeagueID = id --v.leaguaID
		local msg = LeagueStruct_pb.OPGetTotemInfo()
		msg.version = 1
		msg.leaguaID = LianMengRobRank.attackLeagueID --v.leaguaID
		local pb_data = msg:SerializeToString()
		PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_GET_TOTEMINFO_C,pb_data,#pb_data,true)
	end
end

function LianMengRobRank.onInit(container)
    CCLuaLog("LianMengPage.onInit")
end

function LianMengRobRank.onEnter(container)
    CCLuaLog("LianMengPage.onEnter")
    CCLuaLog(container:dumpInfo())
	container:registerPacket(OP_League_pb.OPCODE_GET_TOTEMINFORET_S)
    container.mContent = container:getVarScrollView("mlmrankingrob")
	local node = CCNode:create()
	local sizeX = 0
    local sizeY = 0

    LianMengList = {}
    for k,v in ipairs(LianMengRobRank.mRobList) do
	    LianMengList[v.leaguaRank] = {}
	    LianMengList[v.leaguaRank].k = k
	    LianMengList[v.leaguaRank].v = v
    end

	local count = #LianMengRobRank.mRobList
	local k = 0
    for klist,vlist in pairs(LianMengList) do
	    k = k+1
	    v = vlist.v
		local pItem = ScriptContentBase:create("LianMengRankingRobContent.ccbi",v.leaguaID)
		pItem:release()--release because ScriptContentBase is designed for New Scrollview
		CCLuaLog(pItem:dumpInfo())

		local rankingNum = pItem:getVarLabelBMFont("mrankingnum")
		local rankingpic = pItem:getVarSprite("mrankingpic")
		if v.leaguaRank == 1 then
			rankingNum:setVisible(false)
			rankingpic:setVisible(true)
			rankingpic:setTexture("mainScene/u_LianMengNum01.png")
		elseif v.leaguaRank == 2 then
			rankingNum:setVisible(false)
			rankingpic:setVisible(true)
			rankingpic:setTexture("mainScene/u_LianMengNum02.png")
		elseif v.leaguaRank == 3 then
			rankingNum:setVisible(false)
			rankingpic:setVisible(true)
			rankingpic:setTexture("mainScene/u_LianMengNum03.png")
		else
			rankingNum:setVisible(true)
			rankingpic:setVisible(false)
			rankingNum:setString(tostring(v.leaguaRank))
		end

		if v.playerGrade == 4 then
			pItem:getVarSprite("mmpvaluesymbol"):setTexture("lianmeng/u_LianMengBanner02.png")
		elseif v.playerGrade == 3 then
			pItem:getVarSprite("mmpvaluesymbol"):setTexture("lianmeng/u_LianMengBanner03.png")
		elseif v.playerGrade == 2 then
			pItem:getVarSprite("mmpvaluesymbol"):setTexture("lianmeng/u_LianMengBanner04.png")
		elseif v.playerGrade == 1 then
			pItem:getVarSprite("mmpvaluesymbol"):setTexture("lianmeng/u_LianMengBanner05.png")
		end
		--local sprite = pItem:getVarMenuItemImage("mface")
		local sprite = pItem:getVarSprite("mflagpic"):setTexture(LianMengBadges[v.medalID].filename)
		
		pItem:getVarLabelBMFont("mmplevel"):setString(tostring(v.leaguaLevel))
		pItem:getVarLabelTTF("mname"):setString(v.ownerName)
		--pItem:getVarLabelBMFont("mrankingnum"):setString(tostring(v.leaguaRank))
		--pItem:getVarSprite("mrankingpic"):setVisible(false)
		pItem:getVarLabelTTF("mteamname"):setString(v.leaguaName)
		local rate = math.ceil(v.leaguaWinRate*100);
		if rate>100 then rate = 100	end
		pItem:getVarLabelBMFont("mteamnum"):setString(tostring(rate).."%")
		local memberstr = tostring(v.leaguaCurMemberCount).."/"..tostring(v.leaguaMaxMemberCount)
		pItem:getVarLabelBMFont("mteampeople"):setString(memberstr)
		--[[required int32 leaguaID = 1;required int32 medalID = 9;]]
        local toteamV=1
        for ktotemInfo,vtotemInfo in pairs(v.totemInfo) do
            if toteamV<=5 then
                pItem:getVarLabelBMFont("mElementNum"..tostring(toteamV)):setString(tostring(vtotemInfo.totemLeftHP))
                pItem:getVarSprite("mElementPic"..tostring(toteamV)):setTexture(LianMengTotemInfo[vtotemInfo.totemID-2].iconpath)
                toteamV=toteamV+1
            end
        end
		pItem:registerFunctionHandler(LianMengRobRank.onAttackPress)
		node:addChild(pItem)
		
		local linecount = math.floor(count - k )
		sizeX = pItem:getContentSize().width;
		sizeY = pItem:getContentSize().height
		pItem:setPositionY(linecount*sizeY)
	end
	node:setContentSize(CCSize(sizeX,(count*sizeY)))
	container.mContent:setContainer(node)
	container.mContent:setContentOffset(container.mContent:minContainerOffset());
end

function LianMengRobRank.onExit(container)	
    CCLuaLog("LianMengPage.onExit")
    container:removePacket(OP_League_pb.OPCODE_GET_TOTEMINFORET_S)
end

function LianMengRobRank.onExecute(container)

end

function LianMengRobRank.onLoad(container)
	CCLuaLog("LianMengPage.onLoad")
	container:loadCcbiFile("LianMengRankingRob.ccbi");
	CCLuaLog(container:dumpInfo())
end

function LianMengRobRank.onUnLoad(container)
	CCLuaLog("LianMengPage.onUnLoad")
end

function LianMengRobRank.onReceivePacket(container)
	CCLuaLog("LianMengPage.onReceivePacket")
	if(container:getRecPacketOpcode() == OP_League_pb.OPCODE_GET_TOTEMINFORET_S) then
		container:removePacket(OP_League_pb.OPCODE_GET_TOTEMINFORET_S)
		local msg = LeagueStruct_pb.OPGetTotemInfoRet()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		
		for k,v in ipairs(msg._totemInfoList) do
	        LianMengRobRank.LeagueTotemRobInfo._totemInfoList[k] = v;
	    end
		LianMengRobRank.LeagueTotemRobInfo.status = msg.status
		LianMengRobRank.LeagueTotemRobInfo.totalContribution = msg.totalContribution
		LianMengRobRank.LeagueTotemRobInfo.ReceiveContribution = msg.ReceiveContribution
        LianMengRobRank.LeagueTotemRobInfo.curSurplusAddition = msg.curSurplusAddition
		MainFrame:getInstance():showPage("LianMengTotemRob")
	end
end

function LianMengRobRank.onGameMessage(container)
	CCLuaLog("LianMengPage.onGameMessage")
end

