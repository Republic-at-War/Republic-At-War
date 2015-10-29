-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Library/PGTaskForce.lua#6 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Library/PGTaskForce.lua $
--
--    Original Author: Brian Hayes
--
--            $Author: James_Yarrow $
--
--            $Change: 46700 $
--
--          $DateTime: 2006/06/21 14:40:55 $
--
--          $Revision: #6 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGAICommands")

function FindStageArea(_target, taskforce)
	return _FindStageArea(PlayerObject, _target, taskforce);
end

function AssembleForce(taskforce, stage_at_strongest_space)
	if stage_at_strongest_space then
		stage = FindTarget.Reachable_Target(PlayerObject, "FriendlySpaceForceStrength", "Friendly | Enemy | Neutral", "Enemy_undefended", 1.0, AITarget)
		DebugMessage("%s -- Using the enemy_undefended reachable system %s with the strongest space force for staging.", tostring(Script), tostring(stage))
	else
		stage = taskforce.Get_Stage()
		DebugMessage("%s -- Using default system %s (nearest faction system) for staging.", tostring(Script), tostring(stage))
	end
	
	if not stage then 
		DebugMessage("%s -- Unable to find a staging area.  Abandonning plan.", tostring(Script))
		ScriptExit()
	end
	DebugMessage("%s -- Selected Stage: %s\n", tostring(Script), tostring(stage))
	BlockOnCommand(taskforce.Produce_Force(stage));
end

function SynchronizedAssemble(taskforce, stage_at_strongest_space)
	if stage_at_strongest_space then
		stage = FindTarget(taskforce, "FriendlySpaceForceStrength", "Friendly | Enemy | Neutral", 1.0)
		DebugMessage("%s -- Using the system %s with the strongest space force for staging.", tostring(Script), tostring(stage))
	else
		stage = taskforce.Get_Stage()
		DebugMessage("%s -- Using default system %s (nearest faction system) for staging.", tostring(Script), tostring(stage))
	end
	
	if not stage then 
		DebugMessage("%s -- Unable to find a staging area.  Abandonning plan.", tostring(Script))
		ScriptExit()
	end
	DebugMessage("%s -- Selected Stage: %s\n", tostring(Script), tostring(stage))
	BlockOnCommand(taskforce.Produce_Force(stage, true));
end

function WaitMoveForce(taskforce, planet)
	DebugMessage("Moving Taskforce %s to object %s.", tostring(taskforce), tostring(planet))
	BlockOnCommand(taskforce.Move_To(FindPlanet(planet)))
	DebugMessage("Moving Command finished")
end

function LandUnits(taskforce)
	DebugMessage("Landing on %s with taskforce %s.", tostring(Target), tostring(taskforce))
	BlockOnCommand(taskforce.Land_Units())
	DebugMessage("Land Units Command finished")
end

function LaunchUnits(taskforce)
	DebugMessage("Launching units into orbit with taskforce %s.", tostring(taskforce))
	
	block = taskforce.Launch_Units()
	if not block then
		return false
	end
	BlockOnCommand(block)
	BlockOnCommand(taskforce.Form_Units())
	DebugMessage("Launch Units Command finished")
	
	return true
end

function Invade(taskforce)
	DebugMessage("Invading %s with taskforce %s.", tostring(Target), tostring(taskforce))

	InvasionActive = true
	invade_status = taskforce.Invade()
	if invade_status and BlockOnCommand(invade_status) then
		DebugMessage("Invasion successful.  Waiting for planet conversion.");
		taskforce.Set_As_Goal_System_Removable(false)
		LandUnits(taskforce)
		InvasionActive = false
		return true
	else
		DebugMessage("Invasion failed!")
		InvasionActive = false
		return false
	end
end

