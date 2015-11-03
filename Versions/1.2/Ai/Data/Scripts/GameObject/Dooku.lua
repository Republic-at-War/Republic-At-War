-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Dooku.lua#7 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Dooku.lua $
--
--    Original Author: Brian Hayes
--
--            $Author: z3r0x $
--
--            $Change: 50006 $
--
--          $DateTime: 2011/04/01 16:18:08 $
--
--          $Revision: #7 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

-- This include order is important.  We need the state service defined in main to override the one in heroplanattach.
require("HeroPlanAttach")
require("PGStateMachine")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- only join plans that meet our expense requirements.
	MinPlanAttachCost = 5000
	MaxPlanAttachCost = 0

	Attack_Ability_Type_Names = { 
		"Capital", "Corvette", "Frigate", "Fighter"   	-- Attack these types.
	}
	Attack_Ability_Weights = { 
		1, 1, 1, 1					-- attack type weights.
	}

	Attack_Ability_Types = WeightedTypeList.Create()
	Attack_Ability_Types.Parse(Attack_Ability_Type_Names, Attack_Ability_Weights)

	-- Prefer task forces with these units.
	Escort_Ability_Type_Names = { "Infantry", "Fighter", "Corvette", "Frigate", "Capital" }
	Escort_Ability_Weights = { 1, 2, 3, 4, 5 }
	Escort_Ability_Types = WeightedTypeList.Create()
	Escort_Ability_Types.Parse(Escort_Ability_Type_Names, Escort_Ability_Weights)
	
	-- tactical behavior stuff

	ServiceRate = 1

	Define_State("State_Init", State_Init)
	Define_State("State_AI_Autofire", State_AI_Autofire)
	Define_State("State_Human_No_Autofire", State_Human_No_Autofire)
	Define_State("State_Human_Autofire", State_Human_Autofire)

	unit_trigger_number = 16
	divert_range = 400
	min_threat_to_use_ability = 16
	ability_name = "FORCE_WHIRLWIND"
	area_of_effect = 75

end

function Evaluate_Attack_Ability(target, goal)
	return Get_Target_Weight(target, Attack_Ability_Types, Attack_Ability_Weights)
end

function Get_Escort_Ability_Weights(goal)
	return Escort_Ability_Types
end

function HeroService()

end

function State_Init(message)
	if message == OnEnter then

		-- prevent this from doing anything in galactic mode
		if Get_Game_Mode() ~= "Land" then
			ScriptExit()
		end

		nearby_unit_count = 0
		recent_enemy_units = {}

		if Object.Get_Owner().Is_Human() then
			Register_Prox(Object, Unit_Prox, area_of_effect)
			Set_Next_State("State_Human_No_Autofire")
		else
			Register_Prox(Object, Unit_Prox, divert_range)
			Set_Next_State("State_AI_Autofire")
		end
	end
end

function State_AI_Autofire(message)
	if message == OnUpdate then
		if (nearby_unit_count >= unit_trigger_number) then
			ConsiderDivertAndAOE(Object, ability_name, area_of_effect, recent_enemy_units, min_threat_to_use_ability)
		end
		
		-- reset tracked units each service.
		nearby_unit_count = 0
		recent_enemy_units = {}
	end		
end

function State_Human_No_Autofire(message)
	if message == OnUpdate then
		if Object.Is_Ability_Autofire(ability_name) then
			Set_Next_State("State_Human_Autofire")
		end
	end
end

function State_Human_Autofire(message)
	if message == OnUpdate then
	
		if Object.Is_Ability_Autofire(ability_name) then
			if nearby_unit_count > 8 then
				Object.Activate_Ability(ability_name, true)
			end
				
			-- reset tracked units each service.
			nearby_unit_count = 0
			recent_enemy_units = {}
		else
			Set_Next_State("State_Human_No_Autofire")
		end
	end				
end

-- If an enemy enters the prox, the unit may want to chase them down to use the ability
function Unit_Prox(self_obj, trigger_obj)

	-- Vader can only force push infantry
	if not trigger_obj.Is_Category("Infantry") then
		return
	end
	
	-- Reject heroes, which are often infantry, but we can't affect
	if trigger_obj.Is_Category("LandHero") then
		return
	end
	
	if not trigger_obj.Get_Owner().Is_Enemy(Object.Get_Owner()) then
		return
	end

	if trigger_obj.Is_In_Garrison() then
		return
	end

	-- Note: we're explicitly tracking individual infantry here (as opposed to their parents, the squads)

	-- If we haven't seen this unit recently, track him
	if recent_enemy_units[trigger_obj] == nil then
		recent_enemy_units[trigger_obj] = trigger_obj
		nearby_unit_count = nearby_unit_count + 1
	end
end
