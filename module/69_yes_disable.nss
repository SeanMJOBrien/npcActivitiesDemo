//::///////////////////////////////////////////////
//:: Disable Traps Yes Help
//:://////////////////////////////////////////////
/*
    Does the henchman currently not help with traps
*/
//:://////////////////////////////////////////////
//:: Created By: 69MEH69 DEC2002
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    if(GetLocalInt(OBJECT_SELF, "MH_DISABLE_TRAP") == 1)
    {
        return TRUE;
    }
    return FALSE;
}
