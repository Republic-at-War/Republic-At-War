-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Library/PGEvents.lua#20 $
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
-- (C) Petroglyph Games, Inc.
--
--
--  *****           **                          *                   *
--  *   **          *                           *                   *
--  *    *          *                           *                   *
--  *    *          *     *                 *   *          *        *
--  *   *     *** ******  * **  ****      ***   * *      * *****    * ***
--  *  **    *  *   *     **   *   **   **  *   *  *    * **   **   **   *
--  ***     *****   *     *   *     *  *    *   *  *   **  *    *   *    *
--  *       *       *     *   *     *  *    *   *   *  *   *    *   *    *
--  *       *       *     *   *     *  *    *   *   * **   *   *    *    *
--  *       **       *    *   **   *   **   *   *    **    *  *     *   *
-- **        ****     **  *    ****     *****   *    **    ***      *   *
--                                          *        *     *
--                                          *        *     *
--                                          *       *      *
--                                      *  *        *      *
--                                      ****       *       *
--
--/////////////////////////////////////////////////////////////////////////////////////////////////
-- C O N F I D E N T I A L   S O U R C E   C O D E -- D O   N O T   D I S T R I B U T E
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Library/PGEvents.lua $
--
--    Original Author: Brian Hayes
--
--            $Author: James_Yarrow $
--
--            $Change: 56734 $
--
--          $DateTime: 2006/10/24 14:15:48 $
--
--          $Revision: #20 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

--
-- Default Event Handlers.
--

require("PGTaskForce")

function GoHeal(tf, unit, healer, release)
	
	--If we can lay proximity mines, do so and then rely on a further call to kite the enemy over them
	--Add a random factor here since proximity mines currently have no cooldown and so we'll never run
	--because we can always use them
	if (GameRandom.Get_Float() > 0.5) and Try_Ability(unit, "PROXIMITY_MINES", unit) then
		return
	end
	
	if Try_Ability(unit, "BUZZ_DROIDS", unit) then
		return
	end
		
	if release then
		Try_Ability(unit,"JET_PACK", healer)
		Try_Ability(unit,"SPRINT")
		Try_Ability(unit, "FORCE_CLOAK")
		Try_Ability(unit, "STEALTH")
		unit.Move_To(healer, 10)
		unit.Lock_Current_Orders()
		tf.Release_Unit(unit)
	else
		Try_Ability(unit,"JET_PACK", healer)
		Try_Ability(unit,"SPRINT")
		Try_Ability(unit, "FORCE_CLOAK")
		Try_Ability(unit, "STEALTH")
		unit.Divert(healer)
	end
end

function GoKite(tf, unit, kite_pos, release)
	
	--If we can lay proximity mines, do so and then rely on a further call to kite the enemy over them
	--Add a random factor here since proximity mines currently have no cooldown and so we'll never run
	--because we can always use them
	if (GameRandom.Get_Float() > 0.5) and Try_Ability(unit, "PROXIMITY_MINES", unit) then
		return
	end
	
	if Try_Ability(unit, "BUZZ_DROIDS", unit) then
		return
	end
	
	if release then
		Try_Ability(unit,"Turbo") -- Enable Turbo mode, if we have it.
		Try_Ability(unit,"JET_PACK", kite_pos)
		Try_Ability(unit,"EJECT_VEHICLE_THIEF")
		Try_Ability(unit,"SPRINT")
		Try_Ability(unit, "SPOILER_LOCK")
		Try_Ability(unit, "REPLENISH_WINGMEN")
		Try_Ability(unit, "FORCE_CLOAK")
		Try_Ability(unit, "STEALTH")
		if unit.Get_Hull() > 0.5 then
			Try_Ability(unit, "STIM_PACK")
		end

		unit.Move_To(kite_pos)
		unit.Lock_Current_Orders()
		tf.Release_Unit(unit)
	else
		if not unit.Is_On_Diversion() then
			--MessageBox("%s -- Diverting: %s", tostring(Script), tostring(unit))
			Try_Ability(unit,"Turbo") -- Enable Turbo mode, if we have it.
			Try_Ability(unit,"JET_PACK", kite_pos)
			Try_Ability(unit,"EJECT_VEHICLE_THIEF")
			Try_Ability(unit,"SPRINT")
			Try_Ability(unit, "SPOILER_LOCK")
			Try_Ability(unit, "REPLENISH_WINGMEN")
			Try_Ability(unit, "FORCE_CLOAK")
			Try_Ability(unit, "STEALTH")
			if unit.Get_Hull() > 0.5 then
				Try_Ability(unit, "STIM_PACK")
			end
		
			unit.Divert(kite_pos)
		end
	end
