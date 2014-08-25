// Sample Holdout mutation script by [X6] Herbius on 26/03/14
// Based on Valve's c4m1_milltown_a_holdout.nut
// This file should reside in scripts/vscripts.
// It should be named <mapname>_holdout.nut in order to be picked up by the game.
// This file is executed in the MAP_SCRIPT layer

// Most entity groups can be placed via instances, but some cannot. For example:
//  - "Tank spawn manager" errors will occur if there are no tank manholes in the map. To fix this, place info_item_position
//      entities named "tank_manhole_spawn" where the manholes should spawn. Ensure there are as many as the script expects
//      (4 by default).
//  - "Rescue manager" errors will occur if there is no rescue helicopter in the map. Place an info_item_position named "rescue_helicopter_spawn".
//  - "Witch manager" errors will occur if there are no witch spawns in the map. Place as many info_item_positions named "witch_tombstone_spawn"
//      as the script expects (4 by default).
//  - Gas cans are spawned in Milltown with entities named "gascanspawn_clusterX". There are several
//      spawns for each cluster. For cluster X, the group property on the spawn must also be set to X.
//      "gascanspawn_start" with group 0 is used for the initial can position.

// ==================== Begin includes ==================== //

// Resource manager. Required no matter what you're doing, otherwise players will be unable to purchase items.
IncludeScript("sm_resources", g_MapScript)

// Gascan manager handles the spawning of holdout gascans.
IncludeScript("holdout_gascan_manager", g_MapScript)

// Balloon resupply manager handles spawning of resupply balloon event.
IncludeScript("resupply_balloon_spawn_manager", g_MapScript )

// ==================== End includes ==================== //

// ==================== Begin map spawns ==================== //

// Include all entity group interfaces needed for this mode.
// Entities in the MapSpawns table will be included and spawned on
// map start by default unless otherwise specified.

// MapSpawn table contains at minimum the group name.                                                   E.g., [ "WallBarricade" ]
// There are at most four parameters: group name, spawn location, file to include and spawn flags.      E.g., [ "WallBarricade", "wall_barricade_spawn", "wall_barricade_group", SPAWN_FLAGS.SPAWN ]

// If you provide only the group name, the spawn location and file to include will be generated
// and the default 'spawn' flag will be used.                                                           E.g., [ "WallBarricade" ]

// If you provide two parameters, it assumes they are the group name and spawn flag
// and will auto generate the spawn location and file to include.                                       E.g., [ "WallBarricade", SPAWN_FLAGS.NOSPAWN ]

// If you provide three parameters it assumes group name, spawn location, and file to include.
// It will use the default 'spawn' flag.                                                                E.g., [ "WallBarricade", "my_barricade_spawn", "my_barricade_group" ]

// The spawn flag values can be found in sm_utilities.nut. They are as follows:
// SPAWN_FLAGS.SPAWN        (1<<0)  Default. Spawns on map spawn.
// SPAWN_FLAGS.NOSPAWN      (1<<1)  Includes the entity group but does not spawn the entity.
// SPAWNFLAGS.TARGETSPAWN   (1<<2)  Spawns to a set number of targets.

