Msg("Initiating UC05 map script (general)\n");

DirectorOptions <-
{
	CommonLimit = 30
	ProhibitBosses = true
}

GasCanOptions <-
{
	Required = 8
	Poured = 0
}

getroottable()["GasCansRequired"] <- GasCanOptions.Required;
EntFire("scavenge_progress", "SetTotalItems", GasCanOptions.Required);

function GasCanPoured()
{
	GasCanOptions.Poured += 1;
	getroottable()["GasCansPoured"] <- GasCanOptions.Poured;
}