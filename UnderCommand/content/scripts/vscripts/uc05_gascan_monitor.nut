LastMonitorTime <- Time();
ShouldMonitor <- false;
GasCanZThreshold <- -1290.0;

function DestroyGasCan(gasCan)
{
	local position = gasCan.GetOrigin();
	
	if ( position.z > GasCanZThreshold )
	{
		return;
	}
	
	if ( developer() > 0 )
	{
		Msg("Destroying gas can @ " + position + "\n");
	}
	
	DoEntFire("!self", "Ignite", "", 0, null, gasCan);
}

function DestroyAnyOutOfBoundsGasCans()
{
	local gasCan = null;
	
	while ( gasCan = Entities.FindByClassname(gasCan, "weapon_gascan") )
	{
		DestroyGasCan(gasCan);
	}
}

function Monitor()
{
	// After much investigation (trying to attach scripts to the gas can spawners,
	// trying to have the gas cans interact with triggers, etc.), it looks like this
	// is the only way to do this properly.
	
	if ( !ShouldMonitor )
	{
		return;
	}
	
	local currentTime = Time();
	
	if ( currentTime - LastMonitorTime < 5.0 )
	{
		return;
	}
	
	if ( developer() > 0 )
	{
		Msg("Gas can monitor poll\n");
	}
	
	DestroyAnyOutOfBoundsGasCans();
	
	LastMonitorTime = currentTime;
}

function InputTurnOn()
{
	ShouldMonitor = true;
	return true;
}

function InputTurnOff()
{
	ShouldMonitor = false;
	return true;
}