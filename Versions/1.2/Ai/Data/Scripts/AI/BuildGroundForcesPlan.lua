-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/BuildGroundForcesPlan.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/BuildGroundForcesPlan.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 56727 $
--
--          $DateTime: 2006/10/24 14:14:26 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 7

function Definitions()
	Category = "Build_Ground_Forces"
	IgnoreTarget = true
	
	TaskForce = {
	{
		"ReserveForce"
		,"Infantry = 0,8"
		,"Vehicle = 0,8"
		,"Air = 0,8"
		,"Darkside_Adept_Team = 0,2"
		,"Republic_Arc_Trooper_Squad = 0,2"
		,"Field_Com_Cis_Team = 0,1"
		,"Field_Com_Republic_P1_Team = 0,1"
		,"Field_Com_Republic_P2_Team = 0,1"
	}
	}
	RequiredCategories = { "Vehicle" }
	AllowFreeStoreUnits = false
end

function ReserveForce_Thread()		
	ReserveForce.Set_As_Goal_System_Removable(false)
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)	
end
