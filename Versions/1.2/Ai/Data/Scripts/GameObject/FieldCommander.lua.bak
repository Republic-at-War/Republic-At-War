-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/FieldCommander.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/FieldCommander.lua $
--
--    Original Author: Brian Hayes
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

require("HeroPlanAttach")

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 4

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- only join plans that meet our expense requirements.
	MinPlanAttachCost = 2000
	MaxPlanAttachCost = 0

	-- Commander hit list.
	Attack_Ability_Type_Names = { 
		"Infantry", "Vehicle", "Air", 			-- Attack these types.
		"Bounty_Hunter_Team_E", "Bounty_Hunter_Team_R"  				-- Stay away from these types.
	}
	Attack_Ability_Weights = { 
		1, 1, 1, 					-- attack type weights.
		BAD_WEIGHT, BAD_WEIGHT		-- feared type weights.
	}
	Attack_Ability_Types = WeightedTypeList.Create()
	Attack_Ability_Types.Parse(Attack_Ability_Type_Names, Attack_Ability_Weights)

	-- Prefer task forces with these units.
	Escort_Ability_Type_Names = { "Infantry", "Vehicle", "Air", "Field_Com_Rebel_Team", "Field_Com_Empire_Team" }
	Escort_Ability_Weights = { 10, 10, 10, BAD_WEIGHT, BAD_WEIGHT }
	Escort_Ability_Types = WeightedTypeList.Create()
	Escort_Ability_Types.Parse(Escort_Ability_Type_Names, Escort_Ability_Weights)
end

function Evaluate_Attack_Ability(target, goal)
	return Get_Target_Weight(target, Attack_Ability_Types, Attack_Ability_Weights)
end

function Get_Escort_Ability_Weights(goal)
	return Escort_Ability_Types
end

function HeroService()

end
