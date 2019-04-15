class FCG_UITacticalHud_AbilityContainer extends UITacticalHud_AbilityContainer config(FixControllerGrappling);

var config array<name> RequiresTargetingActivation;

static function bool RequiresActivation(Object obj)
{
	local int i;

	for(i = 0; i < default.RequiresTargetingActivation.Length; i++)
	{
		if (obj.IsA(default.RequiresTargetingActivation[i]))
		{
			return true;
		}
	}

	return false;
}

simulated function bool AbilityRequiresTargetingActivation(int Index)
{
	local XComGameState_Ability AbilityState;

	if (!`ISCONTROLLERACTIVE)
	{
		return false;
	}

	if (Index < 0 || Index >= m_arrAbilities.Length)
	{
		return false;
	}

	AbilityState = XComGameState_Ability(
		`XCOMHISTORY.GetGameStateForObjectID(m_arrAbilities[Index].AbilityObjectRef.ObjectID));

	if (AbilityState != none)
	{
		return static.RequiresActivation(class'XcomEngine'.static.GetClassDefaultObject(AbilityState.GetMyTemplate().TargetingMethod));
	}

	return false;
}

simulated function bool IsTargetingMethodActivated()
{
	if (TargetingMethod != none)
	{
		return static.RequiresActivation(TargetingMethod);
	}

	return false;
}
