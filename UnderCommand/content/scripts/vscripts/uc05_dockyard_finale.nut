Msg("Initiating UC05 map script (finale)\n");

StageDelay <- 15
PreEscapeDelay <- 10

PANIC <- 0
TANK <- 1
DELAY <- 2
ONSLAUGHT <- 3

DirectorOptions <-
{
	A_CustomFinale_StageCount = 4
	
	A_CustomFinale1 		= ONSLAUGHT
	A_CustomFinaleValue1 	= "uc05_dockyard_scavenge_gauntlet"
	
	A_CustomFinale2 		= DELAY
	A_CustomFinaleValue2 	= StageDelay
	
	A_CustomFinale3 		= TANK
	A_CustomFinaleValue3 	= 1
	
	A_CustomFinale4 		= DELAY
	A_CustomFinaleValue4 	= PreEscapeDelay

	ProhibitBosses = true
	HordeEscapeCommonLimit = 20
	EscapeSpawnTanks = false
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
	
	if ( GasCanOptions.Poured == GasCanOptions.Required )
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
	
	if ( num == PreEscapeStage )
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

function GetCustomScriptedStageProgress(defvalue)
{
	local progress = GasCanOptions.Poured.tofloat() / GasCanOptions.Required.tofloat();
	
	if ( developer() > 0 )
	{
		Msg("Progress was " + defvalue + ", now: " + GasCanOptions.Poured + " poured / " + GasCanOptions.Required + " required = " + progress + "\n" );
	}
	
	return progress;
}