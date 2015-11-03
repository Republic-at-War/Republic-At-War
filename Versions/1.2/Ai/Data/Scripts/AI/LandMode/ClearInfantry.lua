-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/ClearInfantry.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/ClearInfantry.lua $
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

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 6

function Definitions()
	
	Category = "Clear_Infantry"
	MinContrastScale = 0.2
	MaxContrastScale = 3.0
	TaskForce = {
	{
		"MainForce"					
		,"DenyHeroAttach"
		,"Infantry | Vehicle | Air = 1,5"
		,"LandHero = 0,2"
	}
	}
	
	AllowEngagedUnits = false

	start_loc = nil
	closest_infantry = nil
	kill_target = nil

end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	QuickReinforce(PlayerObject, AITarget, MainForce)
	
	--BlockOnCommand(MainForce.Move_To(MainForce.Get_Stage(), false)) -- true = wait for entire taskforce at intermediate zone points
	
	MainForce.Set_As_Goal_System_Removable(false)

	Set_Land_AI_Targeting_Priorities(MainForce)
	BlockOnCommand(MainForce.Attack_Move(AITarget, MainForce.Get_Self_Threat_Max()))
	
	-- If the original goal on this target is still valid, keep hunting
	while (EvaluatePerception("Should_Clear_Infantry", PlayerObject, AITarget) > 0) do

		closest_infantry = Find_Nearest(MainForce, "Infantry", PlayerObject, false)
		if TestValid(closest_infantry) then
			BlockOnCommand(MainForce.Attack_Move(closest_infantry))
		else
			-- Prevent endless loops in case of an unexpected condition
			break
		end
	end
	
	ScriptExit()
end

-- Make sure that units don't sit idle at the end of their move order, waiting for others
function MainForce_Unit_Move_Finished(tf, unit)

	Default_Unit_Move_Finished(tf, unit)

	-- Assist the tf with whatever is holding it up
	kill_target = FindDeadlyEnemy(tf)
	if TestValid(kill_target) then
		unit.Attack_Move(kill_target)
	else
		unit.Attack_Move(tf)
	end
end