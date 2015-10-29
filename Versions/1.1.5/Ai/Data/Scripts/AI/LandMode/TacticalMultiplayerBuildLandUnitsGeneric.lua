-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/TacticalMultiplayerBuildLandUnitsGeneric.lua#7 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/TacticalMultiplayerBuildLandUnitsGeneric.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 56734 $
--
--          $DateTime: 2006/10/24 14:15:48 $
--
--          $Revision: #7 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Tactical_Multiplayer_Build_Land_Units_Generic"
	IgnoreTarget = true
	TaskForce = {
	{
		"ReserveForce"
		,"DenySpecialWeaponAttach"
		,"DenyHeroAttach"	
		,"RC_Level_Two_Tech_Upgrade | RC_Level_Three_Tech_Upgrade | RC_Level_Four_Tech_Upgrade = 0,1"
		,"EC_Level_Two_Tech_Upgrade | EC_Level_Three_Tech_Upgrade | EC_Level_Four_Tech_Upgrade = 0,1"
		,"UC_Level_Two_Tech_Upgrade | UC_Level_Three_Tech_Upgrade = 0,1"		
		,"Yoda_Team | Plokoon_Team | Mace_Windu_Team | Obiwan_Team | Anakin_Skywalker_Team | Commander_Cody_Team | Deltasquad_Team | Aayla_Secura_Team_Skirmish = 0,1"
		,"General_Grievous_Team_Land_MP | Jango_Fett_Team_Land_MP | Aurra_Sing_Team | Darkside_Adept_Team | Asajj_Ventress_Team_Land_MP | Durge_Team_Land_MP | Bossk_Team = 0,1"
		,"Urai_Fen_Team | Bossk_Team | Silri_Team | Tyber_Zann_Team | IG88_Team | Guri_Team = 0,1"
		,"Destroyer_Droid_Company | Persuader_Droid_Enforcer_Company | Field_Com_Cis_Team | AAT_Tank_Company | BattleDroid_Squad | Cis_Super_BattleDroid_Squad | Heavy_Artillery_Gun_Company | Cis_Stap_Squad | Hailfire_Tank_Company | Multi_Troop_Transport_Company | Crab_Droid_Company | Darkside_Adept_Team_Skirmish | Homing_Spider_Droid_Company | Repair_Droid_Squad_Skirmish | Magnaguard_Squad_Skirmish | Bx_Commando_Squad | IG86_Squad | BattleDroid_Engineer_Squad | = 0,3"
		,"Field_Com_Republic_P1_Team | Republic_Arc_Trooper_Squad | AT_AP_Company | AT_PT_Company | Republic_Light_Recon_Squad | AT_TE_Company | AV_7_Antivehicle_Cannon_Squad | Republic_Clonetrooper_P1_Squad | Republic_Clonetrooper_P1_Platoon | Republic_Clonetrooper_P1_Company | Barc_Speeder_Squad | Sabertank_Company | Medical_Droid_Squad | Wookiee_Warrior_Company_Skirmish | Republic_Commando_Squad | Republic_Sniper_Squad | A6_Juggernaut_Company | Merc_Squad_Rep_Skirmish | Hacked_Destroyer_Droid_Company | Mandalorian_Merc_Company_Rep | Stolen_AAT_Tank_Company | IG86_Squad_Rep | Arc_Gunship_Air_Wing | Republic_Clonetrooper_Engineer_Two_P1_Squad | Republic_Clonetrooper_Engineer_One_P1_Squad | Republic_Clonetrooper_Medic_P1_Squad  = 0,3"
		,"Canderous_Assault_Tank_Company | Destroyer_Droid_Company | Underworld_Disruptor_Merc_Squad | MAL_Rocket_Vehicle_Company | Underworld_Merc_Squad | Night_Sister_Company | MZ8_Pulse_Cannon_Tank_Company | Underworld_Pod_Walker_Company | Underworld_Skiff_Team | Underworld_Swamp_Speeder_Team | Underworld_Mandalorian_Assault_Squad = 0,3"
		,"HMP_Air_Wing = 0,1"
		,"Laat_Air_Wing = 0,1"
		,"Vornskr_Wolf_Pack | F9TZ_Cloaking_Transport_Company | Underworld_MDU_Company = 0,1"
		}
	}
	RequiredCategories = {"Infantry | Vehicle | LandHero | Upgrade"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)
	BlockOnCommand(ReserveForce.Produce_Force())

	-- Give some time to accumulate money.
	tech_level = PlayerObject.Get_Tech_Level()
	min_credits = 2000
	max_sleep_seconds = 30
	if tech_level == 2 then
		min_credits = 3000
		max_sleep_seconds = 45
	elseif tech_level >= 3 then
		min_credits = 4000
		max_sleep_seconds = 60
	end
	
	current_sleep_seconds = 0
	while (PlayerObject.Get_Credits() < min_credits) and (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end
		
	ScriptExit()
end