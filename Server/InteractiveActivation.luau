local CollectionService = game:GetService("CollectionService")
local RS = game.ReplicatedStorage
local AlyaNum = require(RS.Dependencies.NumberSystems.AlyaNum)
local aN = require(RS.Dependencies.NumberSystems.AlyaNum)
local KH = require(RS.Dependencies.KitHelper)

type baseAttributes = {
	Reset : {},
	SubFromCStat: boolean,
	BillboardFormat: string | "Cost CostTag = Return RetuTag"
}

local function constructStat(Tag : string, CostTag : string, RetuTag : string, Boosts : {}, Attributes : baseAttributes)
	for _, Active : BasePart in pairs(CollectionService:GetTagged(Tag)) do
		local C : Configuration = Active:WaitForChild("Configuration")
		local B : BillboardGui = Active:WaitForChild("BillboardGui")

		--Billboard Configuration

		local Co : string = KH:CorrectNan(aN.toSuffix(aN.fromString(C.Cost.Value)))
		local Re : string = KH:CorrectNan(aN.toSuffix(aN.fromString(C.Return.Value)))

		local CostTagSub = string.gsub(Attributes.BillboardFormat, "CostTag", CostTag)

		local RetuTagSub = string.gsub(CostTagSub, "RetuTag", RetuTag)
		local CostSub = string.gsub(RetuTagSub, "Cost", Co)
		local Final = string.gsub(CostSub, "Return", Re)

		B.Exchange.Text = Final

		Active.Touched:Connect(function(hit)



			if hit.Parent:FindFirstChild("Humanoid") then


				local Player = game.Players:GetPlayerFromCharacter(hit.Parent)
				local PlayerStats = Player:WaitForChild("KitStats")


				--'p' player
				local pCTag = aN.fromString(PlayerStats[CostTag].Value)
				local pRTag = aN.fromString(PlayerStats[RetuTag].Value)

				if aN.moreEquals(pCTag, aN.fromString(C.Cost.Value)) then

					local addValue = aN.fromString(C.Return.Value)


					for boost, value in pairs(Boosts) do
						local KitStatValue = aN.fromString(PlayerStats[boost].Value)
						local init = aN.mul(aN.fromString(value), KitStatValue)
						init = aN.add(init, aN.fromString("1e0"))

						addValue = aN.mul(init, addValue)
					end

					--add stat
					PlayerStats[RetuTag].Value = aN.toString(aN.add(addValue, aN.fromString(PlayerStats[RetuTag].Value)))

					if Attributes.SubFromCStat then
						PlayerStats[CostTag].Value = aN.toString(aN.sub(aN.fromString(PlayerStats[CostTag].Value), aN.fromString(C.Cost.Value)))		
					end

					
					print(Attributes.Reset)
					for _,Stat in pairs(Attributes.Reset) do
						if Stat == "Multi" then PlayerStats["Multi"].Value = "1e0" continue end
						PlayerStats[Stat].Value = "0e0"
					end

				end

			end
		end)
	end
end

-- v0.1

--[[

orb hierarchy and expected children

Orb 
--BillboardGui
--Configuration
--[--Cost
--[--Return


not req children (kit hypothetical)
--BoostOnly
--[--KitStat and TagHandler oriented name ... etc


buttonRender() para

Tag: orb name
Boosts: boosts please use TagName accordingly with KitStats v;"[STAT]":EN


]]

local RegTable = {
	Tag = "Buttons",
	Boosts = {
		["Rebirth"] = "1e0"
	},
	CostTag = "Money",
	RetuTag = "Multi",
	Attributes = {
		Reset = {},
		SubFromCTag = true,
		BillboardFormat = "$Cost = xReturn"
	}
}

--warning(argument #1 expects a string, but table was passed)
--constructStat{Tag=RegTable.Tag, CostTag=RegTable.CostTag, RetuTag=RegTable.RetuTag, Boosts=RegTable.Boosts, Attributes=RegTable.Attributes}
constructStat(RegTable.Tag, RegTable.CostTag, RegTable.RetuTag, RegTable.Boosts, RegTable.Attributes)

local RebirthTable = {
	Tag = "Rebirth",
	Boosts = {
		["UltraRebirth"] = "3e0"
	},
	CostTag = "Multi",
	RetuTag = "Rebirth",
	Attributes = {
		Reset = {"Money","Multi"},
		SubFromCTag = false,
		BillboardFormat = "Cost CostTag = Return RetuTag"
	}
}

constructStat(RebirthTable.Tag, RebirthTable.CostTag, RebirthTable.RetuTag, RebirthTable.Boosts, RebirthTable.Attributes)

local UltraRebirthTable = {
	Tag = "UltraRebirth",
	Boosts = {
		["Prestige"] = "2e0"
	},
	CostTag = "Rebirth",
	RetuTag = "UltraRebirth",
	Attributes = {
		Reset = {"Money","Multi","Rebirth"},
		SubFromCTag = false,
		BillboardFormat = "Cost CostTag = Return RetuTag"
	}
}

constructStat(UltraRebirthTable.Tag, UltraRebirthTable.CostTag, UltraRebirthTable.RetuTag, UltraRebirthTable.Boosts, UltraRebirthTable.Attributes)