// The spawns used for Milltown are below. Uncomment an entry to have it spawn in the map.
// If you have placed items in the map manually using instances, they don't need to be uncommented here. (TODO: Confirm?)
MapSpawns <- 
[
    // Nav blockers - prevent NPCs from traversing parts of the map.
	// [ "Blocknav64" ],
	// [ "Blocknav128" ],
	// [ "Blocknav256" ],
    
    // Causes areas of the map to remain empty from wandering zombies.
    // [ "Empty64" ],
	// [ "Empty256" ],
    
    // Prevents players from going down certain paths.
    // [ "WrongwayBarrier" ],
    
    // Barricades.
    // [ "WallBarricade" ],
	// [ "WindowBarricade" ],
    
    // Weapons.
	// [ "Tier1WeaponCabinet" ],
	// [ "Tier2WeaponCabinet" ],
    
    // Buildable/deployable weapons and items.
    // [ "BuildableMinigun" ],
    // [ "FirewallTrap" ],
	// [ "FirewallPipe" ],
    // [ "CeilingFan" ],
    // [ "Landmine" ],
    // [ "MineTable" ],                     // Table of landmines for purchase.
    // [ "BuildableLadder" ],
    
    // Items.
    // [ "HealthCabinet" ],
	// [ "DefibCabinet" ],
    // [ "AmmoCabinet" ],
    // [ "AmmoCrate" ],
    // [ "FootlockerThrowables" ],
    // [ "MedCabinet" ],
    // [ "ResourceLocker" ],
	// [ "CarnivalgameStachewhacker" ],     // Requires survivors to win the minigame to gain items.
    // [ "PlaceableResource" ],             // Dropped by special infected.
	
	// Utility vehicles.
	// [ "GascanHelicopter" ],
	// [ "GascanHelicopterButton" ],
	// [ "ResupplyHelicopter" ],
	// [ "ResupplyHelicopterButton" ],
    
    // Misc.
    // [ "FireworkLauncher" ],          // Aesthetical only - used to simulate calling in the resupply helicopter.
    // [ "CooldownExtensionButton" ],   // Gives the survivors more time to prepare for the next wave.
    // [ "UnbreakablePanel" ],          // Simple sheet of metal.
    // [ "Searchlight" ],               // Searchlight and generator that call the helicopter.
    // [ "Hintboard" ],                 // Provides gameplay hints. See HintBoardStringTable() to define your own.
    // [ "TankManhole" ],               // Spawn point for a tank on special stages.
    // [ "C4m1MilltownAMisc" ],         // Entities specific to Milltown - you probably won't need these.
	// [ "C4m1MilltownAZombiehouse" ],  // Zombie house in Milltown - again, you probably won't need this.
    
    
    // The following items use parameters specific to Milltown.
    // When uncommenting these items, replace the spawn location targetname and the spawn flags
    // to reflect your map's setup. When using TARGETSPAWN, the subsequent parameter provides
    // the number of targets to consider for spawning at.
    
    // [ "RescueHelicopter", "rescue_helicopter_spawn", "rescue_helicopter_group", SPAWN_FLAGS.TARGETSPAWN, 1 ],
	// [ "WitchTombstone", "witch_tombstone_spawn", "witch_tombstone_group", SPAWN_FLAGS.TARGETSPAWN, 4 ],
    // [ "ResupplyBalloon", SPAWN_FLAGS.NOSPAWN ],
]

// ==================== End map spawns ==================== //

// ==================== Begin map variables ==================== //

MapState <-
{
	RescueTime = 600        // How long to run the rescue timer for. This value is decreased only when the generator is fueled.
	InitialResources = 0    // Initial amount of credits the survivors have to purchase items. 
	NextDelayTime = 60      // The time the survivors must wait between holdout stages. This is only a failsafe default, as each stage should define its own delay (see later).
	HUDWaveInfo = false     // Set this to true to have the wave number in the middle of the HUD,
	HUDRescueTimer = true   // Or this to true to have thr rescue timer in the centre instead. Cannot have both true.
	HUDTickerTimeout = 0    // TODO: What does this do? At a guess, keeping it at 0 means that the ticker never disappears?
	HUDTickerText = "Collect respawning gascans and keep spotlights fueled to be rescued"   // Text to be displayed on the HUD ticker at the beginning of the map..
	StartActive = true      // TODO: What does this do?
}

MapOptions <-
{
	SpawnSetRule = SPAWN_POSITIONAL             // Positional uses radius and position values for spawning infected. For other options, see https://developer.valvesoftware.com/wiki/L4D2_EMS/Appendix:_Spawning_Infected
	SpawnSetRadius = 3000                       // Radius from SpawnSetPosition in which to spawn zombies.
	SpawnSetPosition = Vector( 846, 5267, 158 ) // Vector position representing the centre of the spawning area. Change this to suit your map.
}

// These are custom variables provided for convenience.
// Ensure that at least as many items as specified here are present in the map,
// otherwise there may be script errors.

NumTankManholes <- 4    // Number of tank manholes present in the map.
NumWitchTombstones <- 4 // Number of witch tombstones present in the map.

// ==================== End map variables ==================== //

// ==================== Begin map sanitiation list ==================== //

// List items here that should be removed from the map before the mutation is run.
// This frees up CPU/GPU resources as well as removing logic that may interfere with the workings of the mutation.
// Sanitation can be done in several different ways:

// Removal by model: any entity (apart from static props and the like) whose model matches the given name is removed.
// The input to remove the entity must be specified - most of the time this will just be "kill".
// Eg: { model = "models/props_interiors/chair_cafeteria.mdl", input = "kill" }

// Removal by targetname: any entity whose name matches the given name is removed. Wildcards are allowed.
// Eg: { targetname = "caralarm*", input = "kill" }

// Removal by classname: any entity whose classname matches the given name is removed. Wildcards are allowed.
// Eg: { classname = "func_breakable", input = "break" }

