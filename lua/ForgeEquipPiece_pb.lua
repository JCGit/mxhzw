-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('ForgeEquipPiece_pb')


local OPFORGEEQUIPPIECE = protobuf.Descriptor();
local OPFORGEEQUIPPIECE_EUIPITEM_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET = protobuf.Descriptor();
local OPFORGEEQUIPPIECERET_TOOLINFO = protobuf.Descriptor();
local OPFORGEEQUIPPIECERET_TOOLINFO_ID_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_TOOLINFO_ITEMID_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_TOOLINFO_COUNT_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_EQUIPINFO = protobuf.Descriptor();
local OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO = protobuf.Descriptor();
local OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_TYPE_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_NUM_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_EQUIPINFO_ID_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_EQUIPINFO_ITEMID_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_EQUIPINFO_LEVEL_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_EQUIPINFO_REFINEXP_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_EQUIPINFO_REFINELEVEL_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_EQUIPINFO_PINFO_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_EQUIPINFO_STONEINFO_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_EQUIPINFO_BUFFVALUE_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_STATUS_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_TOOLSINFO_FIELD = protobuf.FieldDescriptor();
local OPFORGEEQUIPPIECERET_EQUIPSINFO_FIELD = protobuf.FieldDescriptor();

OPFORGEEQUIPPIECE_EUIPITEM_FIELD.name = "euipItem"
OPFORGEEQUIPPIECE_EUIPITEM_FIELD.full_name = ".OPForgeEquipPiece.euipItem"
OPFORGEEQUIPPIECE_EUIPITEM_FIELD.number = 1
OPFORGEEQUIPPIECE_EUIPITEM_FIELD.index = 0
OPFORGEEQUIPPIECE_EUIPITEM_FIELD.label = 2
OPFORGEEQUIPPIECE_EUIPITEM_FIELD.has_default_value = false
OPFORGEEQUIPPIECE_EUIPITEM_FIELD.default_value = 0
OPFORGEEQUIPPIECE_EUIPITEM_FIELD.type = 5
OPFORGEEQUIPPIECE_EUIPITEM_FIELD.cpp_type = 1

OPFORGEEQUIPPIECE.name = "OPForgeEquipPiece"
OPFORGEEQUIPPIECE.full_name = ".OPForgeEquipPiece"
OPFORGEEQUIPPIECE.nested_types = {}
OPFORGEEQUIPPIECE.enum_types = {}
OPFORGEEQUIPPIECE.fields = {OPFORGEEQUIPPIECE_EUIPITEM_FIELD}
OPFORGEEQUIPPIECE.is_extendable = false
OPFORGEEQUIPPIECE.extensions = {}
OPFORGEEQUIPPIECERET_TOOLINFO_ID_FIELD.name = "id"
OPFORGEEQUIPPIECERET_TOOLINFO_ID_FIELD.full_name = ".OPForgeEquipPieceRet.ToolInfo.id"
OPFORGEEQUIPPIECERET_TOOLINFO_ID_FIELD.number = 1
OPFORGEEQUIPPIECERET_TOOLINFO_ID_FIELD.index = 0
OPFORGEEQUIPPIECERET_TOOLINFO_ID_FIELD.label = 2
OPFORGEEQUIPPIECERET_TOOLINFO_ID_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_TOOLINFO_ID_FIELD.default_value = 0
OPFORGEEQUIPPIECERET_TOOLINFO_ID_FIELD.type = 5
OPFORGEEQUIPPIECERET_TOOLINFO_ID_FIELD.cpp_type = 1

OPFORGEEQUIPPIECERET_TOOLINFO_ITEMID_FIELD.name = "itemid"
OPFORGEEQUIPPIECERET_TOOLINFO_ITEMID_FIELD.full_name = ".OPForgeEquipPieceRet.ToolInfo.itemid"
OPFORGEEQUIPPIECERET_TOOLINFO_ITEMID_FIELD.number = 2
OPFORGEEQUIPPIECERET_TOOLINFO_ITEMID_FIELD.index = 1
OPFORGEEQUIPPIECERET_TOOLINFO_ITEMID_FIELD.label = 2
OPFORGEEQUIPPIECERET_TOOLINFO_ITEMID_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_TOOLINFO_ITEMID_FIELD.default_value = 0
OPFORGEEQUIPPIECERET_TOOLINFO_ITEMID_FIELD.type = 5
OPFORGEEQUIPPIECERET_TOOLINFO_ITEMID_FIELD.cpp_type = 1

