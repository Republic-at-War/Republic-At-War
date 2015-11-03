-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/GroundToSpaceDisable.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/GroundToSpaceDisable.lua $
--
--    Original Author: Steve_Copeland
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

-- Self-attachment script for the Ion Canno, but currently a custom goal 
-- is the best tactic 

require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	Category = "Ground_To_Space_Disable"
	IgnoreTarget = true
	TaskForce = 
	{
		{
			"MainForce"
			,"DenySpecialWeaponAttach"
			,"DenyHeroAttach"
			,"Ground_Ion_Cannon = 1"
		}
	}
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())

	-- Keep firing at the bigger (and probably slowest) enemies
	-- Add some variance, so that we can spread the effect around
--	AITarget = FindTarget(MainForce, "Needs_Ion_Shot", "Enemy_Unit", 1.0)
--	DebugMessage("%s -- Found Target %s", tostring(Script), tostring(AITarget))

-- Try to fire each variety this weapon might be
	MainForce.Fire_Special_Weapon("Ground_Ion_Cannon", AITarget)


-- Rely on the Weapon Online event to fire the gun subsequent times
	while TestValid(AITarget) do
		Sleep(5)
	end
	
	ScriptExit()
end

function MainForce_Special_Weapon_Online(tf, special_weapon)
	if TestValid(AITarget) then
		special_weapon.Fire_Special_Weapon(AITarget, PlayerObject)
	else
		ScriptExit()
	end
end




