-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/ConquerOpponentPlan.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/ConquerOpponentPlan.lua $
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

require("pgevents")

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 2

--
-- Galactic Mode Contrast Script
--

function Definitions()
	MinContrastScale = 1.25
	MaxContrastScale = 1.75

	Category = "Conquer_Planet_Tech_5"
	TaskForce = {
	-- First Task Force
	{
		"SpaceForce"	
		,"MinimumTotalSize = 12"
		,"MinimumTotalForce = 4000"					
		,"Frigate | Capital | Corvette | Bomber | Fighter = 100%"
	},
	{
		"GroundForce"
		,"MinimumTotalSize = 12"
		,"MinimumTotalForce = 1750"
		,"Vehicle | Infantry | Air = 100%"
	}
	}
	RequiredCategories = { "Infantry", "Corvette | Frigate | Capital | Super" }		--Must have at least one ground unit, also make sure space force is reasonable

	PerFailureContrastAdjust = 0.5
	
	SpaceSecured = true
	LandSecured = false
	MovingGroundForceToTarget = false
	WasConflict = false
	
	difficulty = "Easy"
	if PlayerObject then
		difficulty = PlayerObject.Get_Difficulty()
	end
	sleep_duration = DifficultyBasedMinPause(difficulty)
end

function SpaceForce_Thread()
	-- Since we're using plan failure to adjust contrast, we're 
	-- only concerned with failures in battle. Default the 
	-- plan to successful and then 
	-- only on the event of our task force being killed is the
	-- plan set to a failed state.
	Game_Message("1_CONQUER_PLANET_TECH_5_PLAN")
	SpaceForce.Set_Plan_Result(true)
	
	SpaceSecured = false

	if SpaceForce.Are_All_Units_On_Free_Store() == true then
		AssembleForce(SpaceForce)
	else
		BlockOnCommand(SpaceForce.Produce_Force());
		return
	end

	if SpaceForce.Get_Force_Count() == 0 then
		if EvaluatePerception("Is_Good_Ground_Grab_Target", PlayerObject, Target) == 0 then
			ScriptExit()
		else
			SpaceSecured = true
		end
	else
		BlockOnCommand(SpaceForce.Move_To(Target))
		WasConflict = true
		if SpaceForce.Get_Force_Count() == 0 then
			SpaceForce.Set_Plan_Result(false)		
			Exit_Plan_With_Possible_Sleep()
		end
				
		SpaceSecured = true
		
		while not LandSecured do
			Sleep(5)
		end
		
		SpaceForce.Release_Forces(1.0)
	end
end

function GroundForce_Thread()
	--Needs to be done by both taskforces - sometimes we may only create a ground force, and if we
	--declare it a failure we'll just end up with crazy contrast escalation.
	GroundForce.Set_Plan_Result(true)	
	
	if GroundForce.Are_All_Units_On_Free_Store() == true then
		AssembleForce(GroundForce)
	else
		BlockOnCommand(GroundForce.Produce_Force());
		return
	end
	
	LandUnits(GroundForce)
	
	while not SpaceSecured do
		if WasConflict then
			Exit_Plan_With_Possible_Sleep()
		end
		Sleep(5)
	end
	
	if not LaunchUnits(GroundForce) then
		Exit_Plan_With_Possible_Sleep()
	end
		
	if EvaluatePerception("Is_Good_Ground_Grab_Target", PlayerObject, Target) == 0 then
		Exit_Plan_With_Possible_Sleep()
	end	
	
	MovingGroundForceToTarget = true
	BlockOnCommand(GroundForce.Move_To(Target))	
	MovingGroundForceToTarget = false
	WasConflict = true	
	if Invade(GroundForce) == false then
		GroundForce.Set_Plan_Result(false)
		Exit_Plan_With_Possible_Sleep()
	end

	-- This plan has all but succeeded; make sure AI systems don't remove it
	GroundForce.Set_As_Goal_System_Removable(false)	
	GroundForce.Test_Target_Contrast(false)	
	
	LandSecured = true
				
	GroundForce.Release_Forces(1.0)
	
	FundBases(PlayerObject, Target)

	Exit_Plan_With_Possible_Sleep()
end

function Exit_Plan_With_Possible_Sleep()
	if SpaceForce then
		SpaceForce.Release_Forces(1.0)
	end
	GroundForce.Release_Forces(1.0)
	if WasConflict and (not GalacticAttackAllowed(difficulty, 2)) then
		Sleep(sleep_duration)
	end
	ScriptExit()
end

function SpaceForce_Production_Failed(tf, failed_object_type)
	ScriptExit()
end

function GroundForce_Production_Failed(tf, failed_object_type)
	ScriptExit()
end

function SpaceForce_Original_Target_Owner_Changed(tf, old_owner, new_owner)	
	--Ignore changes to neutral - it might just be temporary on the way to
	--passing into my control.
	if new_owner ~= PlayerObject and new_owner.Is_Neutral() == false then
		if (not LandSecured) or (PlayerObject.Get_Difficulty() == "Hard") then
			ScriptExit()
		end
	end
end

function GroundForce_Original_Target_Owner_Changed(tf, old_owner, new_owner)	
	--Ignore changes to neutral - it might just be temporary on the way to
	--passing into my control.
	if new_owner ~= PlayerObject and new_owner.Is_Neutral() == false then
		if (not LandSecured) or (PlayerObject.Get_Difficulty() == "Hard") then
			ScriptExit()
		end
	end
end

function SpaceForce_No_Units_Remaining()
	if not LandSecured then
		SpaceForce.Set_Plan_Result(false) 
		--Don't exit since we need to sleep to enforce delays between AI attacks (can't be done inside an event handler)
	end
end

function GroundForce_No_Units_Remaining()
	if not LandSecured then
		GroundForce.Set_Plan_Result(false) 
		--Don't exit since we need to sleep to enforce delays between AI attacks (can't be done inside an event handler)
	end
end