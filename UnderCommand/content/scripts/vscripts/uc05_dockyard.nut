Msg("Initiating UC05 map script (general)\n");

DirectorOptions <-
{
	CommonLimit = 30
	ProhibitBosses = true
}

GasCanOptions <-
{
	Required = 0
	Poured = 0
}

// These do not include the first gas can that is poured before the finale.
GasCanSpawners <- []

function FindAllGasCanSpawners()
{
	local spawner = null;
	
	while ( spawner = Entities.FindByName(spawner, "scavenge_gascans") )
	{
		GasCanSpawners.append(spawner);
	}
	
	if ( developer() > 0 )
	{
		Msg("Found " + GasCanSpawners.len() + " gas can spawners in level, plus beginning can.\n");
	}
}

// This includes the first gas can, which is always required.
function CalcNumGasCansRequired()
{
	// TODO: Modify based on difficulty.
	local additionalRequired = 7;
	
	GasCanOptions.Required = 1 + (additionalRequired > GasCanSpawners.len() ? GasCanSpawners.len() : additionalRequired);
	
	if ( developer() > 0 )
	{
		Msg("Gas cans required: " + GasCanOptions.Required + "\n");
	}
}

function KillUnnecessarySpawnersAtRandom()
{
	// -1 here to allow the pre-finale gas can to exist.
	local requiredCount = GasCanOptions.Required - 1;
	
	if ( developer() > 0 )
	{
		Msg("Killing " + (GasCanSpawners.len() - requiredCount) + " gas can spawners.\n");
	}

	while ( GasCanSpawners.len() > requiredCount )
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