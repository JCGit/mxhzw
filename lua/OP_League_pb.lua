-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('OP_League_pb')


local CODE = protobuf.EnumDescriptor();
local CODE_OPCODE_GET_USERLEAGUAINFO_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_USERLEAGUAINFORET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_CREATE_LEAGUA_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_CREATE_LEAGUARET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_APPLY_LEAGUA_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_APPLY_LEAGUARET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_DEAL_APPLY_LEAGUA_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_DEAL_APPLY_LEAGUARET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUAMEMBER_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUAMEMBER_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_QUIT_LEAGUA_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_QUIT_LEAGUARET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_FIRE_LEAGUA_MEMBER_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_FIRE_LEAGUA_MEMBERRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_UPGRADE_LEAGUA_MEMBER_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_UPGRADE_LEAGUA_MEMBERRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_TRANSFER_LEAGUAOWNER_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_TRANSFER_LEAGUAOWNERRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_DISBAND_LEAGUA_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_DISBAND_LEAGUARET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUARANK_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUARANKRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_REFRESH_LEAGUA_BROADCAST_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_REFRESH_LEAGUA_BROADCASTRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUAMEDAL_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUAMEDALRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_MEDALCHANGEINFO_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_MEDALCHANGEINFORET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_RECEIVE_LEAGUAMEDAL_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_RECEIVE_LEAGUAMEDALRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUABUILDING_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUABUILDINGRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_DONATE_BUILDING_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_DONATE_BUILDINGRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_DONATE_FOUNDS_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_DONATE_FOUNDSRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUASHOPINFO_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUASHOPINFORET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_LEAGUASHOPBUY_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_LEAGUASHOPBUYRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_TOTEMINFO_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_TOTEMINFORET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_RECEIVE_TOTEMCONTRIBUTION_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_RECEIVE_TOTEMCONTRIBUTIONRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_REPAIR_TOTEM_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_REPAIR_TOTEMRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUA_APPLYINFO_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUA_APPLYINFORET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_ROB_LIST_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_ROB_LISTRET_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_ROB_LEAGUE_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_ROB_LEAGUERET_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_CHANGE_LEAGUAMEDAL_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_CHANGE_LEAGUAMEDALRET_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_FIREMEMBER_PUSH_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_CLEAR_SHOPBUY_CD_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_CLEAR_SHOPBUY_CDRET_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_TOTEM_REPAIR_COST_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_TOTEM_REPAIR_COSTRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_LIANMENG_JOIN_BATTLE_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_LIANMENG_JOIN_BATTLERET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_LIANMENG_REFRESH_BATTLE_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_LIANMENG_REFRESH_BATTLERET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUA_OWN_MEDAL_INFO_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_GET_LEAGUA_OWN_MEDAL_INFORET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_ROB_LEAGUA_MEDAL_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_ROB_LEAGUA_MEDALRET_S_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_ADD_ATTACK_NUM_C_ENUM = protobuf.EnumValueDescriptor();
local CODE_OPCODE_ADD_ATTACK_NUMRET_S_ENUM = protobuf.EnumValueDescriptor();

