-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/AI_Plan_ExpansionGeneric_DeployTroopTransports.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/AI_Plan_ExpansionGeneric_DeployTroopTransports.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 45506 $
--
--          $DateTime: 2006/05/31 16:18:01 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

--Get transport units landed and move them towards high concentrations of friendly infantry
function Definitions()

	Category = "Deploy_Troop_Transports"
	IgnoreTarget = true
	TaskForce = 
	{
		{
			"MainForce"
			,"HAV_Juggernaut | F9TZ_Cloaking_Transport | Gallofree_HTT_Transport = 1,5"
		}
	}

	AllowEngagedUnits = false

end

function MainForce_Thread()

	BlockOnCommand(MainForce.Produce_Force())
	QuickReinforce(PlayerObject, AITarget, MainForce, nil)
	
	unit_table = MainForce.Get_Unit_Table()
	for i,unit in pairs(unit_table) do
		if unit.Has_Garrison() then
			MainForce.Release_Unit(unit)
		end
	end
	
	MainForce.Set_Plan_Result(true)
	BlockOnCommand(MainForce.Move_To(AITarget))
		
	ScriptExit()
	
end