function FundBases(player, target)

	--Prefer starbases since they block enemy movement
	DebugMessage("%s -- giving desire bonus to build starbase", tostring(Script))
	BlockOnCommand(GiveDesireBonus(player, "Build_Initial_Starbase_Only", target, 15, 5)) 
	DebugMessage("%s -- waiting for starbase", tostring(Script))
	BlockOnCommand(WaitForStarbase(Target, 1))
	DebugMessage("%s -- giving desire bonus to build groundbase", tostring(Script))
	BlockOnCommand(GiveDesireBonus(player, "Build_Initial_Groundbase_Only", target, 15, 5))
end


-- Generally follow the task force we're escorting and attack it's attackers.
-- Conservative style will avoid confrontation with non fighters/bombers
function Escort(taskforce, target, conservative_style)

	if not TestValid(target) then
		Sleep(1)
		return 
	end
	
	lib_enemy = FindDeadlyEnemy(target)
	
	if lib_enemy then
		if Get_Game_Mode() == "Space" then
			if not conservative_style or (lib_enemy.Is_Category("Fighter") or lib_enemy.Is_Category("Bomber")) then
	
				-- Lure them away from our escorted target if we can.
				Try_Ability(taskforce,"LURE")
				
				-- Weave a bit.
				Weave(taskforce, lib_enemy)
	
				-- engage the attackers for a duration
				if not TestValid(lib_enemy) then return end
				DebugMessage("%s -- In Escort: Attacking lib_enemy: %s for Target: %s", tostring(Script), tostring(lib_enemy), tostring(target))
				BlockOnCommand(taskforce.Attack_Target(lib_enemy), 15)
			else
			
				-- run away a bit, then hold ground before resuming escort
				DebugMessage("%s -- In Escort: attempting to divert lib_enemy: %s for Target: %s", tostring(Script), tostring(lib_enemy), tostring(target))
				BlockOnCommand(taskforce.Move_To(Project_By_Unit_Range(lib_enemy, taskforce)), 15)
				
				if not TestValid(target) then return end
				
				BlockOnCommand(taskforce.Guard_Target(target, 5))
			end
		else 
			BlockOnCommand(taskforce.Attack_Target(lib_enemy), 20)
		end
		return
	end

	if not TestValid(target) then
		Sleep(1)
		return 
	end
    
	-- Make sure we're assisting the target provided we're not already assisting
	-- because reissuing a guard will cause the assisting escort to break off attack.
	-- Note: may receive a non tf "target" param, for example EscortPlan passes a unit
	if not Tf_Has_Attack_Target(taskforce) then
		
		-- Escort forces should have attack priorities that allow them to attack structures by this point
		DebugMessage("%s on %s -- In Escort: Resuming escort of %s", tostring(Script), tostring(AITarget), tostring(target))
		taskforce.Guard_Target(target)
	end
	
	Sleep(1)
end


-- Does any member of the given task force have an attack target?
function Tf_Has_Attack_Target(tf)

	if TestValid(tf) then 
		for i, unit in tf.Get_Unit_Table() do
			if unit.Has_Attack_Target() == true then
				return true
			end
		end
	else
		DebugMessage("%s -- task force %s isn't valid", tostring(Script), tostring(tf))
	end
	
	return false
end

function Weave(tf, enemy)
	if not TestValid(enemy) then return end
	BlockOnCommand(tf.Attack_Target(enemy), 10)
	if not TestValid(enemy) then return end
	BlockOnCommand(tf.Move_To(Project_By_Unit_Range(enemy, tf)), 5)
	if not TestValid(enemy) then return end
	BlockOnCommand(tf.Attack_Target(enemy), 2)
	if not TestValid(enemy) then return end
	BlockOnCommand(tf.Move_To(Project_By_Unit_Range(enemy, tf)), 4)
end

function WaitForAllReinforcements(taskforce, target)
	block = taskforce.Reinforce(target)
	if block then
		while block and not BlockOnCommand(block) do
			block = taskforce.Reinforce(target)
		end
	end
end



