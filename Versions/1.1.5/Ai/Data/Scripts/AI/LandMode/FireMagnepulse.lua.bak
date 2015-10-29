-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/FireMagnepulse.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/FireMagnepulse.lua $
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

	Category = "Fire_Magnepulse"
	IgnoreTarget = true
	TaskForce = 
	{
		{
			"MainForce"
			,"DenySpecialWeaponAttach"
			,"DenyHeroAttach"
			,"Ground_Magnepulse_Cannon = 1"
		}
	}
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())

	-- Keep firing at the bigger (and probably slowest) enemies
	-- Add some variance, so that we can spread the effect around
	AITarget = FindTarget(MainForce, "Needs_Magnepulse_Shot", "Enemy_Unit", 0.8)
	DebugMessage("%s -- Found Target %s", tostring(Script), tostring(AITarget))

	-- Just fire once, because the effect isn't that useful to hit the same target in rapid succession
	if TestValid(AITarget) then
		MainForce.Fire_Special_Weapon("Ground_Magnepulse_Cannon", AITarget)
	end
	
	ScriptExit()
end





