-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/BobaFettFlameInfantry.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/BobaFettFlameInfantry.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 56734 $
--
--          $DateTime: 2006/10/24 14:15:48 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Flame_Infantry"
	TaskForce = {
	{
		"MainForce"					
		,"DenyHeroAttach"
		,"Boba_Fett = 1"
	}
	}
	
	IgnoreTarget = true
	AllowEngagedUnits = true
	time_to_transition_reinforcement_point = 10

end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	QuickReinforce(PlayerObject, AITarget, MainForce)
	
	MainForce.Set_As_Goal_System_Removable(false)
	
	fett = MainForce.Get_Unit_Table()[1]
	if not TestValid(fett) then
		MessageBox("unexpected state; fett unavailable")
	end

	-- Make sure he doesn't autonomousely use his flamethrower
	--fett.Set_Single_Ability_Autofire("FLAME_THROWER", false)

	--MessageBox("Start")

	-- Don't let Fett waste the landing party on Easy or Normal difficlties
	difficulty = PlayerObject.Get_Difficulty()
	if (EvaluatePerception("Is_Skirmish_Mode", PlayerObject) == 0) 
			and (difficulty == "Normal" or difficulty == "Easy") then
		friendly_structure = Find_Nearest(MainForce, "Structure", PlayerObject, true)
		if TestValid(friendly_structure) then
			BlockOnCommand(MainForce.Guard_Target(friendly_structure), 80)
		else
			Sleep(80)
		end
	end


	while true do

		ConsiderFettHeal()

		-- Capture a reinforcement point
		lz_table = PruneFriendlyObjects(Find_All_Objects_Of_Type("IsRushTarget"))
		--DebugPrintTable(lz_table)
		if TestValid(lz_table[1]) then
			FettMove(lz_table[1])
			BlockOnCommand(fett.Guard_Target(lz_table[1]), time_to_transition_reinforcement_point)
		end
		
		ConsiderFettHeal()

		-- Chase down infantry and flame them
		closest_infantry = Find_Nearest(fett, "Infantry", PlayerObject, false)
		if TestValid(closest_infantry) then
			FettMove(closest_infantry, true)

			-- Walk the last bit so we can attack more appropriately
			if TestValid(closest_infantry) then
				DebugMessage("%s-- finally attack moving on %s", tostring(Script), tostring(closest_infantry))
				BlockOnCommand(fett.Attack_Move(closest_infantry))
			end
			
		end
		
		MainForce.Set_Plan_Result(true)
		
		-- Make sure the loop always yields
		Sleep(1)
	end
	
	ScriptExit()
end

function ConsiderFettHeal()
	if fett.Get_Hull() < 0.4 then
		bacta = Find_Nearest(fett, "HealsInfantry", PlayerObject, true)
		if TestValid(bacta) then
			FettMove(bacta)
			while fett.Get_Hull() < 0.9 do
				DebugMessage("%s-- Waiting to heal", tostring(Script))
				BlockOnCommand(fett.Guard_Target(bacta), 2)
			end
		end
	end
end

-- Try to use the jet pack to get around, but run if we have to while the ability is recharging.
function FettMove(target, use_attack_move)
	DebugMessage("%s-- starting FettMove", tostring(Script))

	if use_attack_move then
		change_up_duration = 4
	else
		change_up_duration = 30
	end

	if TestValid(target) and fett.Get_Distance(target) > 150 then
			if JetPackReady() then
					BlockOnCommand(fett.Activate_Ability("JET_PACK", target), change_up_duration)
					MoveUntilDone(target, change_up_duration)
			else
				
				if use_attack_move then
					BlockOnCommand(fett.Attack_Move(target, -1, JetPackReady))
				else
					BlockOnCommand(fett.Move_To(target.Get_Position(), -1, JetPackReady))
				end
				
				-- Apparently needed so that the following jet pack usage will detect that the ability is ready
				Sleep(1)
				
				if TestValid(target) then
					DebugMessage("%s-- activating jet pack because it came on line", tostring(Script))
					BlockOnCommand(fett.Activate_Ability("JET_PACK", target), change_up_duration)
					MoveUntilDone(target, change_up_duration)
				end
			end
		else
	end
	
	DebugMessage("%s-- finished FettMove", tostring(Script))
end

-- This moves fett, periodically reissuing the order, while allowing to finish if we get close
-- enough or the block naturally finishes (because we've collided with the structure or whatever)
-- This is to fix a bug where Fett would get stuck trying to move to the center of a building, and
-- still think he's not close enough.  The block should finish when we hit the building.
function MoveUntilDone(target, max_duration)
	DebugMessage("%s-- starting MoveUntilDone", tostring(Script))

	if not TestValid(target) then
		return
	end

	ThreadValue.Set("BlockStartFettMove", GetCurrentTime())
	block = fett.Move_To(target)
	while TestValid(target) and fett.Get_Distance(target) > 30 and block and (block.IsFinished() ~= true) do
		DebugMessage("%s-- servicing MoveUntilDone", tostring(Script))
		PumpEvents()
		if (GetCurrentTime() - ThreadValue("BlockStartFettMove") > max_duration) then
			DebugMessage("%s-- reissuing move order", tostring(Script))
			block = fett.Move_To(target)
		end
	end

	DebugMessage("%s-- finished MoveUntilDone", tostring(Script))
end

function JetPackReady()
	return fett.Is_Ability_Ready("JET_PACK")
end