-- Keep a task force from being idle
-- expects lib_tf_to_anti_idle and lib_enemy_to_avoid to be defined before use
function Anti_Idle_Taskforce()
	DebugMessage("%s-- AntiIdle attempt", tostring(Script))
	if lib_tf_to_anti_idle and TestValid(lib_enemy_to_avoid) then
		DebugMessage("%s-- AntiIdle lib vars are defined", tostring(Script))

		if lib_new_anti_idle == true then
			DebugMessage("%s-- AntiIdling %s", tostring(Script), tostring(lib_tf_to_anti_idle))
			lib_anti_idle_start_time = GetCurrentTime()
			lib_anti_idle_block = lib_tf_to_anti_idle.Move_To(Project_By_Unit_Range(lib_enemy_to_avoid, lib_tf_to_anti_idle))
			lib_new_anti_idle = false 
		elseif lib_anti_idle_block then
			PumpEvents()
			
			-- Reissue a new command if the old one has expired or some time has passed
			-- This ensures that newly landed reinforcements on the task force will also anti-idle
			if lib_anti_idle_block.IsFinished() == true
				or 2 + lib_anti_idle_start_time < GetCurrentTime() then
				lib_new_anti_idle = true
			end
		end
	else
		DebugMessage("%s-- needed global vars aren't defined for anti idle", tostring(Script))
	end
end


-- Try to get units on the map in the most reasonable manner.
-- Passing an escort_force is optional
function QuickReinforce(player, target, tf_to_reinforce, second_try_tf)

	if not player then
		DebugMessage("%s-- received nil player", tostring(Script))
		return 
	end

-- Global plans can pass a nil target and rely on failsafes below to find a target
--	if not target then
--		DebugMessage("%s-- received nil target", tostring(Script))
--		return 
--	end

	if not tf_to_reinforce then
		DebugMessage("%s-- received nil tf_to_reinforce", tostring(Script))
		return 
	end

	
	-- Space mode will attempt various reinforce attempts with timeouts,
	-- then simply fail after the last option is exhausted.
	if Get_Game_Mode() == "Space" then

		lib_reinforce_timeout = 3
	
		-- If some units have landed, try land the remainder near the rest of the main tf
		if tf_to_reinforce.Get_Force_Count() ~= 0 then
	
			-- Define some global vars for the anti idle
			lib_tf_to_anti_idle = tf_to_reinforce
			lib_enemy_to_avoid = Find_Nearest(tf_to_reinforce, PlayerObject, false)
			lib_new_anti_idle = true
	
			-- Reinforce new units and anti-idle existing units waiting for the reinforce
			if BlockOnCommand(tf_to_reinforce.Reinforce(tf_to_reinforce), lib_reinforce_timeout, Anti_Idle_Taskforce) then
				DebugMessage("%s-- reinforced by task force", tostring(Script))
				lib_tf_to_anti_idle = nil
				lib_enemy_to_avoid = nil
				return
			end
		end
	
		-- If some of the escort force exists, try to land there
		if second_try_tf and second_try_tf.Get_Force_Count() ~= 0 then
	
			-- Define some global vars for the anti idle
			lib_tf_to_anti_idle = second_try_tf
			lib_enemy_to_avoid = Find_Nearest(second_try_tf, PlayerObject, false)
			lib_new_anti_idle = true
	
			-- Reinforce new units and anti-idle existing units waiting for the reinforce
			if BlockOnCommand(tf_to_reinforce.Reinforce(second_try_tf), lib_reinforce_timeout, Anti_Idle_Taskforce) then
				DebugMessage("%s-- reinforced by secondary task force", tostring(Script))
				lib_tf_to_anti_idle = nil
				lib_enemy_to_avoid = nil
				return
			end
		end
	
		-- Try to land near the default starting point, or some base building, or finally the target itself.
		lib_start_loc = FindTarget(tf_to_reinforce, "Is_Friendly_Start", "Tactical_Location", 1.0)
		if lib_start_loc then
			DebugMessage("%s-- Trying to reinforce by start point", tostring(Script))
			BlockOnCommand(tf_to_reinforce.Reinforce(lib_start_loc), lib_reinforce_timeout)
		else
			lib_base_list = Find_All_Objects_Of_Type(player, "Structure")
			if lib_base_list[1] then
				DebugMessage("%s-- Trying to reinforce by friendly structure", tostring(Script))
				BlockOnCommand(tf_to_reinforce.Reinforce(lib_base_list[1]), lib_reinforce_timeout)
			else
				lib_base_list = Find_All_Objects_Of_Type(player, "Capital")
				if lib_base_list[1] then
					DebugMessage("%s-- Trying to reinforce by friendly capital", tostring(Script))
					BlockOnCommand(tf_to_reinforce.Reinforce(lib_base_list[1]), lib_reinforce_timeout)
				else
					DebugMessage("%s-- Trying to reinforce by plan target", tostring(Script))
					BlockOnCommand(tf_to_reinforce.Reinforce(target), lib_reinforce_timeout)
				end
			end
		end
		
		-- If we were unable to bring in any reinforcements within a reasonable amount of time
		-- then just abandon the plan; it's not worth holding up other units for too long
		if tf_to_reinforce.Get_Force_Count() == 0 then
			ScriptExit()
		end
	
	-- Land mode: this will just return if the units are all available; 
	-- otherwise we'll reinforce for a long time and then the plan will fail because it may no longer be relevant.
	else
	
		if tf_to_reinforce.Are_All_Units_On_Free_Store() then
			
			DebugMessage("%s-- All units available, proceeding with plan", tostring(Script))

			-- form up any spread out infantry
			tf_to_reinforce.Activate_Ability("SPREAD_OUT", false)
		else

			DebugMessage("%s-- Reinforcements required--waiting for them.", tostring(Script))

			-- Generally, we want things reinforced near the target, if possible
			-- But this will try all of the reinforcement points, if needed.
			-- This typically takes a long time.
			if AITarget then
				WaitForAllReinforcements(tf_to_reinforce, target)
			else
				
				-- find something to reinforce near, for global plans with a nil target
				friendly_loc = FindTarget(tf_to_reinforce, "Space_Area_Is_Hidden", "Tactical_Location", 1.0)
				WaitForAllReinforcements(tf_to_reinforce, friendly_loc)
			end			

			--WaitForAllReinforcements(tf_to_reinforce, tf_to_reinforce)
			DebugMessage("%s-- Reinforcements arrived.  Abandonning plan for reproposal if still relevant", tostring(Script))

			-- If the plan is still relevant, it will be proposed again.
			ScriptExit()
		end
	end

