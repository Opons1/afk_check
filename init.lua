afk_check = { 
	players = {} 
}

local function do_action(player)
    if not player then return end
    local name = player:get_player_name()
    if afk_check.players[name] then
        afk_check.players[name].last_action = 0
        afk_check.players[name].is_afk = false
    end
end

core.register_on_player_receive_fields(function(player, formname, fields)
    if next(fields) == nil then return end 
    do_action(player)
end)

core.register_on_player_inventory_action(function(player)
	do_action(player)
end)

core.register_globalstep(function(dtime)
	for name, data in pairs(afk_check.players) do
		data.last_action = data.last_action + dtime
        if data.last_action > 10 then
            if data.is_afk ~= true then 
                data.is_afk = true
                core.chat_send_all("Player " .. name .. " is now AFK")
            end
        else
			if data.is_afk == true then
        		data.is_afk = false
		    	core.chat_send_all("Player " .. name .. " is no longer AFK")
			end
        end
    end
end)

core.register_on_joinplayer(function(player)
	if not player then return end
    local playername = player:get_player_name()
	afk_check.players[playername] = {
        last_action = 0,
		is_afk = false
    }
end)

core.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	afk_check.players[playername] = nil
end)

core.register_on_chat_message(function(name)
	afk_check.players[name].last_action = 0
end)

core.register_on_chatcommand(function(name)
	afk_check.players[name].last_action = 0
	
end)

core.register_on_craft(function(itemstack, player)
	do_action(player)
end)

core.register_on_dignode(function(pos, oldnode, digger)
	do_action(digger)
end)

core.register_on_placenode(function(pos, newnode, placer)
	do_action(placer)
end)

core.register_on_punchnode(function(pos, node, puncher)
	do_action(puncher)
end)

