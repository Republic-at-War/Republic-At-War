-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/SystematicDisable.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/SystematicDisable.lua $
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




function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	IgnoreTarget = true
	Category = "AlwaysOff"
	TaskForce = {
	{
		"MainForce"						
		,"Corvette | Frigate | Capital | Super = 2,6"
	},
	{
		"EscortForce"
--		,"EscortForce"
		,"Fighter = 1,4"
	}
	}
	
	AllowEngagedUnits = false
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	QuickReinforce(PlayerObject, AITarget, MainForce, EscortForce)
	
	BlockOnCommand(MainForce.Attack_Target(AITarget, "Shield_Generator", 500))
	BlockOnCommand(MainForce.Attack_Target(AITarget, "Engine", 500))
				
	MainForce.Enable_Attack_Positioning(false)
	ScriptExit()
end

function EscortForce_Thread()
	BlockOnCommand(EscortForce.Produce_Force())

	QuickReinforce(PlayerObject, AITarget, EscortForce, MainForce)
	
	BlockOnCommand(EscortForce.Guard_Target(MainForce))
	
	while true do
		Escort(EscortForce, MainForce)
	end
end

function MainForce_No_Units_Remaining()
	DebugMessage("%s -- All units dead or non-buildable.  Abandonning plan.", tostring(Script))
	ScriptExit()
end

function MainForce_Target_Destroyed()
	DebugMessage("%s -- Target destroyed!  Exiting Script.", tostring(Script))
	ScriptExit()
end

function EscortForce_No_Units_Remaining()
	DebugMessage("%s -- Escort wiped out.  Bailing.", tostring(Script))
	ScriptExit()
end


