-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/TacticalMultiplayerBuildSpaceUnitsGeneric.lua#5 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/TacticalMultiplayerBuildSpaceUnitsGeneric.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 54441 $
--
--          $DateTime: 2006/09/13 15:08:39 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Tactical_Multiplayer_Build_Space_Units_Generic"
	IgnoreTarget = true
	TaskForce = {
		{
		"ReserveForce"
		,"CS_Level_Two_Starbase_Upgrade | CS_Level_Three_Starbase_Upgrade | CS_Level_Four_Starbase_Upgrade | CS_Level_Five_Starbase_Upgrade = 0,1"
		,"ES_Level_Two_Starbase_Upgrade | ES_Level_Three_Starbase_Upgrade | ES_Level_Four_Starbase_Upgrade | ES_Level_Five_Starbase_Upgrade = 0,1"
		,"US_Level_Two_Starbase_Upgrade | US_Level_Three_Starbase_Upgrade | US_Level_Four_Starbase_Upgrade | US_Level_Five_Starbase_Upgrade = 0,1"
		,"Pirate_Fighter_Squadron | IPV1_SYSTEM_PATROL_CRAFT | PIRATE_FRIGATE = 0,2"
		,"Vulture_Droid_Squadron | CIS_Bomber_Squadron | Tri_Droid_Squadron | Hammer_Class_Picket | Cis_Patrol_Frigate | Munificent_Frigate | Technounion_Frigate | CIS_Carrier | Recusant_Frigate | Lucrehulk_Battleship | Providence_Class_Carrier | P38_Squadron | Malevolence | CIS_Bulwark | Sabaoth_Fighter_Squadron | Sabaoth_Bomber_Squadron | Sabaoth_Deployer | Sabaoth_Destroyer | Rebel_Pirate_IPV | Rebel_Pirate_Frigate | Cis_Gozanti_Cruiser | Rebel_Pirate_Fighter_Squadron | Z95_Headhunter_Rebel_Squadron = 0,3"
		,"V19_Squadron | Arc_170_Squadron | NTB_630_Squadron | Republic_light_assault_cruiser | Republic_light_frigate | Rep_Acclamator_Assault_Ship | Carrack | Rep_Centax_Heavy_Frigate | Dreadnaught_Cruiser | Venator | Mandator_Super_Star_Destroyer | Republic_Victory_Destroyer | Republic_VWing_Squadron | TIE_Fighter_Squadron | Star_Destroyer | Razor_Squadron_Space | Red_Squadron_Space | Shadow_Squadron_Space | Havoc | Freefall | Guardian_Mantis | Mere_Cruiser | G400_Squadron | Empire_Pirate_IPV | Empire_Pirate_Frigate | Republic_Gozanti_Cruiser | Empire_Pirate_Fighter_Squadron | Z95_Headhunter_Empire_Squadron = 0,3"
		,"Crusader_Gunship | Interceptor4_Frigate | Kedalbe_Battleship | Krayt_Class_Destroyer | Skipray_Squadron | StarViper_Squadron | Vengeance_Frigate | Cloakshape_Squadron | Corellian_Frigate | Munificent_Frigate | Vulture_Droid_Squadron | Corellian_Destroyer | Recusant_Frigate | Howlrunner_Squadron | Providence_Class_Carrier | Corellian_BattleCruiser | Lucrehulk_Battleship | Tri_Droid_Squadron | Ginivex_Squadron | Nantex_Squadron | Mankvim_Squadron | Technounion_Frigate | Pinnace |  = 0,3"
		,"Jango_Fett_Team | Asajj_Ventress_Team | Durge_Team | General_Grievous_Team | Aurra_Sing_Team_Space | Bossk_Team_Space_MP | Cad_Bane_Team_Space_MP = 0,1"
		,"Luminara_Team_Space_MP | Mace_Windu_Team | Anakin_Skywalker_Team | Obiwan_Team | Plokoon_Team | Tiin_Fighter | Delta7b_Kitfisto = 0,1"
		,"Bossk_Team_Space_MP | IG88_Team_Space_MP | The_Peacebringer = 0,1"
		}
	}
	RequiredCategories = {"Fighter | Bomber | Corvette | Frigate | Capital | SpaceHero"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)
		
	-- Give some time to accumulate money.
	tech_level = PlayerObject.Get_Tech_Level()
	min_credits = 2000
	max_sleep_seconds = 30
	if tech_level == 2 then
		min_credits = 4000
		max_sleep_seconds = 50
	elseif tech_level >= 3 then
		min_credits = 6000
		max_sleep_seconds = 80
	end
	
	current_sleep_seconds = 0
	while (PlayerObject.Get_Credits() < min_credits) and (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end

	ScriptExit()
end