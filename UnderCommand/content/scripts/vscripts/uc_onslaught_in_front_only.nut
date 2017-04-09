Msg("Initiating Onslaught (forward only)\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true

	// Min/max time in seconds between mob spawns.
	MobSpawnMinTime = 8
	MobSpawnMaxTime = 8
	
	MobMinSize = 30
	MobMaxSize = 40
	SustainPeakMinTime = 6
	SustainPeakMaxTime = 6
	IntensityRelaxThreshold = 0.90
	RelaxMinInterval = 4
	RelaxMaxInterval = 4
	RelaxMaxFlowTravel = 600
	PreferredMobDirection = SPAWN_ABOVE_SURVIVORS | SPAWN_IN_FRONT_OF_SURVIVORS
	PreferredSpecialDirection = SPAWN_ABOVE_SURVIVORS | SPAWN_IN_FRONT_OF_SURVIVORS
}

Director.ResetMobTimer()