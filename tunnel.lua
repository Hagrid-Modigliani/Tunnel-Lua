--Begin clear function
local function clear()
  term.clear()
  term.setCursorPos(1,1)
end
--End clear function

--Begin drawMenu function
local function drawMenu()
	clear()
	for i = 1,#options-1 do
		if sel == i then write("*") end
		print(options[i].." "..tostring(values[i]))
	end
	if sel == 8 then 
		print("\n\n\n["..options[8].."]")
	else
		print("\n\n\n"..options[8])
	end
end
--End drawMenu function

--Begin setValue function
local function setValue(value)
	if value == "Disabled" then
		value = false
	else
		value = true
	end
	return value
end
--End setValue function

--Begin toggle function
local function toggle(able)
	if able == "Disabled" then
		able = "Enabled"
	else
		able = "Disabled"
	end
	return able
end
--End toggle function

--Begin saveProgress function
local function saveProgress()
	fs.delete("btProgress")
	d = fs.open("btProgress", "w")
	d.writeLine("This contains the current position of the turtle in btunnel.")
	d.writeLine(loc)
	d.writeLine(tostring(curLength))
	d.writeLine(tostring(length))
	d.writeLine(facing)
	d.close()
end
--End saveProgress function

--Begin loadProgress function
local function loadProgress()
	d = fs.open("btProgress", "r")
	comment1 = d.readLine()
	loc = d.readLine()
	curLength = tonumber(d.readLine())
	length = tonumber(d.readLine())
	facing = d.readLine()
end
--End loadProgress function

--Begin saveSettings function
local function saveSettings()
	if fs.exists("btSettings") then
		fs.delete("btSettings")
	end
	h = fs.open("btSettings","w")
	h.writeLine("--Better Tunnel Settings")
	h.writeLine("--Deleting will reset settings")
	h.close()
	h = fs.open("btSettings","a")
	h.writeLine(orders)
	h.writeLine(useChests)
	h.writeLine(useEnder)
	h.writeLine(useTorches)
	h.writeLine(bridgeGaps)
	h.writeLine(tonumber(compID))
	h.writeLine(tonumber(fuelSlot))
	h.writeLine(tunnelType)
	h.close()
end
--End saveSettings function

--Begin checkChests function
local function checkChests()
	if useChests then
		max = 15
		if chests == 0 then
			if useEnder then
				print("\nPlease input an enderchest into slot "..chestSlot.."...")
			else
				print("\nPlease input chests into slot "..chestSlot.."...")
			end
			while chests == 0 do
				chests = turtle.getItemCount(chestSlot)
				sleep(1)
			end
		end
	end
end
--End the checkChests function

--Begin the checkTorches function
local function checkTorches()
	if useTorches then
		if useChests then
			torchSlot = 15
			torches = turtle.getItemCount(torchSlot)	
			max = 14
		else
			torchSlot = 16
			torches = turtle.getItemCount(torchSlot)
			max = 15
		end
		if torches == 0 then
			print("\nPlease input torches into slot "..torchSlot.."...")
			while torches == 0 do
				torches = turtle.getItemCount(torchSlot)
				sleep(1)
			end
		end
	end
end
--End the checkTorches function

--Begin loadSettings function
local function loadSettings()
	h = fs.open("btSettings", "r")
	comment1 = h.readLine()
	comment2 = h.readLine()
	orders = h.readLine()
	useChests = h.readLine()
	useEnder = h.readLine()
	useTorches = h.readLine()
	bridgeGaps = h.readLine()
	compID = tonumber(h.readLine())
	fuelSlot = tonumber(h.readLine())
	tunnelType = h.readLine()
	h.close()
	max = 16
	checkChests()
	checkTorches()
end
--End loadSettings function

--Begin findLoc function
local function findLoc()
	if facing == "right" then
		if loc == "top" then
			dig()
			down()
			loc = "mid"
			dig()
			down()
			loc = "bot"
			dig()
			turtle.turnLeft()
			facing = "forw"
			forward()
			length = length+1
		elseif loc == "mid" then
			dig()
			down()
			loc = "bot"
			dig()
			turtle.turnLeft()
			facing = "forw"
			forward()
			length = length+1
		elseif loc == "bot" then
			dig()
			turtle.turnLeft()
			facing = "forw"
			forward()
			length = length+1
		end
	end
end
--End findLoc function

--Begin modemExists function
local function modemExists()
	if peripheral.getType("right") == "modem" then
		return true
	end
	return false
end
--End modemExists function

--Begin invalid function
local function invalid()
	print("\nInvalid")
	sleep(1)
end
--End invalid function

--Begin isValid function
local function isValid(check, isOrders)
	vType = type(check)
	check = string.lower(check)
	if not isOrders or isOrders == nil then
		if check == "y" or check == "n" and vType == "string" then
			return true
		end
	else
		if check == "u" or check == "r" and vType == "string" then
			return true
		end
	end
	return false
