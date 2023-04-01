_G.GTVERSION = 0.6;
local Craft={
	["WoodRE"]=0,["MineRE"]=0,["HerbRE"]=0,
	["WoodL"]=0,["MineL"]=0,["HerbL"]=0,
};
local WoodOld = GetPlayerCurrentSkillValue("LUMBERING");
local MineOld = GetPlayerCurrentSkillValue("MINING");
local HerbOld = GetPlayerCurrentSkillValue("HERBLISM");
local MatCount = {};
local MatItem = {
	TEXT("Sys200293_name"), --Ash Wood
	TEXT("Sys200508_name"), --Chime Wood
	TEXT("Sys200295_name"), --Willow Wood
	TEXT("Sys200509_name"), --Stone Rotan Wood
	TEXT("Sys200297_name"), --Maple Wood
	TEXT("Sys200300_name"), --Oak Wood
	TEXT("Sys200326_name"), --Redwood
	TEXT("Sys200304_name"), --Pine Wood
	TEXT("Sys200332_name"), --Dragon Beard Root Wood
	TEXT("Sys200298_name"), --Holly Wood
	TEXT("Sys200306_name"), --Yew Wood
	TEXT("Sys200331_name"), --Sagewood
	TEXT("Sys200307_name"), --Tarslin Demon Wood
	TEXT("Sys200310_name"), --Dragonlair Wood
	TEXT("Sys202317_name"), --Fairywood
	TEXT("Sys200312_name"), --Ancient Spirit Oak Wood
	TEXT("Sys202318_name"), --Aeontree Wood
	TEXT("Sys208240_name"), --Fastan Banyan
	TEXT("Sys240323_name"), --Janost Cypress Wood

	TEXT("Sys200335_name"), --Mountain Demon Grass
	TEXT("Sys202552_name"), --Rosemary
	TEXT("Sys200334_name"), --Beetroot
	TEXT("Sys202553_name"), --Bison Grass
	TEXT("Sys200333_name"), --Bitterleaf
	TEXT("Sys200338_name"), --Moxa
	TEXT("Sys202554_name"), --Foloin Nut
	TEXT("Sys200343_name"), --Dusk Orchid
	TEXT("Sys202555_name"), --Green Thistle
	TEXT("Sys200342_name"), --Barsaleaf
	TEXT("Sys200345_name"), --Moon Orchid
	TEXT("Sys202556_name"), --Straw Mushroom
	TEXT("Sys200346_name"), --Sinners Palm
	TEXT("Sys200349_name"), --Dragon Mallow
	TEXT("Sys202557_name"), --Mirror Sedge
	TEXT("Sys200350_name"), --Thorn Apple
	TEXT("Sys202558_name"), --Goblin Grass
	TEXT("Sys208246_name"), --Verbena
	TEXT("Sys240329_name"), --Nocturnal Lantern Grass
	
	TEXT("Sys200230_name"), --Zinc Ore
	TEXT("Sys200507_name"), --Flame Dust
	TEXT("Sys200232_name"), --Tin Ore
	TEXT("Sys200506_name"), --Cyanide
	TEXT("Sys200234_name"), --Iron Ore
	TEXT("Sys200236_name"), --Copper Ore
	TEXT("Sys200249_name"), --Rock Crystal
	TEXT("Sys200238_name"), --Dark Crystal
	TEXT("Sys200269_name"), --Mysticite
	TEXT("Sys200239_name"), --Silver Ore
	TEXT("Sys200242_name"), --Wizard-Iron Ore
	TEXT("Sys200265_name"), --Mithril
	TEXT("Sys200244_name"), --Moon Silver Ore
	TEXT("Sys200264_name"), --Abyss-Mercury
	TEXT("Sys202315_name"), --Frost Crystal
	TEXT("Sys200268_name"), --Rune Obsidian Ore
	TEXT("Sys202316_name"), --Mica
	TEXT("Sys208234_name"), --Olivine
	TEXT("Sys240314_name"), --Purple Agate Crystal
};

