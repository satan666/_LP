LPCONFIG = {
	DISMOUNT = true, 
	CAM = false, 
	GINV = true, 
	FINV = true, 
	SINV = nil, 
	DINV = true, 
	SUMM = true, 
	EBG = true, 
	LBG = true, 
	QBG = true, 
	RBG = true, 
	SBG = false, 
	AQUE = true,
	LOOT = true, 
	EPLATE = false, 
	FPLATE = false, 
	HPLATE = false, 
	RIGHT = true, 
	ZG = 1, 
	DUEL = false, 
	NOSAVE = false, 
	GREEN = 2, 
	SPECIALKEY = true, 
	WORLDDUNGEON = false, 
	WORLDRAID = false, 
	WORLDBG = false, 
	WORLDUNCHECK = nil, 
	SPAM = true,
	SPAM_UNCOMMON = true,
	SPAM_RARE = true,
	SHIFTSPLIT = true, 
	REZ = true, 
	GOSSIP = true, 
	SALVA = false
}

BINDING_HEADER_LP_HEADER = "_LazyPig";
BINDING_NAME_LOGOUT = "Logout";
BINDING_NAME_UNSTUCK = "Unstuck";
BINDING_NAME_RELOAD = "Reaload UI";
BINDING_NAME_DUEL = "Target WSG EFC/Duel Request-Cancel";
BINDING_NAME_WSGDROP = "Drop WSG Flag/Remove Slow Fall";
BINDING_NAME_MENU = "_LazyPig Menu";

local Original_SelectGossipActiveQuest = SelectGossipActiveQuest;
local Original_SelectGossipAvailableQuest = SelectGossipAvailableQuest;
local Original_SelectActiveQuest = SelectActiveQuest;
local Original_SelectAvailableQuest = SelectAvailableQuest;
local OriginalLootFrame_OnEvent = LootFrame_OnEvent;
local OriginalLootFrame_Update = LootFrame_Update;
local OriginalUseContainerItem = UseContainerItem;
local Original_SetItemRef = SetItemRef;
local Original_ChatFrame_OnEvent = ChatFrame_OnEvent;
local Original_StaticPopup_OnShow = StaticPopup_OnShow;

local roster_task_refresh = 0
local last_click = 0
local delayaction = 0
local tradedelay = 0
local bgstatus = 0
local save_check = 0
local save_time = 0
local tmp_splitval = 1
local passpopup = 0

local ctrltime = 0
local alttime = 0
local shift_time = 0
local ctrlalttime = 0
local ctrlshifttime = 0
local altshifttime = 0
local greenrolltime = 0

local timer_split = false
local player_summon_confirm = false
local player_summon_message = false
local player_bg_confirm = false
local player_bg_message = false
local afk_active = false
local dnd_active = false
local duel_active = false
local merchantstatus = false
local tradestatus = false
local mailstatus = false
local auctionstatus = false
local auctionbrowse = false
local bankstatus = false
local channelstatus = false
local battleframe = false
local wsgefc = nil

local WHITE = "|cffffffff"
local RED = "|cffff0000"
local GREEN = "|cff00ff00"
local BLUE = "|cff00eeee"

local ScheduleButton = {}
local ScheduleFunction = {}
local ScheduleSplit = {}
local QuestRecord = {}
local ActiveQuest = {}
local AvailableQuest = {}
local GreySell = {}
local ChatMessage = {{}, {}, INDEX = 1}

local ScheduleSplit = {}
local ScheduleSplitCount = {}

ScheduleSplit.active = nil
ScheduleSplit.sslot = {}
ScheduleSplit.dbag = {}
ScheduleSplit.dslot = {}
ScheduleSplit.sbag = {}
ScheduleSplit.count = {}

local LazyPigMenuObjects = {}
local LazyPigMenuStrings = {
		[00]= "Need",
		[01]= "Greed",
		[02]= "Pass",
		[10]= "Need",
		[11]= "Greed",
		[12]= "Pass",
		[20]= "Dungeon",
		[21]= "Raid",
		[22]= "Battleground",
		[23]= "Mute Permanently",
		[30]= "GuildMates",
		[31]= "Friends",
		[32]= "Strangers",
		[33]= "Idle while in BG or Queue",
		[40]= "Show Friends",
		[41]= "Show Enemies",
		[42]= "Hide if Unchecked",
		[50]= "Enter BG",
		[51]= "Leave BG",
		[52]= "Queue BG",
		[53]= "Auto Release",
		[54]= "Leader Queue Announce",
		[55]= "Block BG Quest Sharing",
		
		[60]= "Always",
		[61]= "Warrior Shield/Druid Bear",
		
		[70]= "Players' Spam",
		[71]= "Uncommon Roll",
		[72]= "Rare Roll",
		[73]= "Poor-Common-Money Loot",
		
		
		[90]= "Summon Auto Accept",
		[91]= "Loot Window Auto Position",
		[92]= "Improved Right Click",
		[93]= "Easy Split/Merge (Shift+Right_Click)",
		[94]= "Extended Camera Distance",
		[95]= "Special Key Combinations",
		[96]= "Duel Auto Decline (Shift to ByPass)",
		[97]= "Instance Resurrection Accept OOC",
		[98]= "Gossip Auto Processing",
		[99]= "Character Auto-Save",
		[100]= "Auto Dismount",
		[101]= "Chat Spam Filter"
}

function LazyPig_OnLoad()
	SelectGossipActiveQuest = LazyPig_SelectGossipActiveQuest;
	SelectGossipAvailableQuest = LazyPig_SelectGossipAvailableQuest;
	SelectActiveQuest = LazyPig_SelectActiveQuest;
	SelectAvailableQuest = LazyPig_SelectAvailableQuest;
	LootFrame_OnEvent = LazyPig_LootFrame_OnEvent;
	LootFrame_Update = LazyPig_LootFrame_Update;
	UseContainerItem = LazyPig_UseContainerItem;
	SetItemRef = LazyPig_SetItemRef_OnEvent;
	ChatFrame_OnEvent = LazyPig_ChatFrame_OnEvent;
	StaticPopup_OnShow = LazyPig_StaticPopup_OnShow;
	
	SLASH_LAZYPIG1 = "/lp";
	SLASH_LAZYPIG2 = "/lazypig";
	SlashCmdList["LAZYPIG"] = LazyPig_Command;
	
	this:RegisterEvent("ADDON_LOADED");
	this:RegisterEvent("PLAYER_LOGIN")
	--this:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function LazyPig_Command()
	if LazyPigOptionsFrame:IsShown() then
		LazyPigOptionsFrame:Hide()
		LazyPigKeybindsFrame:Hide()
	else
		LazyPigOptionsFrame:Show()
		if getglobal("LazyPigOptionsFrameKeibindsButton"):GetText() == "Hide Keybinds" then
			LazyPigKeybindsFrame:Show()
		end
	end	
end

function LazyPig_OnUpdate()
	local current_time = GetTime();
	local shiftstatus = IsShiftKeyDown();
	local ctrlstatus = IsControlKeyDown();
	local altstatus = IsAltKeyDown();
	
	if shiftstatus then
		shift_time = current_time
	elseif altstatus and not ctrlstatus and current_time > alttime then
		alttime = current_time + 0.75
	elseif not altstatus and ctrlstatus and current_time > ctrltime then
		ctrltime = current_time + 0.75
	elseif not altstatus and not ctrlstatus or altstatus and ctrlstatus then 
		ctrltime = 0
		alttime = 0
	end	
	if ctrlstatus and not shiftstatus and altstatus and current_time > ctrlalttime then
		ctrlalttime = current_time + 0.75
	elseif ctrlstatus and shiftstatus and not altstatus and current_time > ctrlshifttime then
		ctrlshifttime = current_time + 0.75
	elseif not ctrlstatus and shiftstatus and altstatus and current_time > altshifttime then
		altshifttime = current_time + 0.75
	elseif ctrlstatus and shiftstatus and altstatus then
		ctrlshifttime = 0
		ctrlalttime = 0
		altshifttime = 0
	end
			
	if LPCONFIG.SPECIALKEY then
		--[[
		if shift_time == current_time  then	
			if not (UnitExists("target") and UnitIsUnit("player", "target")) then
				--
			elseif not battleframe then
				battleframe = current_time
			elseif (current_time - battleframe) > 3 then
				BattlefieldFrame:Show()
				battleframe = current_time
			end
		elseif battleframe then
			battleframe = nil
		end
		--]]
		if ctrlstatus and shiftstatus and altstatus and current_time > delayaction then
			delayaction = current_time + 1
			Logout();
		elseif ctrlstatus and not shiftstatus and altstatus and not auctionstatus and not mailstatus and current_time > delayaction then	
			if tradestatus then
				AcceptTrade();
			elseif not tradestatus and UnitExists("target") and UnitIsPlayer("target") and UnitIsFriend("target", "player") and not UnitIsUnit("player", "target") and CheckInteractDistance("target", 2) and (current_time + 0.25) > ctrlalttime and current_time > tradedelay then
				InitiateTrade("target");
				delayaction = current_time + 2
			end
		elseif ctrlstatus and shiftstatus and not altstatus and UnitIsPlayer("target") and UnitIsFriend("target", "player") and current_time > delayaction and (current_time + 0.25) > ctrlshifttime then
			delayaction = current_time + 1.5
			FollowUnit("target");
		elseif not ctrlstatus and shiftstatus and altstatus and UnitIsPlayer("target") and current_time > delayaction and (current_time + 0.25) > altshifttime then
			delayaction = current_time + 1.5
			InspectUnit("target");
		end
			
		if ctrlstatus and not shiftstatus and altstatus or passpopup > current_time then
			if current_time > delayaction and not LazyPig_BindLootOpen() and not LazyPig_RollLootOpen() and LazyPig_GreenRoll() then	
				delayaction = current_time + 1
			elseif current_time > delayaction then
				for i=1,STATICPOPUP_NUMDIALOGS do
					local frame = getglobal("StaticPopup"..i)
					if frame:IsShown() then
						--DEFAULT_CHAT_FRAME:AddMessage(frame.which)
						if frame.which == "DEATH" and HasSoulstone() then
							getglobal("StaticPopup"..i.."Button2"):Click();
							if passpopup < current_time then delayaction = current_time + 0.5 end
						elseif frame.which ~= "CONFIRM_SUMMON" and frame.which ~= "CONFIRM_BATTLEFIELD_ENTRY" and frame.which ~= "CAMP" and frame.which ~= "AREA_SPIRIT_HEAL"  then --and release and
							getglobal("StaticPopup"..i.."Button1"):Click();
							if passpopup < current_time then delayaction = current_time + 0.5 end
						end
					end
				end
			end	
		end
		
		if ctrlstatus and not shiftstatus and altstatus then
			if current_time > delayaction then
				if auctionstatus and AuctionFrameAuctions and AuctionFrameAuctions:IsVisible() and AuctionsCreateAuctionButton then
					ScheduleButtonClick(AuctionsCreateAuctionButton, 0);
				elseif auctionstatus and AuctionFrameBrowse and AuctionFrameBrowse:IsVisible() and BrowseBuyoutButton then	
					ScheduleButtonClick(BrowseBuyoutButton, 0.55);
				elseif CT_MailFrame and CT_MailFrame:IsVisible() and CT_MailFrame.num > 0 and strlen(CT_MailNameEditBox:GetText()) > 0 and CT_Mail_AcceptSendFrameSendButton then
					ScheduleButtonClick(CT_Mail_AcceptSendFrameSendButton, 1.25);
				elseif GMailFrame and GMailFrame:IsVisible() and GMailFrame.num > 0 and strlen(GMailSubjectEditBox:GetText()) > 0 and GMailAcceptSendFrameSendButton then
					ScheduleButtonClick(GMailAcceptSendFrameSendButton, 1.25);
				elseif mailstatus and SendMailFrame and SendMailFrame:IsVisible() and SendMailMailButton then					
					ScheduleButtonClick(SendMailMailButton, 0);
				elseif mailstatus and OpenMailFrame and OpenMailFrame:IsVisible() then
					if OpenMailFrame.money and OpenMailMoneyButton then
						ScheduleButtonClick(OpenMailMoneyButton, 0);
					elseif OpenMailPackageButton then
						ScheduleButtonClick(OpenMailPackageButton, 0);
					end	
				end	
			end
			LazyPig_AutoLeaveBG();
		elseif not ctrlstatus and shiftstatus and altstatus and current_time > delayaction then
			if auctionstatus and AuctionFrameBrowse and AuctionFrameBrowse:IsVisible() and BrowseBidButton then
				ScheduleButtonClick(BrowseBidButton, 0.55);
			end	
		end	
	end
	
	if merchantstatus and shiftstatus and current_time > last_click and not CursorHasItem() then
		last_click = current_time + 0.25
		LazyPig_GreySellRepair();
	end
	
	if shiftstatus or altstatus then
		if QuestFrameDetailPanel:IsVisible() then
			AcceptQuest();
		end
	elseif QuestRecord["details"] and not shiftstatus then
		LazyPig_RecordQuest();
	end
	
	if not afk_active and player_bg_confirm then
		Check_Bg_Status();
	end
	
	if bgstatus ~= 0 and (bgstatus + 0.5) > current_time then
		bgstatus = 0
		Check_Bg_Status()
		LazyPig_AutoLeaveBG()
	end	
		
	if(current_time - roster_task_refresh) > 29 then
		roster_task_refresh = current_time
		GuildRoster();
		ChatSpamClean();
	end
	
	if save_time ~= 0 and (current_time - save_time) > 3 and not GetBattlefieldWinner() and not UnitAffectingCombat("player") then	
		save_check = current_time
		save_time = 0
		SaveData();
	end
	
	if player_summon_confirm then
		LazyPig_AutoSummon();
	end
	
	LazyPig_CheckSalvation();
	ScheduleButtonClick();
	ScheduleFunctionLaunch();
	ScheduleItemSplit();
	LazyPig_WatchSplit();
	
