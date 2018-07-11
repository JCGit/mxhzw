-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('AdventureInfo_pb')


local OPADVENTUREINFO = protobuf.Descriptor();
local OPADVENTUREINFO_VERSION_FIELD = protobuf.FieldDescriptor();
local OPADVENTUREINFORET = protobuf.Descriptor();
local OPADVENTUREINFORET_ADVENTUREITEM = protobuf.Descriptor();
local OPADVENTUREINFORET_ADVENTUREITEM_ID_FIELD = protobuf.FieldDescriptor();
local OPADVENTUREINFORET_ADVENTUREITEM_ADVENTUREID_FIELD = protobuf.FieldDescriptor();
local OPADVENTUREINFORET_ADVENTUREITEM_ITEMID_FIELD = protobuf.FieldDescriptor();
local OPADVENTUREINFORET_ADVENTUREITEM_LEVELLIMIT_FIELD = protobuf.FieldDescriptor();
local OPADVENTUREINFORET_ADVENTUREITEM_BEGINTIME_FIELD = protobuf.FieldDescriptor();
local OPADVENTUREINFORET_ADVENTUREITEM_ENDTIME_FIELD = protobuf.FieldDescriptor();
local OPADVENTUREINFORET_ADVENTUREITEM_ITEMCOUNT_FIELD = protobuf.FieldDescriptor();
local OPADVENTUREINFORET_SERVERTIME_FIELD = protobuf.FieldDescriptor();
local OPADVENTUREINFORET_ADVENTUREITEM_FIELD = protobuf.FieldDescriptor();

OPADVENTUREINFO_VERSION_FIELD.name = "version"
OPADVENTUREINFO_VERSION_FIELD.full_name = ".OPAdventureInfo.version"
OPADVENTUREINFO_VERSION_FIELD.number = 1
OPADVENTUREINFO_VERSION_FIELD.index = 0
OPADVENTUREINFO_VERSION_FIELD.label = 2
OPADVENTUREINFO_VERSION_FIELD.has_default_value = true
OPADVENTUREINFO_VERSION_FIELD.default_value = 1
OPADVENTUREINFO_VERSION_FIELD.type = 5
OPADVENTUREINFO_VERSION_FIELD.cpp_type = 1

OPADVENTUREINFO.name = "OPAdventureInfo"
OPADVENTUREINFO.full_name = ".OPAdventureInfo"
OPADVENTUREINFO.nested_types = {}
OPADVENTUREINFO.enum_types = {}
OPADVENTUREINFO.fields = {OPADVENTUREINFO_VERSION_FIELD}
OPADVENTUREINFO.is_extendable = false
OPADVENTUREINFO.extensions = {}
OPADVENTUREINFORET_ADVENTUREITEM_ID_FIELD.name = "id"
OPADVENTUREINFORET_ADVENTUREITEM_ID_FIELD.full_name = ".OPAdventureInfoRet.AdventureItem.id"
OPADVENTUREINFORET_ADVENTUREITEM_ID_FIELD.number = 1
OPADVENTUREINFORET_ADVENTUREITEM_ID_FIELD.index = 0
OPADVENTUREINFORET_ADVENTUREITEM_ID_FIELD.label = 2
OPADVENTUREINFORET_ADVENTUREITEM_ID_FIELD.has_default_value = false
OPADVENTUREINFORET_ADVENTUREITEM_ID_FIELD.default_value = 0
OPADVENTUREINFORET_ADVENTUREITEM_ID_FIELD.type = 5
OPADVENTUREINFORET_ADVENTUREITEM_ID_FIELD.cpp_type = 1

OPADVENTUREINFORET_ADVENTUREITEM_ADVENTUREID_FIELD.name = "adventureId"
OPADVENTUREINFORET_ADVENTUREITEM_ADVENTUREID_FIELD.full_name = ".OPAdventureInfoRet.AdventureItem.adventureId"
OPADVENTUREINFORET_ADVENTUREITEM_ADVENTUREID_FIELD.number = 2
OPADVENTUREINFORET_ADVENTUREITEM_ADVENTUREID_FIELD.index = 1
OPADVENTUREINFORET_ADVENTUREITEM_ADVENTUREID_FIELD.label = 2
OPADVENTUREINFORET_ADVENTUREITEM_ADVENTUREID_FIELD.has_default_value = false
OPADVENTUREINFORET_ADVENTUREITEM_ADVENTUREID_FIELD.default_value = 0
OPADVENTUREINFORET_ADVENTUREITEM_ADVENTUREID_FIELD.type = 5
OPADVENTUREINFORET_ADVENTUREITEM_ADVENTUREID_FIELD.cpp_type = 1

