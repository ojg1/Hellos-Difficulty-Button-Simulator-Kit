
--Services
local ReplicatedStorage = game.ReplicatedStorage
local Dependencies = ReplicatedStorage.Dependencies
local DataStoreService = game:GetService("DataStoreService")


--dependencies
local aN = require(Dependencies.NumberSystems.AlyaNum) --Dependencies/NumberSystems/AlyaNum
local ld = require(Dependencies.LibDeflate) --might not be nessecary
local DBSHelper = require(Dependencies.KitHelper) --Dependencies/KitHelper
local DBSConfig = require(Dependencies.Configuration) --Dependencies/Configuration

--DataStore and helper fucntionsd

local DBSData = DataStoreService:GetDataStore("DBSData")

-- local function SaveDataLBEncode(Player : Player)
-- 	local DataString = ""
-- 	local PlayerKitStats = Player:WaitForChild("KitStats")
	
-- 	for _,Stat in pairs(PlayerKitStats:GetChildren()) do
-- 		DataString = DataString..Stat.Name..":"..tostring(aN.lbencode(aN.fromString(Stat.Value))).."|"
-- 	end
	
-- 	local Success, ErrorMessage = pcall(function()
-- 		DBSData:SetAsync(Player.UserId, DataString)
-- 	end)
	
-- 	if Success then
-- 		return 
-- 	else
-- 		print("Failed to save data for userId:"..tostring(Player.UserId).."| userName:"..Player.Name)
-- 		warn(ErrorMessage)
-- 	end
-- end

-- local function SaveData(Player : Player)
-- 	local DataString = ""
-- 	local PlayerKitStats = Player:WaitForChild("KitStats")
	
-- 	for _,Stat in pairs(PlayerKitStats:GetChildren()) do
-- 		DataString = DataString..Stat.Name..":"..Stat.Value.."|"
-- 	end
	
-- 	local Success, ErrorMessage = pcall(function()
-- 		DBSData:SetAsync(Player.UserId, DataString)
-- 	end)

-- 	if Success then
-- 		return
-- 	else
-- 		print("Failed to save data for userId:"..tostring(Player.UserId).."| userName:"..Player.Name)
-- 		warn(ErrorMessage)
-- 	end
-- end

-- local function LoadDataLBDecode(Player : Player, DataString : string)

-- 	--redefine KitStats
-- 	local KitStats = Player:WaitForChild("KitStats")
-- 	local StatList = string.split(DataString, "|")

-- 	for _, LBValue in pairs(StatList) do
-- 		local Divide = string.split(LBValue, ":")
-- 		local StatChild = KitStats:FindFirstChild(Divide[1])
			
-- 		if StatChild then
-- 			StatChild.Value = aN.toString(aN.lbencode(tonumber(Divide[2])))
-- 		end
			
-- 		-- KitStats:FindFirstChild(Divide[1]).Value = aN.toString(aN.lbdecode(Divide[2]))
-- 		--List[Divide[1]] = aN.lbdecode(Divide[2])
-- 	end

-- end

-- local function LoadData(Player : Player, DataString : string)
	
-- 	--redefine KitStats
-- 	local KitStats = Player:WaitForChild("KitStats")
-- 	local StatList = string.split(DataString, "|")

-- 	for _, LBValue in pairs(StatList) do
-- 		local Divide = string.split(LBValue, ":")
-- 		local StatChild = KitStats:FindFirstChild(Divide[1])
			
-- 		if StatChild then
-- 			StatChild.Value = aN.toString(Divide[2])
-- 		end
			
-- 		-- KitStats:FindFirstChild(Divide[1]).Value = aN.toString(aN.lbdecode(Divide[2]))
-- 		--List[Divide[1]] = aN.lbdecode(Divide[2])
-- 	end
-- end

game:BindToClose(function()
	if DBSConfig.UseLeaderboardEncryption then
		for _,Player in pairs(game.Players:GetPlayers()) do
			task.spawn(DBSHelper:SaveDataLBEncode(), Player)
		end		
	else
		for _,Player in pairs(game.Players:GetPlayers()) do
			task.sapwn(DBSHelper:SaveData(), Player)
		end
	end

end)


--PlayerRemoving and PlayerAdded

game.Players.PlayerAdded:Connect(function(Player : Player)
	
	local PlayerCharacter = Player.Character or Player.CharacterAdded:Wait()
	
	local StatGui = ReplicatedStorage.StatGUI:Clone()
	StatGui.Parent = PlayerCharacter:WaitForChild("Head")
	
	local KitStats = ReplicatedStorage.KitStats:Clone()
	KitStats.Parent = Player
	
	local RSkill = aN.fromString("0e0")
	local leaderstats = Instance.new("Folder")
	leaderstats.Parent = Player
	
	local LSkill = Instance.new("StringValue")
	LSkill.Parent = leaderstats
	
	local Data : string = ""
	
	local Success, ErrorMessage = pcall(function()
		Data = DBSData:GetAsync(Player.UserId)
	end)

	if Success and Data then
		if DBSConfig.UseLeaderboardEncryption then
			DBSHelper:LoadDataLBDecode()
		else
			DBSHelper:LoadData()
		end
		
	else
		print("No data found for userId and userName: "..Player.UserId.." "..Player.Name)
	end

	--main loop
	while task.wait(DBSConfig.MainIncrLoopTickRate) do
		local RSkill = aN.mul(aN.fromString("2e0"), 
			aN.log10(aN.fromString(KitStats.Money.Value)))
		LSkill.Value = aN.toSuffix(RSkill)
		
		KitStats.Money.Value = aN.toString(aN.add(aN.fromString(KitStats.Money.Value), aN.fromString(KitStats.Multi.Value)))
	end

end)

game.Players.PlayerRemoving:Connect(function(Player)
	if DBSConfig.UseLeaderboardEncryption then
		DBSHelper:SaveDataLBEncode(Player)
	else
		DBSHelper:SaveData(Player)
	end
end)