// Removal by region: specifying the "region" parameter in any of the above scenarios will remove only entities in this region.
// TODO: How are regions set?
// Eg: // { classname = "logic*", input = "kill", region = "sanitize_region_front" },
SanitizeTable <-
[
    // Common sanitation inputs:
	{ targetname	= "relay_intro_start", input = "kill" },                // Disables the introductory cutscene (at least on Milltown). Change this to match the targetname of the cutscene relay in a given map if needed.
	{ classname	    = "info_survivor_position", input = "kill" },           // Removes survivor positions in the intro cutscene, since they are no longer needed.
	{ targetname	= "caralarm*", input = "kill" },                        // Fairly generic catch-all for car alarm entities. Add in more specific entries if needed.
	{ classname		= "info_survivor_rescue", input = "kill" },             // Survivor spawn points in rescue closets.
	{ classname		= "info_remarkable", input = "kill" },                  // Removes all remarkable points from the map to stop survivors from mentioning campaign-specific lines.
	{ classname		= "weapon_*", input = "kill" },                         // Removes all weapon spawns unrelated to the mutation.
	{ classname		= "upgrade_spawn", input = "kill" },                    // Removes all upgrade spawns unrelated to the mutation.
	{ model 		= "models/props_junk/gascan001a.mdl", input = "kill" }, // Removes all gas cans unrelated to the mutation.
    
    // Potentially useful sanitation inputs:
    // { classname		= "func_breakable", input = "break" },                                  // Uncomment this if you want all func_breakables to be dispensed with.
    // { classname		= "prop_door_rotating", input = "kill" },                               // Uncomment this if you want rotating doors to be removed.
    // { model 		    = "models/props/de_inferno/ceiling_fan_blade.mdl", input = "kill" },    // Removes ceiling fan blades. These can then be replaced with weaponised blades if desired.
    // { targetname    = "ds_int-attack_timer", input = "kill" },                               // Disables air strikes on c5m4.
]

// ==================== End map sanitiation list ==================== //

// ==================== Begin map hints ==================== //

// This table specifies the text hints to display at given hint points.
// The targetname of the hint point, the name of the model to display near, the targetname of the target entity
// and the hint text itself must all be specified.
// TODO: How do we create hint points? How do these definitions actually work?
// TODO: Is there potential for these strings to be localised?
InstructorHintTable <-
[
    // Example entry:
    // { targetname = "tier_1_script_hint",    mdl = "models/props_unique/guncabinet_door.mdl",    targetEntName = "gun_cabinet_door",    hintText = "Tier 1 Guns" }
]

// This table specifies the strings for the hint board to use.
// When players +use the board, one of these strings is picked at random.
// TODO: Is there potential for these strings to be localised?
HintBoardStringTable <-
[
    // Example entry:
    // ["This is a sample hint!"],
]

// ==================== End map hints ==================== //

// ==================== Begin stage callbacks ==================== //

// Callbacks must be defined before the stage tables that use them, otherwise the script throws errors!

// Called when the first stage begins.
// In Milltown this prints a "Here they come!" message to the players' HUD.
function GameStartCB( stageData )
{
	Ticker_SetBlink( true )
	Ticker_NewStr( "Here they come!", 5 )
}

// Called when the escape stage begins.
// This should call the rescue helicopter so that the survivors can escape.
function EscapeWaveCB( stageData )
{
	g_RoundState.g_RescueManager.EnableRescue()
}

// Called when the delay stage begins.
// In Milltown this function was used to check whether to prepare tanks/witches to spawn, or release a supply balloon.
function DelayCB( stageData )
{
	smDbgPrint( "In Delay Callback " + stageData.value )

	// Check to see if tanks should spawn.
	g_RoundState.TankManager.ManholeTankSpawnCheck()

	// Check to see if witches should spawn.
	g_RoundState.WitchManager.WitchSpawnCheck()

	// Check to see if the supply balloon should be released.
	g_RoundState.ResupplyBalloonManager.ResupplyBalloonSpawnCheck()
}

// Called when the witch special stage begins.
// In Milltown this function targets a point_servercommand to set the rage ramp duration for witches,
// before spawning them. (TODO: Why not just execute a console command without having to resort to a point_servercommand??)
function witchWaveCB( stageData )
{
    EntFire( "@command", "command", "witch_rage_ramp_duration 1", 0 )
    g_RoundState.WitchManager.ReleaseTombstoneWitches()	
}

