-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/SpeederBike.lua#5 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/SpeederBike.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 50006 $
--
--          $DateTime: 2006/07/31 16:18:08 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")

function Definitions()

-- Object script stuff

	ServiceRate = 1

	Define_State("State_Init", State_Init);
	Define_State("State_AI_Autofire", State_AI_Autofire)
	Define_State("State_Human_No_Autofire", State_Human_No_Autofire)
	Define_State("State_Human_Autofire", State_Human_Autofire)
	
	unit_trigger_number = 3
	divert_range = 500
	threat_trigger_number = 10
	ability_range = 80
	ability_name = "UNTARGETED_STICKY_BOMB"
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
		if (nearby_unit_count >= unit_trigger_number) then
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