end

function Try_Good_Ground(tf, unit)
	
	nearest_good_ground_indicator = Find_Nearest(unit, "Prop_Good_Ground_Area")
	if nearest_good_ground_indicator then
		dist_to_good_ground = unit.Get_Distance(nearest_good_ground_indicator)
		if (dist_to_good_ground < 300) and (dist_to_good_ground > 20) then

			unit.Activate_Ability("SPREAD_OUT", false)
			unit.Move_To(nearest_good_ground_indicator)
			unit.Lock_Current_Orders()
			tf.Release_Unit(unit)
			return true
		end
	end
	
	return false
end

-- This should be useful for getting units within the minimum attack range
-- or outside the maximum attack range on opponents who behave like artillery
function Respond_To_MinRange_Attacks(tf, unit)

	DebugMessage("%s-- looking at attacker for minrange response", tostring(Script))

	min_range_attackers = {
		"R_Ground_Turbolaser_Tower"
		,"E_Ground_Turbolaser_Tower"
		,"Heavy_Artillery_Gun"
		,"AV_7_Antivehicle_Cannon"
		,"Republic_light_assault_cruiser"
		,"Republic_Victory_Destroyer"
		}

	deadly_enemy = FindDeadlyEnemy(unit)
	if TestValid(deadly_enemy) then
		deadly_enemy_type = deadly_enemy.Get_Type()
		if Is_Type_In_List(deadly_enemy_type, min_range_attackers) then
			DebugMessage("%s -- attacked by min range attacker", tostring(Script))
			
			-- Move any units in the task force which are in range of the attacker 
			-- to a position over the max range or under the min range
			approach_or_flee_range = ((deadly_enemy_type.Get_Max_Range() - deadly_enemy_type.Get_Min_Range()) * 2 / 3) + deadly_enemy_type.Get_Min_Range()
			for i, tf_unit in pairs(tf.Get_Unit_Table()) do
				DebugMessage("%s -- considering run or approach for %s", tostring(Script), tostring(tf_unit))
				distance = tf_unit.Get_Distance(deadly_enemy)
				if distance < deadly_enemy_type.Get_Max_Range() then
					if distance < approach_or_flee_range then
						DebugMessage("%s -- trying to run inside min attack range", tostring(Script))
						tf_unit.Move_To(deadly_enemy)
						tf_unit.Lock_Current_Orders()
						tf.Release_Unit(unit)
					else
						DebugMessage("%s -- trying to run outside max attack range", tostring(Script))
						GoKite(tf, tf_unit, Project_By_Unit_Range(deadly_enemy, tf_unit))
					end
				end
			end
			
			return true
		end
	end
	
	return false
end


function Is_Type_In_List(unit_type, type_name_list)
	for i, type_name in pairs(type_name_list) do
		DebugMessage("%s -- type:%s checking match to:%s", tostring(Script), unit_type.Get_Name(), type_name)
		if unit_type == Find_Object_Type(type_name) then
			return true
		end
	end
	return false
end

-- Check if the passed ability is one of the type that the AI wants to turn back on when cancelled
function IsAbilityAllowedToRecover(ability)
	allowed_abilities = {
		"SPOILER_LOCK"
		,"Turbo"
	}
	
	for i, allowed_ability in pairs(allowed_abilities) do
		if ability == allowed_ability then
			return true
		end
	end
	
	return false
