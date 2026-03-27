local aN = require(game.ReplicatedStorage.Dependencies.NumberSystems.AlyaNum)
local DBSHelper = require(game.ReplicatedFirst.Dependencies.KitHelper)

task.wait(0.5)
local Player = game.Players:GetPlayerFromCharacter(script.Parent.Parent.Parent)
local stat = Player:WaitForChild("KitStats")


while task.wait(0.01) do
	for _, v in pairs(script.Parent:GetDescendants()) do
		if v:IsA("TextLabel") and stat:FindFirstChild(v.Name) then
			local statValue = stat[v.Name]
			
			print(statValue.Value)
						
			if v.Name == "Money" then
				v.Text = statValue:GetAttribute("GUIName")..": $"..aN.toSuffix(aN.fromString(statValue.Value))
			elseif v.Name == "Multi" then
				v.Text = statValue:GetAttribute("GUIName")..": x"..aN.toSuffix(aN.fromString(statValue.Value))
			else
				v.Text = statValue:GetAttribute("GUIName")..": "..aN.toSuffix(aN.fromString(statValue.Value))
			end

		end
	end
end
