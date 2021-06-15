Msg("Initiating Onslaught (forward only)\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true

	// Min/max time in seconds between mob spawns.
	MobSpawnMinTime = 6
	MobSpawnMaxTime = 8
	
	MobMinSize = 20
	MobMaxSize = 30
	SustainPeakMinTime = 6
	SustainPeakMaxTime = 10
	IntensityRelaxThreshold = 0.90
	RelaxMinInterval = 3
	RelaxMaxInterval = 6
	RelaxMaxFlowTravel = 500
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	PreferredSpecialDirection = SPAWN_ABOVE_SURVIVORS | SPAWN_IN_FRONT_OF_SURVIVORS
}

Director.ResetMobTimer()