end





function SetClassPriorities(tf, priority_set_type)

	priority_set_name = "Fighter" .. "_" .. priority_set_type
	tf.Set_Targeting_Priorities(priority_set_name, "Fighter")

	priority_set_name = "Bomber" .. "_" .. priority_set_type
	tf.Set_Targeting_Priorities(priority_set_name, "Bomber")

	priority_set_name = "Corvette" .. "_" .. priority_set_type
	tf.Set_Targeting_Priorities(priority_set_name, "Corvette")

	priority_set_name = "Frigate" .. "_" .. priority_set_type
	tf.Set_Targeting_Priorities(priority_set_name, "Frigate")

	priority_set_name = "Capital" .. "_" .. priority_set_type
	tf.Set_Targeting_Priorities(priority_set_name, "Capital")

end


-- Move task force to asteroids or nebulae if within range and the asteroids aren't near an enemy
-- Returns true if the task force is already obscured or this function obscured it
function Obscure(tf, range, use_nebulae, path_through_fields)
	tf_unit_list = tf.Get_Unit_Table()
	if not UnitListIsObscured(tf_unit_list) then
		asteroids = Find_Nearest_Space_Field(tf, "Asteroid")
		
		if asteroids and tf.Get_Distance(asteroids) < range then
			enemy_nearest_loc = Find_Nearest(asteroids, PlayerObject, false)
			if not TestValid(enemy_nearest_loc) or enemy_nearest_loc.Get_Distance(asteroids) < 750 then

				--MessageBox("%s -- moving to asteroids:%s", tostring (Script), path_through_fields)
				BlockOnCommand(tf.Move_To(asteroids, 10, path_through_fields))
				return true
			end
		elseif use_nebulae then
			nebula = Find_Nearest_Space_Field(tf, "Nebula")
			if nebula and tf.Get_Distance(nebula) < range then
				enemy_nearest_loc = Find_Nearest(nebula, PlayerObject, false)
				if not TestValid(enemy_nearest_loc) or enemy_nearest_loc.Get_Distance(nebula) < 750 then

					--MessageBox("%s -- moving to nebulae:%s", tostring (Script), path_through_fields)
					BlockOnCommand(tf.Move_To(nebula, 10, path_through_fields))
					return true
				end	
			end
		end
		return false -- We're not obscured, and there's nothing in range to obscure us.
	end
	
	return true
