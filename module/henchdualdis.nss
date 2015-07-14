//::///////////////////////////////////////////////
//:: FileName henchdualdis
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 4/13/2003 3:53:22 PM
//:://////////////////////////////////////////////

#include "hench_i0_conv"

int StartingConditional()
{
    int wieldState = GetLocalInt(OBJECT_SELF, sHenchDualWieldState);
    if(wieldState == 2)
    {
        return TRUE;
    }
    if(wieldState == 1)
    {
        return FALSE;
    }
    if (!GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, OBJECT_SELF))
    {
        return TRUE;
    }
    return FALSE;
}
