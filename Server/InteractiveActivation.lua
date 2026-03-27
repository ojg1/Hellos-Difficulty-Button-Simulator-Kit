local CollectionService = game:GetService("CollectionService")
local RS = game.ReplicatedStorage
local AlyaNum = require(RS.Dependencies.NumberSystems.AlyaNum)
local aN = require(RS.Dependencies.NumberSystems.AlyaNum)

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
		
		local Co : string = aN.toSuffix(aN.fromString(C.Cost.Value))
		local Re : string = aN.toSuffix(aN.fromString(C.Return.Value))
		
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
					
					for boost, value in ipairs(Boosts) do
						local KitStatValue = aN.fromString(PlayerStats[boost])
						local init = aN.mul(aN.fromString(value), aN.fromString(KitStatValue))
						init = aN.add(init, aN.fromString("1e0"))
						addValue = aN.mul(init, addValue)
					end
					
					--add stat
					PlayerStats[RetuTag].Value = aN.toString(aN.add(addValue, aN.fromString(PlayerStats[RetuTag].Value)))
	
					if Attributes.SubFromCStat then
						PlayerStats[CostTag].Value = aN.toString(aN.sub(aN.fromString(PlayerStats[CostTag].Value), aN.fromString(C.Cost.Value)))		
					end
					
					for _,Stat in pairs(Attributes.Reset) do
						if Stat == "Multi" then PlayerStats["Multi"].Value = aN.fromString("1e0") return end
						PlayerStats[Stat].Value = aN.fromString("0e0")
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