// Uncomment this if you've uncommented the "zombie house" special stage.
// Change the targetname in EntFire() to reflect the name of your own logic_relay.
// function zombieHouseCB( stageData )
// {
	// Ticker_SetBlink( true )
	// Ticker_NewStr("Beware, a large mob of infected are breaking out of a house!", 15)
	// EntFire( "@zombiehouse_preparehouse_relay", "trigger" )
// }

// ==================== End stage callbacks ==================== //

// ==================== Begin stage definitions ==================== //

// Stages in Holdout are defined by tables containing information pertaining to the director.
// This information specifies things like which special infected are allowed to spawn in the stage, the maximum number of zombies alive,
// the direction from which infected spawn, and so on.
// In Milltown, Valve defined each of the ten stages as hardcoded tables, along with special stages. These are replicated below.

// Convenience defines for delays between stages. These are used in the definitions below.
DelayTimeShort <- 40
DelayTimeMedium <- 65
DelayTimeLong <- 100

// Default stage settings.
// TODO: Is this default stage used anywhere by the code?
stageDefaults <-
{
    name = "default",                               // Name of the stage.
    type = STAGE_PANIC,                             // Stage type. See https://developer.valvesoftware.com/wiki/L4D2_EMS/StageTypeAppendix for different options.
    value = 1,                                      // TODO: What's this?
    params =                                        // Parameters specifying zombie limits.
    {
        CommonLimit = 100,                          // Maximum number of common infected allowed to be alive at one time.
        MegaMobSize = 50,                           // Total number of common infected that must spawn before a panic wave is complete. Adheres to CommonLimit, meaning that if CommonLimit
                                                    // is less that MegaMobSize, new zombies will spawn as previous ones die until the MegaMobSize quota is filled, with the total number alive
                                                    // at one time never going over CommonLimit.
        BileMobSize = 20,                           // Number of zombies spawned in a mob caused by a bile jar. TODO: Confirm?
        TotalSpitters = 0,                          // Max number of active spitters at one time. Other special infected have their own, similar settings too.
        TankLimit = 1,                              // Max number of tanks allowed at one time.
        SpawnDirectionCount = 0,                    // TODO: What's this?
        SpawnDirectionMask = 0,                     // Bit mask of directions, relative to a "compass" entity, that infected are allowed to spawn from in this wave.
                                                    // See https://developer.valvesoftware.com/wiki/L4D2_EMS/Appendix:_Spawning_Infected
        AddToSpawnTimer = 6,                        // TODO: What's this?
        SpawnSetRadius = 3000,                      // If spawning from a specific position, specifies the radius around the position in which to spawn zombies.
        SpawnSetPosition = Vector( 846, 5267, 158 ) // Specifies the central position relating to the above radius.
    },
    callback = null,                                // TODO: Callback to fire when this stage is run.
    trigger = null                                  // TODO: What's this?
}

// Individual stages.
// TODO: Do these just change settings on top of the default stage?
stage1 <-
{
    name = "wave 1",
    params =
    {
        PanicWavePauseMax = 1,
        DefaultLimit = 1,
        BoomerLimit = 0,
        ChargerLimit = 0,
        MaxSpecials = 4,
        SpawnDirectionMask = SPAWNDIR_E
    },
    NextDelay = DelayTimeShort,
    callback = GameStartCB
}

stage2 <-
{
    name = "wave 2",
    params =
    {
        PanicWavePauseMax = 1,
        DefaultLimit = 1,
        BoomerLimit = 0,
        HunterLimit = 2,
        SpitterLimit = 1,
        MaxSpecials = 4,
        SpawnDirectionMask = SPAWNDIR_N
    },
    NextDelay = DelayTimeShort
}

stage3 <-
{
    name = "wave 3",
    params =
    {
        DefaultLimit = 1,
        BoomerLimit = 0,
        JockeyLimit = 2,
        mokerLimit = 2,
        MaxSpecials = 4,
        SpawnDirectionMask = SPAWNDIR_NW | SPAWNDIR_S
    },
    NextDelay = DelayTimeMedium
}

stage4 <-
{
    name = "wave 4",
    params =
    {
        DefaultLimit = 1,
        HunterLimit = 2,
        SmokerLimit = 2,
        SpitterLimit = 2,
        MaxSpecials = 6,
        SpawnDirectionMask = SPAWNDIR_E | SPAWNDIR_W
    },
    NextDelay = DelayTimeShort
} 

stage5 <-
{
    name = "wave 5",
    params =
    {
        DefaultLimit = 1,
        BoomerLimit = 0,
        SpitterLimit = 0,
        MaxSpecials = 4,
        SpawnDirectionMask = SPAWNDIR_SW | SPAWNDIR_NE
    },
    NextDelay = DelayTimeMedium
} 