end

function Default_Space_Conflict_Begin()
	DebugMessage("%s -- In Default_Space_Conflict_Begin.", tostring(Script))
	InSpaceConflict = true
	GlobalValue.Set(PlayerSpecificName(PlayerObject, "CONTACT_OCCURED"), 0.0)
end

function Default_Space_Conflict_End()
	DebugMessage("%s -- In Default_Space_Conflict_End.", tostring(Script))
	InSpaceConflict = false
	GlobalValue.Set(PlayerSpecificName(PlayerObject, "CONTACT_OCCURED"), 0.0)
end

function Default_Unit_Destroyed()
	DebugMessage("%s -- In Default_Unit_Destroyed.", tostring(Script))
end

function Default_Unit_Damaged(tf, unit, attacker, deliberate)
	DebugMessage("%s -- In Default_Unit_Damaged.", tostring(Script))
	
	if not TestValid(unit) or not TestValid(attacker) or attacker.Is_Category("Structure") then
		return
	end

	lib_issued_movement_response = false
	
	-- all units but Interdictors try to maneuver against artillery and turbolasers
	-- Interdictors should use missile shield instead
    if unit.Get_Type() ~= Find_Object_Type("Interdictor_Cruiser") then
		lib_issued_movement_response = Respond_To_MinRange_Attacks(tf, unit)
	end
		
	if Should_Crush(unit, attacker) then
		unit.Divert(Project_By_Unit_Range(unit, attacker))
		lib_issued_movement_response = true
	end
	
	-- If the unit is infantry, try to use any nearby garrisons or "good ground"
	if unit.Is_Category("Infantry") then
	
		if not lib_issued_movement_response then
			lib_issued_movement_response = Try_Garrison(tf, unit, unit.Get_Hull() > 0.4, 300.0)
		end
	
		if not lib_issued_movement_response then
			lib_issued_movement_response = Try_Good_Ground(tf, unit)
		end
		
	end
	
	if attacker.Is_Category("Infantry") then
		Try_Deploy_Garrison(unit, attacker, 0.5)
	end

	-- Use "Power to Shields" if this unit has it and it's ready
	lib_ability_activated = false
	lib_shield_level = unit.Get_Shield()
	if lib_shield_level < 0.2 then
		lib_ability_activated = Try_Ability(unit, "INVULNERABILITY")
	end
	
	if (not lib_ability_activated) and (lib_shield_level < 0.8) then
		lib_ability_activated = Try_Ability(unit, "Defend")
	end

	projectile_type = attacker.Get_Current_Projectile_Type()
	if TestValid(projectile_type) then
		if (not lib_ability_activated) and projectile_type.Is_Affected_By_Missile_Shield() then
			lib_ability_activated = Try_Ability(unit, "SENSOR_JAMMING") or Try_Ability(unit, "MISSILE_SHIELD")
		end
		
		if (not lib_ability_activated) and projectile_type.Is_Affected_By_Laser_Defense() then
			lib_ability_activated = Try_Ability(unit, "LASER_DEFENSE")
		end
	end

	--Everything below deals with movement orders
	if lib_issued_movement_response then
		return
	end

	-- non-hero fighters will always willingly dogfight other fighters
	if deliberate and attacker.Is_Category("Fighter") and unit.Is_Category("Fighter") then

		DebugMessage("%s -- Fighter shot by fighter, releasing unit from tf and attacking.", tostring(Script))
		tf.Release_Unit(unit)
		unit.Activate_Ability("SPOILER_LOCK", false)
		if not unit.Activate_Ability("BUZZ_DROIDS", attacker) then
			unit.Attack_Target(attacker)
		end
		
	-- Default handling for a dying unit in both space and land modes.
	-- Is this unit not fodder AND do we have low health AND (we have a bad face off OR we're rapidly being killed for any reason)
	else
		
		lib_time_till_dead = unit.Get_Time_Till_Dead()
		lib_attacker_is_good_vs_me = attacker.Is_Good_Against(unit)
		lib_i_am_good_vs_attacker = unit.Is_Good_Against(attacker)
		lib_current_health = unit.Get_Hull()
		lib_is_hero = unit.Get_Type().Is_Hero()
		lib_is_fodder = unit.Has_Property("Fodder")
		
		if not lib_i_am_good_vs_attacker then
			Try_Ability(unit, "DEPLOY_TROOPERS")
		end
		
		if ((not lib_is_fodder) and lib_time_till_dead < 20) or
			((not lib_is_fodder) and lib_current_health < 0.2) or
			(lib_is_hero and lib_current_health < 0.6) or
			(lib_current_health < 0.7 and lib_attacker_is_good_vs_me) or
			(lib_current_health < 0.4 and not lib_i_am_good_vs_attacker) then

			--Certain factions have no self-preservation
			lib_faction_name = unit.Get_Owner().Get_Faction_Name()
			if lib_faction_name == "PIRATES" or lib_faction_name == "HUTTS" then
				return
			end

			-- Turn off any abilities that would hinder self-preservation
			unit.Activate_Ability("Power_To_Weapons", false)

			-- Try to find the nearest healing structure appropriate for this unit
			lib_healer_property_flag = Get_Special_Healer_Property_Flag(unit)
			if not lib_healer_property_flag then
				if unit.Is_Category("Infantry") then
					lib_healer_property_flag = "HealsInfantry"
				elseif unit.Is_Category("Vehicle") then
					lib_healer_property_flag = "HealsVehicles"
				end 
			end
			
			if lib_healer_property_flag then
				healer = Find_Nearest(unit, lib_healer_property_flag, PlayerObject, true)
			end
			
			lib_should_release = lib_attacker_is_good_vs_me or lib_is_hero or (lib_current_health < 0.33)
			
			-- Try to heal if we have a healer
			if healer then
				GoHeal(tf, unit, healer, lib_should_release)
			end

			if not lib_is_fodder then
				-- Try to find a protected kiting location
				friendly = Find_Nearest(unit, PlayerObject, true)
				xfire_pos = Get_Most_Defended_Position(unit, PlayerObject)
				if xfire_pos then
					kite_pos = Project_By_Unit_Range(attacker, xfire_pos)
				elseif TestValid(friendly) then
					DebugMessage("Failed to find a Most Defended Position, using position of nearby friendly.")
					kite_pos = Project_By_Unit_Range(attacker, friendly)
				else
					kite_pos = Project_By_Unit_Range(attacker, unit)
				end

				GoKite(tf, unit, kite_pos, lib_should_release)
			end

		end
	end
end

function Default_Original_Target_Destroyed()
	--DebugMessage("%s -- Original target destroyed.  Aborting.", tostring(Script))
	Attacking = false
	--ScriptExit() Some plans now have behaviors to occur after this event.
end

function Default_Current_Target_Destroyed(tf)
	--MessageBox("%s -- Current target destroyed.  Aborting.", tostring(Script))
	Attacking = false
	
	-- Turn off some unending abilities that might no longer be appropriate
	tf.Activate_Ability("SPREAD_OUT", false)

	--ScriptExit() Some plans now have behaviors to occur after this event.
end

function Default_Original_Target_Owner_Changed(tf, old_player, new_player)
	if InvasionActive == true then
		return
	end
	
	DebugMessage("%s -- Original target ownership changed.  Aborting.", tostring(Script))
	ScriptExit()
end

function Default_Unit_Move_Finished(tf, unit)
	Try_Deploy_Garrison(unit, nil, 0.5)
end


function Should_Crush(unit, target)

	-- don't crush in easy mode
	if (PlayerObject.Get_Difficulty() == "Easy") then
		return false
	end
	
	-- don't try to crush again if already on a diversion
	if unit.Is_On_Diversion() then
		return false
	end
		
	-- if the vehicle is good at it, the victim is infantry, and vulnerable to crushing
	if	unit.Has_Property("GoodInfantryCrusher") and target.Is_Category("Infantry") then
		if target.Is_Ability_Active("SPREAD_OUT") then
			return true
		elseif GameRandom.Get_Float() > 0.8 then
			return true
		end
	end
		
	-- if the vehicle can crush anything and is close enough			
	if unit.Has_Property("IsSupercrusher") and (unit.Get_Distance(target) < 75) then
		return true
	end
	
	return false
end


function Default_Target_In_Range(tf, unit, target)
	--MessageBox("%s -- unit:  Default_Target_In_Range for: %s.", tostring(Script), tostring(unit), tostring(target))

	-- We'll assume that once the first unit within a task force is in range, the attack has begun.
	Attacking = true

	-- Certain units like to try to crush other units, but we can't crush Rebel units that are spread out
	if Should_Crush(unit, target) then
		DebugMessage("%s -- Attempting to crush %s with %s", tostring(Script), tostring(target), tostring(unit))
		unit.Divert(Project_By_Unit_Range(unit, target))
	end
    
    Try_Deploy_Garrison(unit, target, 0.5)
    
	-- Turn various abilities that would be useful.  
	-- The ability time-out or the plan ending will turn off the ability.
	Try_Ability(unit,"Power_To_Weapons")
	Try_Ability(unit,"SPREAD_OUT")
	Try_Ability(unit, "BARRAGE", target)
	Try_Ability(unit, "BUZZ_DROIDS", target)
	Try_Ability(unit, "FULL_SALVO")

	if unit.Get_Hull() > 0.5 then
		Try_Ability(unit, "STIM_PACK")
	end	
	
	Try_Weapon_Switch(unit, target)

	GlobalValue.Set(PlayerSpecificName(PlayerObject, "CONTACT_OCCURED"), 1.0)
end

function Default_Hardpoint_Target_In_Range(tf, unit, target)
	DebugMessage("%s -- A hardpoint of %s can now fire on target %s.", tostring(Script), tostring(unit), tostring(attacker))
end

function Default_No_Units_Remaining()
	DebugMessage("%s -- All units dead or non-buildable.  Abandonning plan.", tostring(Script))
	ScriptExit()
end

function Default_Unit_Diversion_Finished(tf, unit)

	if TestValid(unit) then
		-- Turn off turbo, if we happened to be using it to assist in a divert (evasive maneuver).
		unit.Activate_Ability("Turbo", false)	
		unit.Activate_Ability("SPOILER_LOCK", false)
	end
end

-- This fires if the countdown was going and it is now refreshed or if you come out of a nebula
function Default_Unit_Ability_Ready(tf, unit, ability)

	--MessageBox("%s ready for %s", ability, tostring(unit))
	
	-- Try to recover use of interrupted abilities.
	if lib_cancelled_abilities[unit] and lib_cancelled_abilities[unit][ability] then
		--MessageBox("%s-- attempting to recover use of %s", tostring(Script), ability)
		unit.Activate_Ability(ability, true)
		lib_cancelled_abilities[unit][ability] = false
	end
end

-- An ability was interrupted before naturally finishing.
function Default_Unit_Ability_Cancelled(tf, unit, ability)
	DebugMessage("%s -- Ability %s of %s has been cancelled!", tostring(Script), ability, tostring(unit))

	-- Track certain abilities that get cancelled, so we can recover them later
	if IsAbilityAllowedToRecover(ability) then
	
		-- make a new ability table for this unit, if one doesn't yet exist
		if not lib_cancelled_abilities[unit] then
			lib_cancelled_abilities[unit] = {}
		end
		
		lib_cancelled_abilities[unit][ability] = true
	end
end

-- An ability finished naturally by its duration running out or by being turned off.
function Default_Unit_Ability_Finished(tf, unit)
	--DebugMessage("%s -- An ability for %s has finished!", tostring(Script), ability, tostring(unit))
end
