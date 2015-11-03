-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ObjectScript_RemoteBomb.lua#5 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ObjectScript_RemoteBomb.lua $
--
--    Original Author: James Yarrow
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

	ServiceRate = 1

	Define_State("State_Init", State_Init);

	nearby_threat = 0
	nearby_enemies = {}

	threat_threshold = 200.0
	detonate_range = 150.0
end

function State_Init(message)
	if message == OnEnter then

		-- Bail out if this is a human player
		if Object.Get_Owner().Is_Human() then
			ScriptExit()
		end

		-- prevent this from doing anything in galactic mode
		if Get_Game_Mode() ~= "Land" then
			ScriptExit()
		end

		nearby_threat = 0
		nearby_enemies = {}
	
		-- Register a proximity around the unit at a range we're willing to divert for force confuse
		Register_Prox(Object, Detonate_Prox, detonate_range)
		
	elseif message == OnUpdate then

		nearby_threat = 0
		nearby_enemies = {}
				
	end

end

function Detonate_Prox(self_obj, trigger_obj)

	if not trigger_obj.Get_Owner().Is_Enemy(Object.Get_Owner()) then
		return
	end
	
	if trigger_obj.Is_In_Garrison() then
		return
	end	
	
	if nearby_enemies[trigger_obj] == nil then
		nearby_enemies[trigger_obj] = trigger_obj
		nearby_threat = nearby_threat + trigger_obj.Get_Type().Get_Combat_Rating()
		
		if nearby_threat >= threat_threshold then
			saboteur = Find_First_Object("Aurra_Sing", Find_Player("REBEL"))
			if TestValid(saboteur) then
				Try_Ability(saboteur, "DETONATE_REMOTE_BOMB")
			end
		end
	
	end
	
end