stage6 <-
{
    name = "wave 6",
    params =
    {
        DefaultLimit = 2,
        SmokerLimit = 3,
        MaxSpecials = 6,
        SpawnDirectionMask = SPAWNDIR_NW | SPAWNDIR_SE
    },
    NextDelay = DelayTimeMedium
} 

stage7 <-
{
    name = "wave 7",
    params =
    {
        DefaultLimit = 1,
        BoomerLimit = 2,
        SpitterLimit = 6,
        MaxSpecials = 8,
        SpawnDirectionMask = SPAWNDIR_E | SPAWNDIR_S
    },
    NextDelay = DelayTimeShort
} 

stage8 <-
{
    name = "wave 8",
    params =
    {
        DefaultLimit = 2,
        HunterLimit = 4,
        ockeyLimit = 4,
        SmokerLimit = 5,
        MaxSpecials = 10,
        SpawnDirectionMask = SPAWNDIR_NE | SPAWNDIR_SE
    },
    NextDelay = DelayTimeMedium
} 

stage9 <-
{
    name = "wave 9",
    params =
    {
        DefaultLimit = 4,
        MaxSpecials = 10,
        SpawnDirectionMask = SPAWNDIR_NE | SPAWNDIR_E | SPAWNDIR_NW
    },
    NextDelay = DelayTimeMedium
} 

stage10 <-
{
    name = "wave 10",
    params =
    {
        DefaultLimit = 4,
        MaxSpecials = 12,
        SpawnDirectionMask = SPAWNDIR_NE | SPAWNDIR_SW | SPAWNDIR_NW
    },
    NextDelay = DelayTimeMedium
}

// Prototype for stages past level 10.
// The base settings are specified here and are randomised on the fly by the RandomizeStage10Plus() function.
stage10plus <-
{
	name = "wave 10+", 
	params =
    {
        BoomerLimit = 4,
        ChargerLimit = 4,
        HunterLimit = 4,
        JockeyLimit = 4,
        SpitterLimit = 4,
        SmokerLimit = 4,
        MaxSpecials = 14,
        CommonLimit = 100,
        SpawnDirectionCount = 2
    }, 
	NextDelay = DelayTimeShort 
}

// Special stages.
stages_special <-
[
	{
        name = "Spitters!",
        params =
        {
            DefaultLimit = 0,           // TODO: What's this?
            SpitterLimit = 6,
            MaxSpecials = 8,
            CommonLimit = 10,
            TotalSpitters = 6,
            PanicSpecialsOnly = 1,      // TODO: What's this?
            SpecialRespawnInterval = 1, // Number of seconds between death and respawn of a special infected. TODO: Confirm?
            MegaMobSize = 100,
            SpecialInfectedAssault = 1  // TODO: What's this?
        },
        NextDelay = DelayTimeMedium,
        levelrange = [3, 7]             // This stage can only occur between stages 3 and 7 inclusive. TODO: Confirm?
    } 
    
	{
        name = "Chargers!",
        params =
        {
            DefaultLimit = 0,
            ChargerLimit = 8,
            MaxSpecials = 8,
            CommonLimit = 10
        },
        NextDelay = DelayTimeMedium,
        scaletable = [ {var = "MaxSpecials", scale = 1.05} ]    // TODO: What's this? Does it take whatever value is present currently and multiply it by 1.05? If so, why not something like *= 1.05?
    } 
	
	{
        name = "Nothing",
        params =
        {
            DefaultLimit = 1,
            MaxSpecials = 1,
            CommonLimit = 20
        },
        NextDelay = DelayTimeMedium,
        scaletable = [ {var = "CommonLimit", scale = 1.12} ], levelrange = [2, 6]
    }
    
    // The "zombie house" stage from Milltown.
    // Uncomment this and and change the position if you want to use it in your own map.
    // Also uncomment zombieHouseCB() in order for map logic to be triggered when this wave begins.
    // {
        // name = "Zombiehouse!",
        // params =
        // {
            // PanicWavePauseMax = 1,
            // TankLimit = 1,
            // DefaultLimit = 0,
            // BoomerLimit = 0,
            // ChargerLimit = 0,
            // JockeyLimit = 6,
            // SmokerLimit = 0,
            // HunterLimit = 0,
            // SpitterLimit = 0,
            // MaxSpecials = 6,
            // CommonLimit = 5,
            // SpawnSetRadius = 200,
            // SpawnSetPosition = Vector( 1224, 6285, 140 ),
            // MegaMobMaxSize = 75,
            // MegaMobMinSize = 75,
            // MegaMobSize = 15
        // },
        // NextDelay = DelayTimeShort,
        // callback = zombieHouseCB
    // }
]

