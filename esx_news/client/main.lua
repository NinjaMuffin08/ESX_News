playerData			  = {} --store player here
ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
	closeGui() --close on client connect
end)

RegisterNetEvent('esx:playerLoaded') --not in use anymore but junkcode is always a plus
AddEventHandler('esx:playerLoaded', function(xPlayer)  
  playerData = xPlayer
end)

AddEventHandler('onClientMapStart', function()
	--probably not the best idea
end)

-- Open Gui and Focus NUI
function openGui()
  SendNUIMessage({openNews = true})
  Citizen.CreateThread(function()
	Citizen.Wait(500)			--this is extremely important unless you want to check nuifocus on a separate function
	SetNuiFocus(true, true)		--when opened from phone -> phone will send nuifocus(false) -> will glitch the screen if it happens before setting nui focus true. 
	SendNUIMessage({hideLoader = true})
  end)							--was a long term glitch on huesosware editor :(
end

-- Close Gui and disable NUI

function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({openNews = false})
  SendNUIMessage({showLoader = true})
end

-- NUI Callback Methods
RegisterNUICallback('closeNews', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNUICallback('likeArticle', function(data, cb)
  TriggerServerEvent('esx_news:likeArticle', data)
  cb('ok')
end)

function getLikes(id, Likes)
	local intId = tonumber(id)
	local liketbl = {}
	for i = 1, #Likes, 1 do
		if tonumber(Likes[i].news_id) == intId then
			table.insert(liketbl, Likes[i])
		end
	end
	return liketbl
end


RegisterNUICallback('getLikes', function(data, cb)
	cb('ok')
	ESX.TriggerServerCallback('esx_news:getLikes', function(likes)
		local likestring = "Sinä tykkäät tästä"
		if likes ~= nil then 
			local count = #likes 
			local _liked = false
			for i = 1, count, 1 do 				
				if likes[i].liker_id == playerData.identifier then 
					_liked = true 				 
				end
				
				if i == 1 and i < count then  		
					likestring = likes[i].liker_name 	
					
				elseif i == 1 and i == count and _liked == false then	
					likestring = 'Sinä ja ' .. likes[i].liker_name .. ' tykkäätte tästä.'						
				
				elseif i == 1 and i == count and _liked == true then	
					likestring = 'Sinä tykkäsit tästä.'
					break 	
					
				elseif i > 1 and i < count then
					likestring = likestring .. ', ' .. likes[i].liker_name
				
				elseif i > 1 and i == count	then 
					likestring = likestring .. ' ja ' .. likes[i].liker_name .. ' tykkäävät tästä.' 
					break						
				end
				
			end
			
			if _liked == true then 		--if player has liked the article
				
				SendNUIMessage({
				
					addLikes = true,
					likes = likestring
				
				})
			
			else						--if player has not like the article 
			
				SendNUIMessage({
				
					addLikeButton = true,
					like_id = data.id,
					likes = likestring
				
				})
			
			end
		
		else
			
			SendNUIMessage({
				
				addLikeButton = true,
				like_id = data.id,
				likes = likestring
				
			})
			
		end
	end, tonumber(data.id))
end)

--main functions
function openNews()
	 ESX.TriggerServerCallback('esx_news:getNews', function (News)	
		if News ~= nil then
			
			for i = 1, #News, 1 do
				
				SendNUIMessage({
				
				addNews = true,
				title = News[i].title,
				bait_title = News[i].bait_title,
				content = News[i].content,
				author_name = News[i].author_name,
				author_id = News[i].author_id,
				id = News[i].id,
				imgurl = News[i].imgurl
				
				})
			end
			
		end
		
		openGui()
	end)
end

function openremote ()
	openNews()
end