OPADVENTUREINFORET_ADVENTUREITEM_ITEMID_FIELD.name = "itemId"
OPADVENTUREINFORET_ADVENTUREITEM_ITEMID_FIELD.full_name = ".OPAdventureInfoRet.AdventureItem.itemId"
OPADVENTUREINFORET_ADVENTUREITEM_ITEMID_FIELD.number = 3
OPADVENTUREINFORET_ADVENTUREITEM_ITEMID_FIELD.index = 2
OPADVENTUREINFORET_ADVENTUREITEM_ITEMID_FIELD.label = 1
OPADVENTUREINFORET_ADVENTUREITEM_ITEMID_FIELD.has_default_value = false
OPADVENTUREINFORET_ADVENTUREITEM_ITEMID_FIELD.default_value = 0
OPADVENTUREINFORET_ADVENTUREITEM_ITEMID_FIELD.type = 5
OPADVENTUREINFORET_ADVENTUREITEM_ITEMID_FIELD.cpp_type = 1

OPADVENTUREINFORET_ADVENTUREITEM_LEVELLIMIT_FIELD.name = "levelLimit"
OPADVENTUREINFORET_ADVENTUREITEM_LEVELLIMIT_FIELD.full_name = ".OPAdventureInfoRet.AdventureItem.levelLimit"
OPADVENTUREINFORET_ADVENTUREITEM_LEVELLIMIT_FIELD.number = 4
OPADVENTUREINFORET_ADVENTUREITEM_LEVELLIMIT_FIELD.index = 3
OPADVENTUREINFORET_ADVENTUREITEM_LEVELLIMIT_FIELD.label = 2
OPADVENTUREINFORET_ADVENTUREITEM_LEVELLIMIT_FIELD.has_default_value = false
OPADVENTUREINFORET_ADVENTUREITEM_LEVELLIMIT_FIELD.default_value = 0
OPADVENTUREINFORET_ADVENTUREITEM_LEVELLIMIT_FIELD.type = 5
OPADVENTUREINFORET_ADVENTUREITEM_LEVELLIMIT_FIELD.cpp_type = 1

OPADVENTUREINFORET_ADVENTUREITEM_BEGINTIME_FIELD.name = "beginTime"
OPADVENTUREINFORET_ADVENTUREITEM_BEGINTIME_FIELD.full_name = ".OPAdventureInfoRet.AdventureItem.beginTime"
OPADVENTUREINFORET_ADVENTUREITEM_BEGINTIME_FIELD.number = 5
OPADVENTUREINFORET_ADVENTUREITEM_BEGINTIME_FIELD.index = 4
OPADVENTUREINFORET_ADVENTUREITEM_BEGINTIME_FIELD.label = 2
OPADVENTUREINFORET_ADVENTUREITEM_BEGINTIME_FIELD.has_default_value = false
OPADVENTUREINFORET_ADVENTUREITEM_BEGINTIME_FIELD.default_value = 0
OPADVENTUREINFORET_ADVENTUREITEM_BEGINTIME_FIELD.type = 5
OPADVENTUREINFORET_ADVENTUREITEM_BEGINTIME_FIELD.cpp_type = 1

OPADVENTUREINFORET_ADVENTUREITEM_ENDTIME_FIELD.name = "endTime"
OPADVENTUREINFORET_ADVENTUREITEM_ENDTIME_FIELD.full_name = ".OPAdventureInfoRet.AdventureItem.endTime"
OPADVENTUREINFORET_ADVENTUREITEM_ENDTIME_FIELD.number = 6
OPADVENTUREINFORET_ADVENTUREITEM_ENDTIME_FIELD.index = 5
OPADVENTUREINFORET_ADVENTUREITEM_ENDTIME_FIELD.label = 2
OPADVENTUREINFORET_ADVENTUREITEM_ENDTIME_FIELD.has_default_value = false
OPADVENTUREINFORET_ADVENTUREITEM_ENDTIME_FIELD.default_value = 0
OPADVENTUREINFORET_ADVENTUREITEM_ENDTIME_FIELD.type = 5
OPADVENTUREINFORET_ADVENTUREITEM_ENDTIME_FIELD.cpp_type = 1

