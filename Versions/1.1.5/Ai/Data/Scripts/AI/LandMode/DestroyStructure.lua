-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/DestroyStructure.lua#5 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/DestroyStructure.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 56734 $
--
--          $DateTime: 2006/10/24 14:15:48 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

ScriptPoolCount = 16

function Definitions()
	
	Category = "Destroy_Structure"
	TaskForce = {
	{
		"MainForce"						
		,"DenyHeroAttach"
		,"Infantry | Vehicle | Air = 1,10"
		,"LandHero = 0,2"
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
	
	Set_Land_AI_Targeting_Priorities(MainForce)
	
	-- Assign appropriate targeting priorities here, once we get the ability to do this per unit type
	BlockOnCommand(MainForce.Attack_Move(AITarget, MainForce.Get_Self_Threat_Max()))	

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