end


-- Fix the unit or hide if appropriate.
-- Return true if the unit was fixed.
function ConsiderHeal(unit)
	unit_hull = unit.Get_Hull()
	if (unit_hull < 0.8) then
		bacta = Find_Nearest(unit, "HealsInfantry", PlayerObject, true)
		if TestValid(bacta) then
			if (unit_hull < 0.4) or (unit.Get_Distance(bacta) < 700) then
				unit.Activate_Ability("STEALTH", true)
				unit.Activate_Ability("FORCE_CLOAK", true)
				BlockOnCommand(unit.Move_To(bacta))
				while unit.Get_Hull() < 0.9 do
					DebugMessage("%s-- Waiting to heal", tostring(Script))
					BlockOnCommand(unit.Guard_Target(bacta), 2)
				end
				return true
			end
		end
	end
	return false		
end

-- Fix the unit or hide if appropriate.
-- Return true if the unit was fixed.
function ConsiderRepair(unit)
	unit_hull = unit.Get_Hull()
	if (unit_hull < 0.8) then
		repair_station = Find_Nearest(unit, "HealsVehicles", PlayerObject, true)
        if TestValid(repair_station) then 
			if (unit_hull < 0.4) or (unit.Get_Distance(repair_station) < 700) then
		
				BlockOnCommand(unit.Move_To(repair_station))
				while unit.Get_Hull() < 0.9 do
					BlockOnCommand(unit.Guard_Target(repair_station), 2)
				end
				return true
			end
		end
	end
	return false
end