// Provides metadata about the special stages.
stages_special_info <-
{
    chance = 5.0,       // Chance that the next stage should be a special stage. TODO: Confirm? Is this out of 100?
    per_level = 10.0,   // TODO: What's this?
    max_allowed = 1,    // TODO: What's this?
    earliest = 3        // Earliest stage that a special stage is allowed. TODO: Confirm?
}

// Escape stage - when the rescue helicopter has arrived.
stageEscape <-
{ 
	name = "escape wave", 
	params = 
	{ 
		TankLimit = 1, 
		DefaultLimit = 4, 
		JockeyLimit = 5,
		MaxSpecials = 17, 
		CommonLimit = 100,
		SpawnDirectionMask = SPAWNDIR_W | SPAWNDIR_E | SPAWNDIR_N 
	},
	callback = EscapeWaveCB, 
	type = STAGE_ESCAPE
}

// Witch stage - spawn witches for the players to deal with.
stageWitchWave <-
{ 
	name = "witchwave", 
	params =
    {
        DefaultLimit = 0,
        MaxSpecials = 0,
        CommonLimit = 0
    }, 
	callback = witchWaveCB 
}

// Delay stage - gives survivors a cooling-off period between fighting infected.
stageDelay <-
{
    name = "delay",
	params =
    {
        DefaultLimit = 0,
        MaxSpecials = 0,
        BileMobSize = 20
    }
	callback = DelayCB,
    type = STAGE_DELAY,
    value = 60              // This is the delay before the next stage. It is overwritten as needed by GetMapDelayStage().
}

// ==================== End stage definitions ==================== //

// ==================== Begin required function implementations ==================== //

// The Holdout mutation required the following functions to be implemented in each map's script file:

//  DoMapEventCheck()
//  DoMapSetup()
//  GetMapEscapeStage()
//  IsMapSpecificStage()
//  GetMapSpecificStage()
//  GetAttackStage()
//  GetMapClearoutStage()
//  GetMapDelayStage()

//  Each of these should return a "stageTable", or null to ignore. (TODO: What does "null to ignore" mean?)

// DoMapEventCheck() performs checks to decide whether to activate any special map events.
// For example, in Milltown this function checks whether a tank should be spawned or the supply balloon should be released.
// Add in any checks here for custom events within your map.
function DoMapEventCheck()
{
	// Check whether it's time to release a tank.
	g_RoundState.TankManager.ManholeTankReleaseCheck()
}

// DoMapSetup() deals with initialising anything required by the mode, before gameplay begins for the first time.
// In Milltown it is used to create the training hints, spawn specific weapons, set up tanks and witches, etc.
function DoMapSetup()
{
    printl("HOLDOUT: Map setup beginning.")
    
    // Create any hints we require.
	CreateTrainingHints( InstructorHintTable )
	
	// Add tank manholes.
	g_RoundState.TankManager.ManholeTankSetup(NumTankManholes)

	// Set up the witch event.
	g_RoundState.WitchManager.WitchSetup()
}

// GetMapEscapeStage() deals with any logic that should occur just before the final escape stage of the mutation.
// Milltown uses this function to change the HUD ticker to alert players of the rescue helicopter.
// stageEscape is returned by default (see stage definitions above) to provide the stage settings.
function GetMapEscapeStage()  
{
	Ticker_SetBlink( true )
	Ticker_NewStr("Here comes the rescue chopper!")
	return stageEscape
}

// IsMapSpecificStage() returns true if the current stage is a unique stage (ie. not just throwing zombies at players).
// In the context of Milltown, this was the witch stage.
// The function below returns true if the witch stage is happening, or false otherwise.
function IsMapSpecificStage()
{
	if ( g_RoundState.WitchManager.IsActivating() )
		return true
	return false
}

// GetMapSpecificStage() returns the stage table for a unique stage.
// This should be called by the game when IsMapSpecificStage() is true. (TODO: Confirm/clarify)
function GetMapSpecificStage()
{
	if ( g_RoundState.WitchManager.IsActivating() )
		return stageWitchWave
    
    // If this is called at the wrong time (for whatever reason), returning null will cancel it.
    // TODO: What actually happens with the mutation when we return null here?
	printl( "HEY! who called GetMapSpecificStage given that witchchurch isnt activating...???" )
	return null
}

