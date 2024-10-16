local curtick = tick()
--[[if getgenv().himihubloaded then
	return
end]]
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
	UIUrl = "https://github.com/MyoldhamiYeari/himiHub/raw/refs/heads/main/himihubui.rbxm",
	UIid = "18398134908",
	Folder = "himihub/",
	ver = "0.13a",
	barAnims = {
		Buttons = {
			Home = {
				Open = UDim2.new(0, 3, 0.5, 0),
				Closed = UDim2.new(0, 3, 0.5, -50)
			}
		}
	}
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

function getUIandLoad()
	local data = game:HttpGet(himihubvalues.UIUrl)
	if not data then
		return false
	end
	writefile("UI.rbxm", data)
	task.wait(5)
	return getcustomasset("UI.rbxm")
	--return game:GetObjects("rbxassetid://"..himihubvalues.UIid)[1]
end

--[[local loadingUI = game:GetObjects("rbxassetid://18398146507")[1]
loadingUI.Parent = coreGui
local loadingText = loadingUI.Frame.TextLabel]]

local UI = getUIandLoad()
if not UI then
	--loadingText.Text = "Failed to load, sorry!"
	--cloneref(game:GetService('Debris')):AddItem(loadingUI, 5)
	return
end
UI.Parent=coreGui
--loadingUI:Destroy()

local notificationContainer = UI.Notifications
local barContainer = UI.Bar
local barOpened = false
local barDebounce = false
barContainer.Visible = true

-- Roblox kinda removed my UIScale..
for _, button in pairs(barContainer.Buttons:GetChildren()) do
	if not button:FindFirstChild"UIScale" then
		Instance.new("UIScale", button)
	end
end

Instance.new("UIScale", barContainer).Scale=0.8
barContainer.ImageButton.Position = UDim2.new(.5,0,1,25)
barContainer.Buttons.ClipsDescendants = true

local ES = Enum.EasingStyle
local ED = Enum.EasingDirection

function openBar()
	local barAnims = himihubvalues.barAnims
	local btns = barAnims.Buttons
	local bar = barContainer
	local barBtns = bar.Buttons
	barBtns.Home.Position = btns.Home.Closed
	barBtns.Home.UIScale.Scale = 0.8
	tweenService:Create(bar, TweenInfo.new(.3, ES.Quad, ED.In), {Position=UDim2.new(0.5, 0, 0, -25)}):Play();
	tweenService:Create(barBtns.Home, TweenInfo.new(.5, ES.Quad, ED.InOut), {Position=btns.Home.Open}):Play();
	tweenService:Create(barBtns.Home.UIScale, TweenInfo.new(.5, ES.Quad, ED.InOut), {Scale=1}):Play();
	tweenService:Create(bar.ImageButton.fluency_icon, TweenInfo.new(.15, ES.Quad, ED.InOut), {Rotation=180}):Play();
	tweenService:Create(bar.ImageButton, TweenInfo.new(.3, ES.Quad, ED.InOut), {Position=UDim2.new(0.5,0,1,5)}):Play();
	task.wait(.25)
	tweenService:Create(bar.UIScale, TweenInfo.new(.3, ES.Quad, ED.Out), {Scale=1}):Play();
	tweenService:Create(bar, TweenInfo.new(.3, ES.Quad, ED.Out), {Position=UDim2.new(0.5, 0, 0, 10)}):Play();
end

function closeBar()
	local barAnims = himihubvalues.barAnims
	local btns = barAnims.Buttons
	local bar = barContainer
	local barBtns = bar.Buttons
	barBtns.Home.Position = btns.Home.Open
	barBtns.Home.UIScale.Scale = 1
	tweenService:Create(bar, TweenInfo.new(.3, ES.Quad, ED.In), {Position=UDim2.new(0.5, 0, 0, -25)}):Play();
	tweenService:Create(bar.UIScale, TweenInfo.new(.3, ES.Quad, ED.In), {Scale=0.8}):Play();
	tweenService:Create(barBtns.Home, TweenInfo.new(.5, ES.Quad, ED.InOut), {Position=btns.Home.Closed}):Play();
	tweenService:Create(barBtns.Home.UIScale, TweenInfo.new(.5, ES.Quad, ED.InOut), {Scale=0.8}):Play();
	tweenService:Create(bar.ImageButton.fluency_icon, TweenInfo.new(.15, ES.Quad, ED.InOut), {Rotation=0}):Play();
	tweenService:Create(bar.ImageButton, TweenInfo.new(.3, ES.Quad, ED.InOut), {Position=UDim2.new(0.5,0,1,25)}):Play();
	task.wait(0.25)
	tweenService:Create(bar, TweenInfo.new(.3, ES.Quad, ED.Out), {Position=UDim2.new(0.5, 0, 0, -55)}):Play();
end

function toggleBar()
	if barDebounce then
		return
	end
	barDebounce = true
	if not barOpened then
		barOpened = true
		openBar()
	else
		barOpened = false
		closeBar()
	end
	barDebounce = false
end

barContainer.ImageButton.MouseButton1Down:Connect(function()
	toggleBar()
end)

function updateBarTime()
	barContainer.TextLabel.Text = os.date("%H")..":"..os.date("%M")
end

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
		tweenService:Create(newNotification, TweenInfo.new(0.8, ES.Exponential), {Size = UDim2.new(0, 320, 0, newNotification.Description.TextBounds.Y + 50)}):Play()
		task.wait(0.05)
		tweenService:Create(newNotification, TweenInfo.new(0.8, ES.Exponential), {BackgroundTransparency = 0.35}):Play()
		tweenService:Create(newNotification.UIStroke, TweenInfo.new(0.6, ES.Exponential), {Transparency = 0.7}):Play()
		task.wait(0.05)
		tweenService:Create(newNotification.Icon, TweenInfo.new(0.5, ES.Exponential), {ImageTransparency = 0}):Play()
		task.wait(0.04)
		tweenService:Create(newNotification.Title, TweenInfo.new(0.5, ES.Exponential), {TextTransparency = 0}):Play()
		task.wait(0.04)
		tweenService:Create(newNotification.Description, TweenInfo.new(0.5, ES.Exponential), {TextTransparency = 0.15}):Play()
		tweenService:Create(newNotification.Time, TweenInfo.new(0.5, ES.Exponential), {TextTransparency = 0.5}):Play()
		newNotification.Interact.MouseButton1Click:Connect(function()
			local foundNotification = table.find(notifications, newNotification)
			if foundNotification then table.remove(notifications, foundNotification) end

			tweenService:Create(newNotification, TweenInfo.new(0.35, ES.Quart, ED.In), {Position = UDim2.new(1.5, 0, 0, newNotification.Position.Y.Offset)}):Play()

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
		tweenService:Create(newNotification, TweenInfo.new(0.8, ES.Quart, ED.In), {Position = UDim2.new(1.5, 0, 0, newNotification.Position.Y.Offset)}):Play()
		task.wait(1.2)
		newNotification:Destroy()
		figureNotifications()
	end)
end
local timeTaken = curtick - tick()
queueNotification(("Loaded in %s seconds"):format(tostring(timeTaken):sub(1,3)), "Successfully loaded the hub, current version is "..himihubvalues.ver.." remember to make an issue in the github repo if you find a bug, thank you!", "14187686429")

runService.Heartbeat:Connect(function()
	updateBarTime()
end)