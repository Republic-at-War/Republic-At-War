-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/BuildStructureLand.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/BuildStructureLand.lua $
--
--    Original Author: Steve Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 54633 $
--
--          $DateTime: 2006/09/14 17:46:53 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Tactical_Multiplayer_Build_Basic_Structure"
	IgnoreTarget = true
	TaskForce = {
	{
		"MainForce"
		,"UC_Power_Generator_R | UC_R_Ground_Base_Shield | UC_R_Small_Ground_Base_Shield | UC_Rebel_Mineral_Processor | UC_Rebel_Ground_Mining_Facility | UC_R_Ground_Turbolaser_Tower | UC_R_Ground_Light_Vehicle_Factory | UC_R_Ground_Heavy_Vehicle_Factory | UC_R_Ground_Research_Facility | UC_Communications_Array_R | UC_Ground_Hutt_Palace_R | UC_R_Uplink_Station = 0,1"
		,"UC_Power_Generator_E | UC_E_Ground_Base_Shield | UC_E_Small_Ground_Base_Shield | UC_Empire_Mineral_Processor | UC_Empire_Ground_Mining_Facility | UC_E_Ground_Turbolaser_Tower | UC_E_Ground_Light_Vehicle_Factory | UC_E_Ground_Heavy_Vehicle_Factory | UC_E_Ground_Research_Facility | UC_Communications_Array_E | UC_Ground_Hutt_Palace_E | UC_Ground_Magnepulse_Cannon_E = 0,1"
		,"UC_U_Ground_Merc_Outpost | UC_U_Ground_Droid_Works | UC_Underworld_Palace | UC_U_Ground_Arms_Depot | UC_Underworld_Mineral_Processor | UC_U_Ground_Turbolaser_Tower | UC_Ground_Hutt_Palace_U | UC_U_Ground_Gravity_Generator = 0,1"
	}
	}
	RequiredCategories = {"Structure"}
	AllowFreeStoreUnits = false

end

function MainForce_Thread()

	BlockOnCommand(MainForce.Build_All())
	MainForce.Set_Plan_Result(true)
	ScriptExit()
end



