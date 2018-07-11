require "OP_League_pb"
require "LeagueStruct_pb"
require "LeagueStruct_ext_pb"

DecisionPage = {}
DecisionPage.mDecisionTex = ""
DecisionPage.mDecisionCallBack = nil
function luaCreat_DecisionPage(container)
    container:registerFunctionHandler(DecisionPage.onFunction)
end

function DecisionPage.onFunction(eventName,container)
    if eventName == "luaLoad" then
        DecisionPage.onLoad(container)
	elseif eventName == "onNo" or eventName == "onClose" then
	    DecisionPage.onNo(container)
	elseif eventName == "onYes" then
	    DecisionPage.onYes(container)
    end
end

function DecisionPage.onYes(container)
    if DecisionPage.mDecisionCallBack then
        DecisionPage.mDecisionCallBack(true)
    end
    DecisionPage.mDecisionTex = ""
    DecisionPage.mDecisionCallBack = nil
    MainFrame:getInstance():popPage("DecisionPage")
end

function DecisionPage.onNo(container)
    if DecisionPage.mDecisionCallBack then
        DecisionPage.mDecisionCallBack(false)
    end
    DecisionPage.mDecisionTex = ""
    DecisionPage.mDecisionCallBack = nil
    MainFrame:getInstance():popPage("DecisionPage")
end

function DecisionPage.onLoad(container)
	container:loadCcbiFile("Decision.ccbi")
	local s = Language:getInstance():getString(DecisionPage.mDecisionTex)
	container:getVarLabelBMFont("mDecisionTex"):setString(s)
end

function ShowDecisionPage(tex, func)
    DecisionPage.mDecisionTex = tex
    DecisionPage.mDecisionCallBack = func
    MainFrame:getInstance():pushPage("DecisionPage")
end

