local Helper = {}

local aN = require(game.ReplicatedStorage.Dependencies.NumberSystems.AlyaNum)
local DDS = game:GetService("DataStoreService")
local DBSData = DDS:GetDataStore("DBSData")
--Datastore helpers

--save data using aN lb
function Helper:SaveDataLBEncode(Player : Player)
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

--savedata with string as is
function Helper:SaveData(Player : Player)
	local DataString = ""
	local PlayerKitStats = Player:WaitForChild("KitStats")
	
	for _,Stat in pairs(PlayerKitStats:GetChildren()) do
		DataString = DataString..Stat.Name..":"..Stat.Value.."|"
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

--save data using aN lb
function Helper:LoadDataLBDecode(Player : Player, DataString : string)

	--redefine KitStats
	local KitStats = Player:WaitForChild("KitStats")
	local StatList = string.split(DataString, "|")

	for _, LBValue in pairs(StatList) do
		local Divide = string.split(LBValue, ":")
		local StatChild = KitStats:FindFirstChild(Divide[1])
			
		if StatChild then
			StatChild.Value = aN.toString(aN.lbencode(tonumber(Divide[2])))
		end
			
		-- KitStats:FindFirstChild(Divide[1]).Value = aN.toString(aN.lbdecode(Divide[2]))
		--List[Divide[1]] = aN.lbdecode(Divide[2])
	end

end


--savedata with string as is
function Helper:LoadData(Player : Player, DataString : string)
	
	--redefine KitStats
	local KitStats = Player:WaitForChild("KitStats")
	local StatList = string.split(DataString, "|")

	for _, LBValue in pairs(StatList) do
		local Divide = string.split(LBValue, ":")
		local StatChild = KitStats:FindFirstChild(Divide[1])
			
		if StatChild then
			StatChild.Value = aN.toString(Divide[2])
		end
			
		-- KitStats:FindFirstChild(Divide[1]).Value = aN.toString(aN.lbdecode(Divide[2]))
		--List[Divide[1]] = aN.lbdecode(Divide[2])
	end
end

--nan Correct: default
function Helper:CorrectNan(s : string)
    if s == "nan" then
        return "0"
    end
end

return Helper