OPFORGEEQUIPPIECERET_TOOLINFO_COUNT_FIELD.name = "count"
OPFORGEEQUIPPIECERET_TOOLINFO_COUNT_FIELD.full_name = ".OPForgeEquipPieceRet.ToolInfo.count"
OPFORGEEQUIPPIECERET_TOOLINFO_COUNT_FIELD.number = 3
OPFORGEEQUIPPIECERET_TOOLINFO_COUNT_FIELD.index = 2
OPFORGEEQUIPPIECERET_TOOLINFO_COUNT_FIELD.label = 2
OPFORGEEQUIPPIECERET_TOOLINFO_COUNT_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_TOOLINFO_COUNT_FIELD.default_value = 0
OPFORGEEQUIPPIECERET_TOOLINFO_COUNT_FIELD.type = 5
OPFORGEEQUIPPIECERET_TOOLINFO_COUNT_FIELD.cpp_type = 1

OPFORGEEQUIPPIECERET_TOOLINFO.name = "ToolInfo"
OPFORGEEQUIPPIECERET_TOOLINFO.full_name = ".OPForgeEquipPieceRet.ToolInfo"
OPFORGEEQUIPPIECERET_TOOLINFO.nested_types = {}
OPFORGEEQUIPPIECERET_TOOLINFO.enum_types = {}
OPFORGEEQUIPPIECERET_TOOLINFO.fields = {OPFORGEEQUIPPIECERET_TOOLINFO_ID_FIELD, OPFORGEEQUIPPIECERET_TOOLINFO_ITEMID_FIELD, OPFORGEEQUIPPIECERET_TOOLINFO_COUNT_FIELD}
OPFORGEEQUIPPIECERET_TOOLINFO.is_extendable = false
OPFORGEEQUIPPIECERET_TOOLINFO.extensions = {}
OPFORGEEQUIPPIECERET_TOOLINFO.containing_type = OPFORGEEQUIPPIECERET
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_TYPE_FIELD.name = "type"
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_TYPE_FIELD.full_name = ".OPForgeEquipPieceRet.EquipInfo.PropertyInfo.type"
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_TYPE_FIELD.number = 1
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_TYPE_FIELD.index = 0
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_TYPE_FIELD.label = 2
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_TYPE_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_TYPE_FIELD.default_value = 0
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_TYPE_FIELD.type = 5
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_TYPE_FIELD.cpp_type = 1

OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_NUM_FIELD.name = "num"
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_NUM_FIELD.full_name = ".OPForgeEquipPieceRet.EquipInfo.PropertyInfo.num"
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_NUM_FIELD.number = 2
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_NUM_FIELD.index = 1
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_NUM_FIELD.label = 2
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_NUM_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_NUM_FIELD.default_value = 0
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_NUM_FIELD.type = 5
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_NUM_FIELD.cpp_type = 1

OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO.name = "PropertyInfo"
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO.full_name = ".OPForgeEquipPieceRet.EquipInfo.PropertyInfo"
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO.nested_types = {}
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO.enum_types = {}
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO.fields = {OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_TYPE_FIELD, OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO_NUM_FIELD}
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO.is_extendable = false
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO.extensions = {}
OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO.containing_type = OPFORGEEQUIPPIECERET_EQUIPINFO
OPFORGEEQUIPPIECERET_EQUIPINFO_ID_FIELD.name = "id"
OPFORGEEQUIPPIECERET_EQUIPINFO_ID_FIELD.full_name = ".OPForgeEquipPieceRet.EquipInfo.id"
OPFORGEEQUIPPIECERET_EQUIPINFO_ID_FIELD.number = 1
OPFORGEEQUIPPIECERET_EQUIPINFO_ID_FIELD.index = 0
OPFORGEEQUIPPIECERET_EQUIPINFO_ID_FIELD.label = 2
OPFORGEEQUIPPIECERET_EQUIPINFO_ID_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_EQUIPINFO_ID_FIELD.default_value = 0
OPFORGEEQUIPPIECERET_EQUIPINFO_ID_FIELD.type = 5
OPFORGEEQUIPPIECERET_EQUIPINFO_ID_FIELD.cpp_type = 1

