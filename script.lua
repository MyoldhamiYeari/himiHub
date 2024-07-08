local curtick = tick()
if getgenv().himihubloaded then
	return
end
local cloneref = cloneref or function(object)
	return object
end
if not getcustomasset or not isfolder or not makefolder or not writefile then
	local hint = Instance.new("Hint", workspace)
	hint.Text = "We do not support this executor, please wait for an update for this executor if we can possibly fix it.."
	cloneref(game:GetService('Debris')):AddItem(hint, 5)
	return
end
getgenv().himihubloaded = true
local coreGui = cloneref(game:GetService("CoreGui"))
local httpService = cloneref(game:GetService("HttpService"))
local lighting = cloneref(game:GetService("Lighting"))
local players = cloneref(game:GetService("Players"))
local replicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local runService = cloneref(game:GetService("RunService"))
local guiService = cloneref(game:GetService("GuiService"))
local statsService = cloneref(game:GetService("Stats"))
local starterGui = cloneref(game:GetService("StarterGui"))
local teleportService = cloneref(game:GetService("TeleportService"))
local tweenService = cloneref(game:GetService("TweenService"))
local userInputService = cloneref(game:GetService('UserInputService'))
local contentProvider = cloneref(game:GetService("ContentProvider"))
local notifications = {}

local himihubvalues = {
	UIUrl = "https://github.com/MyoldhamiYeari/himiHub/raw/main/himihubui.rbxm",
	UIid = "18398134908",
	Folder = "himihub/",
	ver = "0.1a"
}

local function checkFolder() 
	if isfolder then 
		if not isfolder(himihubvalues.Folder) then 
			makefolder(himihubvalues.Folder) 
		end 
		if not isfolder(himihubvalues.Folder.."/Music") then 
			makefolder(himihubvalues.Folder.."/Music") 
			writefile(himihubvalues.Folder.."/Music/readme.txt", "Place .mp3 or .ogg files here and refresh the in-game music ui.") 
		end 
		if not isfolder(himihubvalues.Folder.."/Assets") then
			makefolder(himihubvalues.Folder.."/Assets") 
		end 
	end 
end
checkFolder()

--[[getfenv().error = function() -- Add these so you wouldn't get detected easily. (dont thank me but its bad)
	return
end
getfenv().print = function()
	return
end
getfenv().warn = function()
	return
end]]

function getUIandLoad()
	--[[local data = game:HttpGet(himihubvalues.UIUrl)
	if not data then
		return false
	end
	writefile(himihubvalues.Folder.."/Assets/UI.rbxm", data)
	return getcustomasset(himihubvalues.Folder.."/Assets/UI.rbxm")]]
	return game:GetObjects("rbxassetid://"..himihubvalues.UIid)[1]
end

local loadingUI = game:GetObjects("rbxassetid://18398146507")[1]
loadingUI.Parent = coreGui
local loadingText = loadingUI.Frame.TextLabel
-- The loading ui.

local UI = getUIandLoad()
if not UI then
	loadingText.Text = "Failed to load, sorry!"
	cloneref(game:GetService('Debris')):AddItem(loadingUI, 5)
	return
end
UI.Parent=coreGui
loadingUI:Destroy()

local notificationContainer = UI.Notifications

local function figureNotifications() -- Thanks to sirius for originally creating this notification system.
	local notificationsSize = 0

	for i = #notifications, 0, -1 do
		local notification = notifications[i]
		if notification then
			if notificationsSize == 0 then
				notificationsSize = notification.Size.Y.Offset + 2
			else
				notificationsSize += notification.Size.Y.Offset + 5
			end
			local desiredPosition = UDim2.new(0.5, 0, 0, notificationsSize)
			if notification.Position ~= desiredPosition then
				notification:TweenPosition(desiredPosition, "Out", "Quart", 0.8, true)
			end
		end
	end	
end
local function queueNotification(Title, Description, Image)
	task.spawn(function()		
		local newNotification = notificationContainer.Template:Clone()
		newNotification.Parent = notificationContainer
		newNotification.Name = Title or "Unknown Title"
		newNotification.Visible = true
		newNotification.Title.Text = Title or "Unknown Title"
		newNotification.Description.Text = Description or "Unknown Description"
		newNotification.Time.Text = "now"
		newNotification.AnchorPoint = Vector2.new(0.5, 1)
		newNotification.Position = UDim2.new(0.5, 0, -1, 0)
		newNotification.Size = UDim2.new(0, 320, 0, 500)
		newNotification.Description.Size = UDim2.new(0, 241, 0, 400)
		newNotification.Description.Size = UDim2.new(0, 241, 0, newNotification.Description.TextBounds.Y)
		newNotification.Size = UDim2.new(0, 100, 0, newNotification.Description.TextBounds.Y + 50)
		table.insert(notifications, newNotification)
		figureNotifications()
		local notificationSound = Instance.new("Sound")
		notificationSound.Parent = UI
		notificationSound.SoundId = "rbxassetid://255881176"
		notificationSound.Name = "notificationSound"
		notificationSound.Volume = 0.65
		notificationSound.PlayOnRemove = true
		notificationSound:Destroy()
		newNotification.Icon.Image = 'rbxassetid://'..Image or 0
		newNotification:TweenPosition(UDim2.new(0.5, 0, 0, newNotification.Size.Y.Offset + 2), "Out", "Quart", 0.9, true)
		task.wait(0.1)
		tweenService:Create(newNotification, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 320, 0, newNotification.Description.TextBounds.Y + 50)}):Play()
		task.wait(0.05)
		tweenService:Create(newNotification, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.35}):Play()
		tweenService:Create(newNotification.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0.7}):Play()
		task.wait(0.05)
		tweenService:Create(newNotification.Icon, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
		task.wait(0.04)
		tweenService:Create(newNotification.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		task.wait(0.04)
		tweenService:Create(newNotification.Description, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0.15}):Play()
		tweenService:Create(newNotification.Time, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0.5}):Play()
		newNotification.Interact.MouseButton1Click:Connect(function()
			local foundNotification = table.find(notifications, newNotification)
			if foundNotification then table.remove(notifications, foundNotification) end

			tweenService:Create(newNotification, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1.5, 0, 0, newNotification.Position.Y.Offset)}):Play()

			task.wait(0.4)
			newNotification:Destroy()
			figureNotifications()
			return
		end)
		local waitTime = (#newNotification.Description.Text*0.1)+2
		if waitTime <= 1 then waitTime = 2.5 elseif waitTime > 10 then waitTime = 10 end
		task.wait(waitTime)
		local foundNotification = table.find(notifications, newNotification)
		if foundNotification then table.remove(notifications, foundNotification) end
		tweenService:Create(newNotification, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1.5, 0, 0, newNotification.Position.Y.Offset)}):Play()
		task.wait(1.2)
		newNotification:Destroy()
		figureNotifications()
	end)
end
local timeTaken = curtick - tick()
queueNotification(("Successfully loaded in %s seconds"):format(tostring(timeTaken):sub(1,3)), "Successfully loaded the hub, current version is "..himihubvalues.ver, "rbxassetid://14187686429")