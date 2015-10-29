-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/AI_Plan_Underworld_MineStructure.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/AI_Plan_Underworld_MineStructure.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 53121 $
--
--          $DateTime: 2006/08/30 16:32:34 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////


require("pgevents")

ScriptPoolCount = 1

function Definitions()
	
	Category = "Mine_Structure"
	AllowEngagedUnits = true
	IgnoreTarget = true
	TaskForce = {
	{
		"MainForce"
		,"DenyHeroAttach"		
		,"Underworld_Merc_Team = 1,2"
	}
	}
end

function MainForce_Thread()
	MainForce.Set_Plan_Result(false)
	
	BlockOnCommand(MainForce.Produce_Force())
	QuickReinforce(PlayerObject, AITarget, MainForce)
	
	unit_table = MainForce.Get_Unit_Table()
	for i,unit in pairs(unit_table) do
		if not unit.Is_Ability_Ready("PROXIMITY_MINES") then
			MainForce.Release_Unit(unit)
		end
	end
	
	BlockOnCommand(MainForce.Attack_Move(AITarget))
	
	enemy = FindDeadlyEnemy(AITarget)
	if not TestValid(enemy) then
		enemy = Find_Nearest(AITarget, PlayerObject, false)
	end
	
	if not TestValid(enemy) then
		ScriptExit()
	end
	
	MainForce.Move_To(enemy)
	Sleep(5)
	MainForce.Activate_Ability("PROXIMITY_MINES", MainForce)
	
	--We treat all instances as failures so as not to repeatedly attempt to mine the same location
	ScriptExit()
end