OPADVENTUREINFORET_ADVENTUREITEM_ITEMCOUNT_FIELD.name = "itemCount"
OPADVENTUREINFORET_ADVENTUREITEM_ITEMCOUNT_FIELD.full_name = ".OPAdventureInfoRet.AdventureItem.itemCount"
OPADVENTUREINFORET_ADVENTUREITEM_ITEMCOUNT_FIELD.number = 7
OPADVENTUREINFORET_ADVENTUREITEM_ITEMCOUNT_FIELD.index = 6
OPADVENTUREINFORET_ADVENTUREITEM_ITEMCOUNT_FIELD.label = 1
OPADVENTUREINFORET_ADVENTUREITEM_ITEMCOUNT_FIELD.has_default_value = false
OPADVENTUREINFORET_ADVENTUREITEM_ITEMCOUNT_FIELD.default_value = 0
OPADVENTUREINFORET_ADVENTUREITEM_ITEMCOUNT_FIELD.type = 5
OPADVENTUREINFORET_ADVENTUREITEM_ITEMCOUNT_FIELD.cpp_type = 1

OPADVENTUREINFORET_ADVENTUREITEM.name = "AdventureItem"
OPADVENTUREINFORET_ADVENTUREITEM.full_name = ".OPAdventureInfoRet.AdventureItem"
OPADVENTUREINFORET_ADVENTUREITEM.nested_types = {}
OPADVENTUREINFORET_ADVENTUREITEM.enum_types = {}
OPADVENTUREINFORET_ADVENTUREITEM.fields = {OPADVENTUREINFORET_ADVENTUREITEM_ID_FIELD, OPADVENTUREINFORET_ADVENTUREITEM_ADVENTUREID_FIELD, OPADVENTUREINFORET_ADVENTUREITEM_ITEMID_FIELD, OPADVENTUREINFORET_ADVENTUREITEM_LEVELLIMIT_FIELD, OPADVENTUREINFORET_ADVENTUREITEM_BEGINTIME_FIELD, OPADVENTUREINFORET_ADVENTUREITEM_ENDTIME_FIELD, OPADVENTUREINFORET_ADVENTUREITEM_ITEMCOUNT_FIELD}
OPADVENTUREINFORET_ADVENTUREITEM.is_extendable = false
OPADVENTUREINFORET_ADVENTUREITEM.extensions = {}
OPADVENTUREINFORET_ADVENTUREITEM.containing_type = OPADVENTUREINFORET
OPADVENTUREINFORET_SERVERTIME_FIELD.name = "servertime"
OPADVENTUREINFORET_SERVERTIME_FIELD.full_name = ".OPAdventureInfoRet.servertime"
OPADVENTUREINFORET_SERVERTIME_FIELD.number = 1
OPADVENTUREINFORET_SERVERTIME_FIELD.index = 0
OPADVENTUREINFORET_SERVERTIME_FIELD.label = 2
OPADVENTUREINFORET_SERVERTIME_FIELD.has_default_value = false
OPADVENTUREINFORET_SERVERTIME_FIELD.default_value = 0
OPADVENTUREINFORET_SERVERTIME_FIELD.type = 5
OPADVENTUREINFORET_SERVERTIME_FIELD.cpp_type = 1

OPADVENTUREINFORET_ADVENTUREITEM_FIELD.name = "adventureItem"
OPADVENTUREINFORET_ADVENTUREITEM_FIELD.full_name = ".OPAdventureInfoRet.adventureItem"
OPADVENTUREINFORET_ADVENTUREITEM_FIELD.number = 2
OPADVENTUREINFORET_ADVENTUREITEM_FIELD.index = 1
OPADVENTUREINFORET_ADVENTUREITEM_FIELD.label = 3
OPADVENTUREINFORET_ADVENTUREITEM_FIELD.has_default_value = false
OPADVENTUREINFORET_ADVENTUREITEM_FIELD.default_value = {}
OPADVENTUREINFORET_ADVENTUREITEM_FIELD.message_type = OPADVENTUREINFORET_ADVENTUREITEM
OPADVENTUREINFORET_ADVENTUREITEM_FIELD.type = 11
OPADVENTUREINFORET_ADVENTUREITEM_FIELD.cpp_type = 10

OPADVENTUREINFORET.name = "OPAdventureInfoRet"
OPADVENTUREINFORET.full_name = ".OPAdventureInfoRet"
OPADVENTUREINFORET.nested_types = {OPADVENTUREINFORET_ADVENTUREITEM}
OPADVENTUREINFORET.enum_types = {}
OPADVENTUREINFORET.fields = {OPADVENTUREINFORET_SERVERTIME_FIELD, OPADVENTUREINFORET_ADVENTUREITEM_FIELD}
OPADVENTUREINFORET.is_extendable = false
OPADVENTUREINFORET.extensions = {}

OPAdventureInfo = protobuf.Message(OPADVENTUREINFO)
OPAdventureInfoRet = protobuf.Message(OPADVENTUREINFORET)
OPAdventureInfoRet.AdventureItem = protobuf.Message(OPADVENTUREINFORET_ADVENTUREITEM)
