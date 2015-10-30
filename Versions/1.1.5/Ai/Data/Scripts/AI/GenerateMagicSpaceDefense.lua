-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/GenerateMagicSpaceDefense.lua#2 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/GenerateMagicSpaceDefense.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 53991 $
--
--          $DateTime: 2006/09/08 11:01:51 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()	
	Category = "Generate_Magic_Space_Defense"
	IgnoreTarget = true
	
	TaskForce = {
	{
		"ReserveForce"
		,"DenyHeroAttach"
		,"Fighter | Bomber = 14"
		,"Corvette | Frigate | Capital = 12"
	}
	}
	AllowFreeStoreUnits = false
	MagicPlan = true
	MagicPlanStealing = false
end

function ReserveForce_Thread()		
	ReserveForce.Set_As_Goal_System_Removable(false)
	BlockOnCommand(ReserveForce.Produce_Force(Target))
	ReserveForce.Set_Plan_Result(true)	
	Sleep(20)

	--Use the Easy version of Needs_Magic_Space_Defense (just in case the units we spawned don't pull us past the
	--Normal threshold)
	wait_start_time = GetCurrentTime()
	wait_duration = Determine_Magic_Wait_Duration()
	while (GetCurrentTime() - wait_start_time < wait_duration) and 
			(EvaluatePerception("Needs_Magic_Space_Defense_Easy", PlayerObject, Target) == 0.0) do
		Sleep(1)
	end
	ScriptExit()
end