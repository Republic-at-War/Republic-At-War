-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/PurchaseLandUpgradesGeneric.lua#6 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/PurchaseLandUpgradesGeneric.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 56734 $
--
--          $DateTime: 2006/10/24 14:15:48 $
--
--          $Revision: #6 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Purchase_Land_Upgrades_Generic"
	IgnoreTarget = true
	TaskForce = {
	{
		"ReserveForce"
		,"DenySpecialWeaponAttach"
		,"DenyHeroAttach"
		
		-- Even though only one can be purchased, the 0,10 should increase the liklihood of items from these lists being chosen.
		,"RL_Increased_Mobility_Upgrade | RL_More_Garrisons_L1_Upgrade | RL_Combat_Armor_L1_Upgrade | RL_Combat_Armor_L2_Upgrade | RL_Light_Reflective_Armor_L1_Upgrade | RL_Light_Reflective_Armor_L2_Upgrade | RL_Enhanced_Reactors_L1_Upgrade | RL_Enhanced_Reactors_L2_Upgrade | RL_Heavy_Reflective_Armor_L1_Upgrade | RL_Heavy_Reflective_Armor_L2_Upgrade | RL_Improved_Heavy_Reactors_L1_Upgrade | RL_Improved_Heavy_Reactors_L2_Upgrade | RL_Increased_Production_L1_Upgrade | RL_Increased_Production_L2_Upgrade | RL_Bombing_Run_Use_Upgrade | RL_Reinforced_Structures_Upgrade | RL_Enhanced_Turret_Firepower_L1_Upgrade | RL_Enhanced_Turret_Firepower_L2_Upgrade | RL_Weatherproof_Upgrade | RL_Enhanced_Base_Shield_Upgrade_NoPre | RL_Planetary_Bombard_Use_Upgrade | E_Secure_Area_Upgrade = 0,10"
		,"RL_Field_Hospital_L1_Upgrade | RL_Field_Hospital_L2_Upgrade | RL_Field_Hospital_L3_Upgrade | RL_Field_Hospital_Battlefield_L1_Upgrade | RL_Field_Hospital_Battlefield_L2_Upgrade | RL_Field_Hospital_Adrenal_Upgrade_L1 | RL_Field_Hospital_Adrenal_Upgrade_L2 | RL_Field_Hospital_Stimulant_Upgrade | RL_Field_Hospital_Hyper_Upgrade_L1 | RL_Engineering_Platform_Rangefinder_L1_Upgrade | RL_Engineering_Platform_Rangefinder_L2_Upgrade | RL_Engineering_Platform_Rangefinder_L3_Upgrade | RL_Engineering_Platform_Light_Vehicle_Sensors_L1_Upgrade | RL_Engineering_Platform_Light_Vehicle_Sensors_L2_Upgrade | RL_Engineering_Platform_Heavy_Vehicle_Sensors_L1_Upgrade | RL_Engineering_Platform_Vehicle_Heavy_Sensors_L2_Upgrade | RL_Engineering_Platform_Vehicle_Salvage_Upgrade | RL_Engineering_Platform_Powerpack_L1_Upgrade | RL_Engineering_Platform_Powerpack_L2_Upgrade | RL_Engineering_Platform_Powerpack_L3_Upgrade | RL_Forward_Commandpost_Veteran_L1_Upgrade | RL_Forward_Commandpost_Veteran_L2_Upgrade | RL_Forward_Commandpost_Veteran_Armor_L1_Upgrade | RL_Forward_Commandpost_Veteran_Armor_L2_Upgrade | RL_Merc_Support_Upgrade | RL_Merc_Stolen_Equipment_Upgrade = 0,10"
		,"EL_Scout_Trooper_Research_Upgrade | EL_ATAA_Research_Upgrade | EL_ATST_Research_Upgrade | EL_M1_Tank_Research_Upgrade | EL_SPMAT_Research_Upgrade | EL_ATAT_Research_Upgrade | EL_Enhanced_Deployment_L1_Upgrade = 0,1"

		,"CL_Droid_Systems_L1_Upgrade_NO_PREREQ | CL_Droid_Systems_L2_Upgrade_NO_PREREQ | CL_More_Garrisons_L1_Upgrade | CL_Light_Armor_L1_Upgrade | CL_Light_Armor_L2_Upgrade | CL_Enhanced_Repulsors_L1_Upgrade | CL_Enhanced_Repulsors_L2_Upgrade | CL_Heavy_Armor_L1_Upgrade | CL_Heavy_Armor_L2_Upgrade | CL_Improved_Treads_L1_Upgrade | CL_Improved_Treads_L2_Upgrade | CL_Improved_OG9_Damage_L1_Upgrade | CL_Improved_OG9_Damage_L2_Upgrade | CL_Increased_Production_L1_Upgrade | CL_Increased_Production_L2_Upgrade | CL_Bombing_Run_Use_Upgrade | CL_Reinforced_Structures_Upgrade | CL_Enhanced_Turret_Firepower_L1_Upgrade | CL_Enhanced_Turret_Firepower_L2_Upgrade | CL_Enhanced_Base_Shield_Upgrade_NoPre | CL_Enhanced_Base_Shield_Upgrade | CL_Weatherproof_Upgrade | R_Magnetically_Sealed_Structure_Upgrade | R_Secure_Area_Upgrade= 0,10"
		,"CL_Cpu_L1_Upgrade | CL_Cpu_L2_Upgrade | CL_Cpu_L3_Upgrade | CL_Servos_L1_Upgrade | CL_Servos_L2_Upgrade | CL_Servos_L3_Upgrade | CL_Combat_Programming_L1_Upgrade | CL_Combat_Programming_L2_Upgrade | CL_Combat_Programming_L3_Upgrade | CL_Enhanced_Photoreceptors_Upgrade_L1 | CL_Enhanced_Photoreceptors_Upgrade_L2 | CL_Rangefinder_L1_Upgrade | CL_Rangefinder_L2_Upgrade | CL_Rangefinder_L3_Upgrade | CL_Light_Vehicle_Sensors_L1_Upgrade | CL_Light_Vehicle_Sensors_L2_Upgrade | CL_Heavy_Vehicle_Sensors_L1_Upgrade | CL_Heavy_Vehicle_Sensors_L2_Upgrade | CL_Vehicle_Salvage_Upgrade | CL_Guidance_L1_Upgrade | CL_Guidance_L2_Upgrade | CL_Guidance_L3_Upgrade | CL_Blaster_L1_Upgrade | CL_Blaster_L2_Upgrade | CL_Tank_Armor_L1_Upgrade | CL_Tank_Armor_L2_Upgrade | CL_Tank_Armor_L3_Upgrade | CL_Onboard_Repair_L1_Upgrade | CL_Onboard_Repair_L2_Upgrade | CL_Hot_Lz_Upgrade | CL_Encrypted_Comms_Upgrade | CL_Sith_Holocron_Upgrade | CL_Fire_Control_Upgrade = 0,10"
		,"RL_Plex_Soldier_Research_Upgrade | RL_Infiltrator_Research_Upgrade | RL_T2B_Research_Upgrade | RL_Snowspeeder_Research_Upgrade | RL_T4B_Research_Upgrade | RL_MPTL_Research_Upgrade | RL_Enhanced_Deployment_L1_Upgrade = 0,1"
		
		,"UL_Bounty_Upgrade | UL_Smuggled_Droid_Systems_L1_Upgrade | UL_MDU_Armor_Plating_L2_Upgrade | UL_Weapon_Boost_L1_Upgrade | UL_Weapon_Boost_L2_Upgrade | UL_Smuggled_Droid_Systems_L2_Upgrade | UL_Extort_Cash_L1_Upgrade | UL_Extort_Cash_L2_Upgrade | U_Magnetically_Sealed_Structure_Upgrade | UL_Planetary_Bombard_Use_Upgrade | UL_Bombing_Run_Use_Upgrade | U_Secure_Area_Upgrade = 0,10"
		,"UL_Black_Market_Shielding_L1_Upgrade | UL_Black_Market_Shielding_L2_Upgrade | UL_MDU_Armor_Plating_L1_Upgrade | UL_Rancor_Stimulant_L1_Upgrade | UL_Rancor_Stimulant_L2_Upgrade | UL_Enhanced_Deployment_L1_Upgrade = 0,1"
	}
	}
	 
	RequiredCategories = {"Upgrade"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)
	BlockOnCommand(ReserveForce.Produce_Force())

	-- Give some time to accumulate money.
	tech_level = PlayerObject.Get_Tech_Level()
	min_credits = 2000
	if tech_level == 2 then
		min_credits = 3000
	elseif tech_level >= 3 then
		min_credits = 4000
	end
	
	max_sleep_seconds = 50
	current_sleep_seconds = 0
	while (PlayerObject.Get_Credits() < min_credits) and (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end
		
	ScriptExit()
end


