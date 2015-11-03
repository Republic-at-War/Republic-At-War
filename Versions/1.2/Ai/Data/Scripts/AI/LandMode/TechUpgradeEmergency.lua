-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/TechUpgradeEmergency.lua#2 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/TechUpgradeEmergency.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 46090 $
--
--          $DateTime: 2006/06/13 15:02:25 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////


-- This should go off whenever we hit the unit cap and have units in reserve
-- Note that the generic unit building will also do tech upgrades if affordable

require("pgevents")


function Definitions()
	
	Category = "Tech_Upgrade_Emergency"
	IgnoreTarget = true
	TaskForce = {
	{
		"ReserveForce"
		,"RC_Level_Two_Tech_Upgrade | RC_Level_Three_Tech_Upgrade | RC_Level_Four_Tech_Upgrade = 0,1"
		,"EC_Level_Two_Tech_Upgrade | EC_Level_Three_Tech_Upgrade | EC_Level_Four_Tech_Upgrade = 0,1"
		,"UC_Level_Two_Tech_Upgrade | UC_Level_Three_Tech_Upgrade = 0,1"
	}
	}
	RequiredCategories = {"Upgrade"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)
		
	ScriptExit()
end

