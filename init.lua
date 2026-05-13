local afk_check = { players = { } }

local function do_action(player)
	if not player then return end
	local playername = player:get_player_name()
	afk_check.players[playername] = { 
		last_action = 0 
	}
end

core.register_globalstep(function(dtime)
	for name, data in pairs(afk_check.players) do
		data.last_action = data.last_action + dtime
    end
end)

core.register_on_joinplayer(function(player)
	do_action(player)
end)

core.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	afk_check.players[playername] = nil
end)

core.register_on_chat_message(function(name)
	afk_check.players[name] = {
		last_action = 0
	}
end)

core.register_on_chatcommand(function(name)
	afk_check.players[name] = {
		last_action = 0
	}
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

