-- Minor Jedi Exploit fix.
-- 
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
-- (C) Republic at War.
--
--
--  8888888b.                            888      888 d8b               
--	888   Y88b                           888      888 Y8P               
--	888    888                           888      888                   
--	888   d88P .d88b.  88888b.  888  888 88888b.  888 888  .d8888b      
--	8888888P" d8P  Y8b 888 "88b 888  888 888 "88b 888 888 d88P"         
--	888 T88b  88888888 888  888 888  888 888  888 888 888 888           
--	888  T88b Y8b.     888 d88P Y88b 888 888 d88P 888 888 Y88b.         
--	888   T88b "Y8888  88888P"   "Y88888 88888P"  888 888  "Y8888P      
--	                   888                                              
--	                   888                                              
--	                   888                                              
--
--
--	         888    
--	         888    
--	         888    
--	 8888b.  888888 
--	    "88b 888    
--	.d888888 888    
--	888  888 Y88b.  
--	"Y888888  "Y888 
--
--
--
--     
--	888       888                  
--	888   o   888                  
--	888  d8b  888                  
--	888 d888b 888  8888b.  888d888 
--	888d88888b888     "88b 888P"   
--	88888P Y88888 .d888888 888     
--	8888P   Y8888 888  888 888     
--	888P     Y888 "Y888888 888     
--
--
-- 			Author: Anakin_Sklavenwalker
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGStoryMode")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
   	StoryModeEvents = 
	{
		Jedi_Purge_Remove_Yoda = Check_Minor_Jedi_Alive
	}	
	jedis = 0
end

function Check_Minor_Jedi_Alive(message)
	republic = Find_Player("Empire") 
	baris = Find_First_Object("Barris_Offee")
	luminara = Find_First_Object("Luminara_Unduli")
	shaakti = Find_First_Object("Shaak_Ti")
	aayla = Find_First_Object("Aayla_Secura")
	anakin = Find_First_Object("Anakin_Skywalker")

	if message == OnEnter then
		Register_Timer(end_this, 600)


	elseif message == OnUpdate then
		if TestValid(baris) then
			baris.Despawn()
			jedis = jedis + 1
		end
		if TestValid(luminara) then
			luminara.Despawn()
			jedis = jedis + 1
		end
		if TestValid(shaakti) then
			shaakti.Despawn()
			jedis = jedis + 1
		end
		if TestValid(aayla) then
			aayla.Despawn()
			jedis = jedis + 1
		end
		if TestValid(anakin) then
			anakin.Despawn()
			jedis = jedis + 1
		end
		if jedis == 5 then
			ScriptExit()
		end
	end
end

function end_this()
	ScriptExit()
end












