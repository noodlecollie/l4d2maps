Msg("Initiating UC05 map script (finale)\n");

StageDelay <- 15
PreEscapeDelay <- 10

PANIC <- 0
TANK <- 1
DELAY <- 2
ONSLAUGHT <- 3

DirectorOptions <-
{
	A_CustomFinale_StageCount = 8
	
	A_CustomFinale1 		= ONSLAUGHT
	A_CustomFinaleValue1 	= "uc05_dockyard_scavenge_gauntlet"
	
	A_CustomFinale2 		= DELAY
	A_CustomFinaleValue2 	= StageDelay
	
	A_CustomFinale3 		= TANK
	A_CustomFinaleValue3 	= 1
	
	A_CustomFinale4 		= DELAY
	A_CustomFinaleValue4 	= StageDelay
	
	A_CustomFinale5 		= ONSLAUGHT
	A_CustomFinaleValue5 	= "uc05_dockyard_scavenge_gauntlet"
	
	A_CustomFinale6 		= DELAY
	A_CustomFinaleValue6 	= StageDelay
	
	A_CustomFinale7 		= TANK
	A_CustomFinaleValue7 	= 2
	
	A_CustomFinale8 		= DELAY
	A_CustomFinaleValue8 	= PreEscapeDelay

	ProhibitBosses = true
	HordeEscapeCommonLimit = 20
	EscapeSpawnTanks = true
}

GasCanOptions <-
{
	Required = getroottable()["GasCansRequired"]
	Poured = getroottable()["GasCansPoured"]
}

local PreEscapeStage = DirectorOptions.A_CustomFinale_StageCount;

function GasCanPoured()
{
	GasCanOptions.Poured += 1;
	
	if ( developer() > 0 )
	{
		Msg("Poured: " + GasCanOptions.Poured + " of " + GasCanOptions.Required + "\n");
	}
	
	if ( GasCanOptions.Poured.tointeger() == (GasCanOptions.Required / 2).tointeger() )
	{
		if ( developer() > 0 )
		{
			Msg("Half of required gas cans have been poured.\n");
		}
		
		DoEntFire("director", "EndCustomScriptedStage", "", 0, null, null);
	}
	else if ( GasCanOptions.Poured == GasCanOptions.Required )
	{
		if ( developer() > 0 )
		{
			Msg("All required gas cans have been poured.\n");
		}
		
		DoEntFire("director", "EndCustomScriptedStage", "", 0, null, null);
	}
}

function OnBeginCustomFinaleStage(num, type)
{
	if ( developer() > 0 )
	{
		Msg("Beginning custom finale stage " + num + " of type " + type + "\n");
	}
	
	// TODO: Make into switch
	if ( num == 5 && GasCanOptions.Poured == GasCanOptions.Required )
	{
		if ( developer() > 0 )
		{
			Msg("All required gas cans have been poured already, skipping second gauntlet stage in 10 seconds.\n");
		}
		
		DoEntFire("director", "EndCustomScriptedStage", "", 10, null, null);
	}
	else if ( num == 7 ) // Tank stage after pouring is complete
	{
		EntFire("scavenge_progress", "TurnOff", "");
	}
	else if ( num == PreEscapeStage )
	{
		if ( developer() > 0 )
		{
			Msg("Pre-escape stage reached - beginning rescue arrival.\n");
		}
		
		DoEntFire("arrive_relay", "Trigger", "", 0, null, null);
	}
	else if ( num == PreEscapeStage + 1 )
	{
		if ( developer() > 0 )
		{
			Msg("Escape stage reached - illuminating rescue.\n");
		}
		
		DoEntFire("rescue_boat", "StartGlowing", "", 0, null, null);
	}
}