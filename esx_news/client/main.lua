playerData			  = {} --store player here
Likes = {}
News = {}

ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
	closeGui() --close on client connect
end)

RegisterNetEvent('esx:playerLoaded') --get xPlayer
AddEventHandler('esx:playerLoaded', function(xPlayer)
  
  playerData = xPlayer
  
  ESX.TriggerServerCallback('esx_news:getLikes', function (likes)
	Likes = likes
  end)
	
   ESX.TriggerServerCallback('esx_news:getNews', function (news)
	 News = news
   end)
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
  end)							--was a long term glitch on huesosware editor :(
end

-- Close Gui and disable NUI

function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({openNews = false})
end

-- NUI Callback Methods
RegisterNUICallback('closeNews', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNUICallback('likeArticle', function(data, cb)
  table.insert(Likes, {id = -1, news_id = data.id, liker_id = playerData.identifier, liker_name = "Teppo Teikäläinen"})
  TriggerServerEvent('esx_news:likeArticle', data)
  cb('ok')
end)

function getLikes(id)
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
  
	local likes = getLikes(data.id)
		local _liked = false --has player liked the article before
		if likes ~= nil then --if likes for this news id was found
				
			local likestring = "" 				--string to return
			local count = #likes
			
			for i = 1, count, 1 do 				--loop likes
			    
				if likes[i].liker_id == playerData.identifier then --if player id matches like id
					_liked = true 				 --player has liked the article
				end
				
				if i == 1 and i < count then  		--if it's the first and not last like
					likestring = likes[i].liker_name 	--adds persons to string
					
				elseif i == 1 and i == count and _liked == false then	--if it's the first and last like and been liked
					likestring = 'Sinä ja ' .. likes[i].liker_name .. ' tykkäätte tästä.'						
				
				elseif i == 1 and i == count and _liked == true then	--if it's the first and last like and been liked
					likestring = 'Sinä tykkäsit tästä.'
					break 	--quit and send this string.
					
				elseif i > 1 and i < count then	--if it's not the first and not the last like
					likestring = likestring .. ', ' .. likes[i].liker_name
				
				elseif i > 1 and i == count	then --if it's not the first but is the last like
					likestring = likestring .. ' ja ' .. likes[i].liker_name .. ' tykkäävät tästä.' 
					break						--quit and send this string.
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
				likes = "Sinä tykkäät tästä."
				
			})
		
		end
  cb('ok')
end)

--main functions
function openNews()
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
end

function openremote ()
	openNews()
end