OPFORGEEQUIPPIECERET_EQUIPINFO_ITEMID_FIELD.name = "itemid"
OPFORGEEQUIPPIECERET_EQUIPINFO_ITEMID_FIELD.full_name = ".OPForgeEquipPieceRet.EquipInfo.itemid"
OPFORGEEQUIPPIECERET_EQUIPINFO_ITEMID_FIELD.number = 2
OPFORGEEQUIPPIECERET_EQUIPINFO_ITEMID_FIELD.index = 1
OPFORGEEQUIPPIECERET_EQUIPINFO_ITEMID_FIELD.label = 2
OPFORGEEQUIPPIECERET_EQUIPINFO_ITEMID_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_EQUIPINFO_ITEMID_FIELD.default_value = 0
OPFORGEEQUIPPIECERET_EQUIPINFO_ITEMID_FIELD.type = 5
OPFORGEEQUIPPIECERET_EQUIPINFO_ITEMID_FIELD.cpp_type = 1

OPFORGEEQUIPPIECERET_EQUIPINFO_LEVEL_FIELD.name = "level"
OPFORGEEQUIPPIECERET_EQUIPINFO_LEVEL_FIELD.full_name = ".OPForgeEquipPieceRet.EquipInfo.level"
OPFORGEEQUIPPIECERET_EQUIPINFO_LEVEL_FIELD.number = 3
OPFORGEEQUIPPIECERET_EQUIPINFO_LEVEL_FIELD.index = 2
OPFORGEEQUIPPIECERET_EQUIPINFO_LEVEL_FIELD.label = 2
OPFORGEEQUIPPIECERET_EQUIPINFO_LEVEL_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_EQUIPINFO_LEVEL_FIELD.default_value = 0
OPFORGEEQUIPPIECERET_EQUIPINFO_LEVEL_FIELD.type = 5
OPFORGEEQUIPPIECERET_EQUIPINFO_LEVEL_FIELD.cpp_type = 1

OPFORGEEQUIPPIECERET_EQUIPINFO_REFINEXP_FIELD.name = "refinexp"
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINEXP_FIELD.full_name = ".OPForgeEquipPieceRet.EquipInfo.refinexp"
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINEXP_FIELD.number = 4
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINEXP_FIELD.index = 3
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINEXP_FIELD.label = 2
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINEXP_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINEXP_FIELD.default_value = 0
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINEXP_FIELD.type = 5
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINEXP_FIELD.cpp_type = 1

OPFORGEEQUIPPIECERET_EQUIPINFO_REFINELEVEL_FIELD.name = "refinelevel"
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINELEVEL_FIELD.full_name = ".OPForgeEquipPieceRet.EquipInfo.refinelevel"
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINELEVEL_FIELD.number = 5
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINELEVEL_FIELD.index = 4
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINELEVEL_FIELD.label = 2
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINELEVEL_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINELEVEL_FIELD.default_value = 0
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINELEVEL_FIELD.type = 5
OPFORGEEQUIPPIECERET_EQUIPINFO_REFINELEVEL_FIELD.cpp_type = 1

OPFORGEEQUIPPIECERET_EQUIPINFO_PINFO_FIELD.name = "pInfo"
OPFORGEEQUIPPIECERET_EQUIPINFO_PINFO_FIELD.full_name = ".OPForgeEquipPieceRet.EquipInfo.pInfo"
OPFORGEEQUIPPIECERET_EQUIPINFO_PINFO_FIELD.number = 6
OPFORGEEQUIPPIECERET_EQUIPINFO_PINFO_FIELD.index = 5
OPFORGEEQUIPPIECERET_EQUIPINFO_PINFO_FIELD.label = 3
OPFORGEEQUIPPIECERET_EQUIPINFO_PINFO_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_EQUIPINFO_PINFO_FIELD.default_value = {}
OPFORGEEQUIPPIECERET_EQUIPINFO_PINFO_FIELD.message_type = OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO
OPFORGEEQUIPPIECERET_EQUIPINFO_PINFO_FIELD.type = 11
OPFORGEEQUIPPIECERET_EQUIPINFO_PINFO_FIELD.cpp_type = 10