end
--End isValid function

--Begin the useFuel function
local function useFuel()
	clear()
	if useFuelSlot then
		continue = false
		repeat
			clear()
			print("What slot would you like the fuel to be in?: ")
			fuelSlot = tonumber(read())
			if fuelSlot == torchSlot or fuelSlot == chestSlot or fuelSlot > 16 then
				continue = false
				invalid()
			else
				if fuelSlot == max then
					max = max-1
				end
				print("\nPlease input fuel into slot ",fuelSlot,"...")
				fuelAmount = turtle.getItemCount(fuelSlot)
				while fuelAmount == 0 do
					fuelAmount = turtle.getItemCount(fuelSlot)
					sleep(1)
				end
				continue = true
			end
		until continue
	end
	continue = true
end
--End the useFuel Function

--Begin dropoff function 
local function dropOff()
	turtle.digUp()
	turtle.select(chestSlot)
	turtle.placeUp()
	for i = 1,max do
		if turtle.getItemCount(i) > 0 and i ~= fuelSlot then
			turtle.select(i)
			turtle.dropUp()
		end
	end
	if useEnder == true then
		sleep(2)
		turtle.select(chestSlot)
		turtle.digUp()
	end
	turtle.select(1)
end
--End dropoff function 

--Begin dig function
local function dig()
	while turtle.detect() do
		turtle.dig()
	end
end
--End dig function

--Begin up function 
function up(num)
	curUp = 1
	if num == nil then
		num = 1
	end
	while curUp <= num do
		if not turtle.up() then
			turtle.digUp()
			turtle.attackUp()
		else
			curUp = curUp+1
		end
	end
end
--End up function 

--Begin forward function 
function forward(num)
	curForw = 1
	if num == nil then
		num = 1
	end
	while curForw <= num do
		if not turtle.forward() then
			turtle.dig()
			turtle.attack()
		else
			curForw = curForw+1
		end
	end
end
--End forward function

--Begin down function 
function down(num)
	curDown = 1
	if num == nil then
		num = 1
	end
	while curDown <= num do
		if not turtle.down() then
			turtle.digDown()
			turtle.attackDown()
		else
			curDown = curDown+1
		end
	end
end
--End down function 

--Begin the tryRefuel function
local function tryRefuel()
	for i = 1,max do
		if turtle.getItemCount(i) > 0 then
			turtle.select(i)
			if turtle.refuel(1) then
				return true
			end
		end
	end
	turtle.select(1)
	return false
end
--End the tryRefuel function 

--Begin refuel function 
local function refuel()
	curFuel = turtle.getFuelLevel()
	if curFuel == "unlimited" or curFuel >= 10 then
		return
	else
		if not tryRefuel() then
			print("Please supply more fuel to coninue...")
			while not tryRefuel() do
				sleep(1)
			end
		end
	end
end
--End refuel function

--Begin the stackFuel function
local function stackFuel()
	for i = 1,16 do
		if turtle.getItemCount(i) > 0 and i ~= fuelSlot and i < max then 
			turtle.select(i)
			if turtle.compareTo(fuelSlot) then
				turtle.transferTo(fuelSlot, turtle.getItemCount(i))
			end
		end
	end
	turtle.select(1)
end
--End the stackFuel function

--Begin tunnel function
local function tunnel(tunLength)
	for i = 1,tunLength do
		if useTorches then
			turtle.select(torchSlot)
			if torch == 9 or curLength == 1 or curLength == tunLength-1 then
				turtle.digDown()
				turtle.placeDown()
				turtle.select(1)
				torch = 1 
			else
				torch = torch+1
			end 
			turtle.select(1)
		end
		if bridgeGaps and not turtle.detectDown() then
			turtle.placeDown()
		end
		print("Current tunnel length: ",curLength-1)
		refuel()
		turtle.turnLeft()
		dig()
		up()
		dig()
		if tunnelType == "3x3" then
			up()
			dig()
		end
		turtle.turnRight()
		turtle.turnRight()
		dig()
		down()
		dig()
		if tunnelType == "3x3" then
			down()
			dig()
		end
		turtle.turnLeft()
		if useFuelSlot == true then
			stackFuel()
		end
		refuel()
		if useChests then
			if turtle.getItemCount(max) > 0 then
				dropOff()
			end
		end
		turtle.select(1)
		turtle.dig()
		forward()
		curLength = curLength+1
		saveProgress()
		saveSettings()
	end
end
--End tunnel function


--Begin Main code
--[[Check if the turtle already began a tunnel and needs to finish it now
if fs.exists("btProgress") then
	print("I need to continue with my tunnel!")
	loadProgress()
	loadSettings()
	findLoc()
end
--]]

