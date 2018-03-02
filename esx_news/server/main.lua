ESX              = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

News = {}
Likes = {}

AddEventHandler('onMySQLReady', function()
	
	MySQL.Async.fetchAll(							
    'SELECT * FROM news_main WHERE news_type = @one ORDER BY id DESC',
    { 
	  ['@one'] = "uutinen"
	},
    function (result)								

      for i=1, #result, 1 do
        table.insert(News, result[i])
      end
	  
    end
   )
   
   MySQL.Async.fetchAll(								
    'SELECT * FROM news_likes WHERE 1 = @one',
    { 
	  ['@one'] = 1 -- :DD
	},
    function (result2)									

      for i=1, #result2, 1 do
        table.insert(Likes, result2[i])
      end
    end
   )
end)

ESX.RegisterServerCallback('esx_news:getNews', function (source, cb)
	cb(News)
end)

ESX.RegisterServerCallback('esx_news:getLikes', function (source, cb)
	cb(Likes)
end)

RegisterServerEvent('esx_news:likeArticle')
AddEventHandler('esx_news:likeArticle', function(data)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(95)
	
	--TriggerClientEvent('esx:showNotification', xPlayer.source, "~w~author id " .. data.author)
	MySQL.Async.fetchAll(
	'SELECT * FROM users WHERE identifier = @identifier', 
	{
      ['@identifier'] = xPlayer.identifier
    }, 
	function(rows)
		
		local _name = "Matti Meikäläinen"
		
		for i = 1, #rows, 1 do
			_name = rows[i].firstname .. ' ' .. rows[i].lastname
		end
		
		table.insert(Likes, {id = -1, news_id = data.id, liker_id = xPlayer.identifier, liker_name = _name})
		
		MySQL.Async.fetchAll(
		'INSERT INTO news_likes (news_id, liker_id, liker_name) VALUES (@id, @lid, @name)',
		{ ['@id'] = data.id,
		  ['@lid'] = xPlayer.identifier,
		  ['@name'] = _name,
		},
		function (rows_changed)
		  TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~ Tykkäsit artikkelista!")
		end
		)
	
	end
	)
	
	MySQL.Async.fetchAll(
    'INSERT INTO paychecks (amount, receiver) VALUES (@sum, @id)',
    { 
		['@sum'] = 200,
		['@id'] = data.author,
	},
    function (rows)
      --???
    end
	)
	
end)