function GatherTip_OnEvent(this,event)
	if event=="VARIABLES_LOADED" then
		this:RegisterEvent("PLAYER_LIFESKILL_CHANGED");
		this:RegisterEvent("PLAYER_BAG_CHANGED");
		if GatherTipSet["X"]==nil then
			GatherTipSet["X"] = 0; GatherTipSet["Y"] = 180;
		end
		this:ClearAllAnchors();
		this:SetAnchor("TOPRIGHT", "TOPRIGHT", "UIParent", GatherTipSet["X"], GatherTipSet["Y"]);
		SaveVariables("GatherTipSet");
		GatherTip_Print("|cff8DE668GatherTip %s|r loaded.", GTVERSION);
	end
	if event=="PLAYER_BAG_CHANGED" or event=="VARIABLES_LOADED" then
		for i, v in ipairs(MatItem) do
			MatCount[v] = 0;
		end
		for i, v in ipairs(MatItem) do
			MatCount[v] = MatCount[v] + GetCountInBagByName(v) + GetCountInBankByName(v);
		end
	end
	if event=="PLAYER_LIFESKILL_CHANGED" or event=="VARIABLES_LOADED" then
		-- xp=2.3 --> lv=2 --> xp%=(2.3-2)*100 --> left=3-2.3
		Craft["MineLV"] = math.floor(GetPlayerCurrentSkillValue("MINING"));
		Craft["WoodLV"] = math.floor(GetPlayerCurrentSkillValue("LUMBERING"));
		Craft["HerbLV"] = math.floor(GetPlayerCurrentSkillValue("HERBLISM"));
		Craft["MineXP"] = (GetPlayerCurrentSkillValue("MINING")-Craft["MineLV"])*100;
		Craft["WoodXP"] = (GetPlayerCurrentSkillValue("LUMBERING")-Craft["WoodLV"])*100;
		Craft["HerbXP"] = (GetPlayerCurrentSkillValue("HERBLISM")-Craft["HerbLV"])*100;
		local MNew = GetPlayerCurrentSkillValue("MINING");
		if MineOld<MNew then
			local Mleft = math.ceil(MNew) - MineOld;
			local Mlast = MNew - MineOld;
			Craft["MineRE"] = math.floor(Mleft / Mlast);
			Craft["MineL"] = Mlast*100;
			MineOld = MNew;
		end
		local WNew = GetPlayerCurrentSkillValue("LUMBERING");
		if WoodOld<WNew then
			local Wleft = math.ceil(WNew) - WoodOld;
			local Wlast = WNew - WoodOld;
			Craft["WoodRE"] = math.floor(Wleft / Wlast);
			Craft["WoodL"] = Wlast*100;
			WoodOld = WNew;
		end
		local HNew = GetPlayerCurrentSkillValue("HERBLISM");
		if HerbOld<HNew then
			local Hleft = math.ceil(HNew) - HerbOld;
			local Hlast = HNew - HerbOld;
			Craft["HerbRE"] = math.floor(Hleft / Hlast);
			Craft["HerbL"] = Hlast*100;
			HerbOld = HNew;
		end
	end
end

function GatherTip_OnEnter(this)
	GameTooltip:SetOwner(this,"ANCHOR_BOTTOMLEFT", 0, 0);
	GameTooltip:SetText("GatherTip");
	GameTooltip:AddDoubleLine("|cffFFE855"..LIFESKILL_MINE.."|r", string.format("Lv"..Craft["MineLV"].." / ".."%.2f%%", Craft["MineXP"]));
	GameTooltip:AddDoubleLine("|cffFFE855"..LIFESKILL_WOOD.."|r", string.format("Lv"..Craft["WoodLV"].." / ".."%.2f%%", Craft["WoodXP"]));
	GameTooltip:AddDoubleLine("|cffFFE855"..LIFESKILL_HERB.."|r", string.format("Lv"..Craft["HerbLV"].." / ".."%.2f%%", Craft["HerbXP"]));
	GameTooltip:AddSeparator();
	GameTooltip:AddDoubleLine(" ", "|cff8DE668".."Last / Repeat".."|r");
	GameTooltip:AddDoubleLine("|cffFFE855"..LIFESKILL_MINE.."|r", string.format("%.2f%%".." / "..Craft["MineRE"], Craft["MineL"]));
	GameTooltip:AddDoubleLine("|cffFFE855"..LIFESKILL_WOOD.."|r", string.format("%.2f%%".." / "..Craft["WoodRE"], Craft["WoodL"]));
	GameTooltip:AddDoubleLine("|cffFFE855"..LIFESKILL_HERB.."|r", string.format("%.2f%%".." / "..Craft["HerbRE"], Craft["HerbL"]));
	local add = false;
	for k,v in pairs(MatCount) do
		if MatCount[k]>0 then
			if add==false then
				GameTooltip:AddSeparator();
				GameTooltip:AddDoubleLine(" ", "|cff8DE668".."Count".."|r");
				add = true;
			end
			GameTooltip:AddDoubleLine("|cffFFE855"..k.."|r", v);
		end
	end
end

function GatherTip_MoveEnd(this)
	this:StopMovingOrSizing();
	_, _, _, GatherTipSet["X"], GatherTipSet["Y"] = this:GetAnchor();
end

function GatherTip_Print(str, ...)
	DEFAULT_CHAT_FRAME:AddMessage(str:format(...), 1, 1, 1);
end