OPFORGEEQUIPPIECERET_EQUIPINFO_STONEINFO_FIELD.name = "stoneInfo"
OPFORGEEQUIPPIECERET_EQUIPINFO_STONEINFO_FIELD.full_name = ".OPForgeEquipPieceRet.EquipInfo.stoneInfo"
OPFORGEEQUIPPIECERET_EQUIPINFO_STONEINFO_FIELD.number = 7
OPFORGEEQUIPPIECERET_EQUIPINFO_STONEINFO_FIELD.index = 6
OPFORGEEQUIPPIECERET_EQUIPINFO_STONEINFO_FIELD.label = 3
OPFORGEEQUIPPIECERET_EQUIPINFO_STONEINFO_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_EQUIPINFO_STONEINFO_FIELD.default_value = {}
OPFORGEEQUIPPIECERET_EQUIPINFO_STONEINFO_FIELD.type = 5
OPFORGEEQUIPPIECERET_EQUIPINFO_STONEINFO_FIELD.cpp_type = 1

OPFORGEEQUIPPIECERET_EQUIPINFO_BUFFVALUE_FIELD.name = "buffvalue"
OPFORGEEQUIPPIECERET_EQUIPINFO_BUFFVALUE_FIELD.full_name = ".OPForgeEquipPieceRet.EquipInfo.buffvalue"
OPFORGEEQUIPPIECERET_EQUIPINFO_BUFFVALUE_FIELD.number = 8
OPFORGEEQUIPPIECERET_EQUIPINFO_BUFFVALUE_FIELD.index = 7
OPFORGEEQUIPPIECERET_EQUIPINFO_BUFFVALUE_FIELD.label = 1
OPFORGEEQUIPPIECERET_EQUIPINFO_BUFFVALUE_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_EQUIPINFO_BUFFVALUE_FIELD.default_value = ""
OPFORGEEQUIPPIECERET_EQUIPINFO_BUFFVALUE_FIELD.type = 9
OPFORGEEQUIPPIECERET_EQUIPINFO_BUFFVALUE_FIELD.cpp_type = 9

OPFORGEEQUIPPIECERET_EQUIPINFO.name = "EquipInfo"
OPFORGEEQUIPPIECERET_EQUIPINFO.full_name = ".OPForgeEquipPieceRet.EquipInfo"
OPFORGEEQUIPPIECERET_EQUIPINFO.nested_types = {OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO}
OPFORGEEQUIPPIECERET_EQUIPINFO.enum_types = {}
OPFORGEEQUIPPIECERET_EQUIPINFO.fields = {OPFORGEEQUIPPIECERET_EQUIPINFO_ID_FIELD, OPFORGEEQUIPPIECERET_EQUIPINFO_ITEMID_FIELD, OPFORGEEQUIPPIECERET_EQUIPINFO_LEVEL_FIELD, OPFORGEEQUIPPIECERET_EQUIPINFO_REFINEXP_FIELD, OPFORGEEQUIPPIECERET_EQUIPINFO_REFINELEVEL_FIELD, OPFORGEEQUIPPIECERET_EQUIPINFO_PINFO_FIELD, OPFORGEEQUIPPIECERET_EQUIPINFO_STONEINFO_FIELD, OPFORGEEQUIPPIECERET_EQUIPINFO_BUFFVALUE_FIELD}
OPFORGEEQUIPPIECERET_EQUIPINFO.is_extendable = false
OPFORGEEQUIPPIECERET_EQUIPINFO.extensions = {}
OPFORGEEQUIPPIECERET_EQUIPINFO.containing_type = OPFORGEEQUIPPIECERET
OPFORGEEQUIPPIECERET_STATUS_FIELD.name = "status"
OPFORGEEQUIPPIECERET_STATUS_FIELD.full_name = ".OPForgeEquipPieceRet.status"
OPFORGEEQUIPPIECERET_STATUS_FIELD.number = 1
OPFORGEEQUIPPIECERET_STATUS_FIELD.index = 0
OPFORGEEQUIPPIECERET_STATUS_FIELD.label = 2
OPFORGEEQUIPPIECERET_STATUS_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_STATUS_FIELD.default_value = 0
OPFORGEEQUIPPIECERET_STATUS_FIELD.type = 5
OPFORGEEQUIPPIECERET_STATUS_FIELD.cpp_type = 1