CODE_OPCODE_GET_USERLEAGUAINFO_C_ENUM.name = "OPCODE_GET_USERLEAGUAINFO_C"
CODE_OPCODE_GET_USERLEAGUAINFO_C_ENUM.index = 0
CODE_OPCODE_GET_USERLEAGUAINFO_C_ENUM.number = 523
CODE_OPCODE_GET_USERLEAGUAINFORET_S_ENUM.name = "OPCODE_GET_USERLEAGUAINFORET_S"
CODE_OPCODE_GET_USERLEAGUAINFORET_S_ENUM.index = 1
CODE_OPCODE_GET_USERLEAGUAINFORET_S_ENUM.number = 524
CODE_OPCODE_CREATE_LEAGUA_C_ENUM.name = "OPCODE_CREATE_LEAGUA_C"
CODE_OPCODE_CREATE_LEAGUA_C_ENUM.index = 2
CODE_OPCODE_CREATE_LEAGUA_C_ENUM.number = 525
CODE_OPCODE_CREATE_LEAGUARET_S_ENUM.name = "OPCODE_CREATE_LEAGUARET_S"
CODE_OPCODE_CREATE_LEAGUARET_S_ENUM.index = 3
CODE_OPCODE_CREATE_LEAGUARET_S_ENUM.number = 526
CODE_OPCODE_APPLY_LEAGUA_C_ENUM.name = "OPCODE_APPLY_LEAGUA_C"
CODE_OPCODE_APPLY_LEAGUA_C_ENUM.index = 4
CODE_OPCODE_APPLY_LEAGUA_C_ENUM.number = 527
CODE_OPCODE_APPLY_LEAGUARET_S_ENUM.name = "OPCODE_APPLY_LEAGUARET_S"
CODE_OPCODE_APPLY_LEAGUARET_S_ENUM.index = 5
CODE_OPCODE_APPLY_LEAGUARET_S_ENUM.number = 528
CODE_OPCODE_DEAL_APPLY_LEAGUA_C_ENUM.name = "OPCODE_DEAL_APPLY_LEAGUA_C"
CODE_OPCODE_DEAL_APPLY_LEAGUA_C_ENUM.index = 6
CODE_OPCODE_DEAL_APPLY_LEAGUA_C_ENUM.number = 529
CODE_OPCODE_DEAL_APPLY_LEAGUARET_S_ENUM.name = "OPCODE_DEAL_APPLY_LEAGUARET_S"
CODE_OPCODE_DEAL_APPLY_LEAGUARET_S_ENUM.index = 7
CODE_OPCODE_DEAL_APPLY_LEAGUARET_S_ENUM.number = 530
CODE_OPCODE_GET_LEAGUAMEMBER_C_ENUM.name = "OPCODE_GET_LEAGUAMEMBER_C"
CODE_OPCODE_GET_LEAGUAMEMBER_C_ENUM.index = 8
CODE_OPCODE_GET_LEAGUAMEMBER_C_ENUM.number = 531
CODE_OPCODE_GET_LEAGUAMEMBER_S_ENUM.name = "OPCODE_GET_LEAGUAMEMBER_S"
CODE_OPCODE_GET_LEAGUAMEMBER_S_ENUM.index = 9
CODE_OPCODE_GET_LEAGUAMEMBER_S_ENUM.number = 532
CODE_OPCODE_QUIT_LEAGUA_C_ENUM.name = "OPCODE_QUIT_LEAGUA_C"
CODE_OPCODE_QUIT_LEAGUA_C_ENUM.index = 10
CODE_OPCODE_QUIT_LEAGUA_C_ENUM.number = 533
CODE_OPCODE_QUIT_LEAGUARET_S_ENUM.name = "OPCODE_QUIT_LEAGUARET_S"
CODE_OPCODE_QUIT_LEAGUARET_S_ENUM.index = 11
CODE_OPCODE_QUIT_LEAGUARET_S_ENUM.number = 534
CODE_OPCODE_FIRE_LEAGUA_MEMBER_C_ENUM.name = "OPCODE_FIRE_LEAGUA_MEMBER_C"
CODE_OPCODE_FIRE_LEAGUA_MEMBER_C_ENUM.index = 12
CODE_OPCODE_FIRE_LEAGUA_MEMBER_C_ENUM.number = 535
CODE_OPCODE_FIRE_LEAGUA_MEMBERRET_S_ENUM.name = "OPCODE_FIRE_LEAGUA_MEMBERRET_S"
CODE_OPCODE_FIRE_LEAGUA_MEMBERRET_S_ENUM.index = 13
CODE_OPCODE_FIRE_LEAGUA_MEMBERRET_S_ENUM.number = 536
CODE_OPCODE_UPGRADE_LEAGUA_MEMBER_C_ENUM.name = "OPCODE_UPGRADE_LEAGUA_MEMBER_C"
CODE_OPCODE_UPGRADE_LEAGUA_MEMBER_C_ENUM.index = 14
CODE_OPCODE_UPGRADE_LEAGUA_MEMBER_C_ENUM.number = 537
CODE_OPCODE_UPGRADE_LEAGUA_MEMBERRET_S_ENUM.name = "OPCODE_UPGRADE_LEAGUA_MEMBERRET_S"
CODE_OPCODE_UPGRADE_LEAGUA_MEMBERRET_S_ENUM.index = 15
CODE_OPCODE_UPGRADE_LEAGUA_MEMBERRET_S_ENUM.number = 538
CODE_OPCODE_TRANSFER_LEAGUAOWNER_C_ENUM.name = "OPCODE_TRANSFER_LEAGUAOWNER_C"
CODE_OPCODE_TRANSFER_LEAGUAOWNER_C_ENUM.index = 16
CODE_OPCODE_TRANSFER_LEAGUAOWNER_C_ENUM.number = 539
CODE_OPCODE_TRANSFER_LEAGUAOWNERRET_S_ENUM.name = "OPCODE_TRANSFER_LEAGUAOWNERRET_S"
CODE_OPCODE_TRANSFER_LEAGUAOWNERRET_S_ENUM.index = 17
CODE_OPCODE_TRANSFER_LEAGUAOWNERRET_S_ENUM.number = 540
CODE_OPCODE_DISBAND_LEAGUA_C_ENUM.name = "OPCODE_DISBAND_LEAGUA_C"
CODE_OPCODE_DISBAND_LEAGUA_C_ENUM.index = 18
CODE_OPCODE_DISBAND_LEAGUA_C_ENUM.number = 541
CODE_OPCODE_DISBAND_LEAGUARET_S_ENUM.name = "OPCODE_DISBAND_LEAGUARET_S"
CODE_OPCODE_DISBAND_LEAGUARET_S_ENUM.index = 19
CODE_OPCODE_DISBAND_LEAGUARET_S_ENUM.number = 542
CODE_OPCODE_GET_LEAGUARANK_C_ENUM.name = "OPCODE_GET_LEAGUARANK_C"
CODE_OPCODE_GET_LEAGUARANK_C_ENUM.index = 20
CODE_OPCODE_GET_LEAGUARANK_C_ENUM.number = 543
CODE_OPCODE_GET_LEAGUARANKRET_S_ENUM.name = "OPCODE_GET_LEAGUARANKRET_S"
CODE_OPCODE_GET_LEAGUARANKRET_S_ENUM.index = 21
CODE_OPCODE_GET_LEAGUARANKRET_S_ENUM.number = 544
CODE_OPCODE_REFRESH_LEAGUA_BROADCAST_C_ENUM.name = "OPCODE_REFRESH_LEAGUA_BROADCAST_C"
CODE_OPCODE_REFRESH_LEAGUA_BROADCAST_C_ENUM.index = 22
CODE_OPCODE_REFRESH_LEAGUA_BROADCAST_C_ENUM.number = 545
CODE_OPCODE_REFRESH_LEAGUA_BROADCASTRET_S_ENUM.name = "OPCODE_REFRESH_LEAGUA_BROADCASTRET_S"
CODE_OPCODE_REFRESH_LEAGUA_BROADCASTRET_S_ENUM.index = 23
CODE_OPCODE_REFRESH_LEAGUA_BROADCASTRET_S_ENUM.number = 546
CODE_OPCODE_GET_LEAGUAMEDAL_C_ENUM.name = "OPCODE_GET_LEAGUAMEDAL_C"
CODE_OPCODE_GET_LEAGUAMEDAL_C_ENUM.index = 24
CODE_OPCODE_GET_LEAGUAMEDAL_C_ENUM.number = 547
CODE_OPCODE_GET_LEAGUAMEDALRET_S_ENUM.name = "OPCODE_GET_LEAGUAMEDALRET_S"
CODE_OPCODE_GET_LEAGUAMEDALRET_S_ENUM.index = 25
CODE_OPCODE_GET_LEAGUAMEDALRET_S_ENUM.number = 548
CODE_OPCODE_GET_MEDALCHANGEINFO_C_ENUM.name = "OPCODE_GET_MEDALCHANGEINFO_C"
CODE_OPCODE_GET_MEDALCHANGEINFO_C_ENUM.index = 26
CODE_OPCODE_GET_MEDALCHANGEINFO_C_ENUM.number = 549
CODE_OPCODE_GET_MEDALCHANGEINFORET_S_ENUM.name = "OPCODE_GET_MEDALCHANGEINFORET_S"
CODE_OPCODE_GET_MEDALCHANGEINFORET_S_ENUM.index = 27
CODE_OPCODE_GET_MEDALCHANGEINFORET_S_ENUM.number = 550
CODE_OPCODE_RECEIVE_LEAGUAMEDAL_C_ENUM.name = "OPCODE_RECEIVE_LEAGUAMEDAL_C"
CODE_OPCODE_RECEIVE_LEAGUAMEDAL_C_ENUM.index = 28
CODE_OPCODE_RECEIVE_LEAGUAMEDAL_C_ENUM.number = 553
CODE_OPCODE_RECEIVE_LEAGUAMEDALRET_S_ENUM.name = "OPCODE_RECEIVE_LEAGUAMEDALRET_S"
CODE_OPCODE_RECEIVE_LEAGUAMEDALRET_S_ENUM.index = 29
CODE_OPCODE_RECEIVE_LEAGUAMEDALRET_S_ENUM.number = 554
CODE_OPCODE_GET_LEAGUABUILDING_C_ENUM.name = "OPCODE_GET_LEAGUABUILDING_C"
CODE_OPCODE_GET_LEAGUABUILDING_C_ENUM.index = 30
CODE_OPCODE_GET_LEAGUABUILDING_C_ENUM.number = 555
CODE_OPCODE_GET_LEAGUABUILDINGRET_S_ENUM.name = "OPCODE_GET_LEAGUABUILDINGRET_S"
CODE_OPCODE_GET_LEAGUABUILDINGRET_S_ENUM.index = 31
CODE_OPCODE_GET_LEAGUABUILDINGRET_S_ENUM.number = 556
CODE_OPCODE_DONATE_BUILDING_C_ENUM.name = "OPCODE_DONATE_BUILDING_C"
CODE_OPCODE_DONATE_BUILDING_C_ENUM.index = 32
CODE_OPCODE_DONATE_BUILDING_C_ENUM.number = 557
CODE_OPCODE_DONATE_BUILDINGRET_S_ENUM.name = "OPCODE_DONATE_BUILDINGRET_S"
CODE_OPCODE_DONATE_BUILDINGRET_S_ENUM.index = 33
CODE_OPCODE_DONATE_BUILDINGRET_S_ENUM.number = 558
CODE_OPCODE_DONATE_FOUNDS_C_ENUM.name = "OPCODE_DONATE_FOUNDS_C"
CODE_OPCODE_DONATE_FOUNDS_C_ENUM.index = 34
CODE_OPCODE_DONATE_FOUNDS_C_ENUM.number = 559
CODE_OPCODE_DONATE_FOUNDSRET_S_ENUM.name = "OPCODE_DONATE_FOUNDSRET_S"
CODE_OPCODE_DONATE_FOUNDSRET_S_ENUM.index = 35
CODE_OPCODE_DONATE_FOUNDSRET_S_ENUM.number = 560
CODE_OPCODE_GET_LEAGUASHOPINFO_C_ENUM.name = "OPCODE_GET_LEAGUASHOPINFO_C"
CODE_OPCODE_GET_LEAGUASHOPINFO_C_ENUM.index = 36
CODE_OPCODE_GET_LEAGUASHOPINFO_C_ENUM.number = 561
CODE_OPCODE_GET_LEAGUASHOPINFORET_S_ENUM.name = "OPCODE_GET_LEAGUASHOPINFORET_S"
CODE_OPCODE_GET_LEAGUASHOPINFORET_S_ENUM.index = 37
CODE_OPCODE_GET_LEAGUASHOPINFORET_S_ENUM.number = 562
CODE_OPCODE_LEAGUASHOPBUY_C_ENUM.name = "OPCODE_LEAGUASHOPBUY_C"
CODE_OPCODE_LEAGUASHOPBUY_C_ENUM.index = 38
CODE_OPCODE_LEAGUASHOPBUY_C_ENUM.number = 563
CODE_OPCODE_LEAGUASHOPBUYRET_S_ENUM.name = "OPCODE_LEAGUASHOPBUYRET_S"
CODE_OPCODE_LEAGUASHOPBUYRET_S_ENUM.index = 39
CODE_OPCODE_LEAGUASHOPBUYRET_S_ENUM.number = 564
CODE_OPCODE_GET_TOTEMINFO_C_ENUM.name = "OPCODE_GET_TOTEMINFO_C"
CODE_OPCODE_GET_TOTEMINFO_C_ENUM.index = 40
CODE_OPCODE_GET_TOTEMINFO_C_ENUM.number = 565
CODE_OPCODE_GET_TOTEMINFORET_S_ENUM.name = "OPCODE_GET_TOTEMINFORET_S"
CODE_OPCODE_GET_TOTEMINFORET_S_ENUM.index = 41
CODE_OPCODE_GET_TOTEMINFORET_S_ENUM.number = 566
CODE_OPCODE_RECEIVE_TOTEMCONTRIBUTION_C_ENUM.name = "OPCODE_RECEIVE_TOTEMCONTRIBUTION_C"
CODE_OPCODE_RECEIVE_TOTEMCONTRIBUTION_C_ENUM.index = 42
CODE_OPCODE_RECEIVE_TOTEMCONTRIBUTION_C_ENUM.number = 567
CODE_OPCODE_RECEIVE_TOTEMCONTRIBUTIONRET_S_ENUM.name = "OPCODE_RECEIVE_TOTEMCONTRIBUTIONRET_S"
CODE_OPCODE_RECEIVE_TOTEMCONTRIBUTIONRET_S_ENUM.index = 43
CODE_OPCODE_RECEIVE_TOTEMCONTRIBUTIONRET_S_ENUM.number = 568
CODE_OPCODE_REPAIR_TOTEM_C_ENUM.name = "OPCODE_REPAIR_TOTEM_C"
CODE_OPCODE_REPAIR_TOTEM_C_ENUM.index = 44
CODE_OPCODE_REPAIR_TOTEM_C_ENUM.number = 569
CODE_OPCODE_REPAIR_TOTEMRET_S_ENUM.name = "OPCODE_REPAIR_TOTEMRET_S"
CODE_OPCODE_REPAIR_TOTEMRET_S_ENUM.index = 45
CODE_OPCODE_REPAIR_TOTEMRET_S_ENUM.number = 570
CODE_OPCODE_GET_LEAGUA_APPLYINFO_C_ENUM.name = "OPCODE_GET_LEAGUA_APPLYINFO_C"
CODE_OPCODE_GET_LEAGUA_APPLYINFO_C_ENUM.index = 46
CODE_OPCODE_GET_LEAGUA_APPLYINFO_C_ENUM.number = 571
CODE_OPCODE_GET_LEAGUA_APPLYINFORET_S_ENUM.name = "OPCODE_GET_LEAGUA_APPLYINFORET_S"
CODE_OPCODE_GET_LEAGUA_APPLYINFORET_S_ENUM.index = 47
CODE_OPCODE_GET_LEAGUA_APPLYINFORET_S_ENUM.number = 572
CODE_OPCODE_GET_ROB_LIST_ENUM.name = "OPCODE_GET_ROB_LIST"
CODE_OPCODE_GET_ROB_LIST_ENUM.index = 48
CODE_OPCODE_GET_ROB_LIST_ENUM.number = 573
CODE_OPCODE_GET_ROB_LISTRET_ENUM.name = "OPCODE_GET_ROB_LISTRET"
CODE_OPCODE_GET_ROB_LISTRET_ENUM.index = 49
CODE_OPCODE_GET_ROB_LISTRET_ENUM.number = 574
CODE_OPCODE_ROB_LEAGUE_ENUM.name = "OPCODE_ROB_LEAGUE"
CODE_OPCODE_ROB_LEAGUE_ENUM.index = 50
CODE_OPCODE_ROB_LEAGUE_ENUM.number = 575
CODE_OPCODE_ROB_LEAGUERET_ENUM.name = "OPCODE_ROB_LEAGUERET"
CODE_OPCODE_ROB_LEAGUERET_ENUM.index = 51
CODE_OPCODE_ROB_LEAGUERET_ENUM.number = 576
CODE_OPCODE_CHANGE_LEAGUAMEDAL_ENUM.name = "OPCODE_CHANGE_LEAGUAMEDAL"
CODE_OPCODE_CHANGE_LEAGUAMEDAL_ENUM.index = 52
CODE_OPCODE_CHANGE_LEAGUAMEDAL_ENUM.number = 577
CODE_OPCODE_CHANGE_LEAGUAMEDALRET_ENUM.name = "OPCODE_CHANGE_LEAGUAMEDALRET"
CODE_OPCODE_CHANGE_LEAGUAMEDALRET_ENUM.index = 53
CODE_OPCODE_CHANGE_LEAGUAMEDALRET_ENUM.number = 578
CODE_OPCODE_FIREMEMBER_PUSH_ENUM.name = "OPCODE_FIREMEMBER_PUSH"
CODE_OPCODE_FIREMEMBER_PUSH_ENUM.index = 54
CODE_OPCODE_FIREMEMBER_PUSH_ENUM.number = 580
CODE_OPCODE_CLEAR_SHOPBUY_CD_ENUM.name = "OPCODE_CLEAR_SHOPBUY_CD"
CODE_OPCODE_CLEAR_SHOPBUY_CD_ENUM.index = 55
CODE_OPCODE_CLEAR_SHOPBUY_CD_ENUM.number = 581
CODE_OPCODE_CLEAR_SHOPBUY_CDRET_ENUM.name = "OPCODE_CLEAR_SHOPBUY_CDRET"
CODE_OPCODE_CLEAR_SHOPBUY_CDRET_ENUM.index = 56
CODE_OPCODE_CLEAR_SHOPBUY_CDRET_ENUM.number = 582
CODE_OPCODE_TOTEM_REPAIR_COST_C_ENUM.name = "OPCODE_TOTEM_REPAIR_COST_C"
CODE_OPCODE_TOTEM_REPAIR_COST_C_ENUM.index = 57
CODE_OPCODE_TOTEM_REPAIR_COST_C_ENUM.number = 583
CODE_OPCODE_TOTEM_REPAIR_COSTRET_S_ENUM.name = "OPCODE_TOTEM_REPAIR_COSTRET_S"
CODE_OPCODE_TOTEM_REPAIR_COSTRET_S_ENUM.index = 58
CODE_OPCODE_TOTEM_REPAIR_COSTRET_S_ENUM.number = 584
CODE_OPCODE_LIANMENG_JOIN_BATTLE_C_ENUM.name = "OPCODE_LIANMENG_JOIN_BATTLE_C"
CODE_OPCODE_LIANMENG_JOIN_BATTLE_C_ENUM.index = 59
CODE_OPCODE_LIANMENG_JOIN_BATTLE_C_ENUM.number = 585
CODE_OPCODE_LIANMENG_JOIN_BATTLERET_S_ENUM.name = "OPCODE_LIANMENG_JOIN_BATTLERET_S"
CODE_OPCODE_LIANMENG_JOIN_BATTLERET_S_ENUM.index = 60
CODE_OPCODE_LIANMENG_JOIN_BATTLERET_S_ENUM.number = 586
CODE_OPCODE_LIANMENG_REFRESH_BATTLE_C_ENUM.name = "OPCODE_LIANMENG_REFRESH_BATTLE_C"
CODE_OPCODE_LIANMENG_REFRESH_BATTLE_C_ENUM.index = 61
CODE_OPCODE_LIANMENG_REFRESH_BATTLE_C_ENUM.number = 587
CODE_OPCODE_LIANMENG_REFRESH_BATTLERET_S_ENUM.name = "OPCODE_LIANMENG_REFRESH_BATTLERET_S"
CODE_OPCODE_LIANMENG_REFRESH_BATTLERET_S_ENUM.index = 62
CODE_OPCODE_LIANMENG_REFRESH_BATTLERET_S_ENUM.number = 588
CODE_OPCODE_GET_LEAGUA_OWN_MEDAL_INFO_C_ENUM.name = "OPCODE_GET_LEAGUA_OWN_MEDAL_INFO_C"
CODE_OPCODE_GET_LEAGUA_OWN_MEDAL_INFO_C_ENUM.index = 63
CODE_OPCODE_GET_LEAGUA_OWN_MEDAL_INFO_C_ENUM.number = 589
CODE_OPCODE_GET_LEAGUA_OWN_MEDAL_INFORET_S_ENUM.name = "OPCODE_GET_LEAGUA_OWN_MEDAL_INFORET_S"
CODE_OPCODE_GET_LEAGUA_OWN_MEDAL_INFORET_S_ENUM.index = 64
CODE_OPCODE_GET_LEAGUA_OWN_MEDAL_INFORET_S_ENUM.number = 590
CODE_OPCODE_ROB_LEAGUA_MEDAL_C_ENUM.name = "OPCODE_ROB_LEAGUA_MEDAL_C"
CODE_OPCODE_ROB_LEAGUA_MEDAL_C_ENUM.index = 65
CODE_OPCODE_ROB_LEAGUA_MEDAL_C_ENUM.number = 591
CODE_OPCODE_ROB_LEAGUA_MEDALRET_S_ENUM.name = "OPCODE_ROB_LEAGUA_MEDALRET_S"
CODE_OPCODE_ROB_LEAGUA_MEDALRET_S_ENUM.index = 66
CODE_OPCODE_ROB_LEAGUA_MEDALRET_S_ENUM.number = 592
CODE_OPCODE_ADD_ATTACK_NUM_C_ENUM.name = "OPCODE_ADD_ATTACK_NUM_C"
CODE_OPCODE_ADD_ATTACK_NUM_C_ENUM.index = 67
CODE_OPCODE_ADD_ATTACK_NUM_C_ENUM.number = 593
CODE_OPCODE_ADD_ATTACK_NUMRET_S_ENUM.name = "OPCODE_ADD_ATTACK_NUMRET_S"
CODE_OPCODE_ADD_ATTACK_NUMRET_S_ENUM.index = 68
CODE_OPCODE_ADD_ATTACK_NUMRET_S_ENUM.number = 594
CODE.name = "code"
CODE.full_name = ".code"
CODE.values = {CODE_OPCODE_GET_USERLEAGUAINFO_C_ENUM,CODE_OPCODE_GET_USERLEAGUAINFORET_S_ENUM,CODE_OPCODE_CREATE_LEAGUA_C_ENUM,CODE_OPCODE_CREATE_LEAGUARET_S_ENUM,CODE_OPCODE_APPLY_LEAGUA_C_ENUM,CODE_OPCODE_APPLY_LEAGUARET_S_ENUM,CODE_OPCODE_DEAL_APPLY_LEAGUA_C_ENUM,CODE_OPCODE_DEAL_APPLY_LEAGUARET_S_ENUM,CODE_OPCODE_GET_LEAGUAMEMBER_C_ENUM,CODE_OPCODE_GET_LEAGUAMEMBER_S_ENUM,CODE_OPCODE_QUIT_LEAGUA_C_ENUM,CODE_OPCODE_QUIT_LEAGUARET_S_ENUM,CODE_OPCODE_FIRE_LEAGUA_MEMBER_C_ENUM,CODE_OPCODE_FIRE_LEAGUA_MEMBERRET_S_ENUM,CODE_OPCODE_UPGRADE_LEAGUA_MEMBER_C_ENUM,CODE_OPCODE_UPGRADE_LEAGUA_MEMBERRET_S_ENUM,CODE_OPCODE_TRANSFER_LEAGUAOWNER_C_ENUM,CODE_OPCODE_TRANSFER_LEAGUAOWNERRET_S_ENUM,CODE_OPCODE_DISBAND_LEAGUA_C_ENUM,CODE_OPCODE_DISBAND_LEAGUARET_S_ENUM,CODE_OPCODE_GET_LEAGUARANK_C_ENUM,CODE_OPCODE_GET_LEAGUARANKRET_S_ENUM,CODE_OPCODE_REFRESH_LEAGUA_BROADCAST_C_ENUM,CODE_OPCODE_REFRESH_LEAGUA_BROADCASTRET_S_ENUM,CODE_OPCODE_GET_LEAGUAMEDAL_C_ENUM,CODE_OPCODE_GET_LEAGUAMEDALRET_S_ENUM,CODE_OPCODE_GET_MEDALCHANGEINFO_C_ENUM,CODE_OPCODE_GET_MEDALCHANGEINFORET_S_ENUM,CODE_OPCODE_RECEIVE_LEAGUAMEDAL_C_ENUM,CODE_OPCODE_RECEIVE_LEAGUAMEDALRET_S_ENUM,CODE_OPCODE_GET_LEAGUABUILDING_C_ENUM,CODE_OPCODE_GET_LEAGUABUILDINGRET_S_ENUM,CODE_OPCODE_DONATE_BUILDING_C_ENUM,CODE_OPCODE_DONATE_BUILDINGRET_S_ENUM,CODE_OPCODE_DONATE_FOUNDS_C_ENUM,CODE_OPCODE_DONATE_FOUNDSRET_S_ENUM,CODE_OPCODE_GET_LEAGUASHOPINFO_C_ENUM,CODE_OPCODE_GET_LEAGUASHOPINFORET_S_ENUM,CODE_OPCODE_LEAGUASHOPBUY_C_ENUM,CODE_OPCODE_LEAGUASHOPBUYRET_S_ENUM,CODE_OPCODE_GET_TOTEMINFO_C_ENUM,CODE_OPCODE_GET_TOTEMINFORET_S_ENUM,CODE_OPCODE_RECEIVE_TOTEMCONTRIBUTION_C_ENUM,CODE_OPCODE_RECEIVE_TOTEMCONTRIBUTIONRET_S_ENUM,CODE_OPCODE_REPAIR_TOTEM_C_ENUM,CODE_OPCODE_REPAIR_TOTEMRET_S_ENUM,CODE_OPCODE_GET_LEAGUA_APPLYINFO_C_ENUM,CODE_OPCODE_GET_LEAGUA_APPLYINFORET_S_ENUM,CODE_OPCODE_GET_ROB_LIST_ENUM,CODE_OPCODE_GET_ROB_LISTRET_ENUM,CODE_OPCODE_ROB_LEAGUE_ENUM,CODE_OPCODE_ROB_LEAGUERET_ENUM,CODE_OPCODE_CHANGE_LEAGUAMEDAL_ENUM,CODE_OPCODE_CHANGE_LEAGUAMEDALRET_ENUM,CODE_OPCODE_FIREMEMBER_PUSH_ENUM,CODE_OPCODE_CLEAR_SHOPBUY_CD_ENUM,CODE_OPCODE_CLEAR_SHOPBUY_CDRET_ENUM,CODE_OPCODE_TOTEM_REPAIR_COST_C_ENUM,CODE_OPCODE_TOTEM_REPAIR_COSTRET_S_ENUM,CODE_OPCODE_LIANMENG_JOIN_BATTLE_C_ENUM,CODE_OPCODE_LIANMENG_JOIN_BATTLERET_S_ENUM,CODE_OPCODE_LIANMENG_REFRESH_BATTLE_C_ENUM,CODE_OPCODE_LIANMENG_REFRESH_BATTLERET_S_ENUM,CODE_OPCODE_GET_LEAGUA_OWN_MEDAL_INFO_C_ENUM,CODE_OPCODE_GET_LEAGUA_OWN_MEDAL_INFORET_S_ENUM,CODE_OPCODE_ROB_LEAGUA_MEDAL_C_ENUM,CODE_OPCODE_ROB_LEAGUA_MEDALRET_S_ENUM,CODE_OPCODE_ADD_ATTACK_NUM_C_ENUM,CODE_OPCODE_ADD_ATTACK_NUMRET_S_ENUM}