-- Note, this is safe for event response (because it doesn't block)
function Release_To_Hide(tf, unit)

	flee_loc = Find_Nearest(unit, "HealsInfantry", PlayerObject, true)
	if not flee_loc then
		flee_loc = FindTarget(tf, "Space_Area_Is_Hidden", "Tactical_Location", 1.0, 5000.0)
	end
	if flee_loc then
		unit.Move_To(flee_loc)
		unit.Lock_Current_Orders()
		tf.Release_Unit(unit)
		return true
	end
end


-- This is for some give and take pacing.  The AI is allowed to attack without difficulty-based pause
-- 1 to N times, then it must wait for the player to win 1 to N times before attacking without pause.
function GalacticAttackAllowed(difficulty, ai_territories_just_gained)

	num_ai_attacks_left = GetGlobalValueOrZero(PlayerObject, "num_ai_attacks_left")
	if num_ai_attacks_left > 0 then

		-- If the AI has allowed attacks left, permit the attack and decrement
		GlobalValue.Set(PlayerSpecificName(PlayerObject, "num_ai_attacks_left"), num_ai_attacks_left - 1)
		--MessageBox("%s -- ai has %d attacks left; not pausing before next attack", tostring(Script), num_ai_attacks_left)
		return true
	else
		
		-- AI has to wait for player wins		

		-- Difficulty will dictate aggressiveness and amount of contrived breathing room the AI gives for free
		min_player_wins_unresponded = 3
		max_player_wins_unresponded = 6
		max_ai_attacks_allowed = 2
		if difficulty == "Normal" then
			min_player_wins_unresponded = 2
			max_player_wins_unresponded = 4
			max_ai_attacks_allowed = 3
		elseif difficulty == "Hard" then
			min_player_wins_unresponded = 1
			max_player_wins_unresponded = 2
			max_ai_attacks_allowed = 5
		end
		
		-- Track the player's progress
		num_land_enemy_controlled = EvaluatePerception("Num_Enemy_Land_Territories", PlayerObject)
		num_space_enemy_controlled = EvaluatePerception("Num_Enemy_Space_Territories", PlayerObject)
		--MessageBox("%s -- num_land_enemy_controlled:%d num_space_enemy_controlled:%d", tostring(Script), num_land_enemy_controlled, num_space_enemy_controlled)

		player_gains_before_attacking = GetGlobalValueOrZero(PlayerObject, "player_gains_before_attacking")
        if player_gains_before_attacking == 0 then
		
			-- Establish how far the player can go unresponded
			player_gains_before_attacking = GameRandom(min_player_wins_unresponded, max_player_wins_unresponded)
			GlobalValue.Set(PlayerSpecificName(PlayerObject, "player_gains_before_attacking"), player_gains_before_attacking)
			--MessageBox("%s -- Determined %d player gains allowed and recording current player territories.", tostring(Script), player_gains_before_attacking)

			-- Record the state of the galaxy
			GlobalValue.Set(PlayerSpecificName(PlayerObject, "recent_land_enemy_controlled"), num_land_enemy_controlled)
			GlobalValue.Set(PlayerSpecificName(PlayerObject, "recent_space_enemy_controlled"), num_space_enemy_controlled)
		end

		-- Check the player's progress (before our current attack)
		player_territories_gained = num_land_enemy_controlled + num_space_enemy_controlled
									- GlobalValue.Get(PlayerSpecificName(PlayerObject, "recent_land_enemy_controlled"))
									- GlobalValue.Get(PlayerSpecificName(PlayerObject, "recent_space_enemy_controlled"))
									--		+ ai_territories_just_gained
		
		if player_territories_gained >= player_gains_before_attacking then
		
			-- Player has won all that he's allowed without AI response, time to start attacking again
			num_ai_attacks_left = GameRandom(0, max_player_wins_unresponded - 1)
			GlobalValue.Set(PlayerSpecificName(PlayerObject, "num_ai_attacks_left"), num_ai_attacks_left)

			-- Also reset the losses allowed, so that it will be randomized next time
			GlobalValue.Set(PlayerSpecificName(PlayerObject, "player_gains_before_attacking"), 0)

			--MessageBox("%s -- player has enough wins unresponded (%d); not pausing before next attack. \n AI gets %d attacks without pause", tostring(Script), player_territories_gained, num_ai_attacks_left)
			return true
		else

			--MessageBox("%s -- %d player territories gained, %d allowed before responding so pausing before next attack"
			--							, tostring(Script), player_territories_gained, player_gains_before_attacking)
			if player_territories_gained < 0 then

				-- Record the state of the galaxy
				--MessageBox("%s -- player lost ground; resetting recent territories records", tostring(Script))
				GlobalValue.Set(PlayerSpecificName(PlayerObject, "recent_land_enemy_controlled"), num_land_enemy_controlled)
				GlobalValue.Set(PlayerSpecificName(PlayerObject, "recent_space_enemy_controlled"), num_space_enemy_controlled)
			end 
		end
	
	end
	
	return false
end


function DifficultyBasedMinPause(difficulty)

	sleep_duration = 200
	if difficulty == "Normal" then
		sleep_duration = 100
	elseif difficulty == "Hard" then
		sleep_duration = 25
	end

	return sleep_duration	
end

function GetGlobalValueOrZero(player, value_name)
	ret_value = GlobalValue.Get(PlayerSpecificName(player, value_name))
	if ret_value == nil then
		return 0.0
	end
	return ret_value
end
