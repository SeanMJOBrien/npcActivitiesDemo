//::///////////////////////////////////////////////
//:: FileName henchlightdis
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 4/13/2003 4:14:13 PM
//:://////////////////////////////////////////////

#include "hench_i0_conv"

int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, sHenchLightOffHand))
    {
        return FALSE;
    }
    int wieldState = GetLocalInt(OBJECT_SELF, sHenchDualWieldState);
    if(wieldState == 1)
    {
        return TRUE;
    }
    if(wieldState == 2)
    {
        return FALSE;
    }
    if (GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, OBJECT_SELF))
    {
        return TRUE;
    }
    return FALSE;
}
