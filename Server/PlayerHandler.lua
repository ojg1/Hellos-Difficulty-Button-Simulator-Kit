
--Services
local ReplicatedStorage = game.ReplicatedStorage
local Dependencies = ReplicatedStorage.Dependencies
local DataStoreService = game:GetService("DataStoreService")

--possible dependencies
local aN = require(Dependencies.NumberSystems.AlyaNum)
local ld = require(Dependencies.LibDeflate)

--DataStore

local DBSData = DataStoreService:GetDataStore("DBSData")

local function SaveData(Player : Player)
	local DataString = ""
	local PlayerKitStats = Player:WaitForChild("KitStats")
	
	for _,Stat in pairs(PlayerKitStats:GetChildren()) do
		DataString = DataString..Stat.Name..":"..tostring(aN.lbencode(aN.fromString(Stat.Value))).."|"
	end
	
	local Success, ErrorMessage = pcall(function()
		DBSData:SetAsync(Player.UserId, DataString)
	end)
	
	if Success then
		return 
	else
		print("Failed to save data for userId:"..tostring(Player.UserId).."| userName:"..Player.Name)
		warn(ErrorMessage)
	end
end

game:BindToClose(function()
	for _,Player in pairs(game.Players:GetPlayers()) do
		task.spawn(SaveData, Player)
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

	if Success and Data  then
		local StatList = string.split(Data, "|")
		
		for _, LBValue in pairs(StatList) do
			local Divide = string.split(LBValue, ":")
			local StatChild = KitStats:FindFirstChild(Divide[1])
			
			if StatChild then
				StatChild.Value = aN.toString(aN.lbencode(tonumber(Divide[2])))
			end
			
			KitStats:FindFirstChild(Divide[1]).Value = aN.toString(aN.lbdecode(Divide[2]))
			--List[Divide[1]] = aN.lbdecode(Divide[2])
		end
		
	else
		print("No data found for userId and userName: "..Player.UserId.." "..Player.Name)
	end

	--main loop
	while task.wait(0.1) do
		local RSkill = aN.mul(aN.fromString("2e0"), 
			aN.log10(aN.fromString(KitStats.Money.Value)))
		LSkill.Value = aN.toSuffix(RSkill)
		
		KitStats.Money.Value = aN.toString(aN.add(aN.fromString(KitStats.Money.Value), aN.fromString(KitStats.Multi.Value)))
	end

end)

game.Players.PlayerRemoving:Connect(function(Player)
	SaveData(Player)
end)