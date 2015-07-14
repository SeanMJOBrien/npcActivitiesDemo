int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    if (GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP,oUnit) == 1)
        return TRUE;
    else
        return FALSE;
}
