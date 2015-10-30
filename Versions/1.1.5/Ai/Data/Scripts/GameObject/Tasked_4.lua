-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Tasked_1.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Tasked_1.lua $
--
--    Original Author: Sidious_Invader
--
--            $Author: z3r0x $
--
--            $Change: 2 $
--
--          $DateTime: 2007/03/15 20:55:33 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGSpawnUnits")

function Definitions()
-- Object isn't valid at this point so don't do any operations that
-- would require it. State_Init is the first chance you have to do
-- operations on Object
DebugMessage("%s -- In Definitions", tostring(Script))

Define_State("State_Init", State_Init);
end

function State_Init(message)
	if message == OnEnter then
	waypoint1 = Find_First_Object("TASKED4_WAYPOINT1")
	waypoint2 = Find_First_Object("TASKED4_WAYPOINT2")
	waypoint3 = Find_First_Object("TASKED4_WAYPOINT3")
	waypoint4 = Find_First_Object("TASKED4_WAYPOINT4")
	waypoint5 = Find_First_Object("TASKED4_WAYPOINT5")
	tasked1 = Find_All_Objects_With_Hint("tasked4")
	
		for k,unit in pairs(tasked1) do
			unit.Set_Selectable(true)
			unit.Prevent_AI_Usage(false)
			unit.Move_To(waypoint1)
			Sleep(15)
			unit.Move_To(waypoint2)
			Sleep(15)
			unit.Move_To(waypoint3)
			Sleep(15)
			unit.Move_To(waypoint4)
			Sleep(15)
			unit.Move_To(waypoint5)
			Sleep(15)
			unit.Move_To(waypoint1)
			Sleep(15)
			unit.Move_To(waypoint2)
			Sleep(15)
			unit.Move_To(waypoint3)
			Sleep(15)
			unit.Move_To(waypoint4)
			Sleep(15)
			unit.Move_To(waypoint5)
			Sleep(15)
			unit.Move_To(waypoint1)
			Sleep(15)
			unit.Move_To(waypoint2)
			Sleep(15)
			unit.Move_To(waypoint3)
			Sleep(15)
			unit.Move_To(waypoint4)
			Sleep(15)
			unit.Move_To(waypoint5)
			Sleep(15)
		end
	end
end

