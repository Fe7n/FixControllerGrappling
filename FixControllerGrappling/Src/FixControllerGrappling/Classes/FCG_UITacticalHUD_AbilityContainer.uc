class FCG_UITacticalHud_AbilityContainer extends UITacticalHud_AbilityContainer config(FixControllerGrappling);

var config array<name> RequiresTargetingActivation;

function bool RequiresActivation(class<X2TargetingMethod> targetingClass)
{
	local int i;

	for(i = 0; i < RequiresTargetingActivation.Length; i++)
	{
		if (targetingClass.IsA(RequiresTargetingActivation[i]))
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
		// Start Issue #476
		return RequiresActivation(AbilityState.GetMyTemplate().TargetingMethod);
		// End Issue #476
	}

	return false;
}

simulated function bool IsTargetingMethodActivated()
{
	if (TargetingMethod != none)
	{
		return RequiresActivation(TargetingMethod.Class);
	}

	return false;
}