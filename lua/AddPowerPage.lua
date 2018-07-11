require "UserBasicInfo_pb"
require "GetAdventurePowerInfo_pb"
require "AddPower_pb"
require "UserBattle_pb"

AddPowerPage = {}

AddPowerPage.AddPowerType = {AM_ADD=1, PM_ADD=2,CAN_NOT_ADD=3}
AddPowerPage.AddPowerTime = {AMSTART_TIME=12,AMEND_TIME=13,PMSTART_TIME=18,PMEND_TIME=19}
AddPowerPage.AddPowerType = {CAN_NOT_REWARD=0,CAN_REWARD=1,ALREADY_REWARD=2}
AddPowerPage.mIsInitData = false;

function AddPowerPage.onFunction(eventName,container)
    --CCLuaLog("eventName"..eventName);
    if eventName == "luaInit" then
        AddPowerPage.onInit(container)
    elseif eventName == "luaEnter" then
        AddPowerPage.onEnter(container)
    elseif eventName == "luaExit" then
        AddPowerPage.onExit(container)
    elseif eventName == "luaExecute" then
        AddPowerPage.onExecute(container)
    elseif eventName == "luaLoad" then
        AddPowerPage.onLoad(container)
    elseif eventName == "luaUnLoad" then
        AddPowerPage.onUnLoad(container)
	elseif eventName == "luaGameMessage" then
		AddPowerPage.onGameMessage(container)
	elseif eventName == "luaReceivePacket" then
		AddPowerPage.onReceivePacket(container)
    elseif eventName == "onAddPowerButton" then
		AddPowerPage.onAddPowerButton(container)
    end
end

function AddPowerPage.onInit(container)
    CCLuaLog("AddPowerPage.onInit")
end

