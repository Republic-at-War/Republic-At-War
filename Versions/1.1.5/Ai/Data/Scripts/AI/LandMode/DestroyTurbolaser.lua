-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/DestroyTurbolaser.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/DestroyTurbolaser.lua $
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

ScriptPoolCount = 16

function Definitions()
	
	Category = "Destroy_Turbolaser"
	TaskForce = {
	{
		"MainForce"						
		,"DenyHeroAttach"
		,"Infantry | Air | LandHero = 3,10"
	},
	{
		"GuardForce"
		,"EscortForce"
		,"Squad_Battledroid | Super_Battledroid | Arc_Trooper | Arc_Trooper_Lt | Arc_Trooper_Captain | Arc_Trooper_Z6 | Squad_Clonetrooper_P1 | Squad_Sgt_Clonetrooper_P1 | Squad_Lt_Clonetrooper_P1 | Squad_Cpt_Clonetrooper_P1 | Squad_Clonetrooper_P2 | Squad_Clonetrooper_7th | Squad_Clonetrooper_41st | Squad_Clonetrooper_212th | Squad_Clonetrooper_Airborne_212th | Squad_Clonetrooper_327th_Star_Corps | Squad_Clonetrooper_Variant_327th_Star_Corps | Squad_Clonetrooper_Variant_2_327th_Star_Corps | Squad_Clonetrooper_501st = 0,2"
	}
	}
	
	start_loc = nil
	
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	QuickReinforce(PlayerObject, AITarget, MainForce, GuardForce)
	
	Try_Ability(MainForce, "FORCE_CLOAK")
	Try_Ability(MainForce, "STEALTH")

	-- Try to get under the min attack range, then attack
	BlockOnCommand(MainForce.Move_To(AITarget, MainForce.Get_Self_Threat_Sum()))
	BlockOnCommand(MainForce.Attack_Target(AITarget))	

	ScriptExit()
end

function GuardForce_Thread()
	BlockOnCommand(GuardForce.Produce_Force())

	QuickReinforce(PlayerObject, AITarget, GuardForce, MainForce)
	
	-- Give an initial order to put the escorts in a state that the Escort function expects
	GuardForce.Guard_Target(MainForce)

	-- Make sure these guys will shoot at structures autonomously
	GuardForce.Set_Targeting_Priorities("Infantry_Attack_Move")

	while true do
		Escort(GuardForce, MainForce)
	end
end

