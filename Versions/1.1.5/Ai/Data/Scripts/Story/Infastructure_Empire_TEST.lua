--/////////////////////////////////////////////////////////////////////////////////////////////////
--AI Republic and CIS Infastructure Plan by Sidious Invader & Z3r0x.
--/////////////////////////////////////////////////////////////////////////////////////////////////
require("PGStateMachine")
require("PGSpawnUnits")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	Define_State("State_Init", State_Init);

-- Omited The Maw, Polis Massa, The Wheel, Antar, Roche Asteroids, and Vergesso Asteroids, because they do not support Land Structures.
	planet_list = {"Abregado_Rae", "AetenII", "Alderaan", "AlzocIII", "Anaxes", "Atzerri", "Bakura", "Bespin", "Bestine", "Bonadan", "Bothawui", "Boz_Pity", "Carida",	
			"Cato_Neimoidia", "Corellia", "Corulag", "Coruscant", "Dathomir", "Duro", "Dantooine", "Endor", "Eriadu", "Felucia", "Foerost", "Fondor", "Fresia", "Geonosis",
			"Honoghr", "Hoth", "Hypori", "Ithor", "Ilum", "Jabiim", "Kamino", "Kashyyyk", "Kessel", "Korriban", "Kuat", "Mechis", "Mandalore", "Minntooine", "MonCalimari", 
			"Mustafar", "Muunilinst", "Mygeeto", "Naboo", "NalHutta", "Ord_Mantell", "Rattatak", "Raxus_Prime", "Rendili", "Rhen_Var", "Ryloth", "Rodia", "Rothana", 
			"Saleucami", "Sluis_Van", "Sullust", "Taris", "Tatooine", "Thyferra", "Utapau", "Trandosha", 
			"Yavin" }
	
	index = 1
	build_sleep = nil
	empire = Find_Player("Empire")
	rebel = Find_Player("Rebel")
	current_planet = nil
	current_planet_owner = nil
	eval_planet = nil
	first_random = nil
	second_random = nil
	third_random = nil
	tech_timer = nil
	
	
end

