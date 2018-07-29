Msg("UC05 map script "+"\n")

// This script is called on MapSpawn, so the CommonLimit is for play before the finale start.
/*DirectorOptions <-
{
    
CommonLimit = 15

}*/

NumCansNeeded <- 3

NavMesh.UnblockRescueVehicleNav() // Unblock so humans can be rescued when incapped near nozzle

EntFire( "scavenge_progress", "SetTotalItems", 3 ) // Set number of cans with game_scavenge_progress_display


function GasCanPoured(){} // Declaration of function, but was moved to main finale script