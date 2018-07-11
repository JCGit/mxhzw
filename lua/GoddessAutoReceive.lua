require "GoddessRebate_pb"
GoddessAutoReceive = {}
GoddessAutoReceive.mHasRecharge=false
GoddessAutoReceive.totalCount=0
GoddessAutoReceive.addCount=0
function GoddessAutoReceive.onReceivePkt(eventName,handler)
	if eventName == "luaReceivePacket" then
		local msg = GoddessRebate_pb.OPGoddessRebateAddRet()
		local msgbuff = handler:getRecPacketBuffer();
		msg:ParseFromString(msgbuff)
        GoddessAutoReceive.mHasRecharge=true
        GoddessAutoReceive.totalCount=msg.totalCount
        GoddessAutoReceive.addCount=msg.addCount
        local str=Language:getInstance():getString("@GoddessFlowRechargeTip")
        str=string.gsub(str,"#v1#",tostring(GoddessAutoReceive.addCount))
        str=string.gsub(str,"#v2#",tostring(GoddessAutoReceive.totalCount))
        MessageBoxPage:Msg_Box_Lan(str)
	end
end
PacketScriptHandler:new(223, GoddessAutoReceive.onReceivePkt)