function State_Init(message)
-- This script will constantly loop, until "ScriptExit()" is used.
		Game_Message("1_LUA_ACTIVE")
		
	difficulty = rebel.Get_Difficulty()
	if difficulty == "Easy" then
		Game_Message("1_EASY")
		build_sleep = 4.0
		tech_timer = 1000
		timer2 = GameRandom(2700, 3200)
		timer3 = GameRandom(3200, 3700)
		timer4 = GameRandom(3700, 4200)
		timer5 = GameRandom(4200, 4700)
	end
	if difficulty == "Normal" then
		Game_Message("1_NORMAL")
		build_sleep = 2.0
		tech_timer = 600
		Game_Message("1_TIMERS_NORMAL")
		timer2 = GameRandom(1800, 2200)
		timer3 = GameRandom(2200, 2600)
		timer4 = GameRandom(2600, 3000)
		timer5 = GameRandom(3000, 3400)
	end
	if difficulty == "Hard" then
		Game_Message("1_HARD")
		build_sleep = 1.0
		tech_timer = 300
		timer2 = GameRandom(900, 1200)
		timer3 = GameRandom(1200, 1500)
		timer4 = GameRandom(1500, 1800)
		timer5 = GameRandom(1800, 2100)
	end
			
	if EvaluatePerception("Human_Player_Is_Rebel", rebel) == 1 then
		Game_Message("1_EMPIRE")
		player_enemy = Find_Player("Empire")
		player = Find_Player("Rebel")
		mines = {"Empire_Ground_Mining_Facility"}
		barracks = {"E_Ground_Barracks"}
		ltvehfact = {"E_Ground_Light_Vehicle_Factory"}
		hvyvehfact = {"E_Ground_Heavy_Vehicle_Factory"}
		advvehfact = {"Ground_Arc_Facility"}
		offacademy = {"Republic_Ground_Outpost"}
		research = {"E_Ground_Research_Facility"}
		cantina = {"Ground_Cantina_E"}
		huttpalace = {"Ground_Hutt_Palace_E"}
		baseshield = {"E_Ground_Base_Shield"}
		hypergun = {"Ground_Ion_Cannon"}
		shutter = {"Republic_Ground_Farm"}
		turbolaser = {"E_Galactic_Turbolaser_Tower_Defenses"}
		magnapulse = {"Republic_Listening_Post"}
		orbital = {"E_Orbital_Jamming_Station"}
		orbitalscanner = {"Empire_Orbital_Long_Range_Scanner"}
		gravitywell = {"E_Gravity_Well_Station"}
	end
	if EvaluatePerception("Human_Player_Is_Empire", empire) == 1 then
		Game_Message("1_REBEL")
		player_enemy = Find_Player("Rebel")
		player = Find_Player("Empire")
		mines = {"Rebel_Ground_Mining_Facility"}
		barracks = {"R_Ground_Barracks"}
		ltvehfact = {"R_Ground_Light_Vehicle_Factory"}
		hvyvehfact = {"R_Ground_Heavy_Vehicle_Factory"}
		offacademy = {"Cis_Ground_Outpost"}
		research = {"R_Ground_Research_Facility"}
		cantina = {"Ground_Cantina_R"}
		huttpalace = {"Ground_Hutt_Palace_R"}
		baseshield = {"R_Ground_Base_Shield"}
		hypergun = {"Ground_Empire_Hypervelocity_Gun"}
		shutter = {"Confederacy_Ground_Farm"}
		turbolaser = {"R_Galactic_Turbolaser_Tower_Defenses"}
		orbital = {"R_Orbital_Jamming_Station"}
		orbitalscanner = {"Rebel_Orbital_Long_Range_Scanner"}
	end

	tech_level = player_enemy.Get_Tech_Level()
	if tech_level == 1 and tech_timer < 0 then
		Game_Message("1_TECH_2")
		Story_Event("ADVANCE_TECH_2")
		tech_timer = timer2
	end
	if tech_level == 2 and tech_timer < 0 then
		Game_Message("1_TECH_3")
		Story_Event("ADVANCE_TECH_3")
		tech_timer = timer3
	end
	if tech_level == 3 and tech_timer < 0 then
		Game_Message("1_TECH_4")
		Story_Event("ADVANCE_TECH_4")
		tech_timer = timer4
	end
	if tech_level == 4 and tech_timer < 0 then
		Game_Message("1_TECH_5")
		Story_Event("ADVANCE_TECH_5")
		tech_timer = timer5
	end

	current_planet = Find_First_Object(planet_list[index])                         				
	current_planet_owner = current_planet.Get_Owner()
	first_random = GameRandom(1, 7)
	second_random = GameRandom(1, 5)
	third_random = GameRandom(1, 3)

	if current_planet_owner == player_enemy and EvaluatePerception("Current_Planet_Open_Structure_Slots", player_enemy, current_planet) > 1 then
		if EvaluatePerception("Current_Planet_Supports_Cantina", player_enemy, current_planet) > 0 and EvaluatePerception("Current_Planet_Has_Cantina", player_enemy, current_planet) < 1 then
			SpawnList(cantina, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if EvaluatePerception("Current_Planet_Supports_Palace", player_enemy, current_planet) > 0 and EvaluatePerception("Current_Planet_Has_Hutt_Palace", player_enemy, current_planet) < 1 then
			SpawnList(huttpalace, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if first_random == 1 and EvaluatePerception("Current_Planet_Supports_Mines", player_enemy, current_planet) > 0 and EvaluatePerception("Current_Planet_Has_Mines", player_enemy, current_planet) < 1 then
			SpawnList(mines, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if first_random == 2 and EvaluatePerception("Current_Planet_Has_Barracks", player_enemy, current_planet) < 1 and EvaluatePerception("Global_Has_Enough_Barracks", player_enemy, current_planet) > 0 and EvaluatePerception("Current_Planet_Has_Light_Vehicle_Factory", player_enemy, current_planet) < 1 then
			SpawnList(barracks, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if first_random == 3 and EvaluatePerception("Current_Planet_Supports_Light_Vehicle_Factory", player_enemy, current_planet) > 0 and EvaluatePerception("Current_Planet_Has_Light_Vehicle_Factory", player_enemy, current_planet) < 1 then
			SpawnList(ltvehfact, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if first_random == 4 and EvaluatePerception("Current_Planet_Supports_Heavy_Vehicle_Factory", player_enemy, current_planet) > 0 and EvaluatePerception("Current_Planet_Has_Heavy_Vehicle_Factory", player_enemy, current_planet) < 1 and EvaluatePerception("Current_Planet_Has_Light_Vehicle_Factory", player_enemy, current_planet) > 0 then
			SpawnList(hvyvehfact, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if first_random == 5 and EvaluatePerception("Current_Planet_Supports_Adv_Vehicle_Factory", player_enemy, current_planet) > 0 and EvaluatePerception("Current_Planet_Has_Adv_Vehicle_Factory", player_enemy, current_planet) < 1 and EvaluatePerception("Current_Planet_Has_Barracks", player_enemy, current_planet) > 0 and EvaluatePerception("Human_Player_Is_Rebel", rebel) == 1 then
			SpawnList(advvehfact, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if first_random == 6 and EvaluatePerception("Current_Planet_Supports_Officer_Academy", player_enemy, current_planet) > 0 and EvaluatePerception("Current_Planet_Has_Officer_Academy", player_enemy, current_planet) < 1 and EvaluatePerception("Current_Planet_Has_Barracks", player_enemy, current_planet) > 0 then
			SpawnList(offacademy, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if first_random == 7 and EvaluatePerception("Current_Planet_Supports_Research_Center", player_enemy, current_planet) > 0 and EvaluatePerception("Current_Planet_Has_Research_Center", player_enemy, current_planet) < 1 then
			SpawnList(research, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
	end

	if current_planet_owner == player_enemy and EvaluatePerception("Current_Planet_Open_Structure_Slots", player_enemy, current_planet) == 1 then
		if second_random == 1 and EvaluatePerception("Current_Planet_Base_Shield_Built", player_enemy, current_planet) < 1 and EvaluatePerception("Global_Has_Enough_Base_Shield", player_enemy, current_planet) > 0 then
			SpawnList(baseshield, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if second_random == 2 and EvaluatePerception("Current_Planet_Turbolaser_Built", player_enemy, current_planet) < 1 and EvaluatePerception("Global_Has_Enough_Turbolaser", player_enemy, current_planet) > 0 then
			SpawnList(turbolaser, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if second_random == 3 and EvaluatePerception("Current_Planet_Supports_Hypervelocity", player_enemy, current_planet) > 0 and EvaluatePerception("Current_Planet_Has_Hypervelocity", player_enemy, current_planet) < 1 then
			SpawnList(hypergun, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if second_random == 4 and EvaluatePerception("Current_Planet_Supports_Magnapulse", player_enemy, current_planet) > 0 and EvaluatePerception("Current_Planet_Has_Magnapulse", player_enemy, current_planet) < 1 and EvaluatePerception("Human_Player_Is_Rebel", rebel) == 1 then
			SpawnList(magnapulse, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if second_random == 5 and EvaluatePerception("Current_Planet_Supports_Shutter_Shield", player_enemy, current_planet) > 0 and EvaluatePerception("Current_Planet_Planet_Has_Shutter_Shield", player_enemy, current_planet) < 1 then
			SpawnList(shutter, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
	end

	if current_planet_owner == player_enemy and EvaluatePerception("Current_Planet_Space_Structure_Count", player_enemy, current_planet) < 2 then
		if third_random == 1 and EvaluatePerception("Current_Planet_Orbital_Jammer_Built", player_enemy, current_planet) < 1 and EvaluatePerception("Global_Has_Enough_Orbital_Jammer", player_enemy, current_planet) > 0 then
			SpawnList(orbital, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if third_random == 2 and EvaluatePerception("Current_Planet_Orbital_Scanner_Built", player_enemy, current_planet) < 1 and EvaluatePerception("Global_Has_Enough_Orbital_Scanner", player_enemy, current_planet) > 0 then
			SpawnList(orbitalscanner, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
		if third_random == 3 and EvaluatePerception("Current_Planet_Gravity_Well_Built", player_enemy, current_planet) < 1 and EvaluatePerception("Global_Has_Enough_Gravity_Well", player_enemy, current_planet) > 0 and EvaluatePerception("Human_Player_Is_Rebel", rebel) == 1 then
			SpawnList(gravitywell, current_planet, player_enemy, false, false)
			Sleep(build_sleep)
		end
	end

	if index == 64 then
		Game_Message("1_PLANETS")									
		index = 1
	else
		index = index + 1
	end
	
	first_random = nil
	second_random = nil
	third_random = nil
	tech_timer = tech_timer - 1
	credits = 1
	
end