// GetAttackStage() returns the stage table the mutation should use for the next wave of zombies.
// The setup for Milltown (replicated below) returns a special stage if applicable, or a standard stage otherwise.
function GetAttackStage( )
{   
    // CheckForSpecialStage uses the array of special stages, along with their metadata, to decide whether a special stage should be chosen.
    // TODO: How does this work behind the scenes?
	local use_stage = CheckForSpecialStage(SessionState.ScriptedStageWave, stages_special, stages_special_info)
    
    // If the function returned a stage, we should use it.
	 if ( use_stage != null )
		return use_stage

    // No special stage was chosen.
    // If we are past stage 10, use stage10Plus and randomise some of its variables.
	if ( SessionState.ScriptedStageWave > 10 )
		return RandomizeStage10Plus(SessionState.RawStageNum)
    
    // Otherwise, return a normal stage.
    // This builds the stage name using the mutation's stage counter and returns the corresponding stage table.
	else
	{
		local stage_name = "stage" + SessionState.ScriptedStageWave // Build the name string.
		return this[stage_name]                                     // Because we need to return the table (and it's global), this is done by indexing using 'this[stage_name]'.
	}
}

// GetMapClearoutStage() returns the stage details for the 'clearout' phase - when the survivors are mopping up the
// last few zombies from the panic wave.
// In Milltown, this function demonstrates an alternative method of setting stage variables:
// previous functions returned a stage table containing the stage settings, whereas
// it is also possible simply to set the director options manually from within the function
// and return null afterwards.
function GetMapClearoutStage()
{
	DirectorOptions.ScriptedStageType = STAGE_CLEAROUT  // Set the stage type to 'clearout'.
	DirectorOptions.ScriptedStageValue = 5              // TODO: What's this?
	return null
}

// GetMapDelayStage() returns the delay in seconds (TODO: Confirm?) until the next stage begins.
function GetMapDelayStage()
{
    // If a NextDelayTime is present in the session, use this value.
	if ( "NextDelayTime" in SessionState )
		stageDelay.value = SessionState.NextDelayTime
    
    // Otherwise, use a medium delay (defined earlier as 65).
	else
		stageDelay.value = DelayTimeMedium
    
    // Return the stageDelay table that we defined earlier (now that its delay value has been overridden).
	return stageDelay
}

// ==================== End required function implementations ==================== //

// ==================== Begin other mutation logic ==================== //

// MapSlowPoll() is called once every 2.5 seconds (TODO: Confirm? I think it's faster.)
// This function allows conditions in the map to be periodically checked.
// Milltown uses it to check whether the rescue helicopter should be summoned, and
// to check whether to spawn new gas cans.
function MapSlowPoll()
{	
    // Check for the rescue helicopter.
	g_RoundState.g_RescueManager.SummonRescueChopperCheck()

	// Spawn gas cans if we need to.
	g_RoundState.g_GascanManager.GascanUpdate()
}

// RandomizeStage10Plus() takes stage10plus and changes some of its settings,
// in order to provide these to the director.
function RandomizeStage10Plus ( raw_stage_num )
{
    // Set a random number of specials, which increases as we progress further through stages.
	stage10plus.params.MaxSpecials = RandomInt(12,19) + (raw_stage_num / 4)
    
	// This loop iterates over each of the special infected and changes their limits.
	foreach (val in SpecialNames)
	{
        // Choose a random number as the limit, which increases as we progress further through stages.
		local limit = RandomInt(2,5) + (raw_stage_num / 10)
		stage10plus.params[val + "Limit"] = limit           // Set the limit by building the name of the property from the special infected's name.
	}
    
    // Valve's notes on spawn directions:
    
	//      if we wanted to do Masks here, we could have a table and just Random an index into that table instead
	//      i.e. local dir_table = [ SPAWNDIR_N, SPAWNDIR_NE | SPAWNDIR_SW, SPAWNDIR_W ]
	//           stage10plus.params.SpawnDirectionMask = dir_table[RandomInt(0,2)]
    
	//      or write code to always pick 2 "next door" directions in the Mask, instead of just using count - prob better
	//      i.e. local first_dir = 1 << RandomInt(0,7)
	//           stage10plus.params.SpawnDirectionMask = first_dir + (first_dir<<1)  // yea, wrap broken, maybe use table, bleh
    
    // That aside, the following lines set how many directions zombies are allowed to spawn from (TODO: Confirm, clarify).
    // There is a 0.2 chance that only one direction will be used, a 0.16 chance that 3 directions will be used
    // and a 0.64 chance that 2 directions will be used.
	if ( RandomInt(0,10) > 8 )
		stage10plus.params.SpawnDirectionCount = 1
	else if ( RandomInt(0, 10) > 8)
		stage10plus.params.SpawnDirectionCount = 3
	else
		stage10plus.params.SpawnDirectionCount = 2
        
	// Valve note: "ps. id think we'd want to play w/CommonLimit too - not sure where 100 everywhere? incorrect?"
	return stage10plus
}