--Declare Variables
max = 16
continue = false
torchSlot = 15
chestSlot = 16
curLength = 1
useSettings = false
compID = 1
facing = "right"
torches = turtle.getItemCount(torchSlot)
chests = turtle.getItemCount(chestSlot)

values={
	"User",
	"Disabled",
	"Disabled",
	"Disabled",
	"Disabled",
	"3x3",
	"Disabled"
}
orders = values[1]
useChests = values[2]
useEnder = values[3]
useTorches = values[4]
bridgeGaps = values[5]
tunnelType = values[6]
useFuelSlot = values[7]

options={
	"Receive orders via:",
	"Use chests:",
	"Use Enderchests:",
	"Use Torches:",
	"Bridge Gaps:",
	"Tunnel Type:",
	"Specific Slot for Fuel:",
	"Continue"
}

clear()
print("Better Tunnel v2.0")
sleep(2.5)

--If a settings file exists, ask the user if they want to load it
if fs.exists("btSettings") then
	continue = false
	repeat
		clear()
		print("A settings file was found.")
		print("Would you like to load it?(Y/N): ")
		load = read()
		load = string.lower(load)
		if load == "y" then
			useSettings = true
			continue = true
		elseif load == "n" then
			useSettings = false
			continue = true
		else
			invalid()
		end
	until continue
else
	useSettings = false
end

--If they chose to load it, it will load the setting from the file
if useSettings then
	loadSettings()
else--If the file didn't exist or the user chose not to load it, the program will ask the user for settings
	sel = 1--The first option is selected when the screen is first drawn

	clear()--clear the screen before starting
	while true do
		clear()
		drawMenu()--draw the menu
		event, key=os.pullEvent("key")--wait for a key to be pressed
		if key == keys.up and sel ~= 1 then--long and excessive logic(I feel it could be improved) to decide what to select next
			sel = sel-1
		elseif key == keys.down and sel ~= 8 then
			sel = sel+1
		elseif key == keys.enter then
			if sel == 1 then
			 	if values[1] == "User" then
			 		values[1] = "Rednet"
			 	else
			 		values[1] = "User"
			 	end
			elseif sel == 2 then
				values[2] = toggle(values[2])
				if values[2] == "Disabled" and values[3] ~= "Disabled" then
					values[3] = toggle(values[3])
				end
			elseif sel == 3 then
				values[3] = toggle(values[3])
				if values[3] == "Enabled" and values [2] ~= "Enabled" then
					values[2] = toggle(values[2])
				end
			elseif sel == 4 then
				values[4] = toggle(values[4])
			elseif sel == 5 then
				values[5] = toggle(values[5])
			elseif sel == 6 then
				if values[6] == "3x3" then
					values[6] = "2x3" 
				else
					values[6] = "3x3"
				end
			elseif sel == 7 then
				values[7] = toggle(values[7])
			elseif sel == 8 then
				orders = values[1]
				useChests = setValue(values[2])
				useEnder = setValue(values[3])
				useTorches = setValue(values[4])
				bridgeGaps = setValue(values[5])
				useFuelSlot = setValue(values[7])
				break
			end
		end
	end
	useFuel()
	checkChests()
	checkTorches()
end

if (not modemExists() and (orders == "Rednet")) then
	clear()
	print("No modem was detected on this turtle!")
	print("User input has been automatically selected.")
	orders = "User"
	sleep(3)
end

--Run the tunnel function based on the orders chosen
if orders == "Rednet" then
	rednet.open("right")
	clear()
	if not useSettings then
		continue = false
		repeat
			print("You chose to receive orders via Rednet.")
			write("What computer would you like me to accept messages from?: ")
			compID = tonumber(read())
			if compID > 0 then
				continue = true
			else
				invalid()
			end
		until continue 
	end
	clear()
	print("I will listen for orders from the computer with id: "..compID)
	id, msg = rednet.receive()
	if id == tonumber(compID) then
		length = msg
		checkChests()
		checkTorches()
		print("Beginning tunnel with length: "..length)
		tunnel(length)
	end
elseif orders == "User" then
	repeat
		clear()
		print("You chose to receive orders via User.")
		write("How long would you like the tunnel to be?(In blocks): ")
		length = tonumber(read())
		vType = type(length)
		if vType == "number" then
			print("Beginning tunnel with length: "..length)
			continue = true
			checkChests()
			checkTorches()
			tunnel(length)
		else
			invalid()
			continue = false
		end
	until continue
end

clear()
print("I'm done!")
print("I completed a tunnel with length: "..length)

if not useSettings then
	print("Would you like to save these settings for use in the next tunnel?(Y/N): ")
	save = read()
	save = string.lower(save)
	if save == "y" then
		saveSettings()
		print("Settings have been saved")
		sleep(2)
	end
end