end

function ScheduleButtonClick(button, delay)
	local current_time = GetTime()
	if button and not ScheduleButton[button] then
		delay = delay or 0.75
		ScheduleButton[button] = current_time + delay
	else
		for blockindex,blockmatch in pairs(ScheduleButton) do
			if current_time < delayaction then
				ScheduleButton[blockindex] = nil
			elseif current_time >= blockmatch then
				blockindex:Click()
				passpopup = current_time + 0.75
				ScheduleButton[blockindex] = nil
			end
		end
	end
end

function ScheduleFunctionLaunch(func, delay)
	local current_time = GetTime()
	if func and not ScheduleFunction[func] then
		delay = delay or 0.75
		ScheduleFunction[func] = current_time + delay
	else
		for blockindex,blockmatch in pairs(ScheduleFunction) do
			if current_time >= blockmatch then
				blockindex()
				ScheduleFunction[blockindex] = nil
			end
		end
	end
end

function LazyPig_OnEvent(event)
	if (event == "ADDON_LOADED") and (arg1 == "_LazyPig") then
		local LP_TITLE = GetAddOnMetadata("_LazyPig", "Title")
		local LP_VERSION = GetAddOnMetadata("_LazyPig", "Version")
		local LP_AUTHOR = GetAddOnMetadata("_LazyPig", "Author")
		
		DEFAULT_CHAT_FRAME:AddMessage(LP_TITLE .. " v" .. LP_VERSION .. " by " .."|cffFF0066".. LP_AUTHOR .."|cffffffff".. " loaded, type".."|cff00eeee".." /lp".."|cffffffff for options")
	elseif (event == "PLAYER_LOGIN") then
	--if (event == "PLAYER_ENTERING_WORLD") then
	--	this:UnregisterEvent("PLAYER_ENTERING_WORLD")
		this:RegisterEvent("CHAT_MSG")
		this:RegisterEvent("CHAT_MSG_SYSTEM")
		this:RegisterEvent("PARTY_INVITE_REQUEST")
		this:RegisterEvent("CONFIRM_SUMMON")
		this:RegisterEvent("RESURRECT_REQUEST")
		this:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
		this:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
		this:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
		this:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
		this:RegisterEvent("BATTLEFIELDS_SHOW")
		this:RegisterEvent("GOSSIP_SHOW")
		this:RegisterEvent("QUEST_GREETING")
		this:RegisterEvent("UI_ERROR_MESSAGE")
		this:RegisterEvent("CHAT_MSG_LOOT")
		--this:RegisterEvent("CHAT_MSG_MONEY")
		this:RegisterEvent("QUEST_PROGRESS")
		this:RegisterEvent("QUEST_COMPLETE")
		this:RegisterEvent("START_LOOT_ROLL")
		this:RegisterEvent("DUEL_REQUESTED")
		this:RegisterEvent("MERCHANT_SHOW")
		this:RegisterEvent("MERCHANT_CLOSED")
		this:RegisterEvent("TRADE_SHOW")
		this:RegisterEvent("TRADE_CLOSED")
		this:RegisterEvent("MAIL_SHOW")
		this:RegisterEvent("MAIL_CLOSED")
		this:RegisterEvent("AUCTION_HOUSE_SHOW")
		this:RegisterEvent("AUCTION_HOUSE_CLOSED")	
		this:RegisterEvent("BANKFRAME_OPENED")
		this:RegisterEvent("BANKFRAME_CLOSED")
		this:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		this:RegisterEvent("PLAYER_UNGHOST")
		this:RegisterEvent("PLAYER_DEAD")
		this:RegisterEvent("PLAYER_AURAS_CHANGED")
		this:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
		this:RegisterEvent("UNIT_INVENTORY_CHANGED")
		this:RegisterEvent("UI_INFO_MESSAGE")
		
		LazyPigOptionsFrame = LazyPig_CreateOptionsFrame()
		LazyPigKeybindsFrame = LazyPig_CreateKeybindsFrame()

		LazyPig_CheckSalvation();
		Check_Bg_Status();
		LazyPig_AutoLeaveBG();
		LazyPig_AutoSummon();
		ScheduleFunctionLaunch(LazyPig_ZoneCheck, 6);
		ScheduleFunctionLaunch(LazyPig_ZoneCheck2, 7);
		ScheduleFunctionLaunch(LazyPig_RefreshNameplates, 0.25);
		MailtoCheck();
		
		

		if LPCONFIG.CAM then SetCVar("cameraDistanceMax",50) end
		if LPCONFIG.LOOT then UIPanelWindows["LootFrame"] = nil end
		QuestRecord["index"] = 0
		
		--TargetUnit("player")
		--SendChatMessage(".xp 8", "SAY") --qgaming version
		--SendChatMessage(".exp 5", "SAY") --scriptcraft version

	elseif (LPCONFIG.SALVA and (event == "PLAYER_AURAS_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" and LazyPig_PlayerClass("Druid", "player") or event == "UNIT_INVENTORY_CHANGED")) then
		LazyPig_CheckSalvation()
		
	elseif(event == "DUEL_REQUESTED") then
		duel_active = true
		if LPCONFIG.DUEL and not IsShiftKeyDown() then --dnd_active and
			duel_active = nil
			CancelDuel()
			UIErrorsFrame:AddMessage(arg1.." - Duel Cancelled")
		end	
	
	elseif(event == "PLAYER_DEAD") then
		if LPCONFIG.RBG and LazyPig_BG() then
			RepopMe();
		end	
	
	elseif(event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_UNGHOST") then
		if event == "ZONE_CHANGED_NEW_AREA" then 
			tradestatus = nil
			mailstatus = nil
			auctionstatus = nil
			bankstatus = nil
			wsgefc = nil
		end
		
		ScheduleFunctionLaunch(LazyPig_RefreshNameplates, 0.25)
		ScheduleFunctionLaunch(LazyPig_ZoneCheck, 5)
		ScheduleFunctionLaunch(LazyPig_ZoneCheck, 6)
		--DEFAULT_CHAT_FRAME:AddMessage(event);

	elseif(event == "BANKFRAME_OPENED") then
		bankstatus = true
		tmp_splitval = 1
		
	elseif(event == "BANKFRAME_CLOSED") then
		bankstatus = false
		LazyPig_EndSplit()
	
	elseif(event == "AUCTION_HOUSE_SHOW") then
		auctionstatus = true
		auctionbrowse = nil
		tmp_splitval = 1
		
	elseif(event == "AUCTION_HOUSE_CLOSED") then
		auctionstatus = false
		LazyPig_EndSplit()	

	elseif(event == "MAIL_SHOW") then
		mailstatus = true
		tmp_splitval = 1

	elseif(event == "MAIL_CLOSED") then
		mailstatus = false
		LazyPig_EndSplit()
		
	elseif(event == "MERCHANT_SHOW") then
		merchantstatus = true
		GreySell = {}
	
	elseif(event == "MERCHANT_CLOSED") then
		merchantstatus = false
	
	elseif(event == "TRADE_SHOW") then	
		tradestatus = true
		tmp_splitval = 1
	
	elseif(event == "TRADE_CLOSED") then	
		tradedelay = GetTime() + 1
		tradestatus = false
		LazyPig_EndSplit()	
			
	elseif(event == "START_LOOT_ROLL") then
		LazyPig_ZGRoll(arg1)
	
	elseif(event == "CHAT_MSG_LOOT") then
		if (string.find(arg1 ,"You won") or string.find(arg1 ,"You receive")) and (string.find(arg1 ,"cffa335e") or string.find(arg1, "cff0070d") or string.find(arg1, "cffff840")) and not string.find(arg1 ,"Bijou") and not string.find(arg1 ,"Idol") and not string.find(arg1 ,"Shard") then
			save_time = GetTime()
		end
	
	elseif(event == "UI_ERROR_MESSAGE") then
		if(string.find(arg1, "mounted") or string.find(arg1, "while silenced")) and LPCONFIG.DISMOUNT then
			UIErrorsFrame:Clear()
			LazyPig_Dismount()
		end
	elseif (event == "UI_INFO_MESSAGE") then
		if string.find(arg1 ,"Duel cancelled") then
			duel_active = nil
		end	
	elseif (event == "CHAT_MSG_SYSTEM") then
		if arg1 == CLEARED_DND or arg1 == CLEARED_AFK then
			dnd_active = false
			afk_active = false
			Check_Bg_Status()
			
		elseif(string.find(arg1, string.sub(MARKED_DND, 1, string.len(MARKED_DND) -3))) then
			afk_active = false
			dnd_active = true
			--if LPCONFIG.DUEL then CancelDuel() UIErrorsFrame:AddMessage("Duel Decline Atctive - DND") end
		
		elseif(string.find(arg1, string.sub(MARKED_AFK, 1, string.len(MARKED_AFK) -2))) then
			afk_active = true
			if LPCONFIG.EBG and not LazyPig_Raid() and not LazyPig_Dungeon() then UIErrorsFrame:AddMessage("Auto Join BG Inactive - AFK") end
		
		elseif string.find(arg1, "There is no such command") and (GetTime() - save_check) < 1 then
			LPCONFIG.NOSAVE = GetRealmName()
			DEFAULT_CHAT_FRAME:AddMessage("LazyPig:"..RED.."Auto Save Disabled - Command not Supported");		
		
		elseif LPCONFIG.AQUE and string.find(arg1 ,"Queued") and UnitIsPartyLeader("player") then
			if UnitInRaid("player") then
				SendChatMessage(arg1, "RAID");
			elseif GetNumPartyMembers() > 1 then
				SendChatMessage(arg1, "PARTY");
			end
			
		elseif string.find(arg1 ,"completed.") then
			LazyPig_FixQuest(arg1)
			QuestRecord["progress"] = nil

		elseif string.find(arg1 ,"Duel starting:") or string.find(arg1 ,"requested a duel") then
			duel_active = true
		elseif string.find(arg1 ,"in a duel") then
			duel_active = nil
		end
	
	elseif(event == "QUEST_GREETING") then
		ActiveQuest = {}
		AvailableQuest = {}
		for i=1, GetNumActiveQuests() do
			ActiveQuest[i] = GetActiveTitle(i).." "..GetActiveLevel(i)
		end
		for i=1, GetNumAvailableQuests() do
			AvailableQuest[i] = GetAvailableTitle(i).." "..GetAvailableLevel(i)
		end	
	
		LazyPig_ReplyQuest(event);
		
		--DEFAULT_CHAT_FRAME:AddMessage("active_: "..table.getn(ActiveQuest))
		--DEFAULT_CHAT_FRAME:AddMessage("available_: "..table.getn(AvailableQuest))			
	
	elseif(event == "GOSSIP_SHOW") then
		local GossipOptions = {};
		local dsc = nil
		local gossipnr = nil
		local gossipbreak = nil
		local processgossip = IsShiftKeyDown() or LPCONFIG.GOSSIP
		
		dsc,GossipOptions[1],_,GossipOptions[2],_,GossipOptions[3],_,GossipOptions[4],_,GossipOptions[5] = GetGossipOptions()	

		ActiveQuest = LazyPig_ProcessQuests(GetGossipActiveQuests())
		AvailableQuest = LazyPig_ProcessQuests(GetGossipAvailableQuests())
		
		if QuestRecord["qnpc"] ~= UnitName("target") then
			QuestRecord["index"] = 0
			QuestRecord["qnpc"] = UnitName("target")
		end
		
		if table.getn(AvailableQuest) ~= 0 or table.getn(ActiveQuest) ~= 0 then 
			gossipbreak = true 
		end
		
		--DEFAULT_CHAT_FRAME:AddMessage("gossip: "..table.getn(GossipOptions))
		--DEFAULT_CHAT_FRAME:AddMessage("active: "..table.getn(ActiveQuest))
		--DEFAULT_CHAT_FRAME:AddMessage("available: "..table.getn(AvailableQuest))
		
		for i=1, getn(GossipOptions) do
			if GossipOptions[i] == "binder" then
				local bind = GetBindLocation();
	
				--if not (bind == GetSubZoneText() or bind == GetZoneText() or bind == GetRealZoneText() or bind == GetMinimapZoneText()) then
				if bind ~= GetSubZoneText() then
					gossipbreak = true
				end	
			elseif gossipnr then
				gossipbreak = true
			elseif (GossipOptions[i] == "trainer" or GossipOptions[i] == "vendor" and processgossip or GossipOptions[i] == "battlemaster" and (LPCONFIG.QBG or processgossip) or GossipOptions[i] == "gossip" and (IsAltKeyDown() or IsShiftKeyDown() or string.find(dsc, "Teleport me to the Molten Core") and processgossip)) then
				gossipnr = i
			elseif GossipOptions[i] == "taxi" and processgossip then	
				gossipnr = i
				LazyPig_Dismount();	
			end
		end
		
		if not gossipbreak and gossipnr then
			SelectGossipOption(gossipnr);
		else
			LazyPig_ReplyQuest(event);
		end	

	elseif(event == "QUEST_PROGRESS" or event == "QUEST_COMPLETE") then
		LazyPig_ReplyQuest(event);
		
	elseif (event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" or event == "CHAT_MSG_BG_SYSTEM_HORDE") then
		--DEFAULT_CHAT_FRAME:AddMessage(event.." - "..arg1);
		LazyPig_Track_EFC(arg1)
		
	elseif(event == "UPDATE_BATTLEFIELD_STATUS" and not afk_active or event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" and arg1 and string.find(arg1, "wins!")) then
		bgstatus = GetTime()
			
	elseif(event == "BATTLEFIELDS_SHOW") then
		LazyPig_QueueBG();

	elseif (event == "CONFIRM_SUMMON") then	
		LazyPig_AutoSummon();
			
	elseif(event == "PARTY_INVITE_REQUEST") then
		local check1 = not LPCONFIG.DINV or LPCONFIG.DINV and not LazyPig_BG() and not LazyPig_Queue()
		local check2 = LPCONFIG.GINV and IsGuildMate(arg1) or LPCONFIG.FINV and IsFriend(arg1) or not IsGuildMate(arg1) and not IsFriend(arg1) and LPCONFIG.SINV
		if check1 and check2 then
			AcceptGroupInvite();
		end
	elseif(event == "RESURRECT_REQUEST" and LPCONFIG.REZ) then
		UIErrorsFrame:AddMessage(arg1.." - Resurrection")
		TargetByName(arg1, true)
		if GetCorpseRecoveryDelay() == 0 and (LazyPig_Raid() or LazyPig_Dungeon() or LazyPig_BG()) and UnitIsPlayer("target") and UnitIsVisible("target") and not UnitAffectingCombat("target") then
			AcceptResurrect()
			StaticPopup_Hide("RESURRECT_NO_TIMER"); 
			StaticPopup_Hide("RESURRECT_NO_SICKNESS");
			StaticPopup_Hide("RESURRECT");
		end
		TargetLastTarget();
	end
	--DEFAULT_CHAT_FRAME:AddMessage(event);	
end

function LazyPig_StaticPopup_OnShow()
	if this.which == "QUEST_ACCEPT" and LazyPig_BG() and LPCONFIG.SBG then
		UIErrorsFrame:Clear();
		UIErrorsFrame:AddMessage("Quest Blocked Successfully");
		this:Hide();
		
	else
		Original_StaticPopup_OnShow();
	end	
end
 
function MailtoCheck(msg) 
	if MailTo_Option then -- to avoid conflicts with mailto addon
		local disable = LPCONFIG.RIGHT or LPCONFIG.SHIFT
		MailTo_Option.noshift = disable
		MailTo_Option.noauction = disable 
		MailTo_Option.notrade = disable
		MailTo_Option.noclick = disable
		if msg then DEFAULT_CHAT_FRAME:AddMessage("_LazyPig: Warning Improved Right Click and Easy Split/Merge features may override MailTo addon functionality !") end
	end
end

function LazyPig_Text(txt)
	if txt then
		LazyPigText:SetTextColor(0, 1, 0)
		LazyPigText:SetText(txt)
		LazyPigText:Show()
	else
		LazyPigText:SetText()
		LazyPigText:Hide()
	end
end

--code taken from quickloot
local function LazyPig_ItemUnderCursor()
	if LPCONFIG.LOOT then
		local index;
		local x, y = GetCursorPosition();
		local scale = LootFrame:GetEffectiveScale();
		x = x / scale;
		y = y / scale;
		LootFrame:ClearAllPoints();
		for index = 1, LOOTFRAME_NUMBUTTONS, 1 do
			local button = getglobal("LootButton"..index);
			if( button:IsVisible() ) then
				x = x - 42;
				y = y + 56 + (40 * index);
				LootFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", x, y);
				return;
			end
		end
		if LootFrameDownButton:IsVisible() then
			x = x - 158;
			y = y + 223;
		else
			if GetNumLootItems() == 0  then
				HideUIPanel(LootFrame);
				return
			end
			x = x - 173;
			y = y + 25;
		end
		LootFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", x, y);
	end	
end

function LazyPig_LootFrame_OnEvent(event)
	OriginalLootFrame_OnEvent(event);
	if(event == "LOOT_SLOT_CLEARED") then
		LazyPig_ItemUnderCursor();
	end
end

function LazyPig_LootFrame_Update()
	OriginalLootFrame_Update();
	LazyPig_ItemUnderCursor();
end
function IsFriend(name)
	for i = 1, GetNumFriends() do
		if GetFriendInfo(i) == name then
			return true
		end
	end
	return nil
end

function IsGuildMate(name)
	if IsInGuild() then
		local ngm=GetNumGuildMembers()
		for i=1, ngm do
			n, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i);
			if strlower(n) == strlower(name) then
			  return true
			end
		end
	end
	return nil
end

function AcceptGroupInvite()
	AcceptGroup();
	StaticPopup_Hide("PARTY_INVITE");
	PlaySoundFile("Sound\\Doodad\\BellTollNightElf.wav");
	UIErrorsFrame:AddMessage("Group Auto Accept");
end

function LazyPig_AutoSummon()
	local keyenter = IsAltKeyDown() and IsControlKeyDown() and not tradestatus and not mailstatus and not auctionstatus and GetTime() > delayaction and GetTime() > (tradedelay + 0.5)
	if LPCONFIG.SUMM then
		local expireTime = GetSummonConfirmTimeLeft()
		if not player_summon_message and expireTime ~= 0 then
			player_summon_message = true
			player_summon_confirm = true
			DEFAULT_CHAT_FRAME:AddMessage("LazyPig: Auto Summon in "..math.floor(expireTime).."s", 1.0, 1.0, 0.0);
			
		elseif expireTime <= 3 or keyenter then
			player_summon_confirm = false
			player_summon_message = false
				
			for i=1,STATICPOPUP_NUMDIALOGS do
				local frame = getglobal("StaticPopup"..i)
				if frame.which == "CONFIRM_SUMMON" and frame:IsShown() then	
					ConfirmSummon();
					delayaction = GetTime() + 0.75
					StaticPopup_Hide("CONFIRM_SUMMON");
				end	
			end
		elseif expireTime == 0 then
			player_summon_confirm = false
			player_summon_message = false
		end
	end
end

function Check_Bg_Status()
	local bgStatus = {};	
	local player_bg_active = false
	local player_bg_request = false
	
	for i=1, MAX_BATTLEFIELD_QUEUES do
		local status, mapName, instanceID = GetBattlefieldStatus(i);
		bgStatus[i] = {};
		bgStatus[i]["status"] = status;
		bgStatus[i]["map"] = mapName;
		bgStatus[i]["id"] = instanceID;
		
		if(status == "confirm" ) then
			player_bg_request = true
		elseif((status == "active") and not (mapName == "Eastern Kingdoms") and not (mapName == "Kalimdor")) then
			player_bg_active = true
		end
	end
	
	player_bg_confirm = player_bg_request
	
	if(player_bg_message and not player_bg_active and not player_bg_request) then
		player_bg_message = false
	end
	
	if(not player_bg_active and player_bg_request) then
		local index = 1
		while bgStatus[index] do
			if(bgStatus[index]["status"] == "confirm" ) then
				LazyPig_AutoJoinBG(index, bgStatus[index]["map"]);
			end
			index = index + 1
		end
	end	
end

function LazyPig_QueueBG()
	if LPCONFIG.QBG then	
		for i=1, MAX_BATTLEFIELD_QUEUES do
			local status = GetBattlefieldStatus(i);
			if IsShiftKeyDown() and (status == "queued" or status == "confirm") then
				AcceptBattlefieldPort(i,nil);
			end
		end
		if (GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0) and IsPartyLeader() then
			JoinBattlefield(0,1);
		else
			JoinBattlefield(0);
		end
		ClearTarget();
		BattlefieldFrameCancelButton:Click()
	end	
end		

function LazyPig_AutoJoinBG(index, map_name)	
	local keyenter = IsAltKeyDown() and IsControlKeyDown() and not tradestatus and not mailstatus and not auctionstatus and GetTime() > delayaction and GetTime() > (tradedelay + 0.5)
	if LPCONFIG.EBG or keyenter then	
		local expireTime = GetBattlefieldPortExpiration(index)/1000
		expireTime = math.floor(expireTime);
		if not player_bg_message and expireTime > 3 and GetTime() > delayaction then
			player_bg_message = true
			DEFAULT_CHAT_FRAME:AddMessage("LazyPig: Auto Join ".. map_name.." in "..expireTime.."s", 1.0, 1.0, 0.0)

		elseif expireTime <= 3 or keyenter then
			AcceptBattlefieldPort(index, true);
			StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY")
			delayaction = GetTime() + 0.75
			if player_bg_message then
				player_bg_message = false
			end
		end	
	end	
end

function LazyPig_AutoLeaveBG()
	local keyenter = IsAltKeyDown() and IsControlKeyDown()
	if LPCONFIG.LBG or keyenter then
		local bg_winner = GetBattlefieldWinner()
		local winner_name = "Alliance"
		if bg_winner ~= nil then	
			save_time = GetTime() + 15
			if bg_winner == 0 then winner_name = "Horde" end
			UIErrorsFrame:Clear();
			UIErrorsFrame:AddMessage(winner_name.." Wins");
			LeaveBattlefield();
		end	
	end
end

function SaveData()
	if LPCONFIG.NOSAVE ~= GetRealmName() then	
		SendChatMessage(".save", "SAY");
		UIErrorsFrame:Clear()
		UIErrorsFrame:AddMessage("Character Saved");
	end	
end

function LazyPig_BagReturn(find)
	local link = nil
	local bagslots = nil
	for bag=0,NUM_BAG_FRAMES do
		bagslots = GetContainerNumSlots(bag)
		if bagslots and bagslots > 0 then
			for slot=1,bagslots do
				link = GetContainerItemLink(bag, slot)
				if not find and not link or find and link and string.find(link, find) then
					return bag, slot
				end
			end
		end
	end
	return nil
end

function LazyPig_ZGRoll(id)
	RollReturn = function()
		local txt = ""
		if LPCONFIG.ZG == 1 then
			txt = "NEED"
		elseif LPCONFIG.ZG == 2 then
			txt = "GREED"
		elseif LPCONFIG.ZG == 0 then
			txt = "PASS"
		end
		return txt
	end
	if LPCONFIG.ZG then	
		local _, name, _, quality = GetLootRollItemInfo(id);
		if string.find(name ,"Hakkari Bijou") or string.find(name ,"Coin") then
			RollOnLoot(id, LPCONFIG.ZG);
			local _, _, _, hex = GetItemQualityColor(quality)
			DEFAULT_CHAT_FRAME:AddMessage("LazyPig: Auto "..hex..RollReturn().." "..GetLootRollItemLink(id))
			return
		end	
	end	
end

function LazyPig_GreenRoll()
	RollReturn = function()
		local txt = ""
		if LPCONFIG.GREEN == 1 then
			txt = "NEED"
		elseif LPCONFIG.GREEN == 2 then
			txt = "GREED"
		elseif LPCONFIG.GREEN == 0 then
			txt = "PASS"
		end
		return txt
	end
	local pass = nil
	if LPCONFIG.GREEN then	
		for i=1, NUM_GROUP_LOOT_FRAMES do
			local frame = getglobal("GroupLootFrame"..i);
			if frame:IsVisible() then
				local id = frame.rollID
				local _, name, _, quality = GetLootRollItemInfo(id);
				if quality == 2 then
					RollOnLoot(id, LPCONFIG.GREEN);
					local _, _, _, hex = GetItemQualityColor(quality)
					greenrolltime = GetTime() + 1
					DEFAULT_CHAT_FRAME:AddMessage("LazyPig: "..hex..RollReturn().."|cffffffff Roll "..GetLootRollItemLink(id))
					pass = true
				end
			end
		end
	end	
	return pass
end

function LazyPig_GreySellRepair()
	local bag, slot = LazyPig_BagReturn("ff9d9d9d")
	if bag and slot then
		local _, _, locked = GetContainerItemInfo(bag, slot)
		if bag and slot and not locked then	
			UseContainerItem(bag,slot)
			if not(GreySell.bag == bag and GreySell.slot == slot) then
				DEFAULT_CHAT_FRAME:AddMessage("LazyPig: Selling "..GetContainerItemLink(bag, slot))
				GreySell.bag = bag
				GreySell.slot = slot
			end	
		end
	elseif CanMerchantRepair() then
		local rcost = GetRepairAllCost()
		if rcost and rcost ~= 0 then
			if rcost > GetMoney() then 
				DEFAULT_CHAT_FRAME:AddMessage("LazyPig: Not Enough Money to Repair")
				return
			end
			GreySell.repair = rcost
			RepairAllItems();
		elseif GreySell.repair and	rcost == 0 then
			local gold = floor(abs(GreySell.repair / 10000))
			local silver = floor(abs(mod(GreySell.repair / 100, 100)))
			local copper = floor(abs(mod(GreySell.repair, 100)))	
			local COLOR_COPPER = "|cffeda55f"
			local COLOR_SILVER = "|cffc7c7cf"
			local COLOR_GOLD = "|cffffd700"
			
			DEFAULT_CHAT_FRAME:AddMessage("LazyPig: Repairing All Items "..COLOR_GOLD..gold.."g "..COLOR_SILVER..silver.."s "..COLOR_COPPER..copper.."c")
			GreySell.repair = nil
		end
	end	
end

function LazyPig_ProcessQuests(...)
	local quest = {}
	for i = 1, table.getn(arg), 2 do
		local count, title, level = i, arg[i], arg[i+1]
		if count > 1 then count = (count+1)/2 end
		quest[count] = title.." "..level
	end
	return quest
end

function LazyPig_PrepareQuestAutoPickup()
	if IsAltKeyDown() then
		GossipFrameCloseButton:Click();
		ClearTarget();
	end	
end

function LazyPig_SelectGossipActiveQuest(index, norecord)
	if not ActiveQuest[index] then 
		--DEFAULT_CHAT_FRAME:AddMessage("LazyPig_SelectGossipActiveQuest Error");
	elseif not norecord then
		LazyPig_RecordQuest(ActiveQuest[index])
	end
	Original_SelectGossipActiveQuest(index);
end

function LazyPig_SelectGossipAvailableQuest(index, norecord)
	if not AvailableQuest[index] then 
		--DEFAULT_CHAT_FRAME:AddMessage("LazyPig_SelectGossipAvailableQuest Error");
	elseif not norecord then
		LazyPig_RecordQuest(AvailableQuest[index])
	end
	Original_SelectGossipAvailableQuest(index);
end

function LazyPig_SelectActiveQuest(index, norecord)
	if not ActiveQuest[index] then 
		--DEFAULT_CHAT_FRAME:AddMessage("LazyPig_SelectActiveQuest Error");
	elseif not norecord then
		LazyPig_RecordQuest(ActiveQuest[index])
	end
	Original_SelectActiveQuest(index);
end

function LazyPig_SelectAvailableQuest(index, norecord)
	if not AvailableQuest[index] then 
		--DEFAULT_CHAT_FRAME:AddMessage("LazyPig_SelectAvailableQuest Error");
	elseif not norecord then
		LazyPig_RecordQuest(AvailableQuest[index])
	end
	Original_SelectAvailableQuest(index);
end

function LazyPig_FixQuest(quest, annouce)
	if not QuestRecord["details"] then
		annouce = true
	end
	if UnitLevel("player") == 60 then	
		if string.find(quest, "Fight for Warsong Gulch") then
			QuestRecord["details"] = "Fight for Warsong Gulch 60"
		elseif string.find(quest, "Battle of Warsong Gulch") then
			QuestRecord["details"] = "Battle of Warsong Gulch 60"	
		elseif string.find(quest, "Claiming Arathi Basin") then
			QuestRecord["details"] = "Claiming Arathi Basin 60"	
		elseif string.find(quest, "Conquering Arathi Basin") then
			QuestRecord["details"] = "Conquering Arathi Basin 60"
		end
	end
	if QuestRecord["details"] and annouce then 
		UIErrorsFrame:Clear();
		UIErrorsFrame:AddMessage("Recording: "..QuestRecord["details"])
	end
end

function LazyPig_RecordQuest(qdetails)
	if IsShiftKeyDown() and qdetails then
		if QuestRecord["details"] ~= qdetails then
			QuestRecord["details"] = qdetails
		end	
		LazyPig_FixQuest(QuestRecord["details"], true)
	elseif not IsShiftKeyDown() and QuestRecord["details"] then
		QuestRecord["details"] = nil
	end
	QuestRecord["progress"] = true
end

function LazyPig_ReplyQuest(event)
	if IsShiftKeyDown() or IsAltKeyDown() then
		if QuestRecord["details"] then
			UIErrorsFrame:Clear();
			UIErrorsFrame:AddMessage("Replaying: "..QuestRecord["details"])
		end
		
		if event == "GOSSIP_SHOW" then
			if QuestRecord["details"] then
				for blockindex,blockmatch in pairs(ActiveQuest) do
					if blockmatch == QuestRecord["details"] then
						Original_SelectGossipActiveQuest(blockindex)
						return
					end
				end
				for blockindex,blockmatch in pairs(AvailableQuest) do
					if blockmatch == QuestRecord["details"] then
						Original_SelectGossipAvailableQuest(blockindex)
						return
					end
				end
			elseif table.getn(ActiveQuest) == 0 and table.getn(AvailableQuest) == 1 or IsAltKeyDown() and table.getn(AvailableQuest) > 0 then
				LazyPig_SelectGossipAvailableQuest(1, true)
			elseif table.getn(ActiveQuest) == 1 and table.getn(AvailableQuest) == 0 or IsAltKeyDown() and table.getn(ActiveQuest) > 0 then
				local nr = table.getn(ActiveQuest)
				if QuestRecord["progress"] and (nr - QuestRecord["index"]) > 0 then
					--DEFAULT_CHAT_FRAME:AddMessage("++quest dec nr - "..nr.." index - "..QuestRecord["index"])
					QuestRecord["index"] = QuestRecord["index"] + 1
					nr = nr - QuestRecord["index"]
				end
				LazyPig_SelectGossipActiveQuest(nr, true)	
			end
		elseif event == "QUEST_GREETING" then
			if QuestRecord["details"] then
				for blockindex,blockmatch in pairs(ActiveQuest) do
					if blockmatch == QuestRecord["details"] then
						Original_SelectActiveQuest(blockindex)
						return
					end
				end
				for blockindex,blockmatch in pairs(AvailableQuest) do
					if blockmatch == QuestRecord["details"] then
						Original_SelectAvailableQuest(blockindex)
						return
					end
				end
			elseif table.getn(ActiveQuest) == 0 and table.getn(AvailableQuest) == 1 or IsAltKeyDown() and table.getn(AvailableQuest) > 0 then
				LazyPig_SelectAvailableQuest(1, true)
			elseif table.getn(ActiveQuest) == 1 and table.getn(AvailableQuest) == 0 or IsAltKeyDown() and table.getn(ActiveQuest) > 0 then
				local nr = table.getn(ActiveQuest)
				if QuestRecord["progress"] and (nr - QuestRecord["index"]) > 0 then
					--DEFAULT_CHAT_FRAME:AddMessage("--quest dec nr - "..nr.." index - "..QuestRecord["index"])
					QuestRecord["index"] = QuestRecord["index"] + 1
					nr = nr - QuestRecord["index"]
				end
				LazyPig_SelectActiveQuest(nr, true)
			end
	
		elseif event == "QUEST_PROGRESS" then
			CompleteQuest()
		elseif event == "QUEST_COMPLETE" and GetNumQuestChoices() == 0 then
			GetQuestReward(0)
		end	
	end
end

function LazyPig_Dismount()
	local counter = 0
	local tooltipfind = "Increases speed by (.+)%%"
	while GetPlayerBuff(counter) >= 0 do
		local index, untilCancelled = GetPlayerBuff(counter)
		LazyPig_Buff_Tooltip:SetPlayerBuff(index)
		local desc = LazyPig_Buff_TooltipTextLeft2:GetText()
		if desc then
			_, _, speed = string.find(desc, tooltipfind) 
			if speed then
				CancelPlayerBuff(counter)
				return
			end	
		end
		counter = counter + 1
	end
end

function LazyPig_DropWSGFlag_NoggBuff()
	local counter = 0
	local tooltipfind1 = "Warsong Flag"
	local tooltipfind2 = "You feel light"
	local tooltipfind3 = "Slow Fall"

	while GetPlayerBuff(counter) >= 0 do
		local index, untilCancelled = GetPlayerBuff(counter)
		LazyPig_Buff_Tooltip:SetPlayerBuff(index)
		local desc = LazyPig_Buff_TooltipTextLeft1:GetText()
		if string.find(desc, tooltipfind1) or string.find(desc, tooltipfind3) then
			CancelPlayerBuff(counter)
		end
		desc = LazyPig_Buff_TooltipTextLeft2:GetText()
		if string.find(desc, tooltipfind2) then
			CancelPlayerBuff(counter)
		end
		counter = counter + 1
	end
end

function LazyPig_ItemIsTradeable(bag, item)
	for i = 1, 29, 1 do
		getglobal("LazyPig_Buff_TooltipTextLeft" .. i):SetText("");
	end

	LazyPig_Buff_Tooltip:SetBagItem(bag, item);

	for i = 1, LazyPig_Buff_Tooltip:NumLines(), 1 do
		local text = getglobal("LazyPig_Buff_TooltipTextLeft" .. i):GetText();	
		if ( text == ITEM_SOULBOUND ) then
			return nil
		elseif ( text == ITEM_BIND_QUEST ) then
			return nil
		elseif ( text == ITEM_CONJURED ) then
			return nil
		end
	end
	return true
end



function LazyPig_Raid()
	local t = GetRealZoneText()
	if t =="Molten Core" or t =="Blackwing Lair" or t =="Zul'Gurub" or t =="Ahn'Qiraj" or t =="Onyxia's Lair" or t =="Ruins of Ahn'Qiraj" or t =="Temple of Ahn'Qiraj" or t =="Naxxramas" or t =="Blackrock Spire" then
		return true
	end
	return false
end

function LazyPig_Dungeon()
	local t = GetRealZoneText()
	if t =="Dire Maul" or t =="Stratholme"  or t =="Scholomance" or t =="Blackrock Depths" or t =="Sunken Temple" or t =="The Stockade" or t =="Zul'Farrak" or t =="Scarlet Monastery" or t =="Gnomeregan" or t =="The Deadmines" or t=="Blackfathom Deeps" or t=="Wailing Caverns" or t=="Razorfen Downs" or t=="Razorfen Kraul" or t=="Ragefire Chasm" or t=="Shadowfang Keep" then 
		return true
	end
	return false
end

function LazyPig_BG()
	local t = GetRealZoneText()
	if t == "Arathi Basin" or t == "Warsong Gulch" or t == "Alterac Valley" then
		return true
	end
	return false
end

function LazyPig_Queue()
	for i=1, MAX_BATTLEFIELD_QUEUES do
		local status, mapName, instanceID = GetBattlefieldStatus(i);	
		if(status == "confirm" or status == "active") then
			return true
		end
	end
	return nil
end

function LazyPig_EndSplit()
	timer_split = nil
	tmp_splitval = 1
	LazyPig_Text()
end

function LazyPig_DecodeItemLink(link)
	if link then
		local found, _, id, name = string.find(link, "item:(%d+):.*%[(.*)%]")
		if found then
			id = tonumber(id)
			return name, id
		end
	end
	return nil
end

function LazyPig_WatchSplit(enable)
	local returnval = timer_split
	if LPCONFIG.SHIFTSPLIT then	
		local time = GetTime()
		local txt_show = enable
		local ctrl = IsControlKeyDown()
		local alt = IsAltKeyDown()
		local duration = 9
	
		if enable then
			timer_split = time + duration
		elseif timer_split then
			local boost = -0.006*tmp_splitval + 1
			
			if auctionstatus then
				if AuctionFrameBrowse:IsVisible() then
					if not auctionbrowse then
						auctionbrowse = true
						LazyPig_EndSplit()
						return
					end	
				else
					auctionbrowse = nil
				end
			end
			
			if time > timer_split or auctionstatus and AuctionFrameAuctions and not (AuctionFrameAuctions:IsVisible() or AuctionFrameBrowse:IsVisible()) or mailstatus and SendMailFrame and not SendMailFrame:IsVisible() and (not CT_MailFrame or CT_MailFrame and not CT_MailFrame:IsVisible()) and (not GMailFrame or GMailFrame and not GMailFrame:IsVisible()) then
				LazyPig_EndSplit()
			elseif (ctrl or alt) and time > last_click then
				local forcepass = (timer_split - duration + 0.6) > time 
				if ctrl and alt then
					timer_split = time + duration - 1
					return	
				elseif alt and ((time + 0.1) > alttime or forcepass) and tmp_splitval < 100 then
					alttime = time + 0.125
					tmp_splitval = tmp_splitval + 1	
					timer_split = time + duration
					last_click = 0.109*boost + time
					txt_show = true
				elseif ctrl and ((time + 0.1) > ctrltime or forcepass) and tmp_splitval > 1 then
					ctrltime = time + 0.125
					tmp_splitval = tmp_splitval - 1
					timer_split = time + duration
					last_click = 0.109*boost + time
					txt_show = true
				end
			end	
		elseif auctionstatus and AuctionFrameAuctions and AuctionFrameAuctions:IsVisible() or mailstatus and SendMailFrame and SendMailFrame:IsVisible() or tradestatus or bankstatus or CT_MailFrame and CT_MailFrame:IsVisible() or GMailFrame and GMailFrame:IsVisible() then
			timer_split = time + duration - 1
			txt_show = true
		end
		if txt_show then LazyPig_Text("- Ctrl  "..tmp_splitval.."  Alt +", duration) end
	end
	return returnval
end

function LazyPig_UseContainerItem(ParentID,ItemID)
		if LPCONFIG.SHIFTSPLIT and not CursorHasItem() and not merchantstatus and IsShiftKeyDown() and not IsAltKeyDown() then
			if(GetTime() - last_click) < 0.3 then return end
			local _, itemCount, locked = GetContainerItemInfo(ParentID, ItemID)
			if locked or not itemCount then return end
			if not LazyPig_WatchSplit(true) then return end
			last_click = GetTime()
				
			local ItemArray = {}
			local name, id = LazyPig_DecodeItemLink(GetContainerItemLink(ParentID,ItemID))
			local _, _, _, _, _, _, maxstack = GetItemInfo(id)
			local out_slpit = tmp_splitval
			
			if out_slpit > maxstack then
				out_slpit = maxstack
			end

			local dcount = out_slpit
			local dbag = nil
			local dslot = nil
			local cursoritem = nil
			
			if itemCount < out_slpit then
				dbag, dslot = ParentID, ItemID
				dcount = out_slpit - itemCount
				cursoritem = true
			end

			if name then
				for b=0, NUM_BAG_FRAMES do
					local bagslots = GetContainerNumSlots(b)
					if bagslots and bagslots > 0 then
						for s=1, bagslots do
							local link = GetContainerItemLink(b, s)
							local n, d = LazyPig_DecodeItemLink(link)
							if not cursoritem or cursoritem and not (b == ParentID and s == ItemID) then
								if not link and not dbag and not dslot then
									dbag, dslot = b, s
									--DEFAULT_CHAT_FRAME:AddMessage(b.." "..s.." - scan mode1")
								elseif n then
									if n == name then
									--if (string.find(n, name) or n == name) then
										local _, c, l = GetContainerItemInfo(b, s)
										if not l then
											if not (itemCount < out_slpit) and not dbag and not dslot and c < out_slpit then
												dbag, dslot = b, s
												dcount = out_slpit - c
												--DEFAULT_CHAT_FRAME:AddMessage("b.." "..s.." count - "..c.." - "..scan mode2)	
											elseif c ~= out_slpit or cursoritem then
												ItemArray[b.."_"..s] = c
											end	
										end	
									end
								end
							end	
						end
					end
				end	
					
				if not dbag or not dslot or CursorHasItem() then return end
				
				local escape = 0 
				while dcount > 0 do
					local sbag = nil
					local sslot = nil
					local score = nil
					local number = nil
					local index = nil
						
					for blockindex,blockmatch in pairs(ItemArray) do
						local x = nil
						local y = nil
						x = string.gsub(blockindex,"_(.+)","")
						x = tonumber(x)
						y = string.gsub(blockindex,"(.+)_","")
						y = tonumber(y)

						if not number or number > blockmatch or number == blockmatch and (x*10 + y) > score then
							sbag = x
							sslot = y
							score = 10*sbag + sslot	
							number = blockmatch
							index = blockindex
						end
					end

					if sbag and sslot then
						local splitval = nil
						if (number - dcount) >= out_slpit then
							splitval = dcount
						elseif number > out_slpit then
							splitval = number - out_slpit
						elseif number < dcount then
							splitval = number
						else
							splitval = dcount
						end
							
						dcount = dcount - splitval
						ScheduleItemSplit(sbag, sslot, dbag, dslot, splitval)
						ItemArray[index] = nil
						--DEFAULT_CHAT_FRAME:AddMessage("Dest "..dbag.." - "..dslot.." From "..sbag.." - "..sslot.." - Count "..splitval)		
					end

					if escape > 99 then
						--DEFAULT_CHAT_FRAME:AddMessage("LazPig_Split: Loop stop") 
						return 
					else
						escape = escape + 1
					end	
				end
			end
			return
		
		elseif LPCONFIG.RIGHT and tradestatus and not IsShiftKeyDown() and not IsAltKeyDown() then
			if not LazyPig_ItemIsTradeable(ParentID,ItemID) then
				DEFAULT_CHAT_FRAME:AddMessage("LazyPig: Cannot attach item", 1, 0.5, 0);
				return
			end
			PickupContainerItem(ParentID,ItemID)
			local slot = TradeFrame_GetAvailableSlot()
			if slot then ClickTradeButton(slot) end
			if CursorHasItem() then
				ClearCursor()
			end
			return
			
		elseif LPCONFIG.RIGHT and GMailFrame and GMailFrame:IsVisible() and not CursorHasItem() then
			if not LazyPig_ItemIsTradeable(ParentID,ItemID) then
				DEFAULT_CHAT_FRAME:AddMessage("LazyPig: Cannot attach item", 1, 0.5, 0);
				return
			end
			local i
			local bag, item = ParentID,ItemID
			for i = 1, GMAIL_NUMITEMBUTTONS, 1 do
				if ( not getglobal("GMailButton" .. i).item ) then

					if ( GMail:ItemIsMailable(bag, item) ) then
						GMail:Print("GMail: Cannot attach item.", 1, 0.5, 0)
						return
					end
					PickupContainerItem(bag, item)
					--GMail.hooks["PickupContainerItem"].orig(bag, item)
					GMail:MailButton_OnClick(getglobal("GMailButton" .. i))
					GMail:UpdateItemButtons()
					return
				end
			end
		
		elseif LPCONFIG.RIGHT and CT_MailFrame and CT_MailFrame:IsVisible() and not IsShiftKeyDown() and not IsAltKeyDown() then
			if not LazyPig_ItemIsTradeable(ParentID,ItemID) then
				DEFAULT_CHAT_FRAME:AddMessage("LazyPig: Cannot attach item", 1, 0.5, 0);
				return
			end
			local bag, item = ParentID,ItemID
			if ( ( CT_Mail_GetItemFrame(bag, item) or ( CT_Mail_addItem and CT_Mail_addItem[1] == bag and CT_Mail_addItem[2] == item ) ) and not special ) then
				return;
			end
			if ( not CursorHasItem() ) then
				CT_MailFrame.bag = bag;
				CT_MailFrame.item = item;
			end
			if ( CT_MailFrame:IsVisible() and not CursorHasItem() ) then
				local i;
				for i = 1, CT_MAIL_NUMITEMBUTTONS, 1 do
					if ( not getglobal("CT_MailButton" .. i).item ) then

						local canMail = CT_Mail_ItemIsMailable(bag, item);
						if ( canMail ) then
							DEFAULT_CHAT_FRAME:AddMessage("<CTMod> Cannot attach item, item is " .. canMail, 1, 0.5, 0);
							return;
						end

						CT_oldPickupContainerItem(bag, item);
						CT_MailButton_OnClick(getglobal("CT_MailButton" .. i));
						CT_Mail_UpdateItemButtons();
						return;
					end
				end
			end
		elseif LPCONFIG.RIGHT and mailstatus and not IsShiftKeyDown() and not IsAltKeyDown() then
			if not LazyPig_ItemIsTradeable(ParentID,ItemID) then
				DEFAULT_CHAT_FRAME:AddMessage("LazyPig: Cannot attach item", 1, 0.5, 0);
				return
			end
			
			if InboxFrame and InboxFrame:IsVisible() then
				MailFrameTab_OnClick(2);
				return
			end
			if SendMailFrame and SendMailFrame:IsVisible() then
				PickupContainerItem(ParentID,ItemID)
				ClickSendMailItemButton()
				if CursorHasItem() then
					ClearCursor()
				end
				return
			end	
		elseif LPCONFIG.RIGHT and auctionstatus and not IsShiftKeyDown() and not IsAltKeyDown() then
			if not LazyPig_ItemIsTradeable(ParentID,ItemID) then
				DEFAULT_CHAT_FRAME:AddMessage("LazyPig: Cannot attach item", 1, 0.5, 0);
				return
			end
			if not AuctionFrameAuctions:IsVisible() then
				AuctionFrameTab3:Click()
				return
			end
			PickupContainerItem(ParentID,ItemID)
			ClickAuctionSellItemButton()
			if CursorHasItem() then
				ClearCursor()
			end
			return
		elseif LPCONFIG.RIGHT and auctionstatus and IsAltKeyDown() then
			if not LazyPig_ItemIsTradeable(ParentID,ItemID) then
				DEFAULT_CHAT_FRAME:AddMessage("LazyPig: Item is not tradeable", 1, 0.5, 0);
				return
			end
			if not AuctionFrameBrowse:IsVisible() then
				AuctionFrameTab1:Click()
				return
			end
			if LazyPig_AuctionSearch(GetContainerItemLink(ParentID,ItemID)) then 
				return 
			end
		end	
		OriginalUseContainerItem(ParentID,ItemID)
		
		
end

function LazyPig_AuctionSearch(link)
    if link and not strfind(link,"item:") then return end
    BrowseMinLevel:SetText('')
    BrowseMaxLevel:SetText('')
    UIDropDownMenu_SetText('',BrowseDropDown)
    UIDropDownMenu_SetSelectedName(BrowseDropDown)
    local name,il,ir,iml,class,sub
    if link then
      local i,j,name = strfind(link,"%[(.+)%]")
      BrowseName:SetText(name)
      BrowseName:HighlightText(0,-1)
      IsUsableCheckButton:SetChecked(false)
      local i,j,item = strfind(link,"(item:%d+:%d+:%d+:%d+)")
      name,il,ir,iml,class,sub = GetItemInfo(item)
    else
      BrowseName:SetText('')
      IsUsableCheckButton:SetChecked(true)
      class = 'Recipe'; sub = class
    end
    AuctionFrameBrowse.selectedClass = class
    for ix,name in CLASS_FILTERS do
      if name==class then
        AuctionFrameBrowse.selectedClassIndex = ix
        i = ix
        break
      end
    end
    if class~=sub then
      AuctionFrameBrowse.selectedSubclass = HIGHLIGHT_FONT_COLOR_CODE..sub..FONT_COLOR_CODE_CLOSE
      for ix,name in {GetAuctionItemSubClasses(i)} do
        if name==sub then
          AuctionFrameBrowse.selectedSubclassIndex = ix
          break
        end
      end
    else
      AuctionFrameBrowse.selectedSubclass = nil
      AuctionFrameBrowse.selectedSubclassIndex = nil
    end
    AuctionFrameBrowse.selectedInvtype = nil
    AuctionFrameBrowse.selectedInvtypeIndex = nil
    AuctionFrameFilters_Update()
    BrowseSearchButton:Click()
    return 1
end

function ScheduleItemSplit(sbag, sslot, dbag, dslot, count)
	if sbag and sslot and dbag and dslot and count then
		
		local number = nil
		
		for blockindex,blockmatch in pairs(ScheduleSplitCount) do
			if not number or number < blockindex then
				number = blockindex
			end
		end
		
		if not number then
			number = 1
		else
			number = number + 1
		end
		
		--DEFAULT_CHAT_FRAME:AddMessage("Task Count - "..number)
		
		ScheduleSplitCount[number] = true
		ScheduleSplit.sbag[number] = sbag
		ScheduleSplit.sslot[number] = sslot
		ScheduleSplit.dbag[number] = dbag
		ScheduleSplit.dslot[number] = dslot
		ScheduleSplit.count[number] = count
		
		ScheduleSplit.active = true
		
	elseif ScheduleSplit.active then
		
		local number = nil
		for blockindex,blockmatch in pairs(ScheduleSplitCount) do
			if not number or number > blockindex then
				number = blockindex
			end
		end
		
		if number then
			last_click = GetTime()
			local _, _, lock = GetContainerItemInfo(ScheduleSplit.dbag[number], ScheduleSplit.dslot[number])
			if not lock then
				
				--DEFAULT_CHAT_FRAME:AddMessage("Dest "..ScheduleSplit.dbag[number].." - "..ScheduleSplit.dslot[number].." From "..ScheduleSplit.sbag[number].." - "..ScheduleSplit.sslot[number].." - Count "..ScheduleSplit.count[number])
				
				SplitContainerItem(ScheduleSplit.sbag[number], ScheduleSplit.sslot[number], ScheduleSplit.count[number])
				PickupContainerItem(ScheduleSplit.dbag[number], ScheduleSplit.dslot[number])
				ScheduleSplitCount[number] = nil
			end
		else
			ScheduleSplit.active = nil
		end
	end
end

function LazyPig_CreateLink(name, count, rgb)
	rgb = rgb or WHITE
	if(name ~= nil) then
		local color = rgb..name.."|r"
		local hlink = "[|Hlazypig:"..count.."|h"..color.."|h]";
		return hlink
	end	
end

function LazyPig_SetItemRef_OnEvent(link, text, button)
	if link and string.find(link, "lazypig:") then
		--local count = string.gsub(link,"lazypig:","")
		LazyPig_Command()
	else
		Original_SetItemRef(link, text, button)
	end	
end

function LazyPig_RefreshNameplates()
	if LPCONFIG.EPLATE then
		ShowNameplates();
	elseif LPCONFIG.HPLATE then
		HideNameplates();
	end
	if LPCONFIG.FPLATE then
		ShowFriendNameplates();
	elseif LPCONFIG.HPLATE then
		HideFriendNameplates();
	end
end

function LazyPig_GetOption(num)
	local labelString = getglobal(this:GetName().."Text");
	local label = LazyPigMenuStrings[num] or "";
	LazyPigMenuObjects[num] = this

	if num == 00 and LPCONFIG.GREEN == 1
	or num == 01 and LPCONFIG.GREEN == 2 
	or num == 02 and LPCONFIG.GREEN == 0 
	or num == 10 and LPCONFIG.ZG == 1		
	or num == 11 and LPCONFIG.ZG == 2
	or num == 12 and LPCONFIG.ZG == 0
	or num == 20 and LPCONFIG.WORLDDUNGEON
	or num == 21 and LPCONFIG.WORLDRAID
	or num == 22 and LPCONFIG.WORLDBG
	or num == 23 and LPCONFIG.WORLDUNCHECK
	or num == 30 and LPCONFIG.GINV
	or num == 31 and LPCONFIG.FINV
	or num == 32 and LPCONFIG.SINV
	or num == 33 and LPCONFIG.DINV
	or num == 40 and LPCONFIG.FPLATE
	or num == 41 and LPCONFIG.EPLATE
	or num == 42 and LPCONFIG.HPLATE 
	or num == 50 and LPCONFIG.EBG
	or num == 51 and LPCONFIG.LBG
	or num == 52 and LPCONFIG.QBG
	or num == 53 and LPCONFIG.RBG
	or num == 54 and LPCONFIG.AQUE
	or num == 55 and LPCONFIG.SBG
	
	or num == 60 and LPCONFIG.SALVA == 1
	or num == 61 and LPCONFIG.SALVA == 2
	or num == 90 and LPCONFIG.SUMM
	
	or num == 70 and LPCONFIG.SPAM
	or num == 71 and LPCONFIG.SPAM_UNCOMMON
	or num == 72 and LPCONFIG.SPAM_RARE
	or num == 73 and LPCONFIG.SPAM_LOOT
	
	or num == 91 and LPCONFIG.LOOT
	or num == 92 and LPCONFIG.RIGHT
	or num == 93 and LPCONFIG.SHIFTSPLIT
	or num == 94 and LPCONFIG.CAM
	or num == 95 and LPCONFIG.SPECIALKEY
	or num == 96 and LPCONFIG.DUEL		
	or num == 97 and LPCONFIG.REZ
	or num == 98 and LPCONFIG.GOSSIP
	or num == 99 and LPCONFIG.NOSAVE ~= GetRealmName()
	or num == 100 and LPCONFIG.DISMOUNT
	or num == 101 and LPCONFIG.SPAM
	
	or nil then
		this:SetChecked(true);
	else
		this:SetChecked(nil);
	end
	labelString:SetText(label);
end

function LazyPig_SetOption(num)
	local checked = this:GetChecked()
	if num == 00 then 
		LPCONFIG.GREEN = 1
		if not checked then LPCONFIG.GREEN = nil end
		LazyPigMenuObjects[01]:SetChecked(nil)
		LazyPigMenuObjects[02]:SetChecked(nil)
	elseif num == 01 then 
		LPCONFIG.GREEN = 2
		if not checked then LPCONFIG.GREEN = nil end
		LazyPigMenuObjects[00]:SetChecked(nil)
		LazyPigMenuObjects[02]:SetChecked(nil)
	elseif num == 02 then
		LPCONFIG.GREEN = 0
		if not checked then LPCONFIG.GREEN = nil end
		LazyPigMenuObjects[00]:SetChecked(nil)
		LazyPigMenuObjects[01]:SetChecked(nil)
	elseif num == 10 then 
		LPCONFIG.ZG = 1
		if not checked then LPCONFIG.ZG = nil end
		LazyPigMenuObjects[11]:SetChecked(nil)
		LazyPigMenuObjects[12]:SetChecked(nil)
	elseif num == 11 then 
		LPCONFIG.ZG= 2
		if not checked then LPCONFIG.ZG = nil end
		LazyPigMenuObjects[10]:SetChecked(nil)
		LazyPigMenuObjects[12]:SetChecked(nil)
	elseif num == 12 then 
		LPCONFIG.ZG = 0 
		if not checked then LPCONFIG.ZG = nil end
		LazyPigMenuObjects[10]:SetChecked(nil)
		LazyPigMenuObjects[11]:SetChecked(nil)
	elseif num == 20 then															
		LPCONFIG.WORLDDUNGEON = true					--fixed
		if not checked then LPCONFIG.WORLDDUNGEON = nil end
		if LPCONFIG.WORLDDUNGEON or LPCONFIG.WORLDRAID or LPCONFIG.WORLDBG then 
			LPCONFIG.WORLDUNCHECK = nil
			LazyPigMenuObjects[23]:SetChecked(nil)
		end
		LazyPig_ZoneCheck()
	elseif num == 21 then 
		LPCONFIG.WORLDRAID = true
		if not checked then LPCONFIG.WORLDRAID = nil end
		if LPCONFIG.WORLDDUNGEON or LPCONFIG.WORLDRAID or LPCONFIG.WORLDBG then 
			LPCONFIG.WORLDUNCHECK = nil
			LazyPigMenuObjects[23]:SetChecked(nil)
		end
		LazyPig_ZoneCheck()
	elseif num == 22 then 
		LPCONFIG.WORLDBG = true
		if not checked then LPCONFIG.WORLDBG = nil end
		if LPCONFIG.WORLDDUNGEON or LPCONFIG.WORLDRAID or LPCONFIG.WORLDBG then 
			LPCONFIG.WORLDUNCHECK = nil
			LazyPigMenuObjects[23]:SetChecked(nil)
		end
		LazyPig_ZoneCheck()
	elseif num == 23 then 
		LPCONFIG.WORLDUNCHECK = true
		if not checked then 
			LPCONFIG.WORLDUNCHECK = nil
		else	
			LPCONFIG.WORLDDUNGEON = nil
			LPCONFIG.WORLDRAID = nil
			LPCONFIG.WORLDBG = nil
			LazyPigMenuObjects[20]:SetChecked(nil)
			LazyPigMenuObjects[21]:SetChecked(nil)
			LazyPigMenuObjects[22]:SetChecked(nil)
		end
		LazyPig_ZoneCheck()
	elseif num == 30 then 								--fixed
		LPCONFIG.GINV = true
		if not checked then LPCONFIG.GINV = nil end
	elseif num == 31 then 
		LPCONFIG.FINV = true
		if not checked then LPCONFIG.FINV = nil end
	elseif num == 32 then 
		LPCONFIG.SINV = true
		if not checked then LPCONFIG.SINV = nil end
	elseif num == 33 then 
		LPCONFIG.DINV = true
		if not checked then LPCONFIG.DINV = nil end	
	elseif num == 40 then 								--fixed
		LPCONFIG.FPLATE = true
		if not checked then LPCONFIG.FPLATE = nil end
		if LPCONFIG.EPLATE and LPCONFIG.FPLATE then 
			LPCONFIG.HPLATE = nil 
			LazyPigMenuObjects[42]:SetChecked(nil)
		end
		LazyPig_RefreshNameplates()
	elseif num == 41 then 
		LPCONFIG.EPLATE = true
		if not checked then LPCONFIG.EPLATE = nil end
		if LPCONFIG.EPLATE and LPCONFIG.FPLATE then 
			LPCONFIG.HPLATE = nil 
			LazyPigMenuObjects[42]:SetChecked(nil)
		end
		LazyPig_RefreshNameplates()
	elseif num == 42 then 
		LPCONFIG.HPLATE = true
		if not checked then 
			LPCONFIG.HPLATE = nil 
		end
		if LPCONFIG.EPLATE and LPCONFIG.FPLATE then 
			LPCONFIG.HPLATE = nil 
			LazyPigMenuObjects[42]:SetChecked(nil)
		end
		LazyPig_RefreshNameplates()	
	elseif num == 50 then --fixed
		LPCONFIG.EBG = true
		if not checked then LPCONFIG.EBG = nil end
	elseif num == 51 then 
		LPCONFIG.LBG = true
		if not checked then LPCONFIG.LBG = nil end
	elseif num == 52 then 
		LPCONFIG.QBG = true
		if not checked then LPCONFIG.QBG = nil end
	elseif num == 53 then 
		LPCONFIG.RBG = true
		if not checked then LPCONFIG.RBG = nil end
	elseif num == 54 then 
		LPCONFIG.AQUE = true
		if not checked then LPCONFIG.AQUE = nil end		
	elseif num == 55 then
		LPCONFIG.SBG  = true
		if not checked then LPCONFIG.SBG  = nil end	
	elseif num == 60 then
		LPCONFIG.SALVA = 1
		if not checked then LPCONFIG.SALVA = nil end
		LazyPigMenuObjects[61]:SetChecked(nil)
		LazyPig_CheckSalvation()
	elseif num == 61 then 
		LPCONFIG.SALVA = 2
		if not checked then LPCONFIG.SALVA = nil end
		LazyPigMenuObjects[60]:SetChecked(nil)
		LazyPig_CheckSalvation()

	elseif num == 70 then --fixed
		LPCONFIG.SPAM = true
		if not checked then LPCONFIG.SPAM = nil end
	elseif num == 71 then 
		LPCONFIG.SPAM_UNCOMMON = true
		if not checked then LPCONFIG.SPAM_UNCOMMON = nil end
	elseif num == 72 then 
		LPCONFIG.SPAM_RARE	 = true
		if not checked then LPCONFIG.SPAM_RARE	 = nil end	
	elseif num == 73 then 
		LPCONFIG.SPAM_LOOT	 = true
		if not checked then LPCONFIG.SPAM_LOOT	 = nil end		
		
	elseif num == 90 then
		LPCONFIG.SUMM = true
		if not checked then LPCONFIG.SUMM = nil end	
	elseif num == 91 then 
		LPCONFIG.LOOT = true
		if not checked then LPCONFIG.LOOT = nil end
	elseif num == 92 then 
		LPCONFIG.RIGHT = true
		if not checked then LPCONFIG.RIGHT = nil end
		MailtoCheck(LPCONFIG.RIGHT)
	elseif num == 93 then--fixed
		LPCONFIG.SHIFTSPLIT = true
		if not checked then LPCONFIG.SHIFTSPLIT = nil end
		MailtoCheck(LPCONFIG.SHIFTSPLIT)
	elseif num == 94 then--fixed 
		LPCONFIG.CAM = true
		if not checked then LPCONFIG.CAM = nil end
		if LPCONFIG.CAM then SetCVar("cameraDistanceMax",50) else SetCVar("cameraDistanceMaxFactor",1) SetCVar("cameraDistanceMax",15) end	
	elseif num == 95 then 
		LPCONFIG.SPECIALKEY = true
		if not checked then LPCONFIG.SPECIALKEY = nil end	
	elseif num == 96 then
		LPCONFIG.DUEL = true
		if not checked then LPCONFIG.DUEL = nil end
		if LPCONFIG.DUEL then CancelDuel() end
	elseif num == 97 then
		LPCONFIG.REZ = true
		if not checked then LPCONFIG.REZ = nil end	
	elseif num == 98 then
		LPCONFIG.GOSSIP = true
		if not checked then LPCONFIG.GOSSIP = nil end
	elseif num == 99 then
		LPCONFIG.NOSAVE = true
		if not checked then LPCONFIG.NOSAVE = GetRealmName() end
	elseif num == 100 then
		LPCONFIG.DISMOUNT = true
		if not checked then LPCONFIG.DISMOUNT = nil end	
	elseif num == 101 then
		LPCONFIG.SPAM  = true
		if not checked then LPCONFIG.SPAM  = nil end			
		
	else
		--DEFAULT_CHAT_FRAME:AddMessage("DEBUG: No num assigned - "..num)
	end
	--DEFAULT_CHAT_FRAME:AddMessage("DEBUG: Num chosen - "..num)
end

function LazyPig_RollLootOpen()
	for i=1,STATICPOPUP_NUMDIALOGS do
		local frame = getglobal("StaticPopup"..i)
		if frame:IsShown() and frame.which == "CONFIRM_LOOT_ROLL" then
			--DEFAULT_CHAT_FRAME:AddMessage("LazyPig_RollLootOpen - TRUE")
			return true
		end
	end
	return nil
end

function LazyPig_BindLootOpen()
	for i=1,STATICPOPUP_NUMDIALOGS do
		local frame = getglobal("StaticPopup"..i)
		if frame:IsShown() and frame.which == "LOOT_BIND" then
			--DEFAULT_CHAT_FRAME:AddMessage("LazyPig_BindLootOpen - TRUE")
			return true
		end
	end
	return nil
end

function LazyPig_ZoneCheck2()
	LazyPig_ZoneCheck()
end

function LazyPig_ZoneCheck()
	local process = function(ChatFrame, name)  
		for index, value in ChatFrame.channelList do
			if (strupper(name) == strupper(value)) then
				return true
			end
		end
		return nil
	end
	
	local leavechat = LPCONFIG.WORLDRAID and LazyPig_Raid() or LPCONFIG.WORLDDUNGEON and LazyPig_Dungeon() or LPCONFIG.WORLDBG and LazyPig_BG() or LPCONFIG.WORLDUNCHECK
	for i = 1, NUM_CHAT_WINDOWS do	
		local ChatFrame = getglobal("ChatFrame"..i)	
		if ChatFrame:IsVisible() and not UnitIsDeadOrGhost("player") then
			local id, name = GetChannelName("world")
			if id > 0 then	
				if leavechat then			
					if process(ChatFrame, name)  then
						ChatFrame_RemoveChannel(ChatFrame, name)
						channelstatus = true
						UIErrorsFrame:Clear();
						UIErrorsFrame:AddMessage("Leaving World")
					end
					return
				end	
			end					
			if (LPCONFIG.WORLDRAID or LPCONFIG.WORLDDUNGEON or LPCONFIG.WORLDBG) and not leavechat then						
				local framename = ChatFrame:GetName()
				if id == 0 then
					UIErrorsFrame:Clear();
					UIErrorsFrame:AddMessage("Joining World");
					JoinChannelByName("world", nil, ChatFrame:GetID());
				else
					if (not process(ChatFrame, name) or channelstatus) and framename == "ChatFrame1" then
						ChatFrame_AddChannel(ChatFrame, name);
						UIErrorsFrame:Clear();
						UIErrorsFrame:AddMessage("Joining World");
						channelstatus = false
					end
				end	
			end
		end
	end	
end

function LazyPig_PlayerClass(class, unit)
	if class then
		local unit = unit or "player"
		local _, c = UnitClass(unit)
		if c then
			if string.lower(c) == string.lower(class) then
				return true
			end
		end
	end
	return false
end

function LazyPig_IsBearForm()
	local i;
	local max = GetNumShapeshiftForms();
	for i = 1 , max do
		local _, name, isActive = GetShapeshiftFormInfo(i);
		if(isActive and LazyPig_PlayerClass("Druid", "player") and (name == "Bear Form" or name == "Dire Bear Form")) then
			return true
		end
	end
	return false
end

function LazyPig_IsShieldEquipped()
	local slot = GetInventorySlotInfo("SecondaryHandSlot")
	local link = GetInventoryItemLink("player", slot)
	if link  then
		local found, _, id, name = string.find(link, "item:(%d+):.*%[(.*)%]")
		if found then
			local _,_,_,_,_,itemType = GetItemInfo(tonumber(id))
			if(itemType == "Shields") then
				return true
			end
		end
	end
	return false
end

function LazyPig_CancelSalvationBuff()
	local buff = {"Spell_Holy_SealOfSalvation", "Spell_Holy_GreaterBlessingofSalvation"}
	local counter = 0
	while GetPlayerBuff(counter) >= 0 do
		local index, untilCancelled = GetPlayerBuff(counter)
		if untilCancelled ~= 1 then
			local i =1
			while buff[i] do
				if string.find(GetPlayerBuffTexture(index), buff[i]) then
					CancelPlayerBuff(index);
					UIErrorsFrame:Clear();
					UIErrorsFrame:AddMessage("Salvation Removed");
					return
				end
				i = i + 1
			end	
		end
		counter = counter + 1
	end
	return nil
end

function LazyPig_CheckSalvation()
	if(LPCONFIG.SALVA == 1 or LPCONFIG.SALVA == 2 and (LazyPig_IsShieldEquipped() and LazyPig_PlayerClass("Warrior", "player") or LazyPig_IsBearForm())) then
		LazyPig_CancelSalvationBuff()
	end
end

function LazyPig_ShowBindings(bind, fs, desc)
	local bind1, bind2 = GetBindingKey(bind)
	local fsl = getglobal(fs)

	local printout = nil
	if bind1 and bind2 then
		printout = "[" .. bind1 .. "/" .. bind2 .. "]"
	elseif bind1 then
		printout = "[" .. bind1 .. "]"
	elseif bind2 then
		printout = "[" .. bind2 .. "]"
	elseif desc then
		printout = "[" .. desc .. "]"
	else
		printout = "none"
		fsl:SetTextColor(1,1,1,1) 
	end
	fsl:SetText(printout)
end

function LazyPig_ChatFrame_OnEvent(event)
	if event == "CHAT_MSG_LOOT" or event == "CHAT_MSG_MONEY" then
		local bijou = string.find(arg1 ,"Bijou")
		local coin = string.find(arg1 ,"Coin")
		
		local green_roll = greenrolltime > GetTime()
		local check_uncommon = LPCONFIG.SPAM_UNCOMMON and string.find(arg1 ,"1eff00")
		local check_rare = LPCONFIG.SPAM_RARE and string.find(arg1 ,"0070dd")
		local check_loot = LPCONFIG.SPAM_LOOT and (string.find(arg1 ,"9d9d9d") or string.find(arg1 ,"ffffff") or string.find(arg1 ,"Your share of the loot"))
		local check_money = LPCONFIG.SPAM_LOOT and string.find(arg1 ,"Your share of the loot")
	
		local check1 = string.find(arg1 ,"You")
		local check2 = string.find(arg1 ,"won") or string.find(arg1 ,"receive")
		local check3 = LPCONFIG.ZG and (bijou or coin)
		local check4 = check1 and not check3 and not green_roll or check2 

		if not check4 and (check_uncommon or check_rare) or check_loot and not check1 or check_money then
			return
		end	
	end
	
	if LPCONFIG.SPAM and arg2 and arg2 ~= GetUnitName("player") and (event == "CHAT_MSG_SAY" or event == "CHAT_MSG_CHANNEL" or event == "CHAT_MSG_YELL" or event == "CHAT_MSG_EMOTE" and not (IsGuildMate(arg2) or IsFriend(arg2))) then
		local time = GetTime()
		local index = ChatMessage["INDEX"]
			
		for blockindex,blockmatch in pairs(ChatMessage[index]) do
			local findmatch1 = (blockmatch + 70) > time --70s delay
			local findmatch2 = blockindex == arg1 
			if findmatch1 and findmatch2 then 
				return
			end
		end
		ChatMessage[index][arg1] = time		
	end
	
	Original_ChatFrame_OnEvent(event);
end

function ChatSpamClean()
	local time = GetTime()
	local index = ChatMessage["INDEX"]
	local newindex = nil
		
	if index == 1 then
		newindex = 2
	else
		newindex = 1
	end
	
	for blockindex,blockmatch in pairs(ChatMessage[index]) do	
		if (blockmatch + 70) > time then
			ChatMessage[newindex][blockindex] = ChatMessage[index][blockindex]
		end
	end
	ChatMessage[index] = {}
	ChatMessage["INDEX"] = newindex
	
	--DEFAULT_CHAT_FRAME:AddMessage("ChatSpamClean")
end

function LazyPig_Track_EFC(msg)
	if msg then
		msg = strlower(msg)
		
		local find0 = "captured "
		local find1 = "The "..UnitFactionGroup("player").." Flag"
		local find2 = " was picked up "
		local find3 = " was dropped "
		
		if string.find(msg, strlower(find1..find2)) then
			_, _, wsgefc = string.find(msg, strlower(find1..find2.."by (.+)%!"))
			--DEFAULT_CHAT_FRAME:AddMessage("ADD EFC - "..wsgefc)
		elseif string.find(msg, strlower(find1..find3)) or string.find(msg, strlower(find0..find1)) then
			wsgefc = nil
			--DEFAULT_CHAT_FRAME:AddMessage("DEL EFC")
		end
	end
end

function LazyPig_Target_EFC()
	ClearTarget()
	if wsgefc then
		TargetByName(wsgefc, true) 
		UIErrorsFrame:Clear()
		if not UnitExists("target") then 
			UIErrorsFrame:AddMessage("OUT OF RANGE - EFC - "..strupper(wsgefc)) 
		elseif strlower(GetUnitName("target")) == wsgefc then
			local class, classFileName = UnitClass("target")
			local color = RAID_CLASS_COLORS[classFileName]
			UIErrorsFrame:AddMessage(strupper(class.." - EFC - "..wsgefc), color.r, color.g, color.b) 
		end
	end	
end

function LazyPig_Duel_EFC()
	if GetRealZoneText() == "Warsong Gulch" then
		LazyPig_Target_EFC()
	else
		local duel = nil
		for i=1,STATICPOPUP_NUMDIALOGS do
			local frame = getglobal("StaticPopup"..i)
			if frame:IsShown() then
				if frame.which == "DUEL_REQUESTED" then
					duel = true
				end
			end
		end
		if duel_active or duel then
			CancelDuel()
		elseif UnitExists("target") and UnitIsFriend("target", "player") then 
			StartDuel(GetUnitName("target")) 
		end
	end	
end


function aaa()
PlayerFrame:Hide()


end