OPFORGEEQUIPPIECERET_TOOLSINFO_FIELD.name = "toolsInfo"
OPFORGEEQUIPPIECERET_TOOLSINFO_FIELD.full_name = ".OPForgeEquipPieceRet.toolsInfo"
OPFORGEEQUIPPIECERET_TOOLSINFO_FIELD.number = 2
OPFORGEEQUIPPIECERET_TOOLSINFO_FIELD.index = 1
OPFORGEEQUIPPIECERET_TOOLSINFO_FIELD.label = 3
OPFORGEEQUIPPIECERET_TOOLSINFO_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_TOOLSINFO_FIELD.default_value = {}
OPFORGEEQUIPPIECERET_TOOLSINFO_FIELD.message_type = OPFORGEEQUIPPIECERET_TOOLINFO
OPFORGEEQUIPPIECERET_TOOLSINFO_FIELD.type = 11
OPFORGEEQUIPPIECERET_TOOLSINFO_FIELD.cpp_type = 10

OPFORGEEQUIPPIECERET_EQUIPSINFO_FIELD.name = "equipsInfo"
OPFORGEEQUIPPIECERET_EQUIPSINFO_FIELD.full_name = ".OPForgeEquipPieceRet.equipsInfo"
OPFORGEEQUIPPIECERET_EQUIPSINFO_FIELD.number = 3
OPFORGEEQUIPPIECERET_EQUIPSINFO_FIELD.index = 2
OPFORGEEQUIPPIECERET_EQUIPSINFO_FIELD.label = 1
OPFORGEEQUIPPIECERET_EQUIPSINFO_FIELD.has_default_value = false
OPFORGEEQUIPPIECERET_EQUIPSINFO_FIELD.default_value = nil
OPFORGEEQUIPPIECERET_EQUIPSINFO_FIELD.message_type = OPFORGEEQUIPPIECERET_EQUIPINFO
OPFORGEEQUIPPIECERET_EQUIPSINFO_FIELD.type = 11
OPFORGEEQUIPPIECERET_EQUIPSINFO_FIELD.cpp_type = 10

OPFORGEEQUIPPIECERET.name = "OPForgeEquipPieceRet"
OPFORGEEQUIPPIECERET.full_name = ".OPForgeEquipPieceRet"
OPFORGEEQUIPPIECERET.nested_types = {OPFORGEEQUIPPIECERET_TOOLINFO, OPFORGEEQUIPPIECERET_EQUIPINFO}
OPFORGEEQUIPPIECERET.enum_types = {}
OPFORGEEQUIPPIECERET.fields = {OPFORGEEQUIPPIECERET_STATUS_FIELD, OPFORGEEQUIPPIECERET_TOOLSINFO_FIELD, OPFORGEEQUIPPIECERET_EQUIPSINFO_FIELD}
OPFORGEEQUIPPIECERET.is_extendable = false
OPFORGEEQUIPPIECERET.extensions = {}

OPForgeEquipPiece = protobuf.Message(OPFORGEEQUIPPIECE)
OPForgeEquipPieceRet = protobuf.Message(OPFORGEEQUIPPIECERET)
OPForgeEquipPieceRet.EquipInfo = protobuf.Message(OPFORGEEQUIPPIECERET_EQUIPINFO)
OPForgeEquipPieceRet.EquipInfo.PropertyInfo = protobuf.Message(OPFORGEEQUIPPIECERET_EQUIPINFO_PROPERTYINFO)
OPForgeEquipPieceRet.ToolInfo = protobuf.Message(OPFORGEEQUIPPIECERET_TOOLINFO)