// Called when damage is taken.
// This function is used to modify damage taken by players or other entities depending on certain conditions.
function AllowTakeDamage( damageTable )
{	
	// If a player is damaged by a landmine, reduce the amount they are hurt.
	if( damageTable.Attacker.GetName().find("mine_1_exp") && damageTable.Victim.GetClassname() == "player" )
	{
		if( damageTable.Victim.IsSurvivor() )
		{
			ScriptedDamageInfo.DamageDone = 5
		}
		return true
	}

	// If a melee weapon hits a breakable door (barricades are doors)
	// then increase the damage so it breaks more quickly.
	if ( damageTable.Victim.GetClassname() == "prop_door_rotating" )
	{
		if ( damageTable.Weapon != null )
		{
			if ( damageTable.Weapon.GetClassname() == "weapon_melee" )
			{
				ScriptedDamageInfo.DamageDone = 100.0
				return true
			}
		}
	}
	
	return true
}

// Called when a survivor leaves the start box.
// This is used to begin the first stage.
function SurvivorLeftStartBox()
{
	EndTrainingHints( 30 )
	Director.ForceNextStage()
}

// Place any content to precache here.
function Precache()
{
	Startbox_Precache()
}

// Called when the mutation is first initialised, before any gameplay takes place.
function OnActivate()
{
	// Begin the gas can spawns.
	g_RoundState.g_GascanManager.StartGascanSpawns()

	// Teleport players to the start points.
    // If you have start point destinations placed in your map, change the name in TeleportPlayersToStartPoints()
    // to match the targetname of your points (wildcards are accepted).
    // If this is a custom map and the player_start point is already placed where you want the players to spawn
    // (ie. not in a safe room), comment this line out.
	if ( !TeleportPlayersToStartPoints("gamemode_playerstart") ) printl(" ** TeleportPlayersToStartPoints: Spawn point count or player count incorrect! Verify that there are 4 of each.")
	
    // Spawns the start box. When any players step outside this box, the first stage begins.
    // Oddly enough, the arguments for the dimensions of the box are actually (length, width), not (width, length),
    // meaning that the dimension in Y is specified before the dimension in X.
    
    // To create a start box in a custom map, block out a cube in Hammer textured with "skip" and make a note of its dimensions.
    // Place an info_target at the centre of the cube (8 units or so above the ground) and name it "startbox_origin".
    // Once done, enter the dimensions of the box here (vertical length followed by horizontal length, when looking from the top viewport).
    // Note that the start box markers will only be present at the same vertical level as the info_target, meaning that they may float in the air
    // (or penetrate the floor) depending on the lie of the land.
    
	if ( !SpawnStartBox( "startbox_origin", true, 1088, 832 ) )
	{
		printl("Warning: No startbox_origin in map.\n  Place a startbox_origin entity in order to spawn a game start region.\n")
	}	
	
	// Give the players their initial amount of resources with which to purchase items.
    // This will update the glow states on items.
	g_ResourceManager.AddResources( SessionState.InitialResources )
	
    // Add the slow poll timer.
	ScriptedMode_AddSlowPoll( MapSlowPoll )
	
    // Set the rescue timer.
	RescueTimer_Set(SessionState.RescueTime)

	// Display the debug overlay for the script.
	DisplayScriptDebugOverlays()
}

// Displays debug data for the script.
// TODO: Does this only work in debug mode? What does this function actually do?
function DisplayScriptDebugOverlays()
{
	ScriptDebugClearWatches()   // TODO: What's this?
	
	// Current wave.
	ScriptDebugAddWatch( @() "Current Wave: " + SessionState.ScriptedStageWave )

	// Witch data.
	ScriptDebugAddWatch( @() "Witch spawning on Wave: " + g_RoundState.WitchManager.GetWitchSpawnWave() )


	// Tank data.
	for( local i=0; i<g_RoundState.TankManager.ManholeTankList.len(); i++ )
	{
		local x = i
		ScriptDebugAddWatch( @() "Manhole tank spawning on wave: " + g_RoundState.TankManager.ManholeTankList[x].SpawnWave )
	}
}

// ==================== End other mutation logic ==================== //