-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/TurboAttack.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/TurboAttack.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Andre_Arsenault $
--
--            $Change: 37816 $
--
--          $DateTime: 2006/02/15 15:33:33 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

--
-- Plan for corvettes to exploit their turbo or power to weapons abilities in a quick strike on a vulnerable unit.
--

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	Category = "Turbo_Attack_Unit"
	TaskForce = {
	-- First Task Force
	{
		"MainForce"
		,"DenyHeroAttach"
		,"CR90 | Republic_light_assault_cruiser | Republic_light_frigate | Slave_I | Hammer_Class_Picket | Cis_Patrol_Frigate = 1, 10"
	}
	}
	
	IgnoreTarget = true
	AllowEngagedUnits = true

	needs_turbo = false

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force());
	
	QuickReinforce(PlayerObject, AITarget, MainForce)
		
	MainForce.Enable_Attack_Positioning(false)
	
	-- Move into position while avoiding threat and without stopping for attacks on the way
	needs_turbo = true
	Try_Ability(MainForce, "Turbo")
	BlockOnCommand(MainForce.Move_To(AITarget, 10, "ASTEROID"))
	MainForce.Activate_Ability("Turbo", false)
	needs_turbo = false

	-- Nah, let attack location plans steal units away 
	-- MainForce.Set_As_Goal_System_Removable(false)

	-- Make a tactical strike on one particular unit (and verify that there's still a good target here).
	enemy = FindTarget(MainForce, "Good_Turbo_Attack_Unit_Opportunity", "Enemy_Unit", 1.0)
	if TestValid(enemy) then
		BlockOnCommand(MainForce.Attack_Target(enemy, 10, "ASTEROID"), 10) -- Timeout after 10 seconds.
	end	
	
	-- Try to flee to a safe spot after the tactical strike
	escape_loc = FindTarget(MainForce, "Space_Area_Is_Hidden", "Tactical_Location", 1.0, 5000.0)
	if escape_loc then
		needs_turbo = true 
		MainForce.Activate_Ability("Turbo", true)
		BlockOnCommand(MainForce.Move_To(escape_loc, 10, "ASTEROID"))
	end

	ScriptExit()
end

-- Make sure that units don't sit idle at the end of their move order, waiting for others
function MainForce_Unit_Move_Finished(tf, unit)

	if Attacking and not unit.Has_Attack_Target() then
		DebugMessage("%s -- %s reached end of move, giving new order", tostring(Script), tostring(unit))
	
		-- Assist the tf with whatever is holding it up
		kill_target = FindDeadlyEnemy(tf)
		if TestValid(kill_target) then
			unit.Attack_Target(kill_target)
		else
			unit.Attack_Move(tf)
		end
	end
end

-- Try to recover use of turbo or power to weapons if it was lost while we were trying to use it.
function MainForce_Unit_Ability_Ready(tf, unit, ability)

	--MessageBox("%s -- Recovering %s for %s!", tostring(Script), ability, tostring(unit))
	if ability == "Turbo" and needs_turbo then
		unit.Activate_Ability("Turbo", true)
	end
	
	-- Default handler behavior is still desired
	Default_Unit_Ability_Ready(tf, unit, ability)
end
