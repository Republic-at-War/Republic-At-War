-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ObiWanPlan.lua#7 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ObiWanPlan.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 50006 $
--
--          $DateTime: 2006/07/31 16:18:08 $
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

	-- Commander hit list.
	Attack_Ability_Type_Names = { 
		"Infantry",	-- Attack these types.
		"Count_Dooku_Team"  				-- Stay away from these types.
	}
	Attack_Ability_Weights = { 
		10,   				-- attack type weights.
		BAD_WEIGHT, BAD_WEIGHT   				-- feared type weights.
	}
	Attack_Ability_Types = WeightedTypeList.Create()
	Attack_Ability_Types.Parse(Attack_Ability_Type_Names, Attack_Ability_Weights)

	-- Prefer task forces with these units.
	Escort_Ability_Type_Names = {  "Infantry", "Vehicle", "Air", "Field_Com_Cis_Team", "Field_Com_Republic_P1_Team", "Field_Com_Republic_P2_Team" }
	Escort_Ability_Weights = { 3, 10, 3, BAD_WEIGHT, BAD_WEIGHT }
	Escort_Ability_Types = WeightedTypeList.Create()
	Escort_Ability_Types.Parse(Escort_Ability_Type_Names, Escort_Ability_Weights)
	
-- tactical behavior stuff

	ServiceRate = 1

	Define_State("State_Init", State_Init);
	Define_State("State_AI_Autofire", State_AI_Autofire)
	Define_State("State_Human_No_Autofire", State_Human_No_Autofire)
	Define_State("State_Human_Autofire", State_Human_Autofire)
	
	unit_trigger_number = 3
	divert_range = 400
	threat_trigger_number = 10
	ability_range = 100
	ability_name = "FORCE_CONFUSE"
	
	invulnerability_ability_name = "TARGETED_INVULNERABILITY"
	min_threat_to_use_invulnerability = 100
	invulnerability_range = 400
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
		
		Register_Prox(Object, Invuln_Prox, invulnerability_range)

		if Object.Get_Owner().Is_Human() then
			Set_Next_State("State_Human_No_Autofire")
			Register_Prox(Object, Unit_Prox, ability_range)
		else
			Set_Next_State("State_AI_Autofire")
			Register_Prox(Object, Unit_Prox, divert_range)
		end
	end
end

function State_AI_Autofire(message)
	if message == OnUpdate then
		if (nearby_unit_count >= unit_trigger_number) and Object.Get_Hull() < 0.5 then
			ConsiderDivertAndAOE(Object, ability_name, ability_range, recent_enemy_units, threat_trigger_number)
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
		
		-- reset tracked units each service.
		nearby_unit_count = 0
		recent_enemy_units = {}
		
	end
end

function State_Human_Autofire(message)
	if message == OnUpdate then
	
		if Object.Is_Ability_Autofire(ability_name) then
			if nearby_unit_count >= unit_trigger_number then
				Object.Activate_Ability(ability_name, true)
			end
		else
			Set_Next_State("State_Human_No_Autofire")
		end
		
		-- reset tracked units each service.
		nearby_unit_count = 0
		recent_enemy_units = {}
			
	end				
end

function Unit_Prox(self_obj, trigger_obj)
	
	--Can only confuse non-hero infantry
	if not trigger_obj.Is_Category("Infantry") then
		return
	end
	
	if trigger_obj.Is_Category("LandHero") then
		return
	end	
	
	if not trigger_obj.Get_Owner().Is_Enemy(Object.Get_Owner()) then
		return
	end
	
	--Promote to parent object (infantry squads) for unit counting purposes
	if trigger_obj.Get_Parent_Object() then
		trigger_obj = trigger_obj.Get_Parent_Object()
	end

	if trigger_obj.Is_In_Garrison() then
		return
	end

	-- If we haven't seen this unit recently, track him
	if recent_enemy_units[trigger_obj] == nil then
		nearby_unit_count = nearby_unit_count + 1
		recent_enemy_units[trigger_obj] = trigger_obj
	end
end

function Invuln_Prox(self_obj, trigger_obj)	
	
	if Object.Get_Owner().Is_Human() and not Object.Is_Ability_Autofire(invulnerability_ability_name) then
		return
	end
	
	--Use invulnerability on friendly objects that are in need of help and worth preserving
	if not trigger_obj.Get_Owner().Is_Ally(Object.Get_Owner()) then
		return
	end	
	
	if not trigger_obj.Get_Type().Is_Hero() then
		if trigger_obj.Get_Type().Get_Combat_Rating() < min_threat_to_use_invulnerability then
			return
		end
	end
	
	if not self_obj.Is_Ability_Ready(invulnerability_ability_name) then
		return
	end
	
	if not TestValid(FindDeadlyEnemy(trigger_obj)) then
		return
	end

	self_obj.Activate_Ability(invulnerability_ability_name, trigger_obj)
end

