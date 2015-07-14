//::///////////////////////////////////////////////
//:: FileName ps_henchcond001
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 12/29/2005 2:10:39 AM
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_CLERIC, OBJECT_SELF) >= 1)
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_DRUID, OBJECT_SELF) >= 1))
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_BARD, OBJECT_SELF) >= 1))
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_PALADIN, OBJECT_SELF) >= 1))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