function AddPowerPage.onEnter(container)
    CCLuaLog("AddPowerPage.onEnter")
	container:registerPacket(110)
	--send packet
	if not AddPowerPage.mIsInitData then
		local msg = GetAdventurePowerInfo_pb.OPGetAdventurePower()
		msg.version = 1
		local pb_data = msg:SerializeToString()
		container:sendPakcet(109,pb_data,#pb_data,true)
	end
end

function AddPowerPage.onExit(container)	
    CCLuaLog("AddPowerPage.onExit")
	container:removePacket(110)
end

function AddPowerPage.onExecute(container)
    --CCLuaLog("AddPowerPage.onExecute")
    if AddPowerPage.mIsInitData then
		if container.mAMLabelTxt then
			container.mAMLabelTxt:setVisible(true)
		end
		if container.mPMLabelTxt then
			container.mPMLabelTxt:setVisible(true)
		end
		AddPowerPage.changePowerStatus(container)
	end
end

function AddPowerPage.changePowerStatus(container)
	local userAddPowerInfo = ServerDateManager:getInstance():getUserAdventureDataInfo()
	local cur_hour = os.date("*t").hour
	container.mAddPowerType = AddPowerPage.AddPowerType.CAN_NOT_ADD
	if cur_hour < AddPowerPage.AddPowerTime.AMSTART_TIME then
		container.mAMLabelTxt:setString(Language:getInstance():getString("@TimeIsNot"))
		container.mPMLabelTxt:setString(Language:getInstance():getString("@TimeIsNot"))
		container.mCanEat:setVisible(false);
		container.mCanNotEat:setVisible(true);
	elseif cur_hour >= AddPowerPage.AddPowerTime.AMSTART_TIME and cur_hour < AddPowerPage.AddPowerTime.AMEND_TIME then
		container.mPMLabelTxt:setString(Language:getInstance():getString("@TimeIsNot"))
		if userAddPowerInfo.addPowerInfo.amStatus < AddPowerPage.AddPowerType.ALREADY_REWARD then
            container.mAMLabelTxt:setString(Language:getInstance():getString("@TimeUp"))
			container.mCanNotEat:setVisible(false)
			container.mCanEat:setVisible(true)
			container.mAddPowerType = AddPowerPage.AddPowerType.AM_ADD
		else
			mAMLabelTxt:setString(Language:getInstance():getString("@AlreadyAddPower"))
			mCanNotEat:setVisible(true)
			mCanEat:setVisible(false)
		end
	elseif cur_hour >= AddPowerPage.AddPowerTime.AMEND_TIME and cur_hour < AddPowerPage.AddPowerTime.PMSTART_TIME then
		if userAddPowerInfo.addPowerInfo.amStatus < AddPowerPage.AddPowerType.ALREADY_REWARD then
		    local str = Language:getInstance():getString("@TimeOut")
			container.mAMLabelTxt:setString(str)
		else
		    local str = Language:getInstance():getString("@AlreadyAddPower")
			container.mAMLabelTxt:setString(str)
		end
		local str = Language:getInstance():getString("@TimeIsNot")
		container.mPMLabelTxt:setString(str)
		--[[container.mCanNotEat:setVisible(true)
		container.mCanEat:setVisible(false)--]]
	elseif cur_hour >= AddPowerPage.AddPowerTime.PMSTART_TIME and cur_hour < AddPowerPage.AddPowerTime.PMEND_TIME then
		if userAddPowerInfo.addPowerInfo.amStatus < AddPowerPage.AddPowerType.ALREADY_REWARD then
		    local str = Language:getInstance():getString("@TimeOut")
			container.mAMLabelTxt:setString(str)
		else
		    local str = Language:getInstance():getString("@AlreadyAddPower")
			container.mAMLabelTxt:setString(str)
		end
		if userAddPowerInfo.addPowerInfo.pmStatus < AddPowerPage.AddPowerType.ALREADY_REWARD then
		    local str = Language:getInstance():getString("@TimeUp")
			container.mPMLabelTxt:setString(str)
			container.mCanNotEat:setVisible(false)
			container.mCanEat:setVisible(true)
			container.mAddPowerType = AddPowerPage.AddPowerType.PM_ADD
		else
		    local str = Language:getInstance():getString("@AlreadyAddPower")
			container.mPMLabelTxt:setString(str)
			container.mCanNotEat:setVisible(true)
			container.mCanEat:setVisible(false)
		end
	elseif cur_hour >= AddPowerPage.AddPowerTime.PMEND_TIME then
		if userAddPowerInfo.addPowerInfo.amStatus < AddPowerPage.AddPowerType.ALREADY_REWARD then
		    local str = Language:getInstance():getString("@TimeOut")
			container.mAMLabelTxt:setString(str)
		else
		    local str = Language:getInstance():getString("@AlreadyAddPower")
			container.mAMLabelTxt:setString(str)
		end
		if userAddPowerInfo.addPowerInfo.pmStatus < AddPowerPage.AddPowerType.ALREADY_REWARD then
		    local str = Language:getInstance():getString("@TimeOut")
			container.mPMLabelTxt:setString(str)
		else
		    local str = Language:getInstance():getString("@AlreadyAddPower")
			container.mPMLabelTxt:setString(str)
		end	
		container.mCanNotEat:setVisible(true)
		container.mCanEat:setVisible(false)
	end
end

function AddPowerPage.onLoad(container)
	CCLuaLog("AddPowerPage.onLoad");
	container:loadCcbiFile("AddPowerPage.ccbi");
	
	container.mAMLabelTxt = container:getVarLabelBMFont("mAMStatusTxt")
    container.mAMLabelTxt:setVisible(false)
    
    container.mPMLabelTxt = container:getVarLabelBMFont("mPMStatusTxt")
    container.mPMLabelTxt:setVisible(false)
    
    container.mCanNotEat = container:getVarNode("mam1")
    container.mCanNotEat:setVisible(false)
    
    container.mCanEat = container:getVarNode("mam2")
    container.mCanEat:setVisible(false)
    
end

function AddPowerPage.onUnLoad(container)
	CCLuaLog("AddPowerPage.onUnLoad");
end

function AddPowerPage.onAddPowerButton(container)
	CCLuaLog("AddPowerPage.onAddPowerButton")
	if container.mAddPowerType ~= AddPowerPage.AddPowerType.CAN_NOT_ADD then
		container.mCanEat:setVisible(false)
		container.mCanNotEat:setVisible(true)
		
		container:registerPacket(64)
		local msg = AddPower_pb.OPAddPower()
		msg.typeid = 1
		local pb_data = msg:SerializeToString()
		container:sendPakcet(63,pb_data,#pb_data,true)
		
		local info = ServerDateManager:getInstance():getUserAdventureDataInfo()
		if container.mAddPowerType==AddPowerPage.AddPowerType.AM_ADD then
			info.addPowerInfo.amStatus=2
		elseif container.mAddPowerType==AddPowerPage.AddPowerType.PM_ADD then
			info.addPowerInfo.pmStatus=2
		end
	end
	--[[
	msg = UserBattle_pb.OPUserBattle()
	msg.type = msg.CARRER
	msg.version = 1
	msg.opponentID = 0
	msg.stage = 104
	pb_data = msg:SerializeToString()
	container:sendPakcet(107,pb_data,#pb_data,true)
	container:registerPacket(108)
	--]]
end

function AddPowerPage.onReceivePacket(container)
	if container:getRecPacketOpcode()==110 then
		AddPowerPage.mIsInitData = true;
	elseif container:getRecPacketOpcode()==64 then
		MessageBoxPage:Msg_Box_Lan("@AdventureAddPowerSuccess")
		container:removePacket(64)
	end
	
	if(container:getRecPacketOpcode()==110) then
		local msg = GetAdventurePowerInfo_pb.OPGetAdventurePowerRet()
		--local str = bp_daba:getBuffer()
		msgbuff = container:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
		amstatus = msg.amStatus
		pmstatus = msg.pmStatus
		CCLuaLog("got 110 message ok")
		if(msg.amStatus<2) then
			container.mCanEat:setVisible(true);
		end
	end
	
	--[[
	if(container:getRecPacketOpcode()==108) then
		CCLuaLog("receive fight");
		FightPage:getInstance():setMessage(container:getRecPacketBuffer(),container:getRecPacketBufferLength())
		FightPage:getInstance():setFightType(CareerBattle)
		--FightPage:getInstance():fight()
		container:sendMessage(4,"FightPage")
	end
	--]]
end

function AddPowerPage.onGameMessage(container)
	CCLuaLog("AddPowerPage.onGameMessage")
	--[[
	if container:getMessageID()==1 then
		CCLuaLog("!!!special message")
		CCLuaLog(container:getMessagePara())
	end
	--]]
end

function luaCreat_AddPowerPage(container)
    CCLuaLog("OnCreat_AddPowerPage")
    container:registerFunctionHandler(AddPowerPage.onFunction)
end

local function calbackfun(eventName)
    CCLuaLog("AddPowerPage.calbackfun")
    if eventName == "onFunction1" then
        MessageBoxPage:Msg_Box("@LevelForArena")
    elseif eventName == "onFunction2" then
        MessageBoxPage:Msg_Box_Lan("@LevelForArena")
    end
end

local function test()
	--AddPowerPage.onUnLoad(container)
        --GetPropManager:getInstance():popUpPage(GetPropManager.EQUIPMENT,13248,1)
       --local ins = InstructionManager:getInstance():loadLocalInstructionStep();
      -- container:registerMessage(1)
	--container:sendMessage(1,"BuyPropsPage\t1")
		--inifile = ConfigFile();inifile:load("Varible.txt");outputstr = inifile:getSetting("ImageFileQuality1");CCLuaLog(outputstr)
		--strIn,strout,lines = GameMaths:stringAutoReturn("Hello world","",1,0);CCLuaLog(strout)
		--if TimeCalculator:getInstance():hasKey("tempCacultor") then

    --TimeCalculator:getInstance():createTimeCalcultor("tempCacultor",1000)
    --sdm = ServerDateManager:getInstance()
    --num = sdm:getDiscipleInfoTotalNum()
    --CCLuaLog(num)
    --disciple = sdm:getUserDiscipleInfoByIndex(0)
    --CCLuaLog(disciple.id)
    --disciple1 = sdm:getUserDiscipleInfoByIndex(1)
    --CCLuaLog(disciple1.id)
    --[[
    d = Disciple(2, true)
    CCLuaLog(d:name())
    CCLuaLog(d:getYuanfenDescribe())
    s = Soul(2)
    CCLuaLog(s:name())
    CCLuaLog(s:getYuanfenDescribe())
    
    skill = Skill(2, true)
    CCLuaLog(skill:name())
    CCLuaLog(skill:describe())
    
    e = Equip(2, true)
    CCLuaLog(e:name())
    CCLuaLog(e:describe())
    
    t = Title(2)
    CCLuaLog(t:name())
    CCLuaLog(t:describe())
    
    ao = ArenaOpponent(2)
    CCLuaLog(ao:name())
    CCLuaLog(ao:arenaRank())
    
    ar = ArenaReward(2)
    CCLuaLog(ar:title())
    CCLuaLog(ar:needScore())
    --]]
    --MessageBoxPage:Msg_Box_Lan("@LevelForArena")
    --PopupPage:Pop_Box(NotEnoughGold)
    --PopupPage:Pop_Box("@BuyFailMsg", "@BuyFailTitle", "@Close", "@Recharge", calbackfun)
    --PopupNotEnoughPage:Pop_NotEnough_Box(VitalityNotEnough)
    --GiftPreviewPage:addContent("aaaaa", "itemposter/poster_item_qiannengyaoji.png", 10 ,2)
    --GiftPreviewPage:addContent("bbbbb", "itemposter/poster_item_langmujiu.png", 9 ,3)
    --GiftPreviewPage:showPage("@GiftPackPreviewText")
	--if !AddPowerPage.mIsInitData then
		--OPGetAdventurePower* msg = new OPGetAdventurePower;
		--msg:set_version(1);
		--PacketManager::Get():sendPakcet(OPCODE_GET_ADVENTURE_POWERINFO_C,msg);
	--end
end
