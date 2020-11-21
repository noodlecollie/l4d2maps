Msg("Initiating UC05 map script (general)\n");

DirectorOptions <-
{
	CommonLimit = 30
	ProhibitBosses = true
}

GasCanOptions <-
{
	Required = 0
	RequiredFromGeneralSpawns = 0
	Poured = 0
}

GasCanSpawners <- []
BeginningGasCans <- []
EssentialGasCans <- []

function FindAllGasCanSpawnersWithName(name, output)
{
	output.clear();
	local spawner = null;
	
	while ( spawner = Entities.FindByName(spawner, name) )
	{
		output.append(spawner);
	}
}

function FindAllGasCanSpawners()
{
	FindAllGasCanSpawnersWithName("scavenge_gascans", GasCanSpawners);
	FindAllGasCanSpawnersWithName("essential_gascans", EssentialGasCans);
	FindAllGasCanSpawnersWithName("begin_gascan", BeginningGasCans);
	
	if ( developer() > 0 )
	{
		Msg("Gas cans found:\n");
		Msg("    " + EssentialGasCans.len() + " essential\n");
		Msg("    " + BeginningGasCans.len() + " pre-finale\n");
		Msg("    " + GasCanSpawners.len() + " general\n");
		Msg("= " + (EssentialGasCans.len() + BeginningGasCans.len() + GasCanSpawners.len()) + " total\n");
	}
}

// This includes the first gas can, which is always required.
function CalcNumGasCansRequired()
{
	// TODO: Modify based on difficulty.
	GasCanOptions.Required = 8;
	
	GasCanOptions.RequiredFromGeneralSpawns = GasCanOptions.Required - BeginningGasCans.len() - EssentialGasCans.len();
	
	// Shouldn't happen if we've been sensible:
	if ( GasCanOptions.RequiredFromGeneralSpawns > GasCanSpawners.len() )
	{
		if ( developer() > 0 )
		{
			Msg(GasCanOptions.RequiredFromGeneralSpawns + " cans were required from general spawners, when only " + GasCanSpawners.len() + " spawners were available.\n");
		}
	
		GasCanOptions.RequiredFromGeneralSpawns = GasCanSpawners.len();
		GasCanOptions.Required = GasCanOptions.RequiredFromGeneralSpawns + BeginningGasCans.len() + EssentialGasCans.len();
	}
	
	if ( developer() > 0 )
	{
		Msg("Gas cans required: " + GasCanOptions.Required + " (" + GasCanOptions.RequiredFromGeneralSpawns + " from general spawns)\n");
	}
}

function KillUnnecessarySpawnersAtRandom()
{
	if ( developer() > 0 )
	{
		Msg("Killing " + (GasCanSpawners.len() - GasCanOptions.RequiredFromGeneralSpawns) + " general gas can spawners.\n");
	}

	while ( GasCanSpawners.len() > GasCanOptions.RequiredFromGeneralSpawns ) 
	{
		local index = RandomInt(0, GasCanSpawners.len() - 1);
		GasCanSpawners[index].Kill();
		GasCanSpawners.remove(index);
	}
}

// Called when the beginning gas can is poured.
// This function just updates the count in the root table.
function GasCanPoured()
{
	GasCanOptions.Poured += 1;
	getroottable()["GasCansPoured"] <- GasCanOptions.Poured;
}

//////////////////////////////////////////////
// Logic run at beginning of level starts here
//////////////////////////////////////////////

FindAllGasCanSpawners();
CalcNumGasCansRequired();
KillUnnecessarySpawnersAtRandom();

// Make sure other scripts can see the required count.
getroottable()["GasCansRequired"] <- GasCanOptions.Required;

EntFire("scavenge_progress", "SetTotalItems", GasCanOptions.Required);