OPCODE_ADD_ATTACK_NUMRET_S = 594
OPCODE_ADD_ATTACK_NUM_C = 593
OPCODE_APPLY_LEAGUARET_S = 528
OPCODE_APPLY_LEAGUA_C = 527
OPCODE_CHANGE_LEAGUAMEDAL = 577
OPCODE_CHANGE_LEAGUAMEDALRET = 578
OPCODE_CLEAR_SHOPBUY_CD = 581
OPCODE_CLEAR_SHOPBUY_CDRET = 582
OPCODE_CREATE_LEAGUARET_S = 526
OPCODE_CREATE_LEAGUA_C = 525
OPCODE_DEAL_APPLY_LEAGUARET_S = 530
OPCODE_DEAL_APPLY_LEAGUA_C = 529
OPCODE_DISBAND_LEAGUARET_S = 542
OPCODE_DISBAND_LEAGUA_C = 541
OPCODE_DONATE_BUILDINGRET_S = 558
OPCODE_DONATE_BUILDING_C = 557
OPCODE_DONATE_FOUNDSRET_S = 560
OPCODE_DONATE_FOUNDS_C = 559
OPCODE_FIREMEMBER_PUSH = 580
OPCODE_FIRE_LEAGUA_MEMBERRET_S = 536
OPCODE_FIRE_LEAGUA_MEMBER_C = 535
OPCODE_GET_LEAGUABUILDINGRET_S = 556
OPCODE_GET_LEAGUABUILDING_C = 555
OPCODE_GET_LEAGUAMEDALRET_S = 548
OPCODE_GET_LEAGUAMEDAL_C = 547
OPCODE_GET_LEAGUAMEMBER_C = 531
OPCODE_GET_LEAGUAMEMBER_S = 532
OPCODE_GET_LEAGUARANKRET_S = 544
OPCODE_GET_LEAGUARANK_C = 543
OPCODE_GET_LEAGUASHOPINFORET_S = 562
OPCODE_GET_LEAGUASHOPINFO_C = 561
OPCODE_GET_LEAGUA_APPLYINFORET_S = 572
OPCODE_GET_LEAGUA_APPLYINFO_C = 571
OPCODE_GET_LEAGUA_OWN_MEDAL_INFORET_S = 590
OPCODE_GET_LEAGUA_OWN_MEDAL_INFO_C = 589
OPCODE_GET_MEDALCHANGEINFORET_S = 550
OPCODE_GET_MEDALCHANGEINFO_C = 549
OPCODE_GET_ROB_LIST = 573
OPCODE_GET_ROB_LISTRET = 574
OPCODE_GET_TOTEMINFORET_S = 566
OPCODE_GET_TOTEMINFO_C = 565
OPCODE_GET_USERLEAGUAINFORET_S = 524
OPCODE_GET_USERLEAGUAINFO_C = 523
OPCODE_LEAGUASHOPBUYRET_S = 564
OPCODE_LEAGUASHOPBUY_C = 563
OPCODE_LIANMENG_JOIN_BATTLERET_S = 586
OPCODE_LIANMENG_JOIN_BATTLE_C = 585
OPCODE_LIANMENG_REFRESH_BATTLERET_S = 588
OPCODE_LIANMENG_REFRESH_BATTLE_C = 587
OPCODE_QUIT_LEAGUARET_S = 534
OPCODE_QUIT_LEAGUA_C = 533
OPCODE_RECEIVE_LEAGUAMEDALRET_S = 554
OPCODE_RECEIVE_LEAGUAMEDAL_C = 553
OPCODE_RECEIVE_TOTEMCONTRIBUTIONRET_S = 568
OPCODE_RECEIVE_TOTEMCONTRIBUTION_C = 567
OPCODE_REFRESH_LEAGUA_BROADCASTRET_S = 546
OPCODE_REFRESH_LEAGUA_BROADCAST_C = 545
OPCODE_REPAIR_TOTEMRET_S = 570
OPCODE_REPAIR_TOTEM_C = 569
OPCODE_ROB_LEAGUA_MEDALRET_S = 592
OPCODE_ROB_LEAGUA_MEDAL_C = 591
OPCODE_ROB_LEAGUE = 575
OPCODE_ROB_LEAGUERET = 576
OPCODE_TOTEM_REPAIR_COSTRET_S = 584
OPCODE_TOTEM_REPAIR_COST_C = 583
OPCODE_TRANSFER_LEAGUAOWNERRET_S = 540
OPCODE_TRANSFER_LEAGUAOWNER_C = 539
OPCODE_UPGRADE_LEAGUA_MEMBERRET_S = 538
OPCODE_UPGRADE_LEAGUA_MEMBER_C = 537
