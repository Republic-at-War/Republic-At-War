-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/CreditPowerUp.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/CreditPowerUp.lua $
--
--    Original Author: James Yarrow
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

require("PGStateMachine")


function Definitions()

   -- Object isn't valid at this point so don't do any operations that
   -- would require it.  State_Init is the first chance you have to do
   -- operations on Object
   
	DebugMessage("%s -- In Definitions", tostring(Script))
		
	Define_State("State_Init", State_Init);

	player = nil
end


function State_Init(message)

	if message == OnEnter then
		-- Set up event handling for when an object moves within range
		Game_Message("CIVILIAN_KILLED_STRUCTURE")
		Object.Event_Object_In_Range(object_in_range_handler, 5000)
	elseif message == OnUpdate then
		-- Do nothing
	elseif message == OnExit then
		-- Do nothing
	end

end

function object_in_range_handler(prox_object, object)

	player = object.Get_Owner()
	if player.Is_Human() then
		object.Get_Owner().Give_Money(-6000)

		-- Cancel the object in range event from signaling anymore.	
		Object.Cancel_Event_Object_In_Range(object_in_range_handler)

		Object.Despawn()
	end
	
end