require "OP_League_pb"
require "LeagueStruct_pb"
require "LeagueStruct_ext_pb"

local LianMengShopBuyPage = {}
LianMengShopBuyPage.Num = 0
function luaCreat_LianMengShopBuyPage(container)
    container:registerFunctionHandler(LianMengShopBuyPage.onFunction)
end

function LianMengShopBuyPage.onFunction(eventName,container)
    if eventName == "luaLoad" then
        LianMengShopBuyPage.onLoad(container)
    elseif eventName == "luaReceivePacket" then
	    LianMengShopBuyPage.onReceivePacket(container)
	elseif eventName == "onReduceNum10" then
	    LianMengShopBuyPage.onReduceNum10(container)
	elseif eventName == "onReduceNum" then
	    LianMengShopBuyPage.onReduceNum(container)
	elseif eventName == "onAddNum" then
	    LianMengShopBuyPage.onAddNum(container)
	elseif eventName == "onAddNum10" then
	    LianMengShopBuyPage.onAddNum10(container)
	elseif eventName == "onConfirm" then
	    LianMengShopBuyPage.onConfirm(container)
	elseif eventName == "onClose" then
	    LianMengShopBuyPage.onClose(container)
    end
end

function LianMengShopBuyPage.onClose(container)
    MainFrame:getInstance():popPage("LianMengShopBuyPage")
end

function LianMengShopBuyPage.onReduceNum(container)
    if LianMengShopBuyPage.Num <= 0  then
        LianMengShopBuyPage.Num = 0
    else 
        LianMengShopBuyPage.Num = LianMengShopBuyPage.Num - 1
    end
    LianMengShopBuyPage.refresh(container)
end

function LianMengShopBuyPage.onReduceNum10(container)
    if LianMengShopBuyPage.Num <= 10  then
        LianMengShopBuyPage.Num = 0
    else 
        LianMengShopBuyPage.Num = LianMengShopBuyPage.Num - 10
    end
    LianMengShopBuyPage.refresh(container)
end

function LianMengShopBuyPage.onAddNum(container)
    LianMengShopBuyPage.Num = LianMengShopBuyPage.Num + 1
    local maxNum = LeaguaShopInfo.shopGoodInfoList[getShopBuyGoodIndex()].goodCount
    if LianMengShopBuyPage.Num >=  maxNum then
	    LianMengShopBuyPage.Num = maxNum
	    MessageBoxPage:Msg_Box_Lan("@LianMengShopBuy_Max")
    end
    LianMengShopBuyPage.refresh(container)
end

function LianMengShopBuyPage.onAddNum10(container)
    LianMengShopBuyPage.Num = LianMengShopBuyPage.Num + 10
    local maxNum = LeaguaShopInfo.shopGoodInfoList[getShopBuyGoodIndex()].goodCount
    if LianMengShopBuyPage.Num >=  maxNum then
	    LianMengShopBuyPage.Num = maxNum
	    MessageBoxPage:Msg_Box_Lan("@LianMengShopBuy_Max")
    end
    LianMengShopBuyPage.refresh(container)
end

function LianMengShopBuyPage.onConfirm(container)
    if LianMengShopBuyPage.Num == 0 then
        MessageBoxPage:Msg_Box_Lan("@LianMengShopBuy_InputBuyNum")
    else
        container:registerPacket(OP_League_pb.OPCODE_LEAGUASHOPBUYRET_S)
	    local msg = LeagueStruct_ext_pb.OPLeaguaShopBuy()
	    msg.id = LeaguaShopInfo.shopGoodInfoList[getShopBuyGoodIndex()].id
	    msg.goodNum = LianMengShopBuyPage.Num
	    local pb_data = msg:SerializeToString()
	    PacketManager:getInstance():sendPakcet(OP_League_pb.OPCODE_LEAGUASHOPBUY_C,pb_data,#pb_data,true)
    end
	LianMengShopBuyPage.Num = 0
	MainFrame:getInstance():popPage("LianMengShopBuyPage")
end

function LianMengShopBuyPage.refresh(container)
	container:getVarLabelBMFont("mNum"):setString(tostring(LianMengShopBuyPage.Num))
	container:getVarLabelBMFont("mlmjsjuanxiantitle"):setString(tostring(Language:getInstance():getString("@mlmjsjuanxiantitle")))
	container:getVarLabelBMFont("mjuanxianNote"):setString(tostring(Language:getInstance():getString("@Not Enough Gold")))
end

function LianMengShopBuyPage.onLoad(container)
	container:loadCcbiFile("lianmengjsjuanxian.ccbi")
	LianMengShopBuyPage